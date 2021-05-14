FROM alpine

# Run locally: `earthly +all` to run full CI process
all:
    BUILD --build-arg RUBY=3.0 +test
    BUILD --build-arg RUBY=2.7 +test
    BUILD --build-arg RUBY=2.5 +test
    BUILD --build-arg RUBY=jruby:9.2.14.0 +test
    BUILD style-check
    BUILD profile-docs

# Run locally: `earthly +test`
# Run with specific version: `earthly --build-arg RUBY=2.5 +test`
test:
    FROM +deps
    RUN script/test    
    RUN script/cucumber
    RUN script/default-site

style-check:
    FROM +deps
    RUN script/fmt

profile-docs:
    FROM +deps
    RUN bundle install --jobs 4
    RUN script/profile-docs
    RUN script/memprof

# Install dependencies and copy in source
# used in above steps
deps:
    ARG RUBY=3.0
    IF case $RUBY in jruby*) ;; *) false; esac
        FROM $RUBY
        ENV JRUBY_OPTS="--dev -J-XX:+TieredCompilation -J-XX:TieredStopAtLevel=1  -J-XX:CompileThreshold=10 -J-XX:ReservedCodeCacheSize=128M"
    ELSE
        FROM ruby:$RUBY
    END
    WORKDIR /src
    RUN apt-get update && apt-get install nodejs dnsutils git make coreutils g++ build-essential -y
    RUN gem install bundler
    RUN gem install sassc -v '2.4.0' --source 'https://rubygems.org/'
    COPY Gemfile .
    COPY jekyll.gemspec .
    COPY lib/jekyll/version.rb lib/jekyll/version.rb
    COPY test test
    RUN bundle install --jobs 4
    COPY . .