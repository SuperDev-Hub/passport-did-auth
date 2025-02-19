#!/bin/bash

# Exit script on error
set -e

# Define project name
PROJECT_NAME="passport-did-auth"

echo "Removing node_modules..."
rm -rf node_modules package-lock.json

echo "Installing dependencies..."
npm install

# Check if authentication token exists
if [ -z "$AUTHTOKEN" ]; then
    echo "Error: Authentication token (AUTHTOKEN) is missing. Exiting..."
    exit 1
fi
echo "Authentication token found!"

# Check if DID and VC exist
if [ -z "$DID" ] || [ -z "$VC" ]; then
    echo "Error: DID or Verifiable Credential (VC) is missing. Exiting..."
    exit 1
fi
echo "DID and Verifiable Credential found!"

echo "Running test cases..."
npm test

echo "Building project..."
npm run build

echo "Starting the project..."
npm start

echo "Project started successfully!"