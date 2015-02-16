curl -L 'http://sourceforge.net/projects/opencvlibrary/files/opencv-unix/2.4.10/opencv-2.4.10.zip/download' > opencv-2.4.10.zip
unzip opencv-2.4.10.zip
rm opencv-*.zip
mkdir -p opencv-2.4.10/release
cd opencv-2.4.10/release
cmake -D BUILD_SHARED_LIBS=OFF -D CMAKE_BUILD_TYPE=RELEASE -D CMAKE_INSTALL_PREFIX=/usr/local/opencv-2.4.10 -D WITH_XINE=ON -D WITH_TBB=ON ..
make -j8 && make install
cd /
rm -rf opencv-2.4.10
