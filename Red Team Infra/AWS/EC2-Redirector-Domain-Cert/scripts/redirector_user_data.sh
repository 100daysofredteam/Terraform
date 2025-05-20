#!/bin/bash
# Install required packages
echo  '[+] Installing apache2 and net tools' > /home/ubuntu/log.txt
sudo apt update && sudo apt install -y apache2 net-tools certbot python3-certbot-apache
sudo chown -R ubuntu:www-data /var/www/html  # required so that user ubuntu can write files to /var/www/html/ folder
echo  '[+] Installed apache2 and net-tools' >> /home/ubuntu/log.txt

# Enable required Apache modules
sudo a2enmod ssl rewrite proxy proxy_http

echo  '[+] Enabled Apache modules' >> /home/ubuntu/log.txt


cat <<'EOF' | sudo tee /etc/apache2/sites-enabled/000-default.conf
<VirtualHost *:80>
    ServerName ${domain_name}

    DocumentRoot /var/www/html

    # Required for Certbot to drop its challenge files here
    Alias /.well-known/acme-challenge/ /var/www/html/.well-known/acme-challenge/
    <Directory "/var/www/html/.well-known/acme-challenge/">
        AllowOverride None
        Options None
        Require all granted
    </Directory>

    ErrorLog $${APACHE_LOG_DIR}/error.log
    CustomLog $${APACHE_LOG_DIR}/access.log combined
</VirtualHost>
EOF

echo  '[+] Updated 000-default.conf for certbot verification' >> /home/ubuntu/log.txt

sudo systemctl restart apache2
echo  '[+] Restarted Apache' >> /home/ubuntu/log.txt


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
<html><head><title>Welcome to 100 Days of Red Team</title></head><body><h1>Welcome to 100 Days of Red Team</h1></body></html>
EOF


sudo chown www-data:www-data /var/www/html/.htaccess

sudo chown www-data:www-data /var/www/html/index.html

echo  '[+] Created .htaccess and index.html' >> /home/ubuntu/log.txt

# Restart Apache
sudo systemctl restart apache2

echo  '[+] Restarted Apache' >> /home/ubuntu/log.txt

DOMAIN="${domain_name}"

echo "Waiting for DNS to propagate..." >> /home/ubuntu/log.txt

while true; do
  A_RECORD=$(dig +short A "$DOMAIN")
  if [ -z "$A_RECORD" ]; then
    echo "DNS not propagated yet."
    sleep 10
  else
    echo "DNS propagated." >> /home/ubuntu/log.txt
    break
  fi
done

certbot --apache \
  --non-interactive \
  --agree-tos \
  --redirect \
  --email admin@$DOMAIN \
  -d $DOMAIN

echo  '[+] Generated the SSL certificate' >> /home/ubuntu/log.txt


# Insert SSLProxyEngine on after SSLEngine on
sudo sed -i '/<VirtualHost \*:443>/a SSLProxyEngine on' /etc/apache2/sites-enabled/000-default-le-ssl.conf
sudo sed -i '/SSLEngine on/a SSLProxyEngine on' /etc/apache2/sites-enabled/000-default-le-ssl.conf
sudo sed -i '/SSLProxyEngine on/a SSLProxyVerify none' /etc/apache2/sites-enabled/000-default-le-ssl.conf
sudo sed -i '/SSLProxyVerify none/a SSLProxyCheckPeerCN off' /etc/apache2/sites-enabled/000-default-le-ssl.conf
sudo sed -i '/SSLProxyCheckPeerCN off/a SSLProxyCheckPeerName off' /etc/apache2/sites-enabled/000-default-le-ssl.conf
sudo sed -i '/SSLProxyCheckPeerName off/a SSLProxyCheckPeerExpire off' /etc/apache2/sites-enabled/000-default-le-ssl.conf
echo  '[+] Enabled SSLEngine on and SSLProxyEngine on' >> /home/ubuntu/log.txt

sudo grep -q "<Directory /var/www/html/>" /etc/apache2/sites-enabled/000-default-le-ssl.conf || \
sudo sed -i '/<\/Directory>/a <Directory /var/www/html/>' /etc/apache2/sites-enabled/000-default-le-ssl.conf
sudo sed -i '/<Directory \/var\/www\/html\/>/a Options Indexes FollowSymLinks MultiViews' /etc/apache2/sites-enabled/000-default-le-ssl.conf
sudo sed -i '/Options Indexes FollowSymLinks MultiViews/a AllowOverride All' /etc/apache2/sites-enabled/000-default-le-ssl.conf
sudo sed -i '/AllowOverride All/a Require all granted' /etc/apache2/sites-enabled/000-default-le-ssl.conf
sed -i '/AllowOverride All/ {
    N
    /AllowOverride All\n[[:space:]]*Require all granted/ a\
</Directory>
}' /etc/apache2/sites-enabled/000-default-le-ssl.conf


echo  '[+] Updated Directory block' >> /home/ubuntu/log.txt

# Restart Apache
sudo systemctl restart apache2

echo  '[+] Restarted Apache' >> /home/ubuntu/log.txt