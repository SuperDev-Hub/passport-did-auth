#!/bin/bash

# Exit script on error

set -e

# Function to check if a tool is installed and install it if not

install_tool() {

    TOOL_NAME=$1

    INSTALL_COMMAND=$2

    COMMAND=$3

    if ! command -v $COMMAND &> /dev/null; then

        echo "$TOOL_NAME not found, installing..."

        $INSTALL_COMMAND

    else

        echo "$TOOL_NAME is already installed."

    fi

}

# Install npm (if it's not installed)

install_tool "npm" "sudo apt install -y npm" "npm"

# Install Snyk (if it's not installed)

install_tool "Snyk" "npm install -g snyk" "snyk"

# Install Retire.js (if it's not installed)

install_tool "Retire.js" "npm install -g retire" "retire"

# Install jq (if it's not installed)

install_tool "jq" "sudo apt install -y jq" "jq"

echo "Starting vulnerability scanning..."

# Run npm audit to check for vulnerabilities

echo "Running npm audit to check for vulnerabilities..."

npm audit --json > npm-audit-report.json

if [ -s npm-audit-report.json ]; then

    echo "Vulnerabilities found by npm audit! Generating report..."

    cat npm-audit-report.json | jq . # Use jq to format the JSON output

else

    echo "No vulnerabilities found via npm audit."

fi

# Run Snyk test to find more vulnerabilities

echo "Running Snyk to check for vulnerabilities..."

snyk test --all-projects > snyk-report.txt

if [ -s snyk-report.txt ]; then

    echo "Snyk found vulnerabilities! Check snyk-report.txt for details."

else

    echo "No vulnerabilities found by Snyk."

fi

# Run Retire.js to scan for JavaScript vulnerabilities

echo "Running Retire.js to scan for vulnerabilities in JS libraries..."

retire --scan . > retire-report.txt

if [ -s retire-report.txt ]; then

    echo "Retire.js found vulnerabilities! Check retire-report.txt for details."

else

    echo "No vulnerabilities found by Retire.js."

fi

echo "Vulnerability scanning completed!"