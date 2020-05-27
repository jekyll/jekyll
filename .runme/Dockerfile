FROM ruby:2.7
WORKDIR /app
COPY . .
RUN gem install bundler jekyll
RUN jekyll new my-awesome-site
ENTRYPOINT cd my-awesome-site && bundle exec jekyll serve -H 0.0.0.0 -P 80