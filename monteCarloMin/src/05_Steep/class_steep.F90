module class_steep
!------------------------------------------------------------------------------
!steep
!------------------------------------------------------------------------------
!This class contains the subroutines to do a steepest descent search. 
!
!
!    Date        Programmer        Comments
!    04/28/2011  C. Blanton        Original Code
!    06/09/2011  C. Blanton        Added data type and associated procedures.
!                                  More general SDS
!
!------------------------------------------------------------------------------
  use mod_param, only:maxchar,&
       wp,&
       iout
  use mod_fitness, only:SumFitness,&
                        calc_hexp,&
                        fit_param
  use class_searchPt, only: searchPt,&
                            searchPt_init,&
                            searchPt_computeSearchDirection,&
                            searchPt_findHMin,&
                            searchPt_constructPt,&
                            searchPt_SDSConvTest,&
                            searchPt_copy,&
                            searchPt_allocate,&
                            searchPt_deallocate,&
                            searchPt_calcEngAlp,&
                            searchPt_displayPt
                           
  private
!------------------------------------------------------------------------------
!Public
!------------------------------------------------------------------------------
  public :: steepDescentSum 
  public :: EnergySDS
  public :: SDSParam
  public :: SDSParam_init
  public :: SteepDescentSearchAlp
  public :: SDSAlp_fileReader

!------------------------------------------------------------------------------
!Data Type
!------------------------------------------------------------------------------
  type :: SDSParam
     private
     character(maxchar) :: outputFileName
     integer :: maxIterations
     real(wp) :: h                   !Step for finite derivatives
     real(wp) :: stepSize            !Step for single parameter search
     real(wp) :: a                   !Lower Limit for single parameter search
     real(wp) :: b                   !Upper limit for single parameter search
     real(wp) :: funcTol             !Tolerance for func difference
     real(wp) :: distTol             !TOlerance for point difference
  end type SDSParam

contains
!------------------------------------------------------------------------------
!Begin Procedures
!------------------------------------------------------------------------------
 
  subroutine SDSParam_init(outputFileName,maxIterations, h, stepSize,a, b, funcTol, distTol, SDSP)
!------------------------------------------------------------------------------
!SDSParam_init
!------------------------------------------------------------------------------
!This procedure loads the paramaters into the type.
!
!    Date        Programmer        Comments
!    06/09/2011  C. Blanton        Original Code
!
!------------------------------------------------------------------------------
    implicit none

!------------------------------------------------------------------------------
!Inputs
!------------------------------------------------------------------------------
    character(maxchar), intent(in) :: outputFileName
    integer, intent(in) :: maxIterations
    real(wp), intent(in) :: h
    real(wp), intent(in) :: stepSize
    real(wp), intent(in) :: a
    real(wp), intent(in) :: b
    real(wp), intent(in) :: funcTol
    real(wp), intent(in) :: distTol
 
!------------------------------------------------------------------------------
!Output
!------------------------------------------------------------------------------
    type(SDSParam), intent(out) :: SDSP

!------------------------------------------------------------------------------
!Begin Code
!------------------------------------------------------------------------------
    SDSP%outputFileName = outputFileName
    SDSP%maxIterations = maxIterations
    SDSP%h = h
    SDSP%stepSize = stepSize
    SDSP%a = a
    SDSP%b = b
    SDSP%funcTol = funcTol
    SDSP%distTol = distTol

!------------------------------------------------------------------------------
!End Code
!------------------------------------------------------------------------------
  end subroutine SDSParam_init

  subroutine steepDescentSum(len,maxIterations, StartVec, AnsVec)
!------------------------------------------------------------------------------
!steepDescentSum
!------------------------------------------------------------------------------
!This subroutine minimizes a the fitness function from a given vector by 
!systematically searchin using a steepest descent method. 
!
!    Date        Programmer        Comments
!    04/28/2011  C. Blanton        Original Code
!------------------------------------------------------------------------------
    implicit none
!------------------------------------------------------------------------------
!Input
!------------------------------------------------------------------------------
    integer, intent(in) :: len
    integer, intent(in) :: maxIterations
    real(wp), intent(in) :: StartVec(len)

!------------------------------------------------------------------------------
!Output
!------------------------------------------------------------------------------
    real(wp), intent(out) :: AnsVec(len)

!------------------------------------------------------------------------------
!Internals
!------------------------------------------------------------------------------
    integer :: i
    integer :: j
    real(wp) :: bestFit
    real(wp) :: workFit(len)
    real(wp) :: workVec(len)
    real(wp) :: tempBestFit
    real(wp) :: previousBest

