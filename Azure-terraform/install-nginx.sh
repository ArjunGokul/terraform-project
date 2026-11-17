
#!/bin/bash

# Update packages
sudo apt-get update -y

# Install Nginx
sudo apt-get install -y nginx

# Enable and start Nginx
sudo systemctl enable nginx && sudo systemctl start nginx && sudo systemctl status nginx