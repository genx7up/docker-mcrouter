yum -y install git wget bzip2
yum -y install gcc

cd /opt && wget https://gmplib.org/download/gmp/gmp-5.1.3.tar.bz2
tar jxf gmp-5.1.3.tar.bz2 && cd gmp-5.1.3/
./configure --prefix=/usr/local/gmp
make && make install

cd /opt && wget http://www.mpfr.org/mpfr-current/mpfr-3.1.2.tar.bz2
tar jxf mpfr-3.1.2.tar.bz2 ;cd mpfr-3.1.2/
./configure --prefix=/usr/local/mpfr -with-gmp=/usr/local/gmp
make && make install 

cd /opt && wget http://www.multiprecision.org/mpc/download/mpc-1.0.1.tar.gz
tar xzf mpc-1.0.1.tar.gz ;cd mpc-1.0.1
./configure --prefix=/usr/local/mpc -with-mpfr=/usr/local/mpfr -with-gmp=/usr/local/gmp
make && make install

cd /opt && wget http://ftp.gnu.org/gnu/gcc/gcc-4.9.1/gcc-4.9.1.tar.bz2
tar jxf gcc-4.9.1.tar.bz2 ;cd gcc-4.9.1
./configure --prefix=/usr/local/gcc -enable-threads=posix -disable-checking -disable-multilib -enable-languages=c,c++ -with-gmp=/usr/local/gmp -with-mpfr=/usr/local/mpfr/ -with-mpc=/usr/local/mpc/
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/usr/local/mpc/lib:/usr/local/gmp/lib:/usr/local/mpfr/lib/
make && make install
[ $? -eq 0 ] && echo install success


