yum -y install bzip2-devel libtool

cd /opt && wget http://www.cmake.org/files/v2.8/cmake-2.8.12.2.tar.gz
tar xvf cmake-2.8.12.2.tar.gz && cd cmake-2.8.12.2
./configure && make && make install

cd /opt && git clone https://github.com/ehdtee/colm.git
cd colm && ./autogen.sh
./configure
make && make install

cd /opt && git clone https://github.com/ehdtee/ragel.git
cd ragel && ./autogen.sh
./configure --prefix=/usr --disable-manual
make && make install

cd /opt && wget https://google-glog.googlecode.com/files/glog-0.3.3.tar.gz
tar xvf glog-0.3.3.tar.gz && cd glog-0.3.3
./configure && make && make install

cd /opt && git clone https://code.google.com/p/gflags/
cd gflags && mkdir build && cd build
ccmake ..
make && make install

yum -y install centos-release-SCL
yum -y install python27
scl enable python27 "easy_install pip"

scl enable python27 bash
cd /opt && wget http://downloads.sourceforge.net/boost/boost_1_56_0.tar.bz2
tar jxf boost_1_56_0.tar.bz2 && cd boost_1_56_0
./bootstrap.sh --prefix=/usr && ./b2 stage threading=multi link=shared
./b2 install threading=multi link=shared

cd /opt && git clone https://github.com/facebook/mcrouter.git
cd mcrouter/mcrouter && autoreconf --install
./configure
make && make install
mcrouter --help
