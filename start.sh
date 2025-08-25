#!/bin/bash

# Set Node.js options to handle OpenSSL compatibility issues
export NODE_OPTIONS="--openssl-legacy-provider"

# Start the Docusaurus development server
echo "Starting Cardano Developer Portal..."
yarn start