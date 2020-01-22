###Custom function to prevent in-source builds
function(AssureOutOfSourceBuilds)
    get_filename_component(srcdir "${CMAKE_SOURCE_DIR}" REALPATH)
    get_filename_component(bindir "${CMAKE_BINARY_DIR}" REALPATH)

    if("${srcdir}" STREQUAL "${bindir}")
        message("################################")
        message(" ISCE should not be configured and built in the soutce directory")
        message(" You must run cmake in a build directory. ")
        message(" When directory structure is finalized .. can add full example here")
        message(FATAL_ERROR "Quitting. In-source builds not allowed....")
    endif()
endfunction()


# Check that compiler supports C++17
# (Only checks GCC and Clang currently)
function(CheckCXX)
    if (CMAKE_COMPILER_IS_GNUCXX AND CMAKE_CXX_COMPILER_VERSION VERSION_LESS 6.0)
        message(FATAL_ERROR "Insufficient GCC version. Version 6.0 or greater is required.")
    elseif(CMAKE_CXX_COMPILER_ID STREQUAL "Clang" AND CMAKE_CXX_COMPILER_VERSION VERSION_LESS 5)
        message(FATAL_ERROR "Insufficient Clang version. Version 5 or greater is required.")
    endif()
    # Require C++17 (no extensions) for host code
    set(CMAKE_CXX_STANDARD            17 PARENT_SCOPE)
    set(CMAKE_CXX_STANDARD_REQUIRED   ON PARENT_SCOPE)
    set(CMAKE_CXX_EXTENSIONS         OFF PARENT_SCOPE)
    # Require C++14 (no extensions) for device code
    set(CMAKE_CUDA_STANDARD           14 PARENT_SCOPE)
    set(CMAKE_CUDA_STANDARD_REQUIRED  ON PARENT_SCOPE)
    set(CMAKE_CUDA_EXTENSIONS        OFF PARENT_SCOPE)
    set(CMAKE_CXX_FLAGS "-Wall -Wextra -Wpedantic -Wno-sign-compare ${CMAKE_CXX_FLAGS}" PARENT_SCOPE)
endfunction()


##Make sure that a reasonable version of Python is installed
function(CheckISCEPython)
    find_package(Python 3.6 COMPONENTS Interpreter Development)
endfunction()


##Check for Pyre installation
function(CheckPyre)
    if(HAVE_PYRE)
        find_package(Pyre REQUIRED)
    else()
        set(PYRE_INCLUDE_DIR ${CMAKE_BINARY_DIR}/include PARENT_SCOPE)
    endif()
endfunction()

##Check for GDAL installation
function(CheckGDAL)
    find_package(GDAL 2.3 REQUIRED)
    message(STATUS "Found GDAL: ${GDAL_VERSION}")
endfunction()

##Check for HDF5 installation
function(CheckHDF5)
    FIND_PACKAGE(HDF5 REQUIRED COMPONENTS CXX)
    message(STATUS "Found HDF5: ${HDF5_VERSION} ${HDF5_CXX_LIBRARIES}")
    if (HDF5_VERSION VERSION_LESS "1.10.2")
        message(FATAL_ERROR "Did not find HDF5 version >= 1.10.2")
    endif()

    # check whether the hdf5 library includes parallel support
    if ((HDF5_IS_PARALLEL))
        # look for MPI
        FIND_PACKAGE(MPI REQUIRED COMPONENTS CXX)
        list(APPEND HDF5_INCLUDE_DIRS ${MPI_CXX_INCLUDE_DIRS})
        list(APPEND HDF5_CXX_LIBRARIES ${MPI_CXX_LIBRARIES})
    endif()
    # Use more standard names to propagate variables
    set(HDF5_INCLUDE_DIR ${HDF5_INCLUDE_DIRS} CACHE PATH "HDF5 include directory")
    set(HDF5_LIBRARY "${HDF5_CXX_LIBRARIES}" CACHE STRING "HDF5 libraries")
