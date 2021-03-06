#cython: language_level=3
#
# Author: Bryan V. Riel
# Copyright 2017-2018
#

from libcpp.string cimport string
from IH5 cimport IH5File

from Metadata cimport Metadata
from Swath cimport Swath
from LookSide cimport LookSide

cdef extern from "isce3/product/Product.h" namespace "isce3::product":

    # Product class
    cdef cppclass Product:

        # Constructors
        Product(IH5File &) except +

        # Metadata
        Metadata & metadata()

        # Swath
        Swath & swath(char)

        # Look side
        LookSide lookSide()

        # The filename of the HDF5 file
        string filename()

# end of file
