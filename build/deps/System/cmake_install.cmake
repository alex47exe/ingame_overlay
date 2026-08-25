# Install script for directory: /home/runner/work/ingame_overlay/ingame_overlay/deps/System

# Set the install prefix
if(NOT DEFINED CMAKE_INSTALL_PREFIX)
  set(CMAKE_INSTALL_PREFIX "/usr/local")
endif()
string(REGEX REPLACE "/$" "" CMAKE_INSTALL_PREFIX "${CMAKE_INSTALL_PREFIX}")

# Set the install configuration name.
if(NOT DEFINED CMAKE_INSTALL_CONFIG_NAME)
  if(BUILD_TYPE)
    string(REGEX REPLACE "^[^A-Za-z0-9_]+" ""
           CMAKE_INSTALL_CONFIG_NAME "${BUILD_TYPE}")
  else()
    set(CMAKE_INSTALL_CONFIG_NAME "")
  endif()
  message(STATUS "Install configuration: \"${CMAKE_INSTALL_CONFIG_NAME}\"")
endif()

# Set the component getting installed.
if(NOT CMAKE_INSTALL_COMPONENT)
  if(COMPONENT)
    message(STATUS "Install component: \"${COMPONENT}\"")
    set(CMAKE_INSTALL_COMPONENT "${COMPONENT}")
  else()
    set(CMAKE_INSTALL_COMPONENT)
  endif()
endif()

# Install shared libraries without execute permission?
if(NOT DEFINED CMAKE_INSTALL_SO_NO_EXE)
  set(CMAKE_INSTALL_SO_NO_EXE "1")
endif()

# Is this installation the result of a crosscompile?
if(NOT DEFINED CMAKE_CROSSCOMPILING)
  set(CMAKE_CROSSCOMPILING "FALSE")
endif()

# Set path to fallback-tool for dependency-resolution.
if(NOT DEFINED CMAKE_OBJDUMP)
  set(CMAKE_OBJDUMP "/usr/bin/objdump")
endif()

if(CMAKE_INSTALL_COMPONENT STREQUAL "Unspecified" OR NOT CMAKE_INSTALL_COMPONENT)
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/lib" TYPE STATIC_LIBRARY FILES "/home/runner/work/ingame_overlay/ingame_overlay/build/deps/System/libsystem.a")
endif()

if(CMAKE_INSTALL_COMPONENT STREQUAL "Unspecified" OR NOT CMAKE_INSTALL_COMPONENT)
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/include/System" TYPE FILE FILES
    "/home/runner/work/ingame_overlay/ingame_overlay/deps/System/include/System/System.h"
    "/home/runner/work/ingame_overlay/ingame_overlay/deps/System/include/System/SystemMacro.h"
    "/home/runner/work/ingame_overlay/ingame_overlay/deps/System/include/System/Filesystem.h"
    "/home/runner/work/ingame_overlay/ingame_overlay/deps/System/include/System/Date.h"
    "/home/runner/work/ingame_overlay/ingame_overlay/deps/System/include/System/Library.h"
    "/home/runner/work/ingame_overlay/ingame_overlay/deps/System/include/System/SystemCompiler.h"
    "/home/runner/work/ingame_overlay/ingame_overlay/deps/System/include/System/SystemCPUExtensions.h"
    "/home/runner/work/ingame_overlay/ingame_overlay/deps/System/include/System/SystemDetector.h"
    "/home/runner/work/ingame_overlay/ingame_overlay/deps/System/include/System/SystemExports.h"
    "/home/runner/work/ingame_overlay/ingame_overlay/deps/System/include/System/SystemInline.h"
    "/home/runner/work/ingame_overlay/ingame_overlay/deps/System/include/System/String.hpp"
    "/home/runner/work/ingame_overlay/ingame_overlay/deps/System/include/System/ThreadPool.hpp"
    "/home/runner/work/ingame_overlay/ingame_overlay/deps/System/include/System/FunctionName.hpp"
    "/home/runner/work/ingame_overlay/ingame_overlay/deps/System/include/System/SourceName.hpp"
    "/home/runner/work/ingame_overlay/ingame_overlay/deps/System/include/System/TemplateStaticStorage.hpp"
    "/home/runner/work/ingame_overlay/ingame_overlay/deps/System/include/System/Encoding.hpp"
    "/home/runner/work/ingame_overlay/ingame_overlay/deps/System/include/System/ClassEnumUtils.hpp"
    "/home/runner/work/ingame_overlay/ingame_overlay/deps/System/include/System/ConstExpressions.hpp"
    "/home/runner/work/ingame_overlay/ingame_overlay/deps/System/include/System/Endianness.hpp"
    "/home/runner/work/ingame_overlay/ingame_overlay/deps/System/include/System/StringSwitch.hpp"
    "/home/runner/work/ingame_overlay/ingame_overlay/deps/System/include/System/LoopBreak.hpp"
    "/home/runner/work/ingame_overlay/ingame_overlay/deps/System/include/System/Guid.hpp"
    "/home/runner/work/ingame_overlay/ingame_overlay/deps/System/include/System/FunctionTraits.hpp"
    "/home/runner/work/ingame_overlay/ingame_overlay/deps/System/include/System/DotNet.hpp"
    )
