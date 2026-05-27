cmake_minimum_required(VERSION 3.12)
project(libserialport C)

# Standardize warnings
add_compile_definitions(_CRT_SECURE_NO_WARNINGS=1)

# List your sources
set(SERIALPORT_SOURCES
    serialport.c
    timing.c
    # Add your OS-specific files here (e.g., windows.c)
)

# Build as a static library
add_library(serialport STATIC ${SERIALPORT_SOURCES})

# Define public include directory
target_include_directories(serialport PUBLIC include)

# MSVC specific compiler options for a clean build
if(MSVC)
    target_compile_options(serialport PRIVATE 
        /W4          # High warning level
        /wd4996      # Suppress deprecation warnings
        /wd5105      # Suppress macro expansion warnings
    )
endif()
