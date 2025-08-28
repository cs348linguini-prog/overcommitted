#!/bin/bash

# This script generates empty Git commits in a loop and pushes them
# to the remote repository after a specified number of commits.

# --- Configuration ---
# Set the number of commits before each push.
# You can change this value to any positive integer.
COMMITS_PER_PUSH=10000

# The commit message for each empty commit.
COMMIT_MESSAGE="Empty commit"

# The remote repository to push to.
# This should match your remote name (e.g., 'origin').
REMOTE_NAME="origin"

# The branch you are working on.
# Make sure you are on the correct branch before running the script.
BRANCH_NAME="main"

# --- Script Logic ---
# Check if a Git repository exists in the current directory.
if [ ! -d ".git" ]; then
  echo "Error: Not a Git repository."
  echo "Please run this script from the root of a Git repository."
  exit 1
fi

# Infinite loop to generate commits.
# The loop will continue until you manually stop it (e.g., with Ctrl+C).
while true; do
  for (( i=1; i<=COMMITS_PER_PUSH; i++ )); do
    # Generate an empty commit.
    # The --allow-empty flag is crucial for this to work.
    git commit --allow-empty -m "${COMMIT_MESSAGE} ${i}/${COMMITS_PER_PUSH}"

    # Print a status message to track progress.
    echo "Generated commit ${i} of ${COMMITS_PER_PUSH}."
  done

  # Push the accumulated commits to the remote.
  echo "Pushing commits to the remote repository..."
  git push ${REMOTE_NAME} ${BRANCH_NAME}

  # Check if the push was successful.
  if [ $? -eq 0 ]; then
    echo "Successfully pushed commits. Continuing..."
  else
    echo "Error: Failed to push commits."
    echo "Please check your network connection and repository access, then try again."
    # You can decide to exit here or continue the loop.
    # We will continue the loop to try again on the next iteration.
  fi

  # Sleep for a short period to avoid overwhelming the system.
  sleep 5
done

