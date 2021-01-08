# Libary-use version

This will solve a randomly generated Ax=b problem. 
This version uses a BLAS libary for the DGEMM used in the solver. 

## Requirements

- A standard Fortran compiler.
- A BLAS library installed on the system

## Compliation 

The Makefile builds out of source and the executables will be in the bin. The location of the BLAS library will likely need to be set in the `Makefile`

This is done by 
```
make benchmark_solver.out
```
The optimization can be adjusted using the `OPT` variable.Profiling can be turned on by uncomming the `PROFILE=-g -pg` line. 

The executable can be cleaned using the standard
```
make clean
```

## Running the execuatable
Within the `bin` directory, run `./benchmark_solver.out` 
Enter the size of the matrix when prompted for `Enter n:`. This will be size of the `n*n` matrix and the vector `n`. Enter the tilesize to use when prompted.
