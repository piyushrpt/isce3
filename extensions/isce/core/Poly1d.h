//
// Author: Joshua Cohen
// Copyright 2017
//

#ifndef ISCELIB_POLY1D_H
#define ISCELIB_POLY1D_H

#include <stdexcept>
#include <string>
#include <vector>

namespace isceLib {
    struct Poly1d {
        int order;
        double mean;
        double norm;
        std::vector<double> coeffs;

        Poly1d(int ord, double mn, double nm) : order(ord), mean(mn), norm(nm), coeffs(ord+1) {}
        Poly1d() : Poly1d(-1,0.,1.) {}
        Poly1d(const Poly1d &p) : order(p.order), mean(p.mean), norm(p.norm), coeffs(p.coeffs) {}
        inline Poly1d& operator=(const Poly1d&);

        inline void setCoeff(int,double);
        inline double getCoeff(int);
        double eval(double);
        void printPoly();
    };

    inline Poly1d& Poly1d::operator=(const Poly1d &rhs) {
        order = rhs.order;
        mean = rhs.mean;
        norm = rhs.norm;
        coeffs = rhs.coeffs;
        return *this;
    }

    inline void Poly1d::setCoeff(int idx, double val) {
        if ((idx < 0) || (idx > order)){
            std::string errstr = "Poly1d::setCoeff - Trying to set coefficient "+std::to_string(idx+1)+" out of "+std::to_string(order+1);
            throw std::out_of_range(errstr);
        }
        coeffs[idx] = val;
    }

    inline double Poly1d::getCoeff(int idx) {
        if ((idx < 0) || (idx > order)) {
            std::string errstr = "Poly1d::getCoeff - Trying to get coefficient "+std::to_string(idx+1)+" out of "+std::to_string(order+1);
            throw std::out_of_range(errstr);
        }
        return coeffs[idx];
    }
}

#endif