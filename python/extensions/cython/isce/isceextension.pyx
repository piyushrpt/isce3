#cython: language_level=3
#
# Author: Bryan V. Riel, Joshua Cohen
# Copyright 2017
#

# Define a helper function to convert Python strings/bytes to bytes
def pyStringToBytes(s):
    if isinstance(s, str):
        return s.encode('utf-8')
    elif isinstance(s, bytes):
        return s
    else:
        raise ValueError('Input Python string not str or bytes')

include "except/pyError.pyx"
include "core/forward.pyx"

# Include the io extensions
include "io/pyGDAL.pyx"
include "io/pyRaster.pyx"
include "io/pyIH5.pyx"

# Include the core extensions
include "core/pyLookSide.pyx"
include "core/pyTimeDelta.pyx"
include "core/pyDateTime.pyx"
include "core/pyEulerAngles.pyx"
include "core/pyQuaternion.pyx"
include "core/pyBasis.pyx"
include "core/pyEllipsoid.pyx"
include "core/pyInterpolator.pyx"
include "core/pyPeg.pyx"
include "core/pyPegtrans.pyx"
include "core/pyLUT2d.pyx"
include "core/pyLUT1d.pyx"
include "core/pyOrbit.pyx"
include "core/pyPoly1d.pyx"
include "core/pyPoly2d.pyx"
include "core/pyStateVector.pyx"
include "core/pyProjections.pyx"

# Include the product extensions
include "product/pyProcessingInformation.pyx"
include "product/pySwath.pyx"
include "product/pyRadarGridParameters.pyx"
include "product/pyMetadata.pyx"
include "product/pyProduct.pyx"
include "product/pyGeoGridParameters.pyx"

# Include the image extensions
include "image/pyResampSlc.pyx"

# Include the signal extensions
include "signal/pyCrossmul.pyx"
include "signal/pyLooks.pyx"

include "geocode/pygeocodeSlc.pyx"

# Include the geometry extensions
include "geometry/pygeometry.pyx"
include "geometry/pyTopo.pyx"
include "geometry/pyGeo2rdr.pyx"
include "geometry/pyRTC.pyx"
include "geometry/pyGeocode.pyx"
include "geometry/pyDEMInterpolator.pyx"
include "geometry/pyBoundingbox.pyx"

# The separate serialization routines
include "serialization/serialize.pyx"

# end of file
