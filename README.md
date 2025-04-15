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
