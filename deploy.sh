#!/bin/bash
# Path to your project
WORK_DIR=/home/ubuntu/spherebot

# Log file
LOG_FILE=/home/ubuntu/weebHook-pipeline/deploy.log

# Start logging
exec 1> >(tee -a "$LOG_FILE")
exec 2>&1

echo "=== Deployment started at $(date) ==="

# Change to working directory
cd "$WORK_DIR" || exit 1

# Store current commit hash
OLD_COMMIT=$(git rev-parse HEAD)

# Pull latest changes
git pull origin main

# Get new commit hash
NEW_COMMIT=$(git rev-parse HEAD)

# Check if there were changes
if [ "$OLD_COMMIT" = "$NEW_COMMIT" ]; then
    echo "No new changes to deploy"
    exit 0
fi

# Run tests
echo "Running tests..."
npm test
if [ $? -ne 0 ]; then
    echo "Tests failed, aborting deployment"
    exit 1
fi

# Restart the application
echo "Tests passed, restarting application..."
pm2 restart sbot

echo "=== Deployment completed at $(date) ==="