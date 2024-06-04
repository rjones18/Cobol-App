# Use an official Ubuntu base image
FROM ubuntu:20.04

ENV DEBIAN_FRONTEND=noninteractive

# # Install necessary packages
RUN apt update
RUN apt install -y open-cobol apache2
RUN a2enmod cgi
# RUN systemctl restart apache2
    

# Update the Apache configuration
COPY script.sh ./script.sh

RUN chmod +x script.sh

RUN ./script.sh

# Expose port 80
EXPOSE 80
