#----------------------------------------------------------------
# Generated CMake target import file.
#----------------------------------------------------------------

# Commands may need to know the format version.
set(CMAKE_IMPORT_FILE_VERSION 1)

# Import target "Nemirtingas::System" for configuration ""
set_property(TARGET Nemirtingas::System APPEND PROPERTY IMPORTED_CONFIGURATIONS NOCONFIG)
set_target_properties(Nemirtingas::System PROPERTIES
  IMPORTED_LINK_INTERFACE_LANGUAGES_NOCONFIG "CXX"
  IMPORTED_LOCATION_NOCONFIG "${_IMPORT_PREFIX}/lib/libsystem.a"
  )

list(APPEND _cmake_import_check_targets Nemirtingas::System )
list(APPEND _cmake_import_check_files_for_Nemirtingas::System "${_IMPORT_PREFIX}/lib/libsystem.a" )

# Commands beyond this point should not need to know the version.
set(CMAKE_IMPORT_FILE_VERSION)
