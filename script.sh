#!/bin/bash
cat <<'EOF' > /etc/apache2/sites-available/000-default.conf
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