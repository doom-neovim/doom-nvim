#!/usr/bin/env bash

# This script updates pinned dependencies in ../lua/doom/modules/init.lua
# It uses grep to find instances of packer.use, uses the repository url to fetch the latest commit sha, and modifies the values
# Dependencies
# perl -- used for Regexing the repository <account>/<repo_name> with capture groups to extract inner text
# grep -- Used for regexing the use({}) block with line numbers
#

index=0
repo_regex='"([^"]+)"'
pin_commit_regex='commit = "[A-z0-9]*"'

repo=''
latest_commit=''

# Find all module package declaration files
find ../lua/doom/modules -name 'init.lua' |
  while read -r file_path; do
    # Update commit shas
    echo ""
    echo "----------------------------------------------- Updating module $file_path..."
    # grep -n "^(\s+)\[\".*\"\]\s?=\s?\{" -A 2 -E "$file_path"
    id=0
    while read -r line; do
      # If index reaches three, we assume it's the next entry
      if [[ $index -eq 3 ]]; then
        sleep 1
        index=0
        repo=''
        latest_commit=''
        retry=''
      fi

      if [[ $index -eq 1 ]]; then
        # Get the repository name as `<username>/reponame`
        if [[ $line =~ $repo_regex ]]; then # Regex $line against $repo_regex
          repo="${BASH_REMATCH[1]}" # Get first capture group
          echo "Updating $repo:"

          # Sometimes the github api requests will fail, in which case we need to re-try after a delay.
          while [[ -z "$latest_commit" &&  "$retry" != "n" ]]; do
            # Get the commit sha from github, use GITHUB_API_KEY if provided
            # GITHUB_API_KEY in this instance is an OAuth2 token
            # https://docs.github.com/en/developers/apps/building-oauth-apps
            if [ -z GITHUB_API_KEY ]; then
              api_result=`curl -s \
                -H "Accept: application/vnd.github.v3+json" \
                https://api.github.com/repos/$repo/commits?per_page=1`
            else
              api_result=`curl -s \
                -H "Accept: application/vnd.github.v3+json" \
                -H "Authentication: token $GITHUB_API_KEY" \
                https://api.github.com/repos/$repo/commits?per_page=1`
            fi

            # If there's an error, log it and wait 30 seconds
            is_array=`echo $api_result | jq -r 'if type=="array" then "yes" else "no" end'`
            if [ "$is_array" = "no" ]; then
              echo "- Github API Error: $( echo "$api_result" | jq -r .message )"
              echo "- Waiting 30 seconds before trying again... for $repo"

              read -t 30 -p "retry? (y/n)" retry </dev/tty
              echo "retry is $retry"
            else
              latest_commit=`echo $api_result | jq -r .[0].sha`
            fi

          done
        else
          echo " - ERROR: No repo name for $line :("
        fi
      fi

      # Update the pinned commit if possible
      if [[ $index -eq 2 ]]; then
        if [ ! -z "$repo" ] && [ ! -z "$latest_commit" ] && [[ $line =~ $pin_commit_regex ]]; then
          line_number=`echo $line | awk -F "-" '{print $1}'`
          sed -r -i ".bak" "${line_number}s/commit = \"[A-z0-9]*\"/commit = \"${latest_commit}\"/" "$file_path"
          echo " - Updated to $latest_commit"
        else
          if [[ "$retry" != "y" ]]; then
            echo " - ERROR: Did not update $repo because \`commit = \"...\"\` was not immediately after the repo name or there is custom logic for determining the pinned commit.  Please update this entry manually."
          fi
        fi
      fi

      let index+=1
      # Grep uses -- to seperate nearby matches
      if [[ $line == '--' ]]; then
        sleep 1
        index=0
        repo=''
        latest_commit=''
        retry=''
      fi
    done < <(grep -n "^(\s+)\[\".*\"\]\s?=\s?\{" -A 2 -E "$file_path")
  done


# Delete backup files
find ../lua/doom/modules -name "*.bak" -type f -delete


