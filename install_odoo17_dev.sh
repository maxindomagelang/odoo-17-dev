#!/bin/bash

echo "🚀 INSTALL ODOO 17 DEV ENVIRONMENT"

# Update system
sudo apt update && sudo apt upgrade -y

# Install dependencies
sudo apt install -y python3 python3-pip python3-dev python3-venv python3-wheel \
build-essential git wget curl nodejs npm \
libxml2-dev libxslt1-dev zlib1g-dev libsasl2-dev libldap2-dev libssl-dev \
libjpeg-dev libpq-dev libffi-dev libtiff-dev libopenjp2-7-dev liblcms2-dev \
libwebp-dev libharfbuzz-dev libfribidi-dev libxcb1-dev \
fonts-dejavu fonts-liberation fonts-noto-core \
postgresql

# Install wkhtmltopdf (recommended version)
cd /tmp
wget https://github.com/wkhtmltopdf/packaging/releases/download/0.12.6.1-2/wkhtmltox_0.12.6.1-2.jammy_amd64.deb
sudo apt install -y ./wkhtmltox_0.12.6.1-2.jammy_amd64.deb

# Install rtlcss
sudo npm install -g rtlcss

# Setup PostgreSQL user
sudo -u postgres createuser -s odoo || true

# Create Odoo directory
sudo mkdir -p /opt/odoo17
sudo chown $USER:$USER /opt/odoo17

cd /opt/odoo17

# Clone Odoo 17
git clone https://github.com/odoo/odoo.git --depth 1 --branch 17.0 .

# Create virtual environment
python3 -m venv venv
source venv/bin/activate

# Upgrade pip
pip install --upgrade pip wheel

# Install Python requirements
pip install -r requirements.txt

# Create custom addons folder
mkdir custom-addons

# Create config file
cat <<EOF > odoo.conf
[options]
admin_passwd = admin123
db_host = False
db_port = False
db_user = odoo
db_password = False

addons_path = addons,custom-addons
logfile = /opt/odoo17/odoo.log
xmlrpc_port = 8069

dev_mode = True
EOF

echo ""
echo "✅ INSTALL SELESAI!"
echo ""
echo "Jalankan Odoo dengan:"
echo "cd /opt/odoo17"
echo "source venv/bin/activate"
echo "./odoo-bin -c odoo.conf --dev=all"
echo ""
echo "Akses di browser:"
echo "http://localhost:8069"
