

# wget https://raw.githubusercontent.com/mugimugi555/raspberrypi/main/lite/tensorflow/create_tensorflow_lite.sh && bash create_tensorflow_lite.sh ;

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
sudo apt install -y python3-pip ;
sudo apt install -y python3-numpy ;
pip3 install pybind11 ;

#-----------------------------------------------------------------------------------------------------------------------
#
#-----------------------------------------------------------------------------------------------------------------------
cd ~ ;
git clone https://github.com/tensorflow/tensorflow.git tensorflow_src ;
mkdir tflite_build ;
cd tflite_build ;
sudo cmake ../tensorflow_src/tensorflow/lite \
    -DCMAKE_C_FLAGS="-I/usr/include/python3.9 -I/home/pi/.local/lib/python3.9/site-packages/pybind11/include" \
    -DCMAKE_CXX_FLAGS="-I/usr/include/python3.9 -I/home/pi/.local/lib/python3.9/site-packages/pybind11/include" \
    -DCMAKE_SHARED_LINKER_FLAGS='-latomic'\
    -DCMAKE_SYSTEM_NAME=Linux \
    -DCMAKE_SYSTEM_PROCESSOR=armv6 \
    -DTFLITE_ENABLE_XNNPACK=OFF ;
sudo cmake --build . --verbose -j 1 -t _pywrap_tensorflow_interpreter_wrapper ;

#-----------------------------------------------------------------------------------------------------------------------
#
#-----------------------------------------------------------------------------------------------------------------------
cd ~/tensorflow_src/tensorflow/lite/tools/pip_package/ ;
mkdir gen ;
mkdir gen/tflite_pip ;
mkdir gen/tflite_pip/python3.9 ;
mkdir gen/tflite_pip/python3.9/tflite_runtime ;
cd gen/tflite_pip/python3.9 ;
cp -r ~/tensorflow_src/tensorflow/lite/tools/pip_package/debian/ ./ ;
cp -r ~/tensorflow_src/tensorflow/lite/tools/pip_package/MANIFEST.in ./ ;
cp -r ~/tensorflow_src/tensorflow/lite/python/interpreter_wrapper/ ./ ;
cp ~/tensorflow_src/tensorflow/lite/tools/pip_package/setup_with_binary.py ./setup.py ;
cp ~/tensorflow_src/tensorflow/lite/python/interpreter.py ./tflite_runtime/ ;
cp ~/tensorflow_src/tensorflow/lite/python/metrics/metrics_interface.py ./tflite_runtime/ ;
cp ~/tensorflow_src/tensorflow/lite/python/metrics/metrics_portable.py ./tflite_runtime/ ;
cp ~/tflite_build/_pywrap_tensorflow_interpreter_wrapper.so ./tflite_runtime/ ;
chmod u+w ./tflite_runtime/_pywrap_tensorflow_interpreter_wrapper.so ;

export PROJECT_NAME=tensorflow_lite ;
export PACKAGE_VERSION=2.8.0 ;
touch ./tflite_runtime/__init__.py ;
echo "__version__ = '2.8.0'" >> ./tflite_runtime/__init__.py ;
echo "__git_version__ = '$(git -C ~/tensorflow_src describe)'" >> ./tflite_runtime/__init__.py ;
python3 setup.py bdist --plat-name=linux_armv6l bdist_wheel --plat-name=linux-armv6l ;

#-----------------------------------------------------------------------------------------------------------------------
#
#-----------------------------------------------------------------------------------------------------------------------
ls -al ~/tensorflow_src/tensorflow/lite/tools/pip_package/gen/tflite_pip/python3.9/dist ;
cd ~/tensorflow_src/tensorflow/lite/tools/pip_package/gen/tflite_pip/python3.9/dist ;
pip3 install tensorflow_lite-2.8.0-cp39-cp39-linux_armv6l.whl ;
python3 -c 'import tflite_runtime as tf; print(tf.__version__)' ;
