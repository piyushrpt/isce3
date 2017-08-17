#cython: language_level=3
#
# Author: Joshua Cohen
# Copyright 2017
#

from libcpp.vector cimport vector

cdef extern from "Ellipsoid.h" namespace "isceLib":
    cdef cppclass Ellipsoid:
        double a
        double e2

        Ellipsoid() except +
        Ellipsoid(double,double) except +
        Ellipsoid(const Ellipsoid&) except +
        double rEast(double)
        double rNorth(double)
        double rDir(double,double)
        void latLon(vector[double]&,vector[double]&,int)
        void getAngs(vector[double]&,vector[double]&,vector[double]&,double&,double&)
        void getTCN_TCvec(vector[double]&,vector[double]&,vector[double]&,vector[double]&)
        void TCNbasis(vector[double]&,vector[double]&,vector[double]&,vector[double]&,vector[double]&)
