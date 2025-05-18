#!/bin/bash
# Install required packages
echo  '[+] Installing apache2 and net tools' > /home/ubuntu/log.txt
sudo apt update && apt install -y apache2 net-tools
sudo chown -R ubuntu:www-data /var/www/html  # required so that user ubuntu can write files to /var/www/html/ folder
echo  '[+] Installed apache2 and net-tools' >> /home/ubuntu/log.txt

# Enable required Apache modules
sudo a2enmod ssl rewrite proxy proxy_http

echo  '[+] Enabled Apache modules' >> /home/ubuntu/log.txt

# Enable SSL site config
cd /etc/apache2/sites-enabled
sudo rm -f 000-default.conf
sudo ln -s ../sites-available/default-ssl.conf .

echo  '[+] Enabled Apache SSL conf' >> /home/ubuntu/log.txt

sudo systemctl restart apache2
echo  '[+] Restarted Apache' >> /home/ubuntu/log.txt



# Add <Directory> block if it doesn't exist
sudo grep -q "<Directory /var/www/html/>" /etc/apache2/sites-enabled/default-ssl.conf || \
sudo cat <<EOF >> /etc/apache2/sites-enabled/default-ssl.conf

<Directory /var/www/html/>
    Options Indexes FollowSymLinks MultiViews
    AllowOverride All
    Require all granted
</Directory>
EOF

echo  '[+] Added Directory block to default-ssl.conf' >> /home/ubuntu/log.txt


# Insert SSLProxyEngine on after SSLEngine on
sudo grep -q "SSLProxyEngine on" /etc/apache2/sites-enabled/default-ssl.conf || \
sudo sed -i '/SSLEngine on/a SSLProxyEngine on' /etc/apache2/sites-enabled/default-ssl.conf
sudo sed -i '/SSLProxyEngine on/a SSLProxyVerify none' /etc/apache2/sites-enabled/default-ssl.conf
sudo sed -i '/SSLProxyVerify none/a SSLProxyCheckPeerCN off' /etc/apache2/sites-enabled/default-ssl.conf
sudo sed -i '/SSLProxyCheckPeerCN off/a SSLProxyCheckPeerName off' /etc/apache2/sites-enabled/default-ssl.conf
sudo sed -i '/SSLProxyCheckPeerName off/a SSLProxyCheckPeerExpire off' /etc/apache2/sites-enabled/default-ssl.conf


echo  '[+] Enabled SSLEngine on and SSLProxyEngine on' >> /home/ubuntu/log.txt


# Create .htaccess file with reverse proxy rule and index.html
cd /var/www/html
sudo cat <<EOF > /var/www/html/.htaccess
RewriteEngine On

# Disable mod_dir default index.html serving
DirectoryIndex disabled

# Serve index.html explicitly for GET /
RewriteCond %%{REQUEST_METHOD} =GET
RewriteCond %%{REQUEST_URI} ^/$
RewriteRule ^$ /index.html [L]

# Serve existing files normally for GET
RewriteCond %%{REQUEST_METHOD} =GET
RewriteCond %%{DOCUMENT_ROOT}%%{REQUEST_URI} -f
RewriteRule ^ - [L]

# Proxy all POST requests to local HTTPS port
RewriteCond %%{REQUEST_METHOD} =POST
RewriteRule ^(.*)$ https://localhost:8443/$1 [P]

# Optional: Proxy all unmatched GET requests
RewriteCond %%{REQUEST_METHOD} =GET
RewriteRule ^(.*)$ https://localhost:8443/$1 [P]
EOF

sudo cat <<EOF > /var/www/html/index.html
Welcome to 100 Days of Red Team
EOF


sudo chown www-data:www-data /var/www/html/.htaccess

sudo chown www-data:www-data /var/www/html/index.html

echo  '[+] Created .htaccess and index.html' >> /home/ubuntu/log.txt

# Restart Apache
sudo systemctl restart apache2

echo  '[+] Restarted Apache' >> /home/ubuntu/log.txt