#----------------------------------------------------------------
# Generated CMake target import file.
#----------------------------------------------------------------

# Commands may need to know the format version.
set(CMAKE_IMPORT_FILE_VERSION 1)

# Import target "Nemirtingas::MiniDetour" for configuration ""
set_property(TARGET Nemirtingas::MiniDetour APPEND PROPERTY IMPORTED_CONFIGURATIONS NOCONFIG)
set_target_properties(Nemirtingas::MiniDetour PROPERTIES
  IMPORTED_LINK_INTERFACE_LANGUAGES_NOCONFIG "C;CXX"
  IMPORTED_LOCATION_NOCONFIG "${_IMPORT_PREFIX}/lib/libmini_detour.a"
  )

list(APPEND _cmake_import_check_targets Nemirtingas::MiniDetour )
list(APPEND _cmake_import_check_files_for_Nemirtingas::MiniDetour "${_IMPORT_PREFIX}/lib/libmini_detour.a" )

# Commands beyond this point should not need to know the version.
set(CMAKE_IMPORT_FILE_VERSION)
