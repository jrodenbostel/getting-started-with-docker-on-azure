FROM node:0.12.14-wheezy

# Install Mongo
RUN apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv EA312927
RUN echo "deb http://repo.mongodb.org/apt/debian wheezy/mongodb-org/3.2 main" | tee /etc/apt/sources.list.d/mongodb-org-3.2.list
RUN apt-get update

RUN apt-get install -y mongodb-org

# Install gem sass for  grunt-contrib-sass
RUN apt-get install -y supervisor

# Install gem sass for  grunt-contrib-sass
RUN apt-get update -qq && apt-get install -y build-essential
RUN apt-get install -y ruby
RUN gem install sass

WORKDIR /home/mean

RUN mkdir -p /var/log/supervisor
RUN mkdir -p /data/db
RUN mkdir ./logs

COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf

# Install Mean.JS Prerequisites
RUN npm install -g grunt-cli
RUN npm install -g bower

# Install Mean.JS packages
ADD package.json /home/mean/package.json
RUN npm install

# Manually trigger bower. Why doesnt this work via npm install?
ADD .bowerrc /home/mean/.bowerrc
ADD bower.json /home/mean/bower.json
RUN bower install --config.interactive=false --allow-root

# Make everything available for start
ADD . /home/mean

# Set development environment as default
ENV NODE_ENV development

EXPOSE 3000
CMD ["/usr/bin/supervisord"]
