FROM ruby:2.6.3-alpine

RUN apk update && apk add bash build-base nodejs tzdata

WORKDIR /app


COPY Gemfile Gemfile.lock ./
RUN gem install bundler  -v '2.3.12'
RUN gem update --system '2.7.10'
RUN bundle update
RUN bundle install --no-binstubs --jobs $(nproc) --retry 3

COPY . .

EXPOSE 3000


CMD ["bundle", "exec", "rails", "server", "-b", "0.0.0.0"]