endfunction()

##Check for Armadillo installation
function(CheckArmadillo)
    FIND_PACKAGE(Armadillo REQUIRED)
    message (STATUS "Found Armadillo:  ${ARMADILLO_VERSION_STRING}")
endfunction()

function(InitInstallDirLayout)
    ###install/bin
    if (NOT ISCE_BINDIR)
        set (ISCE_BINDIR bin CACHE STRING "isce/bin")
    endif(NOT ISCE_BINDIR)

    ###install/packages
    if (NOT ISCE_PACKAGESDIR)
        set (ISCE_PACKAGESDIR packages CACHE STRING "isce/packages")
    endif(NOT ISCE_PACKAGESDIR)

    ###build/packages
    if (NOT ISCE_BUILDPACKAGESDIR)
        set (ISCE_BUILDPACKAGESDIR ${CMAKE_BINARY_DIR}/packages CACHE STRING "build/isce/packages")
    endif(NOT ISCE_BUILDPACKAGESDIR)

    ###install/lib
    if (NOT ISCE_LIBDIR)
        set (ISCE_LIBDIR lib CACHE STRING "isce/lib")
    endif(NOT ISCE_LIBDIR)

    ###install/include
    if (NOT ISCE_INCLUDEDIR)
        set (ISCE_INCLUDEDIR include/isce-${ISCE_VERSION_MAJOR}.${ISCE_VERSION_MINOR} CACHE STRING "isce/include")
    endif(NOT ISCE_INCLUDEDIR)

    ###build/include
    if (NOT ISCE_BUILDINCLUDEDIR)
        set (ISCE_BUILDINCLUDEDIR ${CMAKE_SOURCE_DIR}/cxx CACHE STRING "isce include dir")
    endif(NOT ISCE_BUILDINCLUDEDIR)
    if (NOT ISCE_BUILDINCLUDEDIR_CUDA)
        set (ISCE_BUILDINCLUDEDIR_CUDA ${CMAKE_SOURCE_DIR}/extensions
            CACHE STRING "isce cuda include dir")
    endif()

    ###install/cyinclude
    if (NOT ISCE_CYINCLUDEDIR)
        set (ISCE_CYINCLUDEDIR "cyinclude" CACHE STRING "isce/cyinclude")
    endif(NOT ISCE_CYINCLUDEDIR)

    ###build/cyinclude
    if (NOT ISCE_BUILDCYINCLUDEDIR)
        set (ISCE_BUILDCYINCLUDEDIR ${CMAKE_BINARY_DIR}/include/cyinclude CACHE STRING "build/isce/cyinclude")
    endif(NOT ISCE_BUILDCYINCLUDEDIR)

    ###install/defaults
    if (NOT ISCE_DEFAULTSDIR)
        set (ISCE_DEFAULTSDIR defaults CACHE STRING "isce/defaults")
    endif(NOT ISCE_DEFAULTSDIR)

    ###install/var
    if (NOT ISCE_VARDIR)
        set (ISCE_VARDIR var CACHE STRING "isce/var")
    endif(NOT ISCE_VARDIR)

    ###install/etc
    if (NOT ISCE_ETCDIR)
        set (ISCE_ETCDIR etc CACHE STRING "isce/etc")
    endif(NOT ISCE_ETCDIR)

    ###install/share
    if (NOT ISCE_SHAREDIR)
        set (ISCE_SHAREDIR share CACHE STRING "isce/share")
    endif(NOT ISCE_SHAREDIR)

    ###install/templates
    if (NOT ISCE_TEMPLATESDIR)
        set (ISCE_TEMPLATESDIR templates CACHE STRING "isce/templates")
    endif(NOT ISCE_TEMPLATESDIR)

    ###install/doc
    if (NOT ISCE_DOCDIR)
        set (ISCE_DOCDIR "doc" CACHE STRING "isce/doc")
    endif(NOT ISCE_DOCDIR)
endfunction()
