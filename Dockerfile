# Use an official Ubuntu slim base image
FROM ubuntu:20.04

# Set environment variables to avoid interactive prompts during package installation
ENV DEBIAN_FRONTEND=noninteractive

# Install necessary packages
RUN apt-get update && \
    apt-get install -y --no-install-recommends open-cobol apache2 && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Enable CGI module in Apache
RUN a2enmod cgi

# Copy the COBOL source file
COPY hello.cob /usr/lib/cgi-bin/hello.cob

# Compile the COBOL script
RUN cobc -x -o /usr/lib/cgi-bin/hello /usr/lib/cgi-bin/hello.cob && \
    chmod +x /usr/lib/cgi-bin/hello

# Create the index.cgi script
RUN echo '#!/bin/bash\n\
echo "Content-Type: text/html"\n\
echo ""\n\
/usr/lib/cgi-bin/hello' > /usr/lib/cgi-bin/index.cgi && \
    chmod +x /usr/lib/cgi-bin/index.cgi

# Update the Apache configuration to use port 8080
COPY default.conf /etc/apache2/sites-available/000-default.conf

# Create the log directory
RUN mkdir -p /var/log/apache2

# Expose port 8080
EXPOSE 8080

# Start Apache in the foreground
CMD ["apachectl", "-D", "FOREGROUND"]

