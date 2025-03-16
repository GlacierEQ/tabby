#!/bin/bash
set -e

# Default configuration
BUILD_TYPE="Release"
GENERATOR="Ninja"
USE_CUDA=OFF
USE_ROCM=OFF
USE_METAL=OFF
VERIFY_ONLY=OFF
PARALLEL_LEVEL=$(nproc 2>/dev/null || sysctl -n hw.ncpu 2>/dev/null || echo 4)
NINJA_JOBS="-j${PARALLEL_LEVEL}"

# Parse arguments
while [[ $# -gt 0 ]]; do
  case "$1" in
    --debug)
      BUILD_TYPE="Debug"
      shift
      ;;
    --cuda)
      USE_CUDA=ON
      shift
      ;;
    --rocm)
      USE_ROCM=ON
      shift
      ;;
    --metal)
      USE_METAL=ON
      shift
      ;;
    --verify)
      VERIFY_ONLY=ON
      shift
      ;;
    --parallel=*)
      PARALLEL_LEVEL="${1#*=}"
      NINJA_JOBS="-j${PARALLEL_LEVEL}"
      shift
      ;;
    --jobs=*)
      NINJA_JOBS="-j${1#*=}"
      shift
      ;;
    *)
      echo "Unknown option: $1"
      echo "Usage: $0 [--debug] [--cuda] [--rocm] [--metal] [--verify] [--parallel=N] [--jobs=N]"
      exit 1
      ;;
  esac
done

# Check if Ninja is installed
if ! command -v ninja &>/dev/null; then
  echo "Ninja build system not found. Please install ninja-build."
  exit 1
fi

# Check if CMake is installed
if ! command -v cmake &>/dev/null; then
  echo "CMake not found. Please install cmake."
  exit 1
fi

# Display system information
echo "=== Build System Information ==="
echo "Operating System: $(uname -s)"
echo "Architecture: $(uname -m)"
echo "CPU cores: $PARALLEL_LEVEL"

# Display Ninja version
NINJA_VERSION=$(ninja --version)
echo "Using Ninja version: $NINJA_VERSION"

# Display CMake version
CMAKE_VERSION=$(cmake --version | head -n 1)
echo "Using $CMAKE_VERSION"

# Create build directory
BUILD_DIR="build/cmake-$BUILD_TYPE"
mkdir -p "$BUILD_DIR"
cd "$BUILD_DIR"

# Configure CMake command
CMAKE_CMD="cmake ../.. \
  -G \"$GENERATOR\" \
  -DCMAKE_BUILD_TYPE=\"$BUILD_TYPE\" \
  -DTABBY_USE_CUDA=\"$USE_CUDA\" \
  -DTABBY_USE_ROCM=\"$USE_ROCM\" \
  -DTABBY_USE_METAL=\"$USE_METAL\" \
  -DTABBY_PARALLEL_LEVEL=\"$PARALLEL_LEVEL\""

# Configure with CMake
echo "Configuring CMake build with Ninja..."
eval $CMAKE_CMD

# If verify-only mode, just run the verification target
if [[ "$VERIFY_ONLY" == "ON" ]]; then
  echo "Verifying CMake and Ninja setup..."
  cmake --build . --target verify_cmake_ninja
  
  # Additional verification: Check if we can find llama.cpp files
  if [ -d "../../crates/llama-cpp-server/llama.cpp" ]; then
    echo "✓ llama.cpp directory found"
  else
    echo "⚠️ llama.cpp directory not found at expected location"
    echo "  Run: git submodule update --init --recursive"
  fi
  
  exit 0
fi

# Build with Ninja
echo "Building with Ninja $NINJA_JOBS..."
time cmake --build . -- $NINJA_JOBS

echo "Build completed successfully!"

# Print a summary of what was built
echo ""
echo "=== Build Summary ==="
echo "  Build Type: $BUILD_TYPE"
echo "  CUDA support: $USE_CUDA"
echo "  ROCm support: $USE_ROCM"
echo "  Metal support: $USE_METAL"
echo "  Parallel jobs: $PARALLEL_LEVEL"

# Check if any Rust binaries were built
if [ -d "../../target/release" ]; then
  echo ""
  echo "=== Built Binaries ==="
  find ../../target/release -maxdepth 1 -type f -executable | while read -r binary; do
    echo "  $(basename "$binary")"
  done
fi
