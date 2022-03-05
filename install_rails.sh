#!/bin/bash

# wget https://raw.githubusercontent.com/mugimugi555/raspberrypi/main/install_rails.sh && bash install_rails.sh ;

#-----------------------------------------------------------------------------------------------------------------------
# one liner command
#-----------------------------------------------------------------------------------------------------------------------
#

#-----------------------------------------------------------------------------------------------------------------------
# install nodejs latest
#-----------------------------------------------------------------------------------------------------------------------
sudo apt update ;
sudo apt install -y nodejs npm ;
sudo npm install n -g ;
sudo n stable ;
sudo apt purge -y nodejs npm ;
sudo apt autoremove -y ;
node -v ;

#-----------------------------------------------------------------------------------------------------------------------
# install library
#-----------------------------------------------------------------------------------------------------------------------
sudo apt update ;
sudo apt install -y yarn ;
sudo apt install -y sqlite3 libsqlite3-dev ;
sudo apt install -y git-all ;

#-----------------------------------------------------------------------------------------------------------------------
# install rbenv
#-----------------------------------------------------------------------------------------------------------------------

# setting rbenv
cd ;
git clone https://github.com/rbenv/rbenv.git ~/.rbenv ;
echo 'export PATH="$HOME/.rbenv/bin:$PATH"' >> ~/.profile ;
source ~/.profile ;

# setting rbenv selected version
rbenv init ;
echo 'eval "$(rbenv init - bash)"' >> ~/.profile ;
source ~/.profile ;

# create rbenv custom ruby version
mkdir -p ~/.rbenv/plugins ;
git clone https://github.com/rbenv/ruby-build.git ~/.rbenv/plugins/ruby-build ;
sudo apt install -y                         \
	autoconf bison build-essential libssl-dev \
	libyaml-dev libreadline6-dev zlib1g-dev   \
	libncurses5-dev libffi-dev libgdbm6 libgdbm-dev ;
rbenv install --list ;
rbenv install 3.1.1 ;
rbenv versions ;
rbenv global 3.1.1 ;
ruby -v ;

#-----------------------------------------------------------------------------------------------------------------------
# install rails
#-----------------------------------------------------------------------------------------------------------------------
gem search -ea rails ;
gem install rails ;
rails -v ;
gem list rails ;

#-----------------------------------------------------------------------------------------------------------------------
# create rails project
#-----------------------------------------------------------------------------------------------------------------------
cd ;
mkdir railsProjects ;
cd railsProjects ;
rails new blog ;
cd blog ;

#-----------------------------------------------------------------------------------------------------------------------
# set service
#-----------------------------------------------------------------------------------------------------------------------
# bin/rails server -b $LOCAL_IPADDRESS -p 3000 ;
LOCAL_IPADDRESS=`hostname -I | awk -F" " '{print $1}'` ;
RAILS_SERVICE=$(cat<<TEXT
[Unit]
Description=RailsBlog
After=network.target

[Service]
Type=simple
Environment="PATH=/home/pi/.rbenv/shims:/home/pi/.rbenv/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin"
WorkingDirectory=/home/pi/railsProjects/blog
ExecStart=/home/pi/railsProjects/blog/bin/rails server -b $LOCAL_IPADDRESS -p 3000
Restart=always

[Install]
WantedBy=default.target
TEXT
)
echo "$RAILS_SERVICE" | sudo tee /etc/systemd/system/rails_blog.service ;
sudo systemctl enable rails_blog.service ;
sudo systemctl stop rails_blog.service ;
sudo systemctl start rails_blog.service ;
sudo systemctl status rails_blog.service ;

#-----------------------------------------------------------------------------------------------------------------------
# finish
#-----------------------------------------------------------------------------------------------------------------------
LOCAL_IPADDRESS=`hostname -I | awk -F" " '{print $1}'` ;
echo "=======================================";
echo "visit => http://$LOCAL_IPADDRESS:3000/" ;
echo "=======================================";
