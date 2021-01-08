# Monte Carlo Minimization

This is a problem that minimizes the energy of a system using a Monte Carlo approach. As a check, the system can also be minized using Steepest Descent.

The organizaiton of the files follows the pattern that lower numbered directories and files are more independent than higher numbered files and directories. Source files are found in the `src` directory

- **01_error/error.F90** contains error handling code
- **01_param/mod_param.f90** contains constants used in other files.
- **02_fileGen/mod_fileGen.F90** contains routines to create input files for other problems that may be used.
- **02_io_dir/mod_io.F90** contains IO routines.
- **03_calcEng/mod_calcEng.F90** contains routiens for calculating energies.
- **03_fitness/mod_fitness.f90** contains routines for calcalcuting fitness functiosn for Monte Carlo searches. 
- **04_searchPt/class_searchPt** contains the class for the search point that is used by the Monte Carlo and Steepest descent searches as well as the main programs. 
- **05_MCM/mod_MCM.f90** contains the routines for the Monte Carlo method.
- **05_Steep/class_steep.F90** contains the class with methods for doing Steepest Descent searchs. This was a class rather than a module since a derived data type was used to hold things, emulating a Object-Oriented Progamming within Fortran 90. 
- **99_prog3/prog.f90** This is the full calculation for the system. 

## Requirements

This software requires 

- a Fortran compiler
