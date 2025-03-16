cmake_minimum_required(VERSION 3.15)
project(tabby VERSION 0.26.0 LANGUAGES C CXX)

# Set default build type if not specified
if(NOT CMAKE_BUILD_TYPE)
  set(CMAKE_BUILD_TYPE "Release" CACHE STRING "Build type" FORCE)
endif()

# Options
option(TABBY_BUILD_TESTS "Build tests" OFF)
option(TABBY_USE_CUDA "Build with CUDA support" OFF)
option(TABBY_USE_ROCM "Build with ROCm support" OFF)
option(TABBY_USE_METAL "Build with Metal support (macOS)" OFF)
option(TABBY_PARALLEL_LEVEL "Maximum parallel jobs" 0)

# Detect number of available cores for optimal parallel builds
include(ProcessorCount)
ProcessorCount(PROCESSOR_COUNT)
if(PROCESSOR_COUNT EQUAL 0)
  set(PROCESSOR_COUNT 4)
endif()

# Set default parallel level if not specified
if(TABBY_PARALLEL_LEVEL EQUAL 0)
  set(TABBY_PARALLEL_LEVEL ${PROCESSOR_COUNT})
endif()

# Set parallel jobs
set(CMAKE_JOB_POOL_COMPILE "compile-pool")
set_property(GLOBAL PROPERTY JOB_POOLS compile-pool=${TABBY_PARALLEL_LEVEL})
message(STATUS "Setting parallel job limit to ${TABBY_PARALLEL_LEVEL}")

# Include custom cmake modules
list(APPEND CMAKE_MODULE_PATH "${CMAKE_CURRENT_SOURCE_DIR}/.cmake")

# Find dependencies
find_package(Threads REQUIRED)

# Handle platform-specific settings
if(UNIX AND NOT APPLE)
  # Linux settings
  set(LINUX TRUE)
endif()

if(APPLE)
  # macOS settings
  if(TABBY_USE_METAL)
    message(STATUS "Building with Metal support")
    # Add Metal-specific flags
    find_library(METAL_FRAMEWORK Metal REQUIRED)
    find_library(FOUNDATION_FRAMEWORK Foundation REQUIRED)
    find_library(COCOA_FRAMEWORK Cocoa REQUIRED)
    set(METAL_LIBS ${METAL_FRAMEWORK} ${FOUNDATION_FRAMEWORK} ${COCOA_FRAMEWORK})
  endif()
endif()

# CUDA support
if(TABBY_USE_CUDA)
  find_package(CUDA REQUIRED)
  message(STATUS "Building with CUDA support")
  message(STATUS "  CUDA version: ${CUDA_VERSION}")
  message(STATUS "  CUDA libraries: ${CUDA_LIBRARIES}")
  
  # Enable C++14 support for CUDA
  set(CMAKE_CUDA_STANDARD 14)
  set(CMAKE_CUDA_STANDARD_REQUIRED ON)
endif()

# ROCm support
if(TABBY_USE_ROCM)
  # Find ROCm components
  find_package(ROCm REQUIRED)
  message(STATUS "Building with ROCm support")
  message(STATUS "  ROCm found: ${ROCM_FOUND}")
  message(STATUS "  ROCm include dirs: ${ROCM_INCLUDE_DIRS}")
endif()

# Include directories
include_directories(${CMAKE_CURRENT_SOURCE_DIR})

# Add external dependencies
add_subdirectory(external EXCLUDE_FROM_ALL)

# Add llama.cpp if using it directly from CMake
if(EXISTS "${CMAKE_CURRENT_SOURCE_DIR}/crates/llama-cpp-server/llama.cpp/CMakeLists.txt")
  message(STATUS "Found llama.cpp, adding as subdirectory")
  add_subdirectory(crates/llama-cpp-server/llama.cpp EXCLUDE_FROM_ALL)
endif()

# Split cargo build into separate targets for better parallelism
add_custom_target(cargo_build_deps
  COMMAND cargo build --release --lib
  WORKING_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}
  COMMENT "Building Rust library dependencies with cargo"
  VERBATIM
)

add_custom_target(cargo_build_binaries ALL
  COMMAND cargo build --release --bins
  WORKING_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}
  COMMENT "Building Rust binaries with cargo"
  DEPENDS cargo_build_deps
  VERBATIM
)

# Create a verification target with more detailed output
add_custom_target(verify_cmake_ninja
  COMMAND ${CMAKE_COMMAND} -E echo "CMake and Ninja are properly configured!"
  COMMAND ${CMAKE_COMMAND} -E echo "  CMake version: ${CMAKE_VERSION}"
  COMMAND ${CMAKE_COMMAND} -E echo "  Generator: ${CMAKE_GENERATOR}"
  COMMAND ${CMAKE_COMMAND} -E echo "  Build type: ${CMAKE_BUILD_TYPE}"
  COMMAND ${CMAKE_COMMAND} -E echo "  CPU cores available: ${PROCESSOR_COUNT}"
  COMMAND ${CMAKE_COMMAND} -E echo "  Parallel jobs: ${TABBY_PARALLEL_LEVEL}"
  VERBATIM
)

# Install rules
install(FILES LICENSE README.md README-ja.md
  DESTINATION share/doc/tabby
)

# Print configuration summary
message(STATUS "")
message(STATUS "Tabby build configuration:")
message(STATUS "  CMake version: ${CMAKE_VERSION}")
message(STATUS "  CMake generator: ${CMAKE_GENERATOR}")
message(STATUS "  CMake build type: ${CMAKE_BUILD_TYPE}")
message(STATUS "  Processor count: ${PROCESSOR_COUNT}")
message(STATUS "  Build with CUDA support: ${TABBY_USE_CUDA}")
message(STATUS "  Build with ROCm support: ${TABBY_USE_ROCM}")
message(STATUS "  Build with Metal support: ${TABBY_USE_METAL}")
message(STATUS "")
