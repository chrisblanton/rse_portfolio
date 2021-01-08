# Basic version

This will solve a randomly generated Ax=b problem. 
This version contains a DGEMM in which the matrix multiplication was implemented using a school-book algorithm. 

## Requirements

- A standard Fortran compiler.

## Compilation 

The Makefile builds out of source and the executable will be in the bin. This is done by 
```
make benchmark_solver.out
```
The optimization can be adjusted using the `OPT` variable.Profiling can be turned on by uncommenting the `PROFILE=-g -pg` line. 

The executable can be cleaned using the standard
```
make clean
```

## Running the executable
Within the `bin` directory, run `./benchmark_solver.out` 
Enter the size of the matrix when prompted for `Enter n:`. This will be size of the `n*n` matrix and the vector `n`. 
