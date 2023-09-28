#!/bin/bash
git fetch --all --tags &> /dev/null
current_stage_version=$(git tag | sort --version-sort | tail -n1 | cut -c 2-);
repo_var_name="DEV_RELEASE_VERSION"
repo_var_url="https://api.github.com/repos/${OWNER}/${REPO}/actions/variables/$repo_var_name"

# Get the current dev version from GitHub repo variable
current_dev_full_version=$(
  curl -s -L -H "Accept: application/vnd.github+json" \
    -H "Authorization: Bearer $TOKEN" \
    -H "X-GitHub-Api-Version: 2022-11-28" $repo_var_url |\
  jq -r '.value');

echo "Current Dev Version: $current_dev_full_version"
echo "Current Stage Version: $current_stage_version"

IFS=. read -r major minor patch dev_release <<< "$current_dev_full_version"
new_dev_version=""

if [[ "$current_stage_version" == "$major.$minor.$patch" ]]; then
  new_dev_version="$current_stage_version."$(($dev_release+1))""
else
  new_dev_version="$current_stage_version.1"
fi

echo "New Dev Version: $new_dev_version"
echo "DEV_RELEASE_VERSION=$new_dev_version" >> $GITHUB_ENV

exit $new_dev_version

# Update the repo variable with the new dev version
# curl -s -L \
#   -X PATCH \
#   -H "Accept: application/vnd.github+json" \
#   -H "Authorization: Bearer $TOKEN"\
#   -H "X-GitHub-Api-Version: 2022-11-28" \
#   $repo_var_url \
#   -d '{"name":"'$repo_var_name'","value":"'$new_dev_version'"}'