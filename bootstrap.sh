#!/usr/bin/env bash

cat << EOF
|--------------------------------------------------------|
|                                                        |
|--    Prepare stage before frameworks installation    --|
|                                                        |
|--------------------------------------------------------|
EOF

# Install build tools and ntp (to prevent clock skewing)

sudo mkdir /tmp/build-libs
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

cd /tmp/build-libs
git clone https://github.com/Tencent/rapidjson.git
cd rapidjson
git submodule update --init
cmake -DCMAKE_BUILD_TYPE=Release .
make
sudo make install

# Install Pistache C++ REST framework

cd /tmp/build-libs
git clone https://github.com/oktal/pistache.git
cd pistache
git submodule update --init
cmake -DCMAKE_BUILD_TYPE=Release .
make
sudo make install

# Install Restbed C++ REST framework

cd /tmp/build-libs
git clone --recursive https://github.com/corvusoft/restbed.git
cd restbed
cmake -DCMAKE_BUILD_TYPE=Release .
make
sudo make install
sudo cp -r distribution/library/* /usr/lib/
sudo cp -r distribution/include/* /usr/include/

# Install POCO C++ framework

cd /tmp/build-libs
git clone https://github.com/pocoproject/poco.git
cd poco
mkdir cmake_build
cd cmake_build
cmake -DCMAKE_BUILD_TYPE=Release ..
make
sudo make install

cat << EOF
|-----------------------------------|
|                                   |
|--    Build benchmark samples    --|
|                                   |
|-----------------------------------|
EOF

cd /vagrant/cpp/cpprestsdk-default_json_impl
cmake -DCMAKE_BUILD_TYPE=Release .
make

cd /vagrant/cpp/cpprestsdk-rapidjson
cmake -DCMAKE_BUILD_TYPE=Release .
make

cd /vagrant/cpp/pistache
cmake -DCMAKE_BUILD_TYPE=Release .
make

cd /vagrant/cpp/restbed
cmake -DCMAKE_BUILD_TYPE=Release .
make

cd /vagrant/cpp/poco-default_json_impl
cmake -DCMAKE_BUILD_TYPE=Release .
make

cd /vagrant/cpp/poco-rapidjson
cmake -DCMAKE_BUILD_TYPE=Release .
make
