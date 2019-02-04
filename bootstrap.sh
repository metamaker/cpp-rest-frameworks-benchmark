#!/usr/bin/env bash

cat << EOF
|--------------------------------------------------------|
|                                                        |
|--    Prepare stage before frameworks installation    --|
|                                                        |
|--------------------------------------------------------|
EOF

# Install build tools and ntp (to prevent clock skewing)

mkdir build-libs
sudo apt-get install -y --allow-downgrades --allow-remove-essential --allow-change-held-packages ntp cmake

# Replace nginx configuration

sudo rm /etc/nginx/sites-enabled/localtest.me
sudo echo "
server {
  server_name localhost;

  root /vagrant/php/;
  listen 80;

  location / {
    try_files \$uri \$uri;
  }

  location ~ \.php\$ {
    #include /etc/nginx/nginx.conf.fastcgi.cache;
    fastcgi_pass unix:/var/run/php.fpm.sock;
    include /etc/nginx/nginx.conf.fastcgi;
    fastcgi_param VAGRANT vagrant;
  }

  include /etc/nginx/nginx.conf.sites;
  error_log /var/log/nginx/error.log;
}
" > /etc/nginx/sites-available/default
sudo ln -s /etc/nginx/sites-available/default /etc/nginx/sites-enabled/default
sudo service nginx restart

cat << EOF
|-----------------------------------------|
|                                         |
|--    Install C/C++ REST frameworks    --|
|                                         |
|-----------------------------------------|
EOF

# Install CppRestSDK (Casablanca) C++ REST framework

sudo apt-get install -y --allow-downgrades --allow-remove-essential --allow-change-held-packages libcpprest-dev

# Install RapidJSON library
# RapidJSON is required for pistache, restbed and POCO samples to produce JSON result

pushd build-libs

git clone https://github.com/Tencent/rapidjson.git
pushd rapidjson
git submodule update --init
cmake -DCMAKE_BUILD_TYPE=Release .
make -j 8
sudo make install
popd

# Install Pistache C++ REST framework

git clone https://github.com/oktal/pistache.git
pushd pistache
git submodule update --init
cmake -DCMAKE_BUILD_TYPE=Release .
make -j 8
sudo make install
popd

# Install Restbed C++ REST framework

git clone --recursive https://github.com/corvusoft/restbed.git
pushd restbed
cmake -DCMAKE_BUILD_TYPE=Release .
make -j 8
sudo make install
sudo cp -r distribution/library/* /usr/lib/
sudo cp -r distribution/include/* /usr/include/
popd

# Install POCO C++ framework

git clone https://github.com/pocoproject/poco.git
pushd poco
mkdir cmake_build
cd cmake_build
cmake -DCMAKE_BUILD_TYPE=Release ..
make -j 8
sudo make install
popd

popd

cat << EOF
|-----------------------------------|
|                                   |
|--    Build benchmark samples    --|
|                                   |
|-----------------------------------|
EOF

pushd samples/cpp

pushd cpprestsdk-default_json_impl
cmake -DCMAKE_BUILD_TYPE=Release .
make -j 8
popd

pushd cpprestsdk-rapidjson
cmake -DCMAKE_BUILD_TYPE=Release .
make -j 8
popd

pushd pistache
cmake -DCMAKE_BUILD_TYPE=Release .
make -j 8
popd

pushd restbed
cmake -DCMAKE_BUILD_TYPE=Release .
make -j 8
popd

pushd poco-default_json_impl
cmake -DCMAKE_BUILD_TYPE=Release .
make -j 8
popd

pushd poco-rapidjson
cmake -DCMAKE_BUILD_TYPE=Release .
make -j 8
popd

popd

