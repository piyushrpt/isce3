add_subdirectory(googletest)
add_subdirectory(cereal)
if(NOT HAVE_PYRE)
    add_subdirectory(pyre)
endif()