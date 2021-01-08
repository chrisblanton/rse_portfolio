VERSION="1.0"
EXE="SDSAlp_""$VERSION"".exe"
DIR="../src"

cd ./exe
rm $EXE

## do runtime checking
   check="-check all,noarg_temp_created"

## print all warnings (a bit annoying)
   #warn="-warn all -warn nounused -warn nouncalled"

## print which file compiler is working on
   watch="-watch source"

## debug options
   debug="-g "

## print tarceback infor in case of crash
   trace="-traceback"

## impose standard f90 syntax
   #stand="-stand f90 -e90"

## generate automatic interface
   iface="-gen-interfaces"

## floating point stack check
   fp1="-fp-stack-check -r8"
## floating point overflow/underflow
   fp2="-fpe0 -fpe-all=0 "

DEV_OPT="$check $warn $watch $debug $trace $stand $iface $fp1 $fp2 "

gfortran -g \
    $DIR/01_error/*.[fF]90 \
    $DIR/01_param/*.[fF]90  \
    $DIR/01_file/*.[fF]90 \
    $DIR/02_fileGen/*.[fF]90 \
    $DIR/02_io_dir/*.[fF]90 \
    $DIR/03_calcEng/*.[fF]90 \
    $DIR/03_fitness/*.[fF]90 \
    $DIR/04_searchPt/*.[fF]90 \
    $DIR/05_Steep/*.[fF]90 \
    $DIR/99_prog3/*.[fF]90 -o $EXE
