#!/bin/bash
echo "Starting Jekyll Docker-based testing..."

docker pull jekyll/jekyll:latest

docker run --rm \
  --volume="$PWD:/srv/jekyll" \
  --workdir="/srv/jekyll" \
  jekyll/jekyll:latest \
  bash -c "
    echo 'Installing dependencies...'
    bundle install --quiet
    
    echo 'Running existing test suite...'
    bundle exec rake test
    
    echo 'Testing completed!'
  "

echo "Docker testing finished!"