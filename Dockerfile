# Use an official Ubuntu base image
FROM ubuntu:20.04

ENV DEBIAN_FRONTEND=noninteractive

# Install necessary packages
RUN apt-get update && \
    apt-get install -y open-cobol apache2 && \
    apt-get clean

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
    


    
# Update the Apache configuration
RUN cat << 'EOF' > /etc/apache2/sites-available/000-default.conf
<VirtualHost *:80>
        ServerAdmin webmaster@localhost
        DocumentRoot /usr/lib/cgi-bin
        ErrorLog ${APACHE_LOG_DIR}/error.log
        CustomLog ${APACHE_LOG_DIR}/access.log combined
        <Directory "/usr/lib/cgi-bin">
                Options +ExecCGI
                AddHandler cgi-script .cgi .pl .py .sh .cob
                DirectoryIndex index.cgi
                Require all granted
        </Directory>
</VirtualHost>
# vim: syntax=apache ts=4 sw=4 sts=4 sr noet
EOF

# Expose port 80
EXPOSE 80

# Start Apache in the foreground
CMD ["apachectl", "-D", "FOREGROUND"]
