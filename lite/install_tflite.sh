#!/usr/bin/bash

exit;

# wget

#-----------------------------------------------------------------------------------------------------------------------
# swap
#-----------------------------------------------------------------------------------------------------------------------
sudo echo "CONF_SWAPSIZE=2048" | sudo tee /etc/dphys-swapfile ;
sudo /etc/init.d/dphys-swapfile restart ;

#-----------------------------------------------------------------------------------------------------------------------
#
#-----------------------------------------------------------------------------------------------------------------------
sudo apt update ;
sudo apt upgrade -y ;
sudo apt install -y cmake git ;
sudo apt install -y python3.9-dev ;
sudo apt install -y python3-numpy ;

#-----------------------------------------------------------------------------------------------------------------------
#
#-----------------------------------------------------------------------------------------------------------------------
cd ~
git clone https://github.com/tensorflow/tensorflow.git tensorflow_src
mkdir tflite_build
cd tflite_build
sudo cmake ../tensorflow_src/tensorflow/lite \
    -DCMAKE_C_FLAGS="-I/usr/include/python3.9 -I/home/pi/.local/lib/python3.9/site-packages/pybind11/include" \
    -DCMAKE_CXX_FLAGS="-I/usr/include/python3.9 -I/home/pi/.local/lib/python3.9/site-packages/pybind11/include" \
    -DCMAKE_SHARED_LINKER_FLAGS='-latomic'\
    -DCMAKE_SYSTEM_NAME=Linux \
    -DCMAKE_SYSTEM_PROCESSOR=armv6 \
    -DTFLITE_ENABLE_XNNPACK=OFF
sudo cmake --build . --verbose -j 1 -t _pywrap_tensorflow_interpreter_wrapper

#-----------------------------------------------------------------------------------------------------------------------
#
#-----------------------------------------------------------------------------------------------------------------------
cd ~/tensorflow_src/tensorflow/lite/tools/pip_package/
sudo mkdir gen
sudo mkdir gen/tflite_pip
sudo mkdir gen/tflite_pip/python3.9
sudo mkdir gen/tflite_pip/python3.9/tflite_runtime
cd gen/tflite_pip/python3.9
sudo cp -r ~/tensorflow_src/tensorflow/lite/tools/pip_package/debian/ ./
sudo cp -r ~/tensorflow_src/tensorflow/lite/tools/pip_package/MANIFEST.in ./
sudo cp -r ~/tensorflow_src/tensorflow/lite/python/interpreter_wrapper/ ./
sudo cp ~/tensorflow_src/tensorflow/lite/tools/pip_package/setup_with_binary.py ./setup.py
sudo cp ~/tensorflow_src/tensorflow/lite/python/interpreter.py ./tflite_runtime/
sudo cp ~/tensorflow_src/tensorflow/lite/python/metrics_interface.py ./tflite_runtime/
sudo cp ~/tensorflow_src/tensorflow/lite/python/metrics_portable.py ./tflite_runtime/
sudo cp ~/tflite_build/_pywrap_tensorflow_interpreter_wrapper.so ./tflite_runtime/
sudo chmod u+w ./tflite_runtime/_pywrap_tensorflow_interpreter_wrapper.so
sudo touch ./tflite_runtime/__init__.py
sudo echo "__version__ = '2.8.0'" >> ./tflite_runtime/__init__.py
sudo echo "__git_version__ = '$(git -C ~/tensorflow_src describe)'" >> ./tflite_runtime/__init__.py
sudo python3 setup.py bdist --plat-name=linux_armv6l bdist_wheel --plat-name=linux-armv6l

#-----------------------------------------------------------------------------------------------------------------------
#
#-----------------------------------------------------------------------------------------------------------------------
ls -al ~/tensorflow_src/tensorflow/lite/tools/pip_package/gen/tflite_pip/python3.9/dist
