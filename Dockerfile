FROM ruby:2.7.1-alpine3.12

RUN apk update && apk add gcc less libc-dev make

WORKDIR /app

COPY ./Gemfile* ./

RUN bundle install --jobs=4
