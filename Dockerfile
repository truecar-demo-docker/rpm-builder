FROM amazonlinux:2018.03

RUN yum update --assumeyes --skip-broken && \
      yum install -y rpm-build python-devel git gcc gcc-c++ cmake3 \
      java-1.8.0-openjdk java-1.8.0-openjdk-devel gtk3-devel jasper-devel \
      libpng-devel libjpeg-devel libtiff-devel ruby24 ruby24-devel wget which

RUN wget http://archive.apache.org/dist/ant/binaries/apache-ant-1.9.0-bin.tar.gz && \
    tar -xvzf apache-ant-1.9.0-bin.tar.gz && \
    cd /usr/bin/ && \
    ln -s /apache-ant-1.9.0/bin/ant ant

RUN gem install fpm --no-ri --no-rdoc

ARG OPENCV_VERSION=4.1.0

RUN mkdir -p /build/opencv_source /tmp/opencv \
    && curl -sSL https://github.com/opencv/opencv/archive/${OPENCV_VERSION}.tar.gz | tar -C /build/opencv_source --strip-components=1 -xzf - \
    && ( cd /build && export PATH=/usr/bin:${PATH} \
    && sed -i '/add_extra_compiler_option(-Werror=address)/d' opencv_source/cmake/OpenCVCompilerOptions.cmake \
    && cmake3 -Wno-dev \
        -D ENABLE_PRECOMPILED_HEADERS=OFF \
        -D BUILD_EXAMPLES=OFF \
        -D BUILD_PERF_TESTS=OFF \
        -D BUILD_TESTS=OFF \
        -D CMAKE_BUILD_TYPE=Release \
        -D CMAKE_INSTALL_PREFIX=/usr/local \
        -D INSTALL_C_EXAMPLES=OFF \
        -D INSTALL_PYTHON_EXAMPLES=OFF \
        -D PYTHON_EXECUTABLE=/usr/bin/python2.7 \
        opencv_source ) \
 && ( cd /build && make install DESTDIR=/tmp/opencv ) \
 && rm -rf /build

VOLUME [ "/tmp/fpm" ]
WORKDIR /tmp/fpm

ENTRYPOINT [ "/usr/local/bin/fpm" ]
