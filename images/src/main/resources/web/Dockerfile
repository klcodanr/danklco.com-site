#
#		 Licensed to the Apache Software Foundation (ASF) under one or more contributor license
#        agreements. See the NOTICE file distributed with this work for additional information
#        regarding copyright ownership. The ASF licenses this file to you under the Apache License,
#        Version 2.0 (the "License"); you may not use this file except in compliance with the
#        License. You may obtain a copy of the License at http://www.apache.org/licenses/LICENSE-2.0
#        Unless required by applicable law or agreed to in writing, software distributed under the
#        License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND,
#        either express or implied. See the License for the specific language governing permissions
#        and limitations under the License.

# Pull base image.
FROM ubuntu:latest

# Avoid interaction with tzdata
ARG DEBIAN_FRONTEND=noninteractive

# Install Apache
RUN apt-get update && apt-get install apache2 -y \
     && rm -rf /var/lib/apt/lists/*

# Enable Apache modules
RUN a2enmod rewrite && a2enmod proxy && a2enmod proxy_http && a2enmod cache \
     && a2enmod cache_disk && a2enmod expires && a2enmod headers && a2enmod ssl

# Configure sites
RUN mkdir -p /etc/cloudflare 
COPY *.conf /etc/apache2/sites-enabled/
COPY 503.html /var/www/html
COPY cloudflare/ /etc/cloudflare/

# Expose endpoints
EXPOSE 80 443

# Start Apache httpd
RUN service apache-htcacheclean start
CMD ["/usr/sbin/apache2ctl", "-DFOREGROUND"]
