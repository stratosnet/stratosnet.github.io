#!/bin/bash

# IPFS Terminal Client
# This script provides a simple interface to interact with Stratos RPC API

# Configuration
KUBO_API="https://sds-gateway-uswest.thestratos.org/spfs/PSu46EiNUYevTVA8doNHiCAFrxU=/api/v0"
PUBLIC_GATEWAY="https://spfs-gateway.thestratos.net"
CACHE_DIR="$HOME/.ipfs-client-cache"
MAPPING_FILE="$CACHE_DIR/file_cid_mapping.json"

# Create cache directory if it doesn't exist
mkdir -p "$CACHE_DIR"
touch "$MAPPING_FILE"

# Display usage information
show_help() {
  echo "IPFS Terminal Client - Interact with Stratos RPC API"
  echo ""
  echo "Usage: $0 COMMAND [ARGS]"
  echo ""
  echo "Commands:"
  echo "  fetch <CID> [output_file] - Retrieve file from IPFS"
  echo "  add <file_path>           - Add a file to IPFS and pin it automatically"
  echo "  pin <CID>                 - Pin a CID to the node"
  echo "  unpin <CID>               - Unpin a CID from the node"
  echo "  mfsadd <CID> <mfs_path>   - Add a CID to the IPFS Mutable File System"
  echo "  rm <mfs_path>             - Remove a file from IPFS Mutable File System"
  echo "  id                        - Get node info from Kubo API"
  echo "  list files                - List files in IPFS Mutable File System (MFS)"
  echo "  list peers                - List connected IPFS peers"
  echo "  cat <CID>                 - Display the contents of a file"
  echo "  map                       - Show the mapping between filenames and CIDs"
  echo "  inspect <path-or-cid>     - Get detailed info about a file or CID"
  echo "  lookup <pattern>          - Search for a file or CID by pattern"
  echo ""
}

# Check for required dependencies
check_dependencies() {
  if ! command -v curl &> /dev/null; then
    echo "Error: curl is required but not installed."
    exit 1
  fi
  if ! command -v jq &> /dev/null; then
    echo "Warning: jq is not installed. Some output will not be formatted nicely."
    echo "Installing jq is highly recommended for full functionality."
  fi
}

