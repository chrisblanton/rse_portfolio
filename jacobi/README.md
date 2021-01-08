# Jacobi Solver Example

This directory contains three implementations of a Jacobi Solver that contains various versions of the matrix multiplication routine. As the goal was an example of serial optimization, the matrix multiplication routine was purposely implemented in a naive manner and an "hand-optimized" version. 
The three directories include a basic implementation, an optimized version, and a version which uses a library. 

- **basic** This is a naive implementation of the DGEMM matrix multiplication. 
- **opt1** This is a optimized tiled matrix multiplication within the DGEMM routine. 
- **blas** This is a version that uses a BLAS DGEMM matrix multiplication. 
