![Alt text](https://github.com/vmzilla/tux-ai/blob/4feca52f0dda42566893f259220e5eaf87374a01/tux.jpg)

#  TuxAI - Your Linux Command Line AI Assistant

TuxAI is a command-line tool that brings AI assistance directly to your Linux terminal. It allows you to interact with an AI assistant without leaving your workflow or visiting external websites.

## As Linux users and system administrators, we often find ourselves:

- Searching through man pages to find the right command options
- Switching to web browsers to search for command examples
- Visiting company wiki pages for specific internal procedures
- Consulting Stack Overflow or forums for complex command patterns

## TuxAI eliminates these context switches by bringing AI assistance directly to where you work - the terminal. It can:

- Answer questions about Linux commands and system administration
- Interpret command outputs when you pipe them to TuxAI
- Provide explanations for complex outputs from tools like top, free, and ps
- Give you the exact command you need without sifting through search results

## Prerequisites

- Bash shell
- curl and jq installed on your system
- Python 3 (for JSON handling)
- An API key and endpoint for DigitalOcean GenAI Agent

# Installation Guide

- Download the latest release of the script and move it to the `/usr/local/bin/` folder of your system

`wget https://github.com/vmzilla/tux-ai/releases/download/v0.0.0/tuxai`

`cp tuxai /usr/local/bin`

- Make the script executable 

`chmod +x /usr/local/bin/tuxai`

- Create a GenAI Agent on DigitalOcean and export the endpoint, health check end point and secret as variables

```
export AGENT_ACCESS_KEY="your-access-key"
export AGENT_ENDPOINT="your-agent-endpoint"
export HEALTH_CHECK_ENDPOINT="your-agent-health-check-endpoint"
```

Now you can start using the tuxai CLI

# Usage

## Basic Queries

Simply run tuxai followed by your question:

`tuxai how do I check disk space on Linux?`

You can pipe the output of commands to TuxAI for analysis:

`free -h | tuxai how much free memory do I have?`

`top -b -n 1 | tuxai what process is using the most CPU?`

`ps -eo pmem,pid,user,args --sort=-pmem | head | tuxai what are the top memory-consuming processes?`

`ss -tuln | tuxai explain these network connections`

# Contributing

Contributions are welcome! Please feel free to submit a Pull Request.
