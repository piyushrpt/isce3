##isce3 package
file(COPY isce3 
     DESTINATION ${ISCE_BUILDPACKAGESDIR})
install(DIRECTORY isce3
        DESTINATION ${ISCE_PACKAGESDIR})

##nisar package
file(COPY nisar
     DESTINATION ${ISCE_BUILDPACKAGESDIR})
install(
    DIRECTORY nisar
    DESTINATION ${ISCE_PACKAGESDIR})

##pybind nisar package
file(COPY pybind_nisar
     DESTINATION ${ISCE_BUILDPACKAGESDIR})
install(
    DIRECTORY pybind_nisar
    DESTINATION ${ISCE_PACKAGESDIR})
