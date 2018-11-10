// -*- C++ -*-
// -*- coding: utf-8 -*-
//
// Author: Heresh Fattahi
// Copyright 2018-
//

#include "Crossmul.h"

/*
isce::signal::Crossmul::
Crossmul(const isce::product::Product& referenceSlcProduct,
         const isce::product::Product& secondarySlcProduct,
         isce::product::Product& outputInterferogramProduct)
*/


/**
* @param[in] referenceSLC Raster object of refernce SLC
* @param[in] secondarySLC Raster object of secondary SLC
* @param[out] interferogram Raster object of output interferogram
*/
void isce::signal::Crossmul::
crossmul(isce::io::Raster& referenceSLC,
        isce::io::Raster& secondarySLC,
        isce::io::Raster& interferogram)
{

    // Create reusable pyre::journal channels
    pyre::journal::warning_t warning("isce.geometry.Topo");
    pyre::journal::info_t info("isce.geometry.Topo");

    int nrows = referenceSLC.length();
    int ncols = referenceSLC.width();

    std::cout << "ncols, nrows" << ncols << " , " << nrows << std::endl;
    /*
    if (nrows =! secondarySLC.length()) {
        pyre::journal::error_t error("isce.signal.Crossmul");
        error
            << pyre::journal::at(__HERE__)
            << "Error in Crossmul::crossmul - number of rows in secondary "
            << "SLC should be the same as the refernce SLC."
            << pyre::journal::endl;
    }

    if (ncols =! secondarySLC.width()) {
        pyre::journal::error_t error("isce.signal.Crossmul");
        error
            << pyre::journal::at(__HERE__)
            << "Error in Crossmul::crossmul - number of columns in secondary "
            << "SLC should be the same as the refernce SLC."
            << pyre::journal::endl;
    }
    */
    std::cout << "ncols, nrows" << ncols << " , " << nrows << std::endl; 

    // Compute FFT size (power of 2)
    int nfft = 512; //ncols; //nextPow2(ncols);
    
    // it should be determined somehow
    int blockRows = 90;
    int oversample = 2;

    int nblocks = nrows / blockRows;
    if (nblocks == 0) {
        nblocks = 1;
    } else if (nrows % (nblocks * blockRows) != 0) {
        nblocks += 1;
    }

    // storage for a block of reference SLC data
    std::valarray<std::complex<float>> refSlc(ncols*blockRows);

    // storage for a block of secondary SLC data
    std::valarray<std::complex<float>> secSlc(ncols*blockRows);

    // storage for spectrum of the block of data in reference SLC
    std::valarray<std::complex<float>> refSpectrum(nfft*blockRows);

    // storage for spectrum of the block of data in secondary SLC
    std::valarray<std::complex<float>> secSpectrum(nfft*blockRows);

    // upsampled spectrum of the block of reference SLC
    std::valarray<std::complex<float>> refSpectrumUpsampled(oversample*nfft*blockRows);

    // upsampled spectrum of the block of secondary SLC
    std::valarray<std::complex<float>> secSpectrumUpsampled(oversample*nfft*blockRows);

    // upsampled block of reference SLC 
    std::valarray<std::complex<float>> refSlcUpsampled(oversample*nfft*blockRows);

    // upsampled block of secondary SLC
    std::valarray<std::complex<float>> secSlcUpsampled(oversample*nfft*blockRows);

    // upsampled interferogram
    std::valarray<std::complex<float>> ifgramUpsampled(oversample*ncols*blockRows);

    // full resolution interferogram
    std::valarray<std::complex<float>> ifgram(ncols*blockRows);

    //signal object for refSlc
    isce::signal::Signal<float> refSignal;

    //signal object for secSlc
    isce::signal::Signal<float> secSignal;

    // make forward and inverse fft plans for the reference SLC 
    refSignal.forwardRangeFFT(refSlc, refSpectrum, ncols, blockRows, nfft, blockRows);
    refSignal.inverseRangeFFT(refSpectrumUpsampled, refSlcUpsampled, nfft*oversample, blockRows, nfft*oversample, blockRows);

    // make forward and inverse fft plans for the secondary SLC
    secSignal.forwardRangeFFT(secSlc, secSpectrum, ncols, blockRows, nfft, blockRows);
    secSignal.inverseRangeFFT(secSpectrumUpsampled, secSlcUpsampled, nfft*oversample, blockRows, nfft*oversample, blockRows);

    //filter object
    isce::signal::Filter<float> filter;
    if (_doCommonAzimuthbandFilter){

        // construct azimuth common band filter for a block of data
        filter.constructAzimuthCommonbandFilter(_refDoppler, 
					    _secDoppler, 
                                            _commonAzimuthBandwidth,
                                            _prf, 
                                            _beta,
                                            refSlc, refSpectrum,
                                            ncols, blockRows);
    }

    // loop over all blocks
    std::cout << "nblocks : " << nblocks << std::endl;

    for (size_t block = 0; block < nblocks; ++block) {
       
        // start row for this block
        size_t rowStart;
        rowStart = block * blockRows;
        
        //number of lines of data in this block. blockRowsData<= blockRows
        //Note that blockRows is fixed number of lines
        //blockRowsData might be less than or equal to blockRows.
        //e.g. if nrows = 512, and blockRows = 100, then 
        //blockRowsData for last block will be 12
	int blockRowsData;
        if ((rowStart+blockRows)>nrows) {
            blockRowsData = nrows - rowStart;
        } else {
            blockRowsData = blockRows;
        }

        // fill the valarray with zero before getting the block of the data
        refSlc = 0;
        secSlc = 0;
        ifgramUpsampled = 0;
        ifgram = 0;

        // get a block of reference and secondary SLC data
        std::cout << rowStart << " , " << ncols << " , " << blockRowsData << std::endl;

        referenceSLC.getBlock(refSlc, 0, rowStart, ncols, blockRowsData);
        secondarySLC.getBlock(secSlc, 0, rowStart, ncols, blockRowsData);
    
        //commaon azimuth band-pass filter the reference and secondary SLCs
        std::cout << "common band filtering" << std::endl;
        if (_doCommonAzimuthbandFilter){
            filter.filter(refSlc, refSpectrum);
            filter.filter(secSlc, secSpectrum);
        }

        // upsample the refernce and secondary SLCs
        std::cout << "upsampling " << std::endl;
        refSignal.upsample(refSlc, refSlcUpsampled, blockRows, nfft, oversample);
        secSignal.upsample(secSlc, secSlcUpsampled, blockRows, nfft, oversample);
       
        std::cout << "upsampled ifgram " << std::endl;
        // Compute oversampled interferogram data

        /*
        for (size_t line = 0; line < blockRowsData; ++line){
            for (size_t col = 0; col < oversample*ncols; ++col){
                ifgramUpsampled[line*(oversample*ncols) + col] =
                        refSlc[line*(oversample*nfft) + col]*
                        std::conj(secSlc[line*(oversample*nfft) + col]);
            }
        }
        */
        
        for (size_t line = 0; line < blockRowsData; line++){
            for (size_t col = 0; col < oversample*ncols; col++){
                ifgramUpsampled[line*(oversample*ncols) + col] = 
                        refSlcUpsampled[line*(oversample*nfft) + col]*
                        std::conj(secSlcUpsampled[line*(oversample*nfft) + col]);
            }
        }
        std::cout << "full res ifgram " << std::endl;
        // Reclaim the extra oversample looks across
        for (size_t line = 0; line < blockRowsData; line++){
            for (size_t col = 0; col < ncols; col++){
                std::complex<float> sum =(0,0);
                for (size_t j=0; j< oversample; j++)
                    sum += ifgramUpsampled[line*(ncols*oversample) + j + col*oversample]; // + 2*col];
                ifgram[line*ncols + col] = sum;            
            }
        }

	// Take looks down (summing columns)
        
	// set the block of interferogram
        interferogram.setBlock(ifgram, 0, rowStart, ncols, blockRowsData);
        //interferogram.setBlock(ifgramUpsampled, 0, rowStart, ncols*oversample, blockRowsData);
    }
}



