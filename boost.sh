#!/bin/bash

yum -y install unzip bzip2-devel libtool gflags-devel libevent-devel libcap-devel openssl-devel 
yum -y install bison flex snappy-devel numactl-devel cyrus-sasl-devel

#CMAKE
cd /opt && wget http://www.cmake.org/files/v2.8/cmake-2.8.12.2.tar.gz
tar xvf cmake-2.8.12.2.tar.gz && cd cmake-2.8.12.2
./configure && make && make install

#AutoConf
cd /opt && http://ftp.gnu.org/gnu/autoconf/autoconf-2.69.tar.gz
tar xvf autoconf-2.69.tar.gz && cd autoconf-2.69
./configure && make && make install

#GLOG
cd /opt && wget https://google-glog.googlecode.com/files/glog-0.3.3.tar.gz
tar xvf glog-0.3.3.tar.gz && cd glog-0.3.3
./configure && make && make install

#COLM for RAGEL
cd /opt && git clone https://github.com/ehdtee/colm.git
cd colm && ./autogen.sh
./configure
make && make install

#RAGEL
cd /opt && git clone https://github.com/ehdtee/ragel.git
cd ragel && ./autogen.sh
./configure --prefix=/usr --disable-manual
make && make install

#Python27 for Boost
yum -y install centos-release-SCL
yum -y install python27
scl enable python27 "easy_install pip"

#Boost
scl enable python27 bash
python --version
cd /opt && wget http://downloads.sourceforge.net/boost/boost_1_56_0.tar.bz2
tar jxf boost_1_56_0.tar.bz2 && cd boost_1_56_0
./bootstrap.sh --prefix=/usr && ./b2 stage threading=multi link=shared
./b2 install threading=multi link=shared

#SCONS & double-conversion for Folly
rpm -Uvh http://sourceforge.net/projects/scons/files/scons/2.3.3/scons-2.3.3-1.noarch.rpm
cd /opt && git clone https://code.google.com/p/double-conversion/
cd double-conversion && scons install

#Folly
cd /opt && git clone https://github.com/genx7up/folly.git
cp folly/folly/SConstruct.double-conversion /opt/double-conversion/
cd double-conversion && scons -f SConstruct.double-conversion
ln -sf src double-conversion

#Folly
cd /opt/folly/folly/
export LD_LIBRARY_PATH="/opt/folly/folly/lib:$LD_LIBRARY_PATH"
export LD_RUN_PATH="/opt/folly/folly/lib"
export LDFLAGS="-L/opt/folly/folly/lib -L/opt/double-conversion -L/usr/local/lib -ldl"
export CPPFLAGS="-I/opt/folly/folly/include -I/opt/double-conversion"
autoreconf -ivf
./configure
make && make install

#Folly Test
cd /opt/folly/folly/test
wget https://googletest.googlecode.com/files/gtest-1.6.0.zip
unzip gtest-1.6.0.zip

#Thrift
cd /opt && git clone https://github.com/facebook/fbthrift.git
cd fbthrift/thrift
ln -sf thrifty.h "/opt/fbthrift/thrift/compiler/thrifty.hh"
export LD_LIBRARY_PATH="/opt/fbthrift/thrift/lib:$LD_LIBRARY_PATH"
export LD_RUN_PATH="/opt/fbthrift/thrift/lib"
export LDFLAGS="-L/opt/fbthrift/thrift/lib -L/usr/local/lib"
export CPPFLAGS="-I/opt/fbthrift/thrift/include -I/opt/fbthrift/thrift/include/python2.7 -I/opt/folly -I/opt/double-conversion"
echo "/usr/local/lib/" >> /etc/ld.so.conf.d/gcc-4.9.1.conf && ldconfig
/usr/local/bin/autoreconf -ivf
./configure --enable-boostthreads
cd /opt/fbthrift/thrift/compiler && make
cd /opt/fbthrift/thrift/lib/thrift && make
cd /opt/fbthrift/thrift/lib/cpp2 && make gen-cpp2/Sasl_types.h
cd /opt/fbthrift/thrift/lib/cpp2/test && make gen-cpp2/Service_constants.cpp
cd /opt/fbthrift/thrift && make && make install

#McRouter
cd /opt && git clone https://github.com/facebook/mcrouter.git
cd mcrouter/mcrouter
export LD_LIBRARY_PATH="/opt/mcrouter/mcrouter/lib:$LD_LIBRARY_PATH"
export LD_RUN_PATH="/opt/folly/folly/test/.libs:/opt/mcrouter/mcrouter/lib"
export LDFLAGS="-L/opt/mcrouter/mcrouter/lib -L/usr/local/lib -L/opt/folly/folly/test/.libs"
export CPPFLAGS="-I/opt/folly/folly/test/gtest-1.6.0/include -I/opt/mcrouter/mcrouter/include -I/opt/folly -I/opt/double-conversion -I/opt/fbthrift -I/opt/boost_1_56_0"
export CXXFLAGS="-fpermissive"
autoreconf --install && ./configure
make && make install
mcrouter --help
