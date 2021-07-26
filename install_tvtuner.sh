#!/usr/bin/bash

# wget 

# NOTE : I did not run this script test.

# install docker

echo "=====================";
echo "   install docker";
echo "=====================";

curl -fsSL https://get.docker.com -o get-docker.sh
sudo sh get-docker.sh
sudo usermod -aG docker ${USER}
sudo su - ${USER}
docker version
docker run hello-world

# install docker compose

echo "=====================";
echo "install docker compose";
echo "=====================";

sudo apt-get install libffi-dev libssl-dev
sudo apt install python3-dev
sudo apt-get install -y python3 python3-pip
sudo pip3 install docker-compose

# install mirakurun

echo "=====================";
echo " install mirakurun";
echo "=====================";

cd ;
mkdir mirakurun ;
cd mirakurun ;
wget https://raw.githubusercontent.com/Chinachu/Mirakurun/master/docker/docker-compose.yml ;
docker-compose pull ;
docker-compose run --rm -e SETUP=true mirakurun
docker-compose up -d ;
ls -al /usr/local/mirakurun/* ;
curl -X PUT "http://localhost:40772/api/config/channels/scan" ;

# install chinachu ( web gui )

echo "=====================";
echo "  install chinachu";
echo "=====================";

cd ;
git clone git://github.com/kanreisa/Chinachu.git ;
cd Chinachu ;
mkdir recorded ;
echo "[]" > rules.json ;
cp config.sample.json config.json ;

echo "=====================";
echo "chinachu install please input 1";
echo "=====================";

./chinachu installer 1 ;
./chinachu update ;
./chinachu service wui execute ;

sudo pm2 start processes.json ;
sudo pm2 save ;
sudo pm2 startup ;
