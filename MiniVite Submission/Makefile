
CXX = mpic++

# use -xmic-avx512 instead of -xHost for Intel Xeon Phi platforms
OPTFLAGS = -O3 -fopenmp -DPRINT_DIST_STATS #-DPRINT_EXTRA_NEDGES #-DUSE_MPI_RMA -DUSE_MPI_ACCUMULATE #-DUSE_32_BIT_GRAPH #-DDEBUG_PRINTF #-DUSE_MPI_RMA #-DPRINT_LCG_DOUBLE_LOHI_RANDOM_NUMBERS#-DUSE_MPI_RMA #-DPRINT_LCG_DOUBLE_RANDOM_NUMBERS #-DPRINT_RANDOM_XY_COORD
#-DUSE_MPI_SENDRECV
#-DUSE_MPI_COLLECTIVES
# use export ASAN_OPTIONS=verbosity=1 to check ASAN output
SNTFLAGS = -std=c++11 -fopenmp -fsanitize=address -O1 -fno-omit-frame-pointer
CXXFLAGS = -std=c++11 -g $(OPTFLAGS)


# TEMP1 = -L/apps/modules/libraries/openmpi/5.0.3/armclang-24.04/lib/libmpi.a
# TEMP2 = -I/apps/modules/libraries/openmpi/5.0.3/armclang-24.04/include

OBJ = main.o
TARGET = miniVite

all: $(TARGET)

%.o: %.cpp
	$(CXX) $(CXXFLAGS) -c -o $@ $^

$(TARGET):  $(OBJ)
	$(CXX) $^ $(OPTFLAGS) -o $@

.PHONY: clean

clean:
	rm -rf *~ $(OBJ) $(TARGET)