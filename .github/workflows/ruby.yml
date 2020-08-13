# This workflow uses actions that are not certified by GitHub.
# They are provided by a third-party and are governed by
# separate terms of service, privacy policy, and support
# documentation.
# This workflow will download a prebuilt Ruby version, install dependencies and run tests with Rake
# For more information see: https://github.com/marketplace/actions/setup-ruby-jruby-and-truffleruby

name: Ruby

on:
  push:
    branches: [ master ]
  pull_request:
    branches: [ master ]

jobs:
  test:

    runs-on: ubuntu-latest

    steps:
    - uses: actions/checkout@v2
    - name: Set up Ruby
    # To automatically get bug fixes and new Ruby versions for ruby/setup-ruby,
    # change this to (see https://github.com/ruby/setup-ruby#versioning):
    # uses: ruby/setup-ruby@v1
      uses: ruby/setup-ruby@ec106b438a1ff6ff109590de34ddc62c540232e0
      with:
        ruby-version: 2.6
    - name: Install dependencies
      run: bundle install
    - name: Run tests
      run: bundle exec rake
