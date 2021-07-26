#!/usr/bin/bash

# wget https://raw.githubusercontent.com/mugimugi555/raspberrypi/main/install_tvtuner.sh && bash install_tvtuner.sh ;

# NOTE : I did not run this script test.

# install docker
# https://devdojo.com/bobbyiliev/how-to-install-docker-and-docker-compose-on-raspberry-pi

echo "=====================";
echo "   install docker";
echo "=====================";

curl -fsSL https://get.docker.com -o get-docker.sh ;
sudo sh get-docker.sh ;
sudo usermod -aG docker ${USER} ;
sudo su - ${USER} ;
docker version ;
docker run hello-world ;

# install docker compose

echo "=====================";
echo "install docker compose";
echo "=====================";

sudo apt install -y libffi-dev libssl-dev ;
sudo apt install python3-dev ;
sudo apt install -y python3 python3-pip ;
sudo pip3 install docker-compose ;

# install mirakurun
# https://github.com/Chinachu/Mirakurun

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
chromium http://localhost:40772/ &

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
chromium http://localhost:20772/ &
./chinachu service wui execute ;

echo "=====================";
echo "  install node latest";
echo "=====================";

sudo apt install -y nodejs npm ;
sudo npm install n -g ;
sudo n stable ;
sudo apt purge -y nodejs npm ;
exec $SHELL -l ;
node -v ;

echo "=====================";
echo "  install pm2 service";
echo "=====================";

sudo npm install -g pm2 ;
sudo pm2 start processes.json ;
sudo pm2 save ;
sudo pm2 startup ;
