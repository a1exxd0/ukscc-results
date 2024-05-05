# build script that copies OSU from shared directory and builds it

# load in needed modules
module load compilers/gcc/13 libraries/openmpi/5.0.3/gcc-13
module list

# delete and make OSU in build directory
rm -rf ~/build/OSU
mkdir ~/build/OSU
cd ~/build/OSU

# download and untar source code
wget https://mvapich.cse.ohio-state.edu/download/mvapich/osu-micro-benchmarks-7.4.tar.gz
tar xzf osu-micro-benchmarks-7.4.tar.gz

# configure and build
./osu-micro-benchmarks-7.4/configure CC=mpicc CXX=mpicxx --prefix=$(pwd)
make -j
make -j install

echo " --- Script finished building OSU --- "
ls


