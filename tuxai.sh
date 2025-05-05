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
    # Remove the extra read from stdin, since we're passing the content directly
    python3 -c 'import json,sys; print(json.dumps(sys.argv[1]))' "$1"
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
        message_content="$user_query

Command output:
$command_output"
    else
        message_content="$user_query"
    fi
    
    # Escape the content for JSON properly
    local escaped_content=$(json_escape "$message_content")
    
    # Create the request body
    local request_body="{\"messages\":[{\"role\":\"user\",\"content\":${escaped_content}}],\"max_tokens\":${max_tokens},\"temperature\":${temperature}}"
    
    # Make the API call - ensure AGENT_ENDPOINT doesn't already include the path
    # Remove trailing slash from endpoint if present
    local endpoint="${AGENT_ENDPOINT%/}"
    
    # Make the API call
    local response=$(curl -s -X POST "${endpoint}/api/v1/chat/completions" \
        -H "Content-Type: application/json" \
        -H "Authorization: Bearer $AGENT_ACCESS_KEY" \
        -d "$request_body")
    
    # Check if response is empty or has error
    if [ -z "$response" ]; then
        echo "Error: Empty response from API"
        return 1
    fi
    
    # Extract and return the response content with better error handling
    if echo "$response" | grep -q "error"; then
        echo "API Error: $(echo "$response" | jq -r '.error.message // .error')"
    else
        echo "$response" | jq -r '.choices[0].message.content // "Error: Unexpected response format"'
    fi
}

# Main function
main() {
    # Handle arguments properly
    local query=""
    
    # Combine all arguments into a single query
    if [ $# -gt 0 ]; then
        query="$*"
    fi
    
    # Check if input is being piped in
    if [ -t 0 ]; then
        # No piped input, just use command line arguments
        if [ -z "$query" ]; then
            echo "Error: Please provide a query"
            exit 1
        fi
        query_ai "$query" ""
    else
        # Read piped input
        local piped_input=$(cat)
        
        # Use command line arguments as the query
        query_ai "$query" "$piped_input"
    fi
}

# Run the main function with all script arguments
main "$@"
