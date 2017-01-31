FROM ruby:2.4.0-alpine
RUN apk add --no-cache gcc musl-dev make
RUN gem install jekyll bundler redcarpet
RUN mkdir -p /usr/app/jekyll
WORKDIR /usr/app/jekyll
CMD ["jekyll", "serve", "--host","0.0.0.0"]
