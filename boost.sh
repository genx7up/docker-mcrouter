yum -y install bzip2-devel libtool gflags-devel libevent-devel libcap-devel openssl-devel

#CMAKE
cd /opt && wget http://www.cmake.org/files/v2.8/cmake-2.8.12.2.tar.gz
tar xvf cmake-2.8.12.2.tar.gz && cd cmake-2.8.12.2
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
export LDFLAGS=-L/opt/double-conversion/
export CPPFLAGS=-I/opt/double-conversion/
export LD_LIBRARY_PATH="/opt/folly/folly/lib:$LD_LIBRARY_PATH"
export LD_RUN_PATH="/opt/folly/folly/lib"
export LDFLAGS="-L/opt/folly/folly/lib -L/opt/double-conversion -ldl"
export CPPFLAGS="-I/opt/folly/folly/include -I/opt/double-conversion"
autoreconf -ivf
./configure
make && make install

#Python27 for Boost
yum -y install centos-release-SCL
yum -y install python27
scl enable python27 "easy_install pip"

#Boost
scl enable python27 bash
cd /opt && wget http://downloads.sourceforge.net/boost/boost_1_56_0.tar.bz2
tar jxf boost_1_56_0.tar.bz2 && cd boost_1_56_0
./bootstrap.sh --prefix=/usr && ./b2 stage threading=multi link=shared
./b2 install threading=multi link=shared

#McRouter
cd /opt && git clone https://github.com/facebook/mcrouter.git
cd mcrouter/mcrouter && autoreconf --install
./configure
make && make install
mcrouter --help
