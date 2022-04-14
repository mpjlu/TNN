#!/bin/bash

export TENSORRT_ROOT_DIR=/root/software/TensorRT-8.2.0.6
export CUDNN_ROOT_DIR=/usr/local/cuda-11.5/
export LIBTORCH_ROOT_DIR=/root/anaconda3/envs/py38/lib/python3.8/site-packages/torch/
TNNTORCH="ON"

if [ -z $TNN_ROOT_PATH ]
then
    TNN_ROOT_PATH=$(cd `dirname $0`; pwd)/..
fi

BUILD_DIR=${TNN_ROOT_PATH}/scripts/build_cuda_linux
TNN_INSTALL_DIR=${TNN_ROOT_PATH}/scripts/cuda_linux_release

TNN_VERSION_PATH=$TNN_ROOT_PATH/scripts/version
cd $TNN_VERSION_PATH
source $TNN_VERSION_PATH/version.sh
source $TNN_VERSION_PATH/add_version_attr.sh

mkdir -p ${BUILD_DIR}
cd ${BUILD_DIR}

cmake ${TNN_ROOT_PATH} \
    -DTNN_TEST_ENABLE=ON \
    -DTNN_CPU_ENABLE=ON \
    -DTNN_X86_ENABLE=OFF \
    -DTNN_CUDA_ENABLE=ON \
    -DTNN_TENSORRT_ENABLE=ON \
    -DTNN_TNNTORCH_ENABLE=${TNNTORCH} \
    -DTNN_BENCHMARK_MODE=OFF \
    -DTNN_BUILD_SHARED=ON \
    -DTNN_CONVERTER_ENABLE=OFF \
    -DTNN_PYBIND_ENABLE=OFF

echo "Building TNN ..."
make -j32

if [ -d ${TNN_INSTALL_DIR} ]
then 
    rm -rf ${TNN_INSTALL_DIR}
fi
mkdir ${TNN_INSTALL_DIR}
mkdir ${TNN_INSTALL_DIR}/lib
mkdir ${TNN_INSTALL_DIR}/bin

cp -r ${TNN_ROOT_PATH}/include ${TNN_INSTALL_DIR}/
cp libTNN.so* ${TNN_INSTALL_DIR}/lib
cp test/TNNTest ${TNN_INSTALL_DIR}/bin

echo "Done"
