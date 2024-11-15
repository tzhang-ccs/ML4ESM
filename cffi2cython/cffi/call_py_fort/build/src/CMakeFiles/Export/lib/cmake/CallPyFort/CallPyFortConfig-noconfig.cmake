#----------------------------------------------------------------
# Generated CMake target import file.
#----------------------------------------------------------------

# Commands may need to know the format version.
set(CMAKE_IMPORT_FILE_VERSION 1)

# Import target "CallPyFort::callpy" for configuration ""
set_property(TARGET CallPyFort::callpy APPEND PROPERTY IMPORTED_CONFIGURATIONS NOCONFIG)
set_target_properties(CallPyFort::callpy PROPERTIES
  IMPORTED_LOCATION_NOCONFIG "${_IMPORT_PREFIX}/lib/libcallpy.so"
  IMPORTED_SONAME_NOCONFIG "libcallpy.so"
  )

list(APPEND _IMPORT_CHECK_TARGETS CallPyFort::callpy )
list(APPEND _IMPORT_CHECK_FILES_FOR_CallPyFort::callpy "${_IMPORT_PREFIX}/lib/libcallpy.so" )

# Commands beyond this point should not need to know the version.
set(CMAKE_IMPORT_FILE_VERSION)
