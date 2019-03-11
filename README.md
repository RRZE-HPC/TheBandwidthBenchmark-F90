# The Bandwidth Benchmark (Fortran version)

This is a collection of simple streaming kernels for teaching purposes.
It is heavily inspired by John McCalpin's https://www.cs.virginia.edu/stream/.

It contains the following streaming kernels with corresponding data access pattern (Notation: S - store, L - load, WA - write allocate):

* init (S1, WA): Initilize an array. Store only.
* sum (L1): Vector reduction. Load only.
* copy  (L1, S1, WA): Classic memcopy.
* update (L1, S1): Update a vector. Also load + store but without write allocate.
* triad (L2, S1, WA): Stream triad - `a = b + b * scalar`.
* daxpy (L2, S1): Daxpy - `a = a + b * scalar`.
* striad (L3, S1, WA): Schoenauer triad - `a = b + c * d`.
* sdaxpy (L3, S1): Schoenauer triad without write allocate - `a = a + b * c`.


## Build

1. Configure the toolchain to use in the `Makefile`:
```
TAG = GFORTRAN  # Supported GFORTRAN, IFORT
```

2. Review the flags for toolchain in the corresponding included file, e.g. `include_GFORTRAN.mk`. OpenMP is disabled per default, you can enable it by uncommenting the OpenMP flag:
```
OPENMP   = -fopenmp
```

3. Build with:
```
make
```

You can build multiple toolchains in the same directory, but notice that the Makefile is only acting on the one currently set.
Intermediate build results are located in the `<TOOLCHAIN>` directory.

4. Clean up with:
```
make clean
```
to clean intermediate build results.

```
make distclean
```
to clean intermediate build results and binary.

5. (Optional) Generate assembler:
```
make asm
```
The assembler files will also be located in the `<TOOLCHAIN>` directory.

## Usage

To run the benchmark call:
```
./bwBench-<TOOLCHAIN>
```

The benchmark will output the results similar to the stream benchmark. Results are validated.
For threaded execution it is recommended to control thread affinity.

We recommend to use likwid-pin for benchmarking:
```
likwid-pin -c 0-3 ./bwbench-GFORTRAN  
```

Example output for threaded execution:
```
[pthread wrapper]
[pthread wrapper] MAIN -> 0
[pthread wrapper] PIN_MASK: 0->1  1->2  2->3
[pthread wrapper] SKIP MASK: 0x0
        threadid 140210970978048 -> core 1 - OK
        threadid 140210962585344 -> core 2 - OK
        threadid 140210954192640 -> core 3 - OK
 ----------------------------------------------
 Number of Threads =            4
 ----------------------------------------------
 -------------------------------------------------------------
 Function      Rate (MB/s)   Avg time     Min time     Max time
 Init:         15068.23      0.0123       0.0106       0.0112
 Sum:          21384.63      0.0088       0.0075       0.0082
 Copy:         18854.08      0.0190       0.0170       0.0174
 Update:       28157.37      0.0129       0.0114       0.0114
 Triad:        19215.55      0.0281       0.0250       0.0263
 Daxpy:        26606.76      0.0203       0.0180       0.0182
 STriad:       21279.46      0.0339       0.0301       0.0309
 SDaxpy:       26629.39      0.0271       0.0240       0.0240
 -------------------------------------------------------------
```
