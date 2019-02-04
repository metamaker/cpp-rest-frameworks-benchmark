cmake_minimum_required(VERSION 3.5)
project(main)

find_package(Poco REQUIRED COMPONENTS Foundation Net JSON Util)

add_executable(main main.cpp)
target_link_libraries(main 
  Poco::Foundation
  Poco::Net
  Poco::JSON
  Poco::Util
)
