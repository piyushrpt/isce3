#cython: language_level=3
#
# Author: Joshua Cohen
# Copyright 2017
#

from libcpp cimport bool
from libcpp.vector cimport vector

cdef extern from "isce3/core/Poly2d.h" namespace "isce3::core":
    cdef cppclass Poly2d:
        int azimuthOrder
        int rangeOrder
        double azimuthMean
        double rangeMean
        double azimuthNorm
        double rangeNorm
        vector[double] coeffs

        Poly2d() except +
        Poly2d(int,int,double,double,double,double) except +
        Poly2d(const Poly2d&) except +
        void setCoeff(int,int,double)
        double getCoeff(int,int)
        double eval(double,double)
        void printPoly()

# end of file
