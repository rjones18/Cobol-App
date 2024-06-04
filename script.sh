#!/bin/bash

# Ensure the script is run with sudo
if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root" 
   exit 1
fi

# Install necessary packages
# apt update
# apt install -y open-cobol apache2

# # Enable CGI module in Apache
# a2enmod cgi
systemctl restart apache2

# Create the COBOL source file
cat << 'EOF' > /usr/lib/cgi-bin/hello.cob
       IDENTIFICATION DIVISION.
       PROGRAM-ID. HELLO.

       ENVIRONMENT DIVISION.
       INPUT-OUTPUT SECTION.

       DATA DIVISION.

       WORKING-STORAGE SECTION.
       01 WS-OUTPUT PIC X(80) VALUE "Content-Type: text/html".
       01 WS-BODY-1 PIC X(40) VALUE "<html><body><h1>Hello, ".
       01 WS-BODY-2 PIC X(40) VALUE "World!</h1></body></html>".

       PROCEDURE DIVISION.
           DISPLAY WS-OUTPUT.
           DISPLAY " ".
           DISPLAY WS-BODY-1.
           DISPLAY WS-BODY-2.
           STOP RUN.
EOF

# Compile the COBOL script
cobc -x -o /usr/lib/cgi-bin/hello /usr/lib/cgi-bin/hello.cob
chmod +x /usr/lib/cgi-bin/hello

# Create the index.cgi script
cat << 'EOF' > /usr/lib/cgi-bin/index.cgi
#!/bin/bash
echo "Content-Type: text/html"
echo ""
/usr/lib/cgi-bin/hello
EOF

# Make the index.cgi script executable
chmod +x /usr/lib/cgi-bin/index.cgi

# Update the Apache configuration
cat << 'EOF' > /etc/apache2/sites-available/000-default.conf
<VirtualHost *:80>
        ServerAdmin webmaster@localhost
        DocumentRoot /usr/lib/cgi-bin

        ErrorLog ${APACHE_LOG_DIR}/error.log
        CustomLog ${APACHE_LOG_DIR}/access.log combined

        # Enable CGI scripts in the new document root
        <Directory "/usr/lib/cgi-bin">
                Options +ExecCGI
                AddHandler cgi-script .cgi .pl .py .sh .cob
                DirectoryIndex index.cgi
                Require all granted
        </Directory>
</VirtualHost>

# vim: syntax=apache ts=4 sw=4 sts=4 sr noet
EOF

# Restart Apache to apply the changes
systemctl restart apache2

echo "Setup complete. You can now navigate to http://localhost to see your COBOL CGI application."