!------------------------------------------------------------------------------
!Begin Code
!------------------------------------------------------------------------------
    workVec = StartVec
    call SumFitness(len,workVec, bestFit)
    tempBestFit = bestFit
    previousBest = bestFit
    do i=1, maxIterations
       do j=1, len
          workVec(j) = -(workVec(j))
          call SumFitness(len, workVec, workFit(j))
          workVec(j) = -(workVec(j))
       end do
       do j=1, len
          if (workFit(j) < tempbestFit) then
             tempbestFit = workFit(j)
             workVec(j) = -(workVec(j))
             write(iout,*) "Main Loop ", i, "Sub Loop ", j, "Temp Best Fit ", tempBestFit
          end if
       end do
       if (previousBest == tempBestFit) EXIT
       previousBest = tempBestFit
    end do
    ansVec = workVec
!------------------------------------------------------------------------------
!End Code
!------------------------------------------------------------------------------
  end subroutine steepDescentSum


  subroutine EnergySDS(nb,maxIterations, StartVec,EngParam, AnsVec)
!------------------------------------------------------------------------------
!EnergySDS
!------------------------------------------------------------------------------
!This subroutine minimizes a the fitness function from a given vector by 
!systematically searchin using a steepest descent method using an energy
!as the fitness function. 
!
!    Date        Programmer        Comments
!    05/03/2011  C. Blanton        Original Code
!------------------------------------------------------------------------------
    implicit none
!------------------------------------------------------------------------------
!Input
!------------------------------------------------------------------------------
    integer, intent(in) :: nb
    integer, intent(in) :: maxIterations
    real(wp), intent(in) :: StartVec(nb)
    ! real(wp), intent(in) :: phi(nb)
    ! real(wp), intent(in) :: hmat(nb,nb)
    type(fit_param), intent(in) :: EngParam
!------------------------------------------------------------------------------
!Output
!------------------------------------------------------------------------------
    real(wp), intent(out) :: AnsVec(nb)

!------------------------------------------------------------------------------
!Internals
!------------------------------------------------------------------------------
    character(100) :: outfile 
    integer :: i
    integer :: j
    real(wp) :: bestFit
    real(wp) :: workFit(nb)
    real(wp) :: workVec(nb)
    real(wp) :: tempBestFit
    real(wp) :: previousBest
    
!------------------------------------------------------------------------------
!Begin Code
!------------------------------------------------------------------------------
    outfile = "EnergyStep.txt"
    open(unit=11,file=outfile,action="write")
    write(11,*) "Loop #    Energy"
    workVec = StartVec
    call calc_hexp(nb,workVec,EngParam,bestFit)
    tempBestFit = bestFit
    previousBest = bestFit
    do i=1, maxIterations
       do j=1, nb
          workVec(j) = -(workVec(j))
          call calc_hexp(nb, workVec,EngParam, workFit(j))
          workVec(j) = -(workVec(j))
       end do
       do j=1, nb
          if (workFit(j) < tempbestFit) then
             tempbestFit = workFit(j)
             workVec(j) = -(workVec(j))
             write(11,*) i, tempBestFit
             write(iout,*) "Main Loop ", i, "Sub Loop ", j, "Temp Best Fit ", tempBestFit
          end if
       end do
       if (previousBest == tempBestFit) EXIT
       previousBest = tempBestFit
    end do
    ansVec = workVec
!------------------------------------------------------------------------------
!End Code
!------------------------------------------------------------------------------
  end subroutine EnergySDS

  subroutine SteepDescentSearchAlp(SDSP,initalPt,eng,ansPt)
!------------------------------------------------------------------------------
!SteepDescentSearchAlp
!------------------------------------------------------------------------------
!This procedure will perform a general steepest descent search.
!
!
!
!    Date        Programmer        Comments
!    06/09/2011  C. Blanton        Original Code
!
!------------------------------------------------------------------------------
    implicit none

!------------------------------------------------------------------------------
!Parameter
!------------------------------------------------------------------------------
    integer, parameter :: ifp=23
!------------------------------------------------------------------------------
!Input
!------------------------------------------------------------------------------
    type(SDSParam), intent(in) :: SDSP
    type(searchPt), intent(in) :: initalPt
    
!------------------------------------------------------------------------------
!Output
!------------------------------------------------------------------------------
    real(wp), intent(out) :: eng
    type(searchPt), intent(out) :: ansPt

