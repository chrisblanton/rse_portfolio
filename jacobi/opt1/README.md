# Optimized version

This will solve a randomly generated Ax=b problem. 
This version contains a DGEMM in which the matrix multiplication was implemented using a tiled algorithm.

## Requirements

- A standard Fortran compiler.

## Compliation 

The Makefile builds out of source and the executables will be in the bin. This is done by 
```
make benchmark_solver_tilesize.out
```
The optimization can be adjusted using the `OPT` variable.Profiling can be turned on by uncomming the `PROFILE=-g -pg` line. 

The executable can be cleaned using the standard
```
make clean
```

## Running the execuatable
Within the `bin` directory, run `./benchmark_solver_tilesize.out` 
Enter the size of the matrix when prompted for `Enter n:`. This will be size of the `n*n` matrix and the vector `n`. Enter the tilesize to use when prompted.
