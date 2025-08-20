cmake_minimum_required(VERSION 3.10)
project(cpp-benchmark)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_FLAGS_RELEASE "-O3 -DNDEBUG")

# Find required packages
find_package(PkgConfig REQUIRED)

# Add executable
add_executable(benchmark
    src/main.cpp
    src/benchmark.cpp
    src/output.cpp
)

# Link libraries
target_link_libraries(benchmark)

# Set default build type to Release for performance
if(NOT CMAKE_BUILD_TYPE)
    set(CMAKE_BUILD_TYPE Release)
endif()