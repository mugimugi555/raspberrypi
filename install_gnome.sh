

wget https://github.com/TerraGitHuB/gnomeforpi/archive/refs/heads/stable.zip ;
unzip stable.zip ;
cd gnomeforpi-stable ;

sudo ./gnomeforpi-install ;
# - or - 
#sudo gnomeforpi-install --lite

sudo update-alternatives --config x-session-manager ;