endif()

if(CMAKE_INSTALL_COMPONENT STREQUAL "Unspecified" OR NOT CMAKE_INSTALL_COMPONENT)
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/include/System/Encoding" TYPE FILE FILES
    "/home/runner/work/ingame_overlay/ingame_overlay/deps/System/include/System/Encoding/UTF8.hpp"
    "/home/runner/work/ingame_overlay/ingame_overlay/deps/System/include/System/Encoding/Base64.hpp"
    "/home/runner/work/ingame_overlay/ingame_overlay/deps/System/include/System/Encoding/Hex.hpp"
    )
endif()

if(CMAKE_INSTALL_COMPONENT STREQUAL "Unspecified" OR NOT CMAKE_INSTALL_COMPONENT)
  if(EXISTS "$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}/lib/cmake/System/SystemConfig.cmake")
    file(DIFFERENT _cmake_export_file_changed FILES
         "$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}/lib/cmake/System/SystemConfig.cmake"
         "/home/runner/work/ingame_overlay/ingame_overlay/build/deps/System/CMakeFiles/Export/beebf04c5a6caa218e452f5c42979970/SystemConfig.cmake")
    if(_cmake_export_file_changed)
      file(GLOB _cmake_old_config_files "$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}/lib/cmake/System/SystemConfig-*.cmake")
      if(_cmake_old_config_files)
        string(REPLACE ";" ", " _cmake_old_config_files_text "${_cmake_old_config_files}")
        message(STATUS "Old export file \"$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}/lib/cmake/System/SystemConfig.cmake\" will be replaced.  Removing files [${_cmake_old_config_files_text}].")
        unset(_cmake_old_config_files_text)
        file(REMOVE ${_cmake_old_config_files})
      endif()
      unset(_cmake_old_config_files)
    endif()
    unset(_cmake_export_file_changed)
  endif()
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/lib/cmake/System" TYPE FILE FILES "/home/runner/work/ingame_overlay/ingame_overlay/build/deps/System/CMakeFiles/Export/beebf04c5a6caa218e452f5c42979970/SystemConfig.cmake")
  if(CMAKE_INSTALL_CONFIG_NAME MATCHES "^()$")
    file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/lib/cmake/System" TYPE FILE FILES "/home/runner/work/ingame_overlay/ingame_overlay/build/deps/System/CMakeFiles/Export/beebf04c5a6caa218e452f5c42979970/SystemConfig-noconfig.cmake")
  endif()
endif()

string(REPLACE ";" "\n" CMAKE_INSTALL_MANIFEST_CONTENT
       "${CMAKE_INSTALL_MANIFEST_FILES}")
if(CMAKE_INSTALL_LOCAL_ONLY)
  file(WRITE "/home/runner/work/ingame_overlay/ingame_overlay/build/deps/System/install_local_manifest.txt"
     "${CMAKE_INSTALL_MANIFEST_CONTENT}")
endif()
