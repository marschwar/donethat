FROM ruby:2.1

RUN apt-get update -qq -y
RUN apt-get install -qq -y \
    build-essential             \
    libcurl4-openssl-dev        \
    libmysqlclient-dev          \
    libpq-dev                   \
    libvpx-dev                  \
    libjpeg-dev                 \
    libpng-dev                  \
    icu-devtools libicu-dev     \
    libmcrypt-dev               \
    libxml2-dev libxslt1-dev    \
    nodejs  

ENV APP_HOME /myapp
RUN mkdir $APP_HOME
WORKDIR $APP_HOME

ADD Gemfile* $APP_HOME/
RUN bundle install

ADD . $APP_HOME