!------------------------------------------------------------------------------
!Internals
!------------------------------------------------------------------------------
    integer :: i
    real(wp) :: hmin
    real(wp) :: stats(2)
    logical :: conv
    type(searchPt) :: sVec
    type(searchPt) :: point
    type(searchPt) :: newPt
    
!------------------------------------------------------------------------------
!Begin Code
!------------------------------------------------------------------------------
    open(unit=ifp,file=SDSP%outputFileName,action='write')
    call searchPt_copy(initalPt, point)

    do i = 1, SDSP%maxIterations
       call searchPt_computeSearchDirection(SDSP%h, point, sVec)
       call searchPt_findHMin(SDSP%stepSize,SDSP%a,SDSP%b, point, sVec, hmin)
       call searchPt_constructPt(hmin,sVec,point,newPt)
       call searchPt_SDSConvTest(SDSP%funcTol, SDSP%distTol,point, newPt,stats, conv)
       call searchPt_calcEngAlp(newPt,eng)
       write(iout,*) "Iteration # ", i, "Energy ", eng,  " Converged: ", conv
       write(iout,*) "Eng Difference: ", stats(1), " Distance Difference: ", stats(2)
       write(ifp,*)  "Iteration # ", i, "Energy ", eng,  " Converged: ", conv
       if (conv) exit
       call searchPt_copy(newPt, point)
       call searchPt_displayPt(iout,point) 
    end do
    
    call searchPt_copy(newPt,ansPt)
!------------------------------------------------------------------------------
!End Code
!------------------------------------------------------------------------------
  end subroutine SteepDescentSearchAlp

  subroutine SDSAlp_fileReader(ifp,file_input,initalPt,SDSP)
!------------------------------------------------------------------------------
!SDSAlp_filereader
!------------------------------------------------------------------------------
!This procedure will read a correctly formatted input file (for example
!see ./SDSAlp.inp 
!
!    Date        Programmer        Comments
!    06/10/2011  C. Blanton        Original Code
!
!------------------------------------------------------------------------------
    implicit none

!------------------------------------------------------------------------------
!Parameters
!------------------------------------------------------------------------------


!------------------------------------------------------------------------------
!Input
!------------------------------------------------------------------------------
    integer, intent(in) :: ifp
    character(maxchar), intent(in) :: file_input

!------------------------------------------------------------------------------
!Output
!------------------------------------------------------------------------------
    type(searchPt), intent(out) :: initalPt
    type(SDSParam), intent(out) :: SDSP

!------------------------------------------------------------------------------
!Interals
!------------------------------------------------------------------------------
    character(maxchar) :: outputFileName
    integer :: i
    integer :: ierror
    integer :: num
    integer :: calcType
    integer :: maxIterations
    real(wp) :: h
    real(wp) :: stepSize
    real(wp) :: a
    real(wp) :: b
    real(wp) :: funcTol
    real(wp) :: distTol
    real(wp), allocatable :: point(:)
    logical :: Lalloc

!------------------------------------------------------------------------------
!Begin Code
!------------------------------------------------------------------------------
    open(unit=ifp,file=file_input, status='old',action='read',iostat=ierror)
    if (ierror /= 0) then
       STOP "***File_input does not exist.***"
    end if


    read(ifp,*) !Title
    read(ifp,*) !Output File Name
    read(ifp,*) outputFileName
    read(ifp,*) !AlphLength
    read(ifp,*) num
    if(allocated(point)) deallocate(point)
    allocate(point(num))
    read(ifp,*) !Type of Calculation
    read(ifp,*) calcType
    read(ifp,*) !Inital Point
    read(ifp,*) point
    read(ifp,*) !maxIterations
    read(ifp,*) maxIterations
    read(ifp,*) !h
    read(ifp,*) h
    read(ifp,*) !stepSize
    read(ifp,*) stepSize
    read(ifp,*) !a
    read(ifp,*) a
    read(ifp,*) !b
    read(ifp,*) b
    read(ifp,*) !funcTol
    read(ifp,*) funcTol
    read(ifp,*) !distTol
    read(ifp,*) distTol

    call searchPt_init(num,calcType,point, initalPt)
    call SDSParam_init(outputFileName,maxIterations,h,stepSize,a,b,funcTol,distTol,SDSP)

!------------------------------------------------------------------------------
!End Code
!------------------------------------------------------------------------------
  end subroutine SDSAlp_fileReader

!------------------------------------------------------------------------------
!End Procedures
!------------------------------------------------------------------------------
end module class_steep
