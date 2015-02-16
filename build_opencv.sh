curl -L 'https://github.com/Itseez/opencv/archive/3.0.0-beta.zip' > opencv-3.0.0-beta.zip
unzip opencv-3.0.0-beta.zip
rm opencv-*.zip
mkdir -p opencv-3.0.0-beta/build
cd opencv-3.0.0-beta/build
cmake -D BUILD_SHARED_LIBS=OFF -D CMAKE_BUILD_TYPE=Release -D CMAKE_INSTALL_PREFIX=/usr/local/opencv-3.0.0-beta -D BUILD_EXAMPLES=OFF -D BUILD_TESTS=OFF -D BUILD_PERF_TESTS=OFF -D WITH_TBB=ON ..
make -j7 && make install
cd /
rm -rf opencv-3.0.0-beta
