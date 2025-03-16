# FindROCm.cmake
# Find the ROCm installation on the system
#
# This module defines:
# - ROCM_FOUND        - True if ROCm was found
# - ROCM_INCLUDE_DIRS - ROCm include directories
# - ROCM_LIBRARIES    - ROCm libraries to link against
# - ROCM_ROOT         - ROCm installation root directory

# Find ROCm installation
find_path(ROCM_ROOT
  NAMES include/hip/hip_runtime.h
  PATHS
    /opt/rocm
    ENV ROCM_PATH
    ENV HIP_PATH
)

# Check if found
if(ROCM_ROOT)
  set(ROCM_FOUND TRUE)
  
  # Include directories
  set(ROCM_INCLUDE_DIRS
    ${ROCM_ROOT}/include
    ${ROCM_ROOT}/hipblas/include
    ${ROCM_ROOT}/rocblas/include
  )
  
  # Libraries
  find_library(HIPBLAS_LIBRARY
    NAMES hipblas
    PATHS ${ROCM_ROOT}/hipblas/lib
  )
  
  find_library(ROCBLAS_LIBRARY
    NAMES rocblas
    PATHS ${ROCM_ROOT}/rocblas/lib
  )
  
  set(ROCM_LIBRARIES
    ${HIPBLAS_LIBRARY}
    ${ROCBLAS_LIBRARY}
  )
  
  mark_as_advanced(ROCM_ROOT HIPBLAS_LIBRARY ROCBLAS_LIBRARY)
  message(STATUS "Found ROCm: ${ROCM_ROOT}")
else()
  if(ROCm_FIND_REQUIRED)
    message(FATAL_ERROR "Could not find ROCm installation")
  endif()
endif()
