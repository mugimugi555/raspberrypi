#!/usr/bin/bash

# wget

cd ;

echo "==============================";
echo " download openvino";
echo "==============================";
wget "https://storage.openvinotoolkit.org/repositories/openvino/packages/2021.4/l_openvino_toolkit_runtime_raspbian_p_2021.4.582.tgz"
sudo mkdir -p /opt/intel/openvino_2021
sudo tar -xf l_openvino_toolkit_runtime_raspbian_p_2021.4.582.tgz --strip 1 -C /opt/intel/openvino_2021 ;
sudo apt update 
sudo apt install cmake

echo "==============================";
echo " add config";
echo "==============================";
source /opt/intel/openvino_2021/bin/setupvars.sh ;
echo "source /opt/intel/openvino_2021/bin/setupvars.sh" >> ~/.bashrc ;
sudo usermod -a -G users "$(whoami)" ;
source /opt/intel/openvino_2021/bin/setupvars.sh ;
sh /opt/intel/openvino_2021/install_dependencies/install_NCS_udev_rules.sh ;

echo "==============================";
echo " make samples";
echo "==============================";
mkdir build ;
cd build ;
cmake -DCMAKE_BUILD_TYPE=Release -DCMAKE_CXX_FLAGS="-march=armv7-a" /opt/intel/openvino_2021/deployment_tools/inference_engine/samples/cpp ;
#make -j2 object_detection_sample_ssd ;
make -j2 * ;

echo "==============================";
echo " download models";
echo "==============================";

git clone --depth 1 https://github.com/openvinotoolkit/open_model_zoo ;
cd open_model_zoo/tools/downloader ;
python3 -m pip install -r requirements.in ;
git clone --depth 1 https://github.com/openvinotoolkit/open_model_zoo ;
cd open_model_zoo/tools/downloader ;
python3 -m pip install -r requirements.in ;
python3 downloader.py --name face-detection-adas-0001  ;

#./armv7l/Release/object_detection_sample_ssd -m <path_to_model>/face-detection-adas-0001.xml -d MYRIAD -i <path_to_image>
