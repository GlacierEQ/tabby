#!/bin/bash
# Script to verify that CMake and Ninja are correctly configured

set -e

echo "=== CMake/Ninja Verification Tool ==="
echo ""

# Check CMake
if command -v cmake &>/dev/null; then
    CMAKE_VERSION=$(cmake --version | head -n 1)
    echo "✓ CMake is installed: $CMAKE_VERSION"
else
    echo "✗ CMake is not installed. Please install CMake."
    exit 1
fi

# Check Ninja
if command -v ninja &>/dev/null; then
    NINJA_VERSION=$(ninja --version)
    echo "✓ Ninja is installed: v$NINJA_VERSION"
else
    echo "✗ Ninja is not installed. Please install Ninja."
    exit 1
fi

# Check for multiprocessing capability
if command -v nproc &>/dev/null; then
    NUM_CORES=$(nproc)
    echo "✓ This system has $NUM_CORES CPU cores available for parallel builds"
elif command -v sysctl &>/dev/null; then
    NUM_CORES=$(sysctl -n hw.ncpu)
    echo "✓ This system has $NUM_CORES CPU cores available for parallel builds"
else
    echo "? Could not determine the number of CPU cores"
    NUM_CORES=4
    echo "  Assuming $NUM_CORES cores for parallel builds"
fi

# Check if we're in a Git repository
if git rev-parse --is-inside-work-tree &>/dev/null; then
    echo "✓ Running in a Git repository"
    
    # Check for submodules (especially llama.cpp)
    if git submodule status | grep -q "llama.cpp"; then
        if [ -d "crates/llama-cpp-server/llama.cpp" ]; then
            echo "✓ llama.cpp submodule is present"
        else
            echo "✗ llama.cpp submodule directory not found, but it's in .gitmodules"
            echo "  Run: git submodule update --init --recursive"
        fi
    fi
else
    echo "? Not running in a Git repository"
fi

# Test a minimal CMake configuration
echo ""
echo "=== Testing CMake Configuration ==="

TEST_DIR=$(mktemp -d)
pushd "$TEST_DIR" >/dev/null

cat > CMakeLists.txt << EOF
cmake_minimum_required(VERSION 3.15)
project(cmake_test)
add_executable(test_app main.cpp)
EOF

cat > main.cpp << EOF
#include <iostream>
int main() {
    std::cout << "CMake/Ninja test successful!" << std::endl;
    return 0;
}
EOF

echo "Creating build directory..."
mkdir -p build
cd build

echo "Configuring CMake with Ninja..."
if cmake .. -G "Ninja"; then
    echo "✓ CMake configuration successful"
else
    echo "✗ CMake configuration failed"
    popd >/dev/null
    rm -rf "$TEST_DIR"
    exit 1
fi

echo "Building test project..."
if cmake --build .; then
    echo "✓ Build successful"
    if [ -f "test_app" ] || [ -f "test_app.exe" ]; then
        echo "✓ Executable was created"
    else
        echo "✗ Executable was not created"
    fi
else
    echo "✗ Build failed"
    popd >/dev/null
    rm -rf "$TEST_DIR"
    exit 1
fi

popd >/dev/null
rm -rf "$TEST_DIR"

echo ""
echo "=== All checks passed! ==="
echo "CMake and Ninja are correctly configured for parallel builds."
echo "You can now run 'make cmake-build' to build the project."
