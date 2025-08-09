@echo off
REM Docker-based Jekyll testing script for Windows
REM This allows testing without local Ruby/Bundle installation

echo Starting Jekyll Docker-based testing...

REM Pull the official Jekyll Docker image
docker pull jekyll/jekyll:latest

REM Run tests in Docker container
docker run --rm ^
  --volume="%CD%:/srv/jekyll" ^
  --workdir="/srv/jekyll" ^
  jekyll/jekyll:latest ^
  bash -c "echo 'Installing dependencies...' && bundle install --quiet && echo 'Running existing test suite...' && bundle exec rake test && echo 'Testing completed!'"

echo 🎉 Docker testing finished!