# Process API response and handle errors
process_response() {
  local HTTP_CODE=$1
  local RESPONSE=$2
  
  if [[ $HTTP_CODE -eq 200 ]]; then
    if command -v jq &> /dev/null && [[ $RESPONSE == {* ]]; then
      echo "$RESPONSE" | jq
    else
      echo "$RESPONSE"
    fi
  elif [[ $HTTP_CODE -eq 405 ]]; then
    echo "Error: Method not allowed. This endpoint might not be supported by the node or might require authentication."
  elif [[ $HTTP_CODE -eq 404 ]]; then
    echo "Error: Not found. The requested resource doesn't exist."
  elif [[ $HTTP_CODE -eq 403 ]]; then
    echo "Error: Forbidden. You don't have permission to access this resource."
  elif [[ $HTTP_CODE -eq 401 ]]; then
    echo "Error: Unauthorized. Authentication is required."
  else
    echo "Error: HTTP code $HTTP_CODE"
    echo "$RESPONSE"
  fi
}

# Update the mapping between filenames and CIDs
update_mapping() {
  local FILENAME=$1
  local CID=$2
  
  if [ -z "$FILENAME" ] || [ -z "$CID" ]; then
    return
  fi
  
  if ! command -v jq &> /dev/null; then
    echo "Warning: jq is required for maintaining filename-CID mapping."
    return
  fi
  
  # Create or update the mapping file
  if [ ! -s "$MAPPING_FILE" ]; then
    echo "{}" > "$MAPPING_FILE"
  fi
  
  # Update the mapping file with the new CID
  local TEMP_FILE=$(mktemp)
  jq --arg filename "$FILENAME" --arg cid "$CID" \
     '.[$filename] = $cid | .[$cid] = $filename' "$MAPPING_FILE" > "$TEMP_FILE"
  mv "$TEMP_FILE" "$MAPPING_FILE"
  
  echo "Updated mapping: $FILENAME ↔ $CID"
}

# Add a CID to the MFS
add_to_mfs() {
  if [ -z "$1" ] || [ -z "$2" ]; then
    echo "Error: CID and MFS path are required"
    echo "Usage: add_to_mfs <CID> <mfs_path>"
    return 1
  fi
  
  CID="$1"
  MFS_PATH="$2"
  
  # Make sure the path starts with /
  if [[ $MFS_PATH != /* ]]; then
    MFS_PATH="/$MFS_PATH"
  fi
  
  echo "Adding CID $CID to MFS at path $MFS_PATH..."
  RESPONSE=$(curl -s -w "\\n%{http_code}" -X POST "$KUBO_API/files/cp?arg=/ipfs/$CID&arg=$MFS_PATH")
  
  HTTP_CODE=$(echo "$RESPONSE" | tail -n1)
  CONTENT=$(echo "$RESPONSE" | sed '$d')
  
  if [ $HTTP_CODE -eq 200 ]; then
    echo "Successfully added to MFS at $MFS_PATH"
    return 0
  else
    echo "Failed to add to MFS (HTTP code: $HTTP_CODE)"
    echo "$CONTENT"
    return 1
  fi
}

# Remove a file from MFS
remove_from_mfs() {
  if [ -z "$1" ]; then
    echo "Error: MFS path is required"
    echo "Usage: remove_from_mfs <mfs_path>"
    return 1
  fi
  
  MFS_PATH="$1"
  
  # Make sure the path starts with /
  if [[ $MFS_PATH != /* ]]; then
    MFS_PATH="/$MFS_PATH"
  fi
  
  echo "Removing file from MFS at path $MFS_PATH..."
  RESPONSE=$(curl -s -w "\\n%{http_code}" -X POST "$KUBO_API/files/rm?arg=$MFS_PATH")
  
  HTTP_CODE=$(echo "$RESPONSE" | tail -n1)
  CONTENT=$(echo "$RESPONSE" | sed '$d')
  
  if [ $HTTP_CODE -eq 200 ]; then
    echo "Successfully removed from MFS"
    return 0
  else
    echo "Failed to remove from MFS (HTTP code: $HTTP_CODE)"
    echo "$CONTENT"
    return 1
  fi
}

# Fetch a file from IPFS by CID
fetch_file() {
  if [ -z "$1" ]; then
    echo "Error: CID is required"
    echo "Usage: $0 fetch <CID> [output_file]"
    exit 1
  fi
  
  CID="$1"
  OUTPUT_FILE="$2"
  
  # If no output file is specified, check if we have a filename mapping
  if [ -z "$OUTPUT_FILE" ] && command -v jq &> /dev/null && [ -s "$MAPPING_FILE" ]; then
    MAPPED_NAME=$(jq -r --arg cid "$CID" '.[$cid] // empty' "$MAPPING_FILE")
    if [ -n "$MAPPED_NAME" ] && [ "$MAPPED_NAME" != "null" ]; then
      OUTPUT_FILE="${MAPPED_NAME##*/}"  # Extract the basename
      echo "Found filename from mapping: $OUTPUT_FILE"
    else
      OUTPUT_FILE="$CID"
    fi
  elif [ -z "$OUTPUT_FILE" ]; then
    OUTPUT_FILE="$CID"
  fi
  
  echo "Fetching $CID from IPFS..."
  HTTP_CODE=$(curl -s -w "%{http_code}" "$PUBLIC_GATEWAY/ipfs/$CID" -o "$OUTPUT_FILE")
  
  if [ $HTTP_CODE -eq 200 ]; then
    echo "Successfully downloaded to $OUTPUT_FILE"
    # Update mapping if we have a named output file
    if [ "$OUTPUT_FILE" != "$CID" ]; then
      update_mapping "$OUTPUT_FILE" "$CID"
    fi
  else
    echo "Failed to fetch $CID (HTTP code: $HTTP_CODE)"
    rm -f "$OUTPUT_FILE"
    exit 1
  fi
}

# Add a file to IPFS
add_file() {
  if [ -z "$1" ]; then
    echo "Error: file path is required"
    echo "Usage: $0 add <file_path>"
    exit 1
  fi
  
  FILE_PATH="$1"
  
  if [ ! -f "$FILE_PATH" ]; then
    echo "Error: File $FILE_PATH does not exist"
    exit 1
  fi
  
  echo "Adding $FILE_PATH to IPFS..."
  RESPONSE=$(curl -s -w "\\n%{http_code}" -X POST "$KUBO_API/add" -F "file=@$FILE_PATH")
  
  HTTP_CODE=$(echo "$RESPONSE" | tail -n1)
  CONTENT=$(echo "$RESPONSE" | sed '$d')
  
  if [ $HTTP_CODE -eq 200 ] && command -v jq &> /dev/null; then
    # Extract the CID from the response
    CID=$(echo "$CONTENT" | jq -r '.Hash // empty')
    if [ -n "$CID" ] && [ "$CID" != "null" ]; then
      # Store the mapping
      FILENAME=$(basename "$FILE_PATH")
      update_mapping "$FILENAME" "$CID"
      
      # Auto-pin the file
      echo "Auto-pinning CID $CID..."
      PIN_RESPONSE=$(curl -s -w "\\n%{http_code}" -X POST "$KUBO_API/pin/add?arg=$CID")
      PIN_HTTP_CODE=$(echo "$PIN_RESPONSE" | tail -n1)
      
      if [ $PIN_HTTP_CODE -eq 200 ]; then
        echo "Successfully pinned $CID"
        
        # Generate shareable URL
        echo ""
        echo "Shareable URL:"
        echo "$PUBLIC_GATEWAY/ipfs/$CID"
      fi
    fi
  fi
  
  # We don't show the raw response anymore
  if [ $HTTP_CODE -eq 200 ]; then
    if command -v jq &> /dev/null; then
      CID=$(echo "$CONTENT" | jq -r '.Hash // empty')
      NAME=$(echo "$CONTENT" | jq -r '.Name // empty')
      SIZE=$(echo "$CONTENT" | jq -r '.Size // empty')
      
      echo "Added file:"
      echo "  Name: $NAME"
      echo "  CID: $CID"
      echo "  Size: $SIZE"
    else
      echo "File added successfully, but jq is not installed to parse details."
      echo "Raw response: $CONTENT"
    fi
  else
    echo "Failed to add file (HTTP code: $HTTP_CODE)"
    echo "$CONTENT"
  fi
}

# Pin a CID to the node
pin_cid() {
  if [ -z "$1" ]; then
    echo "Error: CID is required"
    echo "Usage: $0 pin <CID>"
    exit 1
  fi
  
  CID="$1"
  
  echo "Pinning $CID to the node..."
  RESPONSE=$(curl -s -w "\\n%{http_code}" -X POST "$KUBO_API/pin/add?arg=$CID")
  
  HTTP_CODE=$(echo "$RESPONSE" | tail -n1)
  CONTENT=$(echo "$RESPONSE" | sed '$d')
  
  if [ $HTTP_CODE -eq 200 ]; then
    echo "Successfully pinned $CID"
    
    # Try to show the filename if available
    if command -v jq &> /dev/null && [ -s "$MAPPING_FILE" ]; then
      FILENAME=$(jq -r --arg cid "$CID" '.[$cid] // empty' "$MAPPING_FILE")
      if [ -n "$FILENAME" ] && [ "$FILENAME" != "null" ]; then
        echo "Pinned file: $FILENAME"
      fi
    fi
    
    # Display shareable URL
    echo ""
    echo "Shareable URL:"
    echo "$PUBLIC_GATEWAY/ipfs/$CID"
  else
    echo "Failed to pin $CID (HTTP code: $HTTP_CODE)"
    echo "$CONTENT"
  fi
}

# Unpin a CID from the node
unpin_cid() {
  if [ -z "$1" ]; then
    echo "Error: CID is required"
    echo "Usage: $0 unpin <CID>"
    exit 1
  fi
  
  CID="$1"
  
  echo "Unpinning $CID from the node..."
  RESPONSE=$(curl -s -w "\\n%{http_code}" -X POST "$KUBO_API/pin/rm?arg=$CID")
  
  HTTP_CODE=$(echo "$RESPONSE" | tail -n1)
  CONTENT=$(echo "$RESPONSE" | sed '$d')
  
  if [ $HTTP_CODE -eq 200 ]; then
    echo "Successfully unpinned $CID"
    
    # If jq is available, try to show the filename for better UX
    if command -v jq &> /dev/null && [ -s "$MAPPING_FILE" ]; then
      FILENAME=$(jq -r --arg cid "$CID" '.[$cid] // empty' "$MAPPING_FILE")
      if [ -n "$FILENAME" ] && [ "$FILENAME" != "null" ]; then
        echo "Unpinned file: $FILENAME"
      fi
    fi
  else
    echo "Failed to unpin $CID (HTTP code: $HTTP_CODE)"
    echo "$CONTENT"
  fi
}

# Get node info
get_node_info() {
  echo "Getting node info..."
  RESPONSE=$(curl -s -w "\\n%{http_code}" -X POST "$KUBO_API/id")
  
  HTTP_CODE=$(echo "$RESPONSE" | tail -n1)
  CONTENT=$(echo "$RESPONSE" | sed '$d')
  
  if [ $HTTP_CODE -eq 200 ] && command -v jq &> /dev/null; then
    echo "Node ID: $(echo "$CONTENT" | jq -r '.ID // "Unknown"')"
    echo "Protocol Version: $(echo "$CONTENT" | jq -r '.ProtocolVersion // "Unknown"')"
    echo "Agent Version: $(echo "$CONTENT" | jq -r '.AgentVersion // "Unknown"')"
    
    # Show addresses if available
    if echo "$CONTENT" | jq -e '.Addresses' > /dev/null; then
      echo "Addresses:"
      echo "$CONTENT" | jq -r '.Addresses[]' | sed 's/^/  - /'
    fi
  else
    process_response "$HTTP_CODE" "$CONTENT"
  fi
}

# List pinned CIDs
list_pins() {
  echo "Listing pinned CIDs..."
  RESPONSE=$(curl -s -w "\\n%{http_code}" -X POST "$KUBO_API/pin/ls")
  
  HTTP_CODE=$(echo "$RESPONSE" | tail -n1)
  CONTENT=$(echo "$RESPONSE" | sed '$d')
  
  # If jq is available, try to enrich the output with filename mappings
  if [ $HTTP_CODE -eq 200 ] && command -v jq &> /dev/null; then
    echo "CIDs with known filename mappings:"
    echo "--------------------------------"
    
    # Check if we have pins
    if echo "$CONTENT" | jq -e '.Keys' > /dev/null; then
      # Extract and process the CIDs
      echo "$CONTENT" | jq -r '.Keys | keys[]' | while read -r CID; do
        FILENAME=$(jq -r --arg cid "$CID" '.[$cid] // "Unknown"' "$MAPPING_FILE")
        TYPE=$(echo "$CONTENT" | jq -r --arg cid "$CID" '.Keys[$cid].Type')
        
        if [ "$FILENAME" != "null" ] && [ "$FILENAME" != "Unknown" ]; then
          echo "CID: $CID"
          echo "Name: $FILENAME"
          echo "Type: $TYPE"
          echo "URL: $PUBLIC_GATEWAY/ipfs/$CID"
          echo "--------------------------------"
        else
          echo "CID: $CID"
          echo "Name: [No filename mapped]"
          echo "Type: $TYPE"
          echo "URL: $PUBLIC_GATEWAY/ipfs/$CID"
          echo "--------------------------------"
        fi
      done
    else
      echo "No pins found."
    fi
  else
    # Only show error if there was one
    if [ $HTTP_CODE -ne 200 ]; then
      echo "Failed to list pins (HTTP code: $HTTP_CODE)"
      echo "$CONTENT"
    elif echo "$CONTENT" | grep -q "error"; then
      echo "$CONTENT"
    else
      echo "No pins found or empty response."
    fi
  fi
}

# List files in IPFS MFS
list_files() {
  echo "Listing files in IPFS MFS..."
  RESPONSE=$(curl -s -w "\\n%{http_code}" -X POST "$KUBO_API/files/ls?arg=/")
  
  HTTP_CODE=$(echo "$RESPONSE" | tail -n1)
  CONTENT=$(echo "$RESPONSE" | sed '$d')
  
  # If successful and jq is available, try to get CIDs for each file
  if [ $HTTP_CODE -eq 200 ] && command -v jq &> /dev/null; then
    echo "Files with their CIDs:"
    echo "--------------------------------"
    
    # Check if we have any entries
    if echo "$CONTENT" | jq -e '.Entries' > /dev/null && [ "$(echo "$CONTENT" | jq '.Entries | length')" -gt 0 ]; then
      # Extract and process the files
      echo "$CONTENT" | jq -r '.Entries[] | .Name' | while read -r FILENAME; do
        if [ -n "$FILENAME" ] && [ "$FILENAME" != "null" ]; then
          # Try to get file stats to get the real CID
          STAT_RESPONSE=$(curl -s -X POST "$KUBO_API/files/stat?arg=/$FILENAME")
          CID=$(echo "$STAT_RESPONSE" | jq -r '.Hash // empty')
          
          if [ -n "$CID" ] && [ "$CID" != "null" ]; then
            echo "Name: $FILENAME"
            echo "CID: $CID"
            echo "URL: $PUBLIC_GATEWAY/ipfs/$CID"
            echo "--------------------------------"
            
            # Update the mapping
            update_mapping "$FILENAME" "$CID"
          else
            # Check if we have a mapping from our local cache
            MAPPED_CID=$(jq -r --arg filename "$FILENAME" '.[$filename] // empty' "$MAPPING_FILE")
            if [ -n "$MAPPED_CID" ] && [ "$MAPPED_CID" != "null" ]; then
              echo "Name: $FILENAME"
              echo "CID: $MAPPED_CID (from cache)"
              echo "URL: $PUBLIC_GATEWAY/ipfs/$MAPPED_CID"
              echo "--------------------------------"
            else
              echo "Name: $FILENAME"
              echo "CID: [Could not resolve CID]"
              echo "--------------------------------"
            fi
          fi
        fi
      done
    else
      echo "No files found in MFS."
    fi
  else
    # Only show error if there was one
    if [ $HTTP_CODE -ne 200 ]; then
      echo "Failed to list files (HTTP code: $HTTP_CODE)"
      echo "$CONTENT"
    elif echo "$CONTENT" | grep -q "error"; then
      echo "$CONTENT"
    else
      echo "No files found or empty response."
    fi
  fi
}

# List connected IPFS peers
list_peers() {
  echo "Listing connected IPFS peers..."
  RESPONSE=$(curl -s -w "\\n%{http_code}" -X POST "$KUBO_API/swarm/peers")
  
  HTTP_CODE=$(echo "$RESPONSE" | tail -n1)
  CONTENT=$(echo "$RESPONSE" | sed '$d')
  
  if [ $HTTP_CODE -eq 200 ] && command -v jq &> /dev/null; then
    # Format the peer list nicely
    if echo "$CONTENT" | jq -e '.Peers' > /dev/null && [ "$(echo "$CONTENT" | jq '.Peers | length')" -gt 0 ]; then
      echo "Connected peers:"
      echo "$CONTENT" | jq -r '.Peers[] | .Peer + " (" + .Addr + ")"' | sed 's/^/  - /'
      echo "Total peers: $(echo "$CONTENT" | jq '.Peers | length')"
    else
      echo "No peers connected."
    fi
  else
    # Only show error if there was one
    if [ $HTTP_CODE -ne 200 ]; then
      echo "Failed to list peers (HTTP code: $HTTP_CODE)"
      echo "$CONTENT"
    elif echo "$CONTENT" | grep -q "error"; then
      echo "$CONTENT"
    else
      echo "No peers found or empty response."
    fi
  fi
}

# Cat a file (display its contents)
cat_file() {
  if [ -z "$1" ]; then
    echo "Error: CID is required"
    echo "Usage: $0 cat <CID>"
    exit 1
  fi
  
  CID="$1"
  
  # Try to get filename from mapping for information
  if command -v jq &> /dev/null && [ -s "$MAPPING_FILE" ]; then
    FILENAME=$(jq -r --arg cid "$CID" '.[$cid] // empty' "$MAPPING_FILE")
    if [ -n "$FILENAME" ] && [ "$FILENAME" != "null" ]; then
      echo "Displaying contents of $CID (filename: $FILENAME)..."
    else
      echo "Displaying contents of $CID..."
    fi
  else
    echo "Displaying contents of $CID..."
  fi
  
  RESPONSE=$(curl -s -w "\\n%{http_code}" -X POST "$KUBO_API/cat?arg=$CID")
  
  HTTP_CODE=$(echo "$RESPONSE" | tail -n1)
  CONTENT=$(echo "$RESPONSE" | sed '$d')
  
  if [ $HTTP_CODE -eq 200 ]; then
    echo "$CONTENT"
  else
    # Try the public gateway if the API fails
    echo "API request failed, trying public gateway..."
    curl -s "$PUBLIC_GATEWAY/ipfs/$CID"
  fi
}

# Show the mapping between filenames and CIDs
show_mapping() {
  if [ ! -s "$MAPPING_FILE" ]; then
    echo "No filename to CID mappings available yet."
    echo "Mappings are created when you add or fetch files."
    return
  fi
  
  if ! command -v jq &> /dev/null; then
    echo "Error: jq is required for displaying mappings."
    echo "Please install jq to use this feature."
    return
  fi
  
  echo "Filename to CID mappings:"
  echo "--------------------------------"
  
  # Filter out CID keys (they contain specific patterns) and only show filename -> CID mappings
  jq -r 'to_entries | map(select(.key | test("^Q[a-zA-Z0-9]+$") | not)) | from_entries' "$MAPPING_FILE" | 
    jq -r 'to_entries[] | "File: \(.key)\nCID:  \(.value)\nURL:  '"$PUBLIC_GATEWAY"'/ipfs/\(.value)\n--------------------------------"'
}

# Get detailed info about a file or CID
inspect_item() {
  if [ -z "$1" ]; then
    echo "Error: path or CID is required"
    echo "Usage: $0 inspect <path-or-cid>"
    exit 1
  fi
  
  ITEM="$1"
  
  # Check if the input is a CID (simplified check)
  if [[ $ITEM =~ ^Q[a-zA-Z0-9]+$ ]]; then
    CID="$ITEM"
    
    # Try to get filename from mapping
    if command -v jq &> /dev/null && [ -s "$MAPPING_FILE" ]; then
      FILENAME=$(jq -r --arg cid "$CID" '.[$cid] // "Unknown"' "$MAPPING_FILE")
      if [ "$FILENAME" != "null" ] && [ "$FILENAME" != "Unknown" ]; then
        echo "Inspecting CID: $CID (mapped to: $FILENAME)"
      else
        echo "Inspecting CID: $CID (no filename mapping found)"
      fi
    else
      echo "Inspecting CID: $CID"
    fi
    
    # Get object stats
    echo "Object info:"
    RESPONSE=$(curl -s -X POST "$KUBO_API/object/stat?arg=$CID")
    if command -v jq &> /dev/null; then
      echo "  Hash: $(echo "$RESPONSE" | jq -r '.Hash // "Unknown"')"
      echo "  Links: $(echo "$RESPONSE" | jq -r '.NumLinks // "Unknown"')"
      echo "  Size: $(echo "$RESPONSE" | jq -r '.BlockSize // "Unknown"') bytes"
      echo "  Data size: $(echo "$RESPONSE" | jq -r '.DataSize // "Unknown"') bytes"
      echo "  Cumulative size: $(echo "$RESPONSE" | jq -r '.CumulativeSize // "Unknown"') bytes"
    else
      echo "$RESPONSE"
    fi
    
    # Check if pinned
    echo "Pin status:"
    PIN_RESPONSE=$(curl -s -X POST "$KUBO_API/pin/ls?arg=$CID")
    if command -v jq &> /dev/null; then
      if echo "$PIN_RESPONSE" | jq -e ".Keys | has(\"$CID\")" > /dev/null; then
        echo "  Status: Pinned"
        echo "  Type: $(echo "$PIN_RESPONSE" | jq -r ".Keys[\"$CID\"].Type")"
      else
        echo "  Status: Not pinned"
      fi
    else
      echo "$PIN_RESPONSE"
    fi
    
    # Show shareable URL
    echo "Shareable URL:"
    echo "  $PUBLIC_GATEWAY/ipfs/$CID"
    
  else
    # Assume it's a file path in MFS
    FILENAME="$ITEM"
    
    # Try to get CID from mapping or stat API
    if [[ $FILENAME == /* ]]; then
      # Dealing with full path
      PATH_ARG="$FILENAME"
    else
      # Dealing with relative path - assume root
      PATH_ARG="/$FILENAME"
    fi
    
    echo "Inspecting file: $FILENAME"
    STAT_RESPONSE=$(curl -s -X POST "$KUBO_API/files/stat?arg=$PATH_ARG")
    
    if command -v jq &> /dev/null; then
      echo "  Type: $(echo "$STAT_RESPONSE" | jq -r '.Type // "Unknown"')"
      echo "  Size: $(echo "$STAT_RESPONSE" | jq -r '.Size // "Unknown"') bytes"
      CID=$(echo "$STAT_RESPONSE" | jq -r '.Hash // empty')
      
      if [ -n "$CID" ] && [ "$CID" != "null" ]; then
        echo "  CID: $CID"
        
        # Update the mapping
        update_mapping "$FILENAME" "$CID"
        
        # Check if pinned
        echo "Pin status:"
        PIN_RESPONSE=$(curl -s -X POST "$KUBO_API/pin/ls?arg=$CID")
        if echo "$PIN_RESPONSE" | jq -e ".Keys | has(\"$CID\")" > /dev/null; then
          echo "  Status: Pinned"
          echo "  Type: $(echo "$PIN_RESPONSE" | jq -r ".Keys[\"$CID\"].Type")"
        else
          echo "  Status: Not pinned"
        fi
        
        # Show shareable URL
        echo "Shareable URL:"
        echo "  $PUBLIC_GATEWAY/ipfs/$CID"
      else
        echo "  CID: Could not resolve"
      fi
    else
      echo "$STAT_RESPONSE"
    fi
  fi
}

# Search for a file or CID by pattern
lookup_item() {
  if [ -z "$1" ]; then
    echo "Error: search pattern is required"
    echo "Usage: $0 lookup <pattern>"
    exit 1
  fi
  
  PATTERN="$1"
  
  if ! command -v jq &> /dev/null; then
    echo "Error: jq is required for lookup functionality."
    echo "Please install jq to use this feature."
    return
  fi
  
  if [ ! -s "$MAPPING_FILE" ]; then
    echo "No mappings available to search through."
    echo "Try using list files or list pins first to build mappings."
    return
  fi
  
  echo "Searching for pattern: $PATTERN"
  echo "--------------------------------"
  
  # Search through the mapping file
  RESULTS=$(jq -r --arg pattern "$PATTERN" 'to_entries | map(select(.key | contains($pattern) or .value | contains($pattern))) | from_entries' "$MAPPING_FILE")
  
  if [ "$RESULTS" = "{}" ]; then
    echo "No matching files or CIDs found."
  else
    echo "$RESULTS" | jq -r 'to_entries[] | "Match: \(.key)\nValue: \(.value)\nURL: '"$PUBLIC_GATEWAY"'/ipfs/\(.value)\n--------------------------------"'
  fi
}

# Main function to handle commands
main() {
  check_dependencies
  
  if [ $# -eq 0 ]; then
    show_help
    exit 0
  fi
  
  COMMAND="$1"
  shift
  
  case "$COMMAND" in
    fetch)
      fetch_file "$@"
      ;;
    add)
      add_file "$@"
      ;;
    pin)
      pin_cid "$@"
      ;;
    unpin)
      unpin_cid "$@"
      ;;
    mfsadd)
      add_to_mfs "$@"
      ;;
    rm)
      remove_from_mfs "$@"
      ;;
    id)
      get_node_info
      ;;
    cat)
      cat_file "$@"
      ;;
    map)
      show_mapping
      ;;
    inspect)
      inspect_item "$@"
      ;;
    lookup)
      lookup_item "$@"
      ;;
    list)
      if [ -z "$1" ]; then
        echo "Error: list subcommand required (pins, files, or peers)"
        exit 1
      fi
      case "$1" in
        pins)
          list_pins
          ;;
        files)
          list_files
          ;;
        peers)
          list_peers
          ;;
        *)
          echo "Error: Unknown list subcommand: $1"
          echo "Available subcommands: pins, files, peers"
          exit 1
          ;;
      esac
      ;;
    help)
      show_help
      ;;
    *)
      echo "Error: Unknown command: $COMMAND"
      show_help
      exit 1
      ;;
  esac
}

# Execute main function with all arguments
main "$@"