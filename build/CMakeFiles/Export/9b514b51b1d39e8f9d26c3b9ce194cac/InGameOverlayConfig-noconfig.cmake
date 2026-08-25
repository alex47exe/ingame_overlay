#----------------------------------------------------------------
# Generated CMake target import file.
#----------------------------------------------------------------

# Commands may need to know the format version.
set(CMAKE_IMPORT_FILE_VERSION 1)

# Import target "Nemirtingas::InGameOverlay" for configuration ""
set_property(TARGET Nemirtingas::InGameOverlay APPEND PROPERTY IMPORTED_CONFIGURATIONS NOCONFIG)
set_target_properties(Nemirtingas::InGameOverlay PROPERTIES
  IMPORTED_LINK_INTERFACE_LANGUAGES_NOCONFIG "CXX"
  IMPORTED_LOCATION_NOCONFIG "${_IMPORT_PREFIX}/lib/libingame_overlay.a"
  )

list(APPEND _cmake_import_check_targets Nemirtingas::InGameOverlay )
list(APPEND _cmake_import_check_files_for_Nemirtingas::InGameOverlay "${_IMPORT_PREFIX}/lib/libingame_overlay.a" )

# Commands beyond this point should not need to know the version.
set(CMAKE_IMPORT_FILE_VERSION)
