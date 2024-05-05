# build script that copies NAMD from shared directory and builds it

# load needed module
# TODO: Try using armclang instead of gcc, didn't work for compiling charm :(
# When compiling for arm use -mcpu=native instead of -march and -mtune (better optimises for smaller subset)
module load compilers/gcc/13 libraries/openmpi/5.0.3/gcc-13 tools/cmake
module list

# make build directory (if doesn't exist) and cd to it
mkdir -p ~/build
cd ~/build

# copy NAMD folder to NAMD in build directory
rm -rf ./NAMD
cp -r /opt/UKSCCSCC/NAMD ./
cd ./NAMD

# untar source code and input file
tar zxf ./NAMD_3.0b6_Source.tar.gz
tar zxf ./stmv.tar.gz

# cd inside source directory
cd ./NAMD_3.0b6_Source

# build charm++ with openmpi (-DCMK_OPTIMIZE optimises charm build so it doesn't add loads of asserts on API calls)
# TODO: Build net version instead of mpi, may be significantly more performant as will just ssh into nodes directly (especially given no omnipath)
tar xf ./charm-7.0.0.tar
cd ./charm-v7.0.0
#env MPICXX=mpicxx ./build charm++ mpi-linux-arm8 --with-production -march=native -DCMK_OPTIMIZE

# TODO: Try using smp correctly with +ppn x (where x is number of worker threads per process) 
# [non-smp provides better performance, normally only needed in high memory applications which may not be an issue here? see if memory contrained]
# build with smp to reserve one core process for communication (may improve performance?)
# ./build charm++ mpi-linux-arm8 smp mpicxx --with-production -march=native -DCMK_OPTIMIZE
# BUILD_CHARM_ARCH=mpi-linux-arm8-smp-mpicxx

# build without smp
./build charm++ mpi-linux-arm8 mpicxx --with-production -mcpu=native -DCMK_OPTIMIZE
BUILD_CHARM_ARCH=mpi-linux-arm8-mpicxx

# test charm++
# cd mpi-linux-arm8/tests/charm++/megatest
# make -j megatest
# mpiexec -n 4 ./megatest


# download pre-built tcl binary # NOT COMPATIBLE (Compiler issues?)
# wget http://www.ks.uiuc.edu/Research/namd/libraries/tcl8.5.9-linux-arm.tar.gz
# wget http://www.ks.uiuc.edu/Research/namd/libraries/tcl8.5.9-linux-arm-threaded.tar.gz
# tar xzf tcl8.5.9-linux-arm.tar.gz
# tar xzf tcl8.5.9-linux-arm-threaded.tar.gz
# mv tcl8.5.9-linux-arm ./NAMD_3.0b6_Source/tcl
# mv tcl8.5.9-linux-arm-threaded ./NAMD_3.0b6_Source/tcl-threaded

# download and build tcl from scratch
cd ~/build/NAMD
wget http://prdownloads.sourceforge.net/tcl/tcl8.5.9-src.tar.gz
tar xzf tcl8.5.9-src.tar.gz
cd ./tcl8.5.9/unix
./configure --prefix=$HOME/build/NAMD/NAMD_3.0b6_Source/tcl
make -j
# make test
make -j install


# download and build fftw from scratch (needs shared library, module is static)
cd ~/build/NAMD
wget http://www.fftw.org/fftw-3.3.10.tar.gz
tar xzf fftw-3.3.10.tar.gz
cd ./fftw-3.3.10
./configure --prefix=/home/ogooberman/build/NAMD/NAMD_3.0b6_Source/fftw --enable-float
make -j
make -j install

# configure NAMD to pick up fftw module NOT COMPATIBLE (Seems to be static and wants shared library?)
# THIS WEBSITE SHOWS HOW TO USE STATIC https://www.pugetsystems.com/labs/hpc/namd-custom-build-for-better-performance-on-your-modern-gpu-accelerated-workstation-ubuntu-16-04-18-04-centos-7-1196/#NAMD
# cd ~/build/NAMD
# cp -r /apps/modules/libraries/fftw/gcc-13 ./NAMD_3.0b6_Source/fftw

# build NAMD
cd ~/build/NAMD/NAMD_3.0b6_Source

# compile optimised for platform (charm, tcl, fftw3 are all installed in default locations)
# could potentiall enable --with-memopt but requires input file to be binary rather than plaintext
./config Linux-ARM64-g++ --charm-arch $BUILD_CHARM_ARCH --with-fftw3 --cc-opts '-O3 -mcpu=native ' --cxx-opts '-O3 -mcpu=native '
cd Linux-ARM64-g++
make -j
