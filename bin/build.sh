#!/bin/sh

DIR=$(dirname "$0")

cd $DIR/..

if [[ $(git status -s) ]]
then
	echo "The working directory is dirty. Please commit any pending changes."
	exit 1;
fi

message="Update page :boom:"
if [ $# -eq 1 ]
	then message="$1"
fi

echo "Deleting old publication"
rm -rf public
mkdir public
git worktree prune
rm -rf .git/worktrees/public/

echo "Checking out gh-pages branch into public"
git worktree add -B gh-pages public origin/gh-pages

echo "Removing existing files"
rm -rf public/*

echo "Generating site"
npm install
npm run css
npm run js
hugo
npm run html
echo "littledrop.cz" > public/CNAME
echo "/css/*" >> public/.gitignore
echo "/js/*" >> public/.gitignore

echo "Updating gh-pages branch"
cd public
git reset HEAD~ && git add --all && git commit -m "$message" && git push origin gh-pages --force

echo "Cleanup"
cd .. && rm -rf public
git worktree prune
git branch -D gh-pages
