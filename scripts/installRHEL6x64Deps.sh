#-----------------------
#path config 

PATHNAME=/root/licode/scripts
ROOT=$PATHNAME/..
BUILD_DIR=$ROOT/build
CURRENT_DIR=`pwd`

LIB_DIR=$BUILD_DIR/libdeps
PREFIX_DIR=$LIB_DIR/build/

#---------------------------
#dev tools
yum groupinstall "Development Tools"

#---------------------
#epel repo

#rpm -Uvh http://dl.fedoraproject.org/pub/epel/6/x86_64/epel-release-6-8.noarch.rpm
rpm -Uvh http://mirror.neolabs.kz/epel/epel-release-latest-6.noarch.rpm

yum -y install  git make gcc openssl-devel cmake pkgconfig nodejs boost-devel boost-regex boost-thread boost-system log4cxx-devel rabbitmq-server mongodb mongodb-server curl boost-test tar xz libffi-devel npm yasm java-1.7.0-openjdk

#---------------
#libffi
wget ftp://rpmfind.net/linux/centos/6.7/os/x86_64/Packages/libffi-devel-3.0.5-3.2.el6.x86_64.rpm
rpm -ivH libffi-devel-3.0.5-3.2.el6.x86_64.rpm  
#---------------
mkdir -p $LIB_DIR
#---------------
#glib2
cd $LIB_DIR
wget -O glib-2.38.2.tar.xz http://ftp.gnome.org/pub/gnome/sources/glib/2.38/glib-2.38.2.tar.xz
tar -xvf glib-2.38.2.tar.xz
cd glib-2.38.2
./configure --prefix=$PREFIX_DIR
make 
make install

CPLUS_INCLUDE_PATH=$BUILD_DIR/libdeps/glib-2.38.2/glib
export CPLUS_INCLUDE_PATH

cd $CURRENT_DIR


#-------------
#opensl
cd $LIB_DIR
curl -O http://www.openssl.org/source/openssl-1.0.1g.tar.gz
tar -zxvf openssl-1.0.1g.tar.gz
cd openssl-1.0.1g
./config --prefix=$PREFIX_DIR -fPIC
make -s V=0
make install
cd $CURRENT_DIR


#-------------
#libnice
cd $LIB_DIR
curl -O http://nice.freedesktop.org/releases/libnice-0.1.4.tar.gz
tar -zxvf libnice-0.1.4.tar.gz
cd libnice-0.1.4
patch -R ./agent/conncheck.c < $PATHNAME/libnice-014.patch0
PKG_CONFIG_PATH=${PREFIX_DIR}/lib/pkgconfig ./configure --prefix=$PREFIX_DIR 
make -s V=0
make install
cd $CURRENT_DIR
#-------------
#srtp
cd $ROOT/third_party/srtp
CFLAGS="-fPIC" ./configure --prefix=$PREFIX_DIR
make -s V=0
make uninstall
make install
cd $CURRENT_DIR
#-------------
#opus
cd $LIB_DIR
curl -O http://downloads.xiph.org/releases/opus/opus-1.1.tar.gz
tar -zxvf opus-1.1.tar.gz
cd opus-1.1
./configure --prefix=$PREFIX_DIR
make -s V=0
make install
cd $CURRENT_DIR
#-------------
#vpx
cd $LIB_DIR
curl -O https://webm.googlecode.com/files/libvpx-v1.0.0.tar.bz2
tar -xf libvpx-v1.0.0.tar.bz2
cd libvpx-v1.0.0
./configure --prefix=$PREFIX_DIR --enable-vp8 --enable-shared --enable-pic
make -s V=0
make install
cd $CURRENT_DIR
#-------------
#media
cd $LIB_DIR
curl -O https://www.libav.org/releases/libav-11.1.tar.gz
tar -zxf libav-11.1.tar.gz
cd libav-11.1
PKG_CONFIG_PATH=${PREFIX_DIR}/lib/pkgconfig CPATH=${PREFIX_DIR}/include ./configure --prefix=$PREFIX_DIR --enable-shared --enable-libopus --enable-libvpx
CPATH=${PREFIX_DIR}/include make -s V=0
make install
cd $CURRENT_DIR
#-------------

#-------------
#end
