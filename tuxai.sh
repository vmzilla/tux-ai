#!/bin/bash

# Check for required environment variables
if [ -z "$AGENT_ACCESS_KEY" ]; then
    echo "Error: AGENT_ACCESS_KEY environment variable is not set."
    echo "Please set it using: export AGENT_ACCESS_KEY=your_key_here"
    exit 1
fi

if [ -z "$AGENT_ENDPOINT" ]; then
    echo "Error: AGENT_ENDPOINT environment variable is not set."
    echo "Please set it using: export AGENT_ENDPOINT=your_api_endpoint"
    exit 1
fi

# Function to properly escape JSON content
json_escape() {
    # Use python for reliable JSON string escaping
    python3 -c 'import json,sys; print(json.dumps(sys.stdin.read()))'
}

# Function to query the AI API
query_ai() {
    local user_query="$1"
    local command_output="$2"
    local temperature="0.7"
    local max_tokens="500"
    
    # Create the combined message content
    local message_content
    if [ -n "$command_output" ]; then
        message_content="$user_query\n\nCommand output:\n$command_output"
    else
        message_content="$user_query"
    fi
    
    # Escape the content for JSON properly
    local escaped_content=$(echo "$message_content" | json_escape)
    
    # Create the request body
    local request_body="{\"messages\":[{\"role\":\"user\",\"content\":${escaped_content}}],\"max_tokens\":${max_tokens},\"temperature\":${temperature}}"
    
    # Make the API call - note the /api/v1/chat/completions path added to the endpoint
    local response=$(curl -s -X POST "${AGENT_ENDPOINT}/api/v1/chat/completions" \
        -H "Content-Type: application/json" \
        -H "Authorization: Bearer $AGENT_ACCESS_KEY" \
        -d "$request_body")
    
    # Extract and return the response content
    echo "$response" | jq -r '.choices[0].message.content' 2>/dev/null || echo "Error: $response"
}

# Main function
main() {
    # Check if input is being piped in
    if [ -t 0 ]; then
        # No piped input, just use command line arguments
        query_ai "$*" ""
    else
        # Read piped input
        local piped_input=$(cat)
        
        # Use command line arguments as the query
        query_ai "$*" "$piped_input"
    fi
}

# Run the main function with all script arguments
main "$@"
