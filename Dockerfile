FROM ruby:2.4.2
MAINTAINER TomoProg <helloworld0306.xxx@gmail.com>
RUN apt-get update && apt-get install -y \
	vim-tiny
WORKDIR /app
