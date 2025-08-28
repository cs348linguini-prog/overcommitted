#!/bin/bash

TOTAL_COMMITS=3000068
BATCH_SIZE=5000
REMOTE_NAME="origin"
BRANCH_NAME="main"  # change if needed

# Ensure repo exists
if ! git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
    echo "Not inside a git repository."
    exit 1
fi

echo "Creating $TOTAL_COMMITS commits with git fast-import..."
for ((start=1; start<=TOTAL_COMMITS; start+=BATCH_SIZE)); do
    end=$(( start + BATCH_SIZE - 1 ))
    if (( end > TOTAL_COMMITS )); then
        end=$TOTAL_COMMITS
    fi

    {
        for ((i=start; i<=end; i++)); do
            echo "commit refs/heads/$BRANCH_NAME"
            echo "committer Script <script@example.com> $(date +%s) +0000"
            echo "data 16"
            echo "Commit #$i"
            echo
        done
    } | git fast-import

    echo "Pushing commits $start–$end..."
    git push "$REMOTE_NAME" "$BRANCH_NAME"
done

echo "Done! Created and pushed $TOTAL_COMMITS commits."

