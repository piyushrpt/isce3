#cython: language_level=3
#
# Author: Bryan Riel
# Copyright 2017-2018
#

from libcpp cimport bool
from libcpp.string cimport string

# Cython declarations for isce3::core objects
from isceextension cimport Ellipsoid
from isceextension cimport Product
from isceextension cimport Orbit
from isceextension cimport Raster
from LUT2d cimport LUT2d
from RadarGridParameters cimport RadarGridParameters

cdef extern from "isce3/cuda/geometry/Geo2rdr.h" namespace "isce3::cuda::geometry":

    # Geo2rdr class
    cdef cppclass Geo2rdr:

        # Constructor
        Geo2rdr(Product & product, char frequency, bool nativeDoppler,
                size_t numberAzimuthLooks, size_t numberRangeLooks) except +
        Geo2rdr(RadarGridParameters & radarGrid, Orbit & orbit,
                Ellipsoid & ellipsoid, LUT2d[double] & doppler) except +
        Geo2rdr(RadarGridParameters & radarGrid, Orbit & orbit,
                Ellipsoid & ellipsoid) except +

        # Set options
        void threshold(double)
        void numiter(int)

        # Run geo2rdr with offsets and internally created offset rasters
        void geo2rdr(Raster &, const string &, double, double)

        # Run geo2rdr with offsets and externally created offset rasters
        void geo2rdr(Raster &, Raster &, Raster &, double, double)

# end of file
