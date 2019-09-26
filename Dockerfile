FROM maven:3-jdk-8

RUN apt-get update \
 && apt-get install --no-install-recommends -y \
      ant \
      build-essential \
      bzip2 \
      cmake \
      libbz2-dev \
      libsnappy-dev \
      libssl1.0-dev \
      make \
      pkg-config \
      python \
      zlib1g \
      ruby \
      ruby-dev \
      zlib1g-dev \
      rpm

RUN ruby --version

RUN gem install fpm --no-ri --no-rdoc

ARG OPENCV_VERSION=4.1.0

RUN apt-get update \
 && apt-get install --no-install-recommends -y \
        libjasperreports-java \
        libjpeg-dev \
        libpng-dev \
        libtiff5-dev \
        python-numpy \
        python2.7-dev \
 && mkdir -p /build/opencv_source /tmp/opencv \
 && curl -sSL https://github.com/opencv/opencv/archive/${OPENCV_VERSION}.tar.gz | tar -C /build/opencv_source --strip-components=1 -xzf - \
 && ( cd /build && export PATH=${JAVA_HOME}/bin:${PATH} \
   && sed -i '/add_extra_compiler_option(-Werror=address)/d' opencv_source/cmake/OpenCVCompilerOptions.cmake \
   && cmake -Wno-dev \
        -D ENABLE_PRECOMPILED_HEADERS=OFF \
        -D BUILD_EXAMPLES=OFF \
        -D BUILD_PERF_TESTS=OFF \
        -D BUILD_SHARED_LIBS=OFF \
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
