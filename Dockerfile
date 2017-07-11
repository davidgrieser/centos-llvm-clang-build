FROM centos:7

CMD bash

RUN yum update -y && yum groupinstall -y development &&  yum install -y svn cmake

# Checkout LLVM
RUN svn co http://llvm.org/svn/llvm-project/llvm/trunk llvm

# Checkout Clang
RUN cd llvm/tools && svn co http://llvm.org/svn/llvm-project/cfe/trunk clang && cd ../..

# Download cmake to 3.8.2
RUN curl -o cmake-3.8.2.sh https://cmake.org/files/v3.8/cmake-3.8.2-Linux-x86_64.sh

# Install cmake
RUN yes y | sh ./cmake-3.8.2.sh

# Build LLVM and Clang
ENV PATH /cmake-3.8.2-Linux-x86_64/bin/cmake:$PATH
RUN mkdir build && cd build && /cmake-3.8.2-Linux-x86_64/bin/cmake -G "Unix Makefiles" ../llvm && make -j4

# Run Test Suite
RUN make check-clang

