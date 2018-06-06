FROM ruby:2.5.1

RUN mkdir /blockchain
WORKDIR /blockchain
COPY Gemfile .
COPY Gemfile.lock .
RUN bundle install
COPY . .
RUN rm data/*.db

CMD ["bin/ruby-coin", "node"]
