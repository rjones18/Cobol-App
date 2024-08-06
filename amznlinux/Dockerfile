# Use an official Amazon Linux base image
FROM amazonlinux:latest

# Install necessary packages for building GnuCOBOL
RUN yum update -y && \
    yum groupinstall -y "Development Tools" && \
    yum install -y gmp gmp-devel libdb libdb-devel libtool httpd && \
    yum clean all

# Download and install GnuCOBOL
RUN curl -O https://ftp.gnu.org/gnu/gnucobol/gnucobol-3.1.2.tar.xz && \
    tar xf gnucobol-3.1.2.tar.xz && \
    cd gnucobol-3.1.2 && \
    ./configure && \
    make && \
    make install && \
    cd .. && \
    rm -rf gnucobol-3.1.2 gnucobol-3.1.2.tar.xz

# Enable CGI module in Apache
RUN echo "LoadModule cgi_module modules/mod_cgi.so" >> /etc/httpd/conf/httpd.conf

# Copy the COBOL source file
COPY hello.cob /var/www/cgi-bin/hello.cob

# Compile the COBOL script
RUN cobc -x -o /var/www/cgi-bin/hello /var/www/cgi-bin/hello.cob && \
    chmod +x /var/www/cgi-bin/hello

# Create the index.cgi script
RUN echo '#!/bin/bash\n\
echo "Content-Type: text/html"\n\
echo ""\n\
/var/www/cgi-bin/hello' > /var/www/cgi-bin/index.cgi && \
    chmod +x /var/www/cgi-bin/index.cgi

# Update the Apache configuration to use port 8080
COPY default.conf /etc/httpd/conf.d/000-default.conf
# Create the log directory
RUN mkdir -p /var/log/httpd

# Expose port 8080
EXPOSE 8080

# Start Apache in the foreground
CMD ["httpd", "-D", "FOREGROUND"]
