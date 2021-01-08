module class_MCM
!------------------------------------------------------------------------------
!MCM
!------------------------------------------------------------------------------
!This class contains the subroutines to perform Monte Carlo minimization.
!
!
!
!    Date        Programmer        Comments
!    04/27/2011  C. Blanton        Original Code
!    04/28/2011  C. Blanton        Converted -1.00e0_wp to -(workVec(j))
!                                  (This is more general!)
!
!------------------------------------------------------------------------------
  use mod_param, only: wp,&
       one,&
n       iout
  use mod_fitness, only: SumFitness,&
                         calc_hexp,&
                         fit_param
  private

!------------------------------------------------------------------------------
!Public
!------------------------------------------------------------------------------

  public :: MCMSum
  public :: EnergyMCM


!------------------------------------------------------------------------------
!Data Type
!------------------------------------------------------------------------------
  type :: MCMParam
     private
     character :: outputFileName
     integer :: seed                     !Random Seed for Monte Carlo
     integer :: maxIterations
     real(wp) :: lowRandLim              !Lower limit for random number generation
     real(wp) :: upRandLim               !Upper limit for random number generation
     real(wp) :: funcTol                 !Tolerance for func difference
     real(wp) :: distTol                 !Tolerenace for point difference
  end type MCMParam

contains
!------------------------------------------------------------------------------
!Begin Subroutines
!------------------------------------------------------------------------------

  subroutine MCMParam_init(outputFileName,seed,maxIterations,lowRandLim,&
                           upRandLim, funcTol, distTol, MCMP)
!------------------------------------------------------------------------------
!MCMParam_init
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
    integer, intent(in) :: seed
    integer, intent(in) :: maxIterations
    integer, intent(in) :: iParamVary
    real(wp), intent(in) :: lowRandLim
    real(wp), intent(in) :: upRandLim
    real(wp), intent(in) :: funcTol
    real(wp), intent(in) :: distTol
 
!------------------------------------------------------------------------------
!Output
!------------------------------------------------------------------------------
    type(MCMParam), intent(out) :: MCMP

!------------------------------------------------------------------------------
!Begin Code
!------------------------------------------------------------------------------
    MCMP%outputFileName = outputFileName
    MCMP%seed = seed
    MCMP%maxIterations = maxIterations
    MCMP%iParamVay = iParamVary
    MCMP%lowRandLim = lowRandLim
    MCMP%upRandLim = upRandLim
    MCMP%funcTol = funcTol
    MCMP%distTol = distTol

!------------------------------------------------------------------------------
!End Code
!------------------------------------------------------------------------------
  end subroutine MCMParam_init


  subroutine MCMSum(len,maxIterations, StartVec, AnsVec)
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
!Internal
!------------------------------------------------------------------------------
    integer :: i
    integer :: j
    integer :: best(len)
    integer :: dtVals(8)
    integer :: seed
    real(wp) :: bestFit
    real(wp) :: workFit
    real(wp) :: random
    real(wp) :: workVec(len)
    real(wp) :: bestVec(len)

!------------------------------------------------------------------------------
!Begin Program
!------------------------------------------------------------------------------
    call DATE_AND_TIME(VALUES=dtVals)
    call RANDOM_SEED(PUT=dtVals(1:8))

    workVec = StartVec
    bestVec = StartVec
    do i=1, maxIterations
       do j=1, len
          call RANDOM_NUMBER(random)
          if (random .le. 0.50e0_wp) then
             workVec(j) = -(workVec(j))
          else
             workVec(j) = workVec(j)
          end if
       end do
       call SumFitness(len,bestVec,bestFit)
       call SumFitness(len,workVec,workFit)
       if (workFit .lt. bestFit) then
          bestVec = workVec 
       else
          write(iout,*) "Minimia found at iteration", i
          write(iout,*) "Fitness = ", bestFit
          ansVec = bestVec
          EXIT
       end if
       write(iout,*) "Iteration ", i
       write(iout,*) "Best Fitness = ", bestFit
       ansVec = bestVec
    end do
  end subroutine MCMSum

!------------------------------------------------------------------------------
!EnergyMCM
!------------------------------------------------------------------------------
  subroutine EnergyMCM(nb,maxIterations, StartVec,EngParam,AnsVec)
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
!Internal
!------------------------------------------------------------------------------
    integer :: i
    integer :: j
    integer :: best(nb)
    integer :: dtVals(8)
    integer :: seed
    real(wp) :: bestFit
    real(wp) :: workFit
    real(wp) :: random
    real(wp) :: workVec(nb)
    real(wp) :: bestVec(nb)

!------------------------------------------------------------------------------
!Begin Program
!------------------------------------------------------------------------------
!Change this so that the seed is user-defined. 
    call DATE_AND_TIME(VALUES=dtVals)
    call RANDOM_SEED(PUT=dtVals(1:8))

    workVec = StartVec
    bestVec = StartVec
    MCloop: do i=1, maxIterations
       guessLoop: do j=1, nb
          call RANDOM_NUMBER(random)
          if (random .le. 0.50e0_wp) then
             workVec(j) = -(workVec(j))
          else
             workVec(j) = workVec(j)
          end if
       end do guessLoop
!nb and vec should not be visable. Data type "point".
!The point class should contain all the dimensional points.
!Procedures for the data type should contain the rules for
!generating new points froms old points.  
!Move the bestfit calculation outside the loops. It doesn't change.
       call calc_hexp(nb,bestVec,EngParam,bestFit)
       call calc_hexp(nb,workVec,EngParam,workFit)
       if (workFit .lt. bestFit) then
          bestVec = workVec 
       else
          write(iout,*) "Minimia found at iteration", i
          write(iout,*) "Fitness = ", bestFit
          ansVec = bestVec
          EXIT
       end if
       write(iout,*) "Iteration ", i
       write(iout,*) "Best Fitness = ", bestFit
       ansVec = bestVec
    end do MCloop
  end subroutine EnergyMCM


! !------------------------------------------------------------------------------
! !EnergyMCMArray
! !------------------------------------------------------------------------------
! !Check to see how this is suppose to effect things.
!   subroutine EnergyMCMArray(nb,maxIterations, StartArray,EngParam,AnsArray)
!     implicit none
    
! !------------------------------------------------------------------------------
! !Input
! !------------------------------------------------------------------------------
!     integer, intent(in) :: nb
!     integer, intent(in) :: maxIterations
!     real(wp), intent(in) :: StartArray(nb,nb)
!     ! real(wp), intent(in) :: phi(nb)
!     ! real(wp), intent(in) :: hmat(nb,nb)
!     type(fit_param), intent(in) :: EngParam

! !------------------------------------------------------------------------------
! !Output
! !------------------------------------------------------------------------------
!     real(wp), intent(out) :: AnsArray(nb,nb)

! !------------------------------------------------------------------------------
! !Internal
! !------------------------------------------------------------------------------
!     integer :: i
!     integer :: j
!     integer :: k
!     integer :: best(nb,nb)
!     integer :: dtVals(8)
!     integer :: seed
!     real(wp) :: bestFit
!     real(wp) :: workFit
!     real(wp) :: random
!     real(wp) :: workArray(nb,nb)
!     real(wp) :: bestArray(nb,nb)

! !------------------------------------------------------------------------------
! !Begin Program
! !------------------------------------------------------------------------------
!     call DATE_AND_TIME(VALUES=dtVals)
!     call RANDOM_SEED(PUT=dtVals(1:8))

!     workArray = StartArray
!     bestArray = StartArray
!     do i=1, maxIterations
!        do j=1, nb
!           do k=1, nb
!              call RANDOM_NUMBER(random)
!              if (random .le. 0.50e0_wp) then
!                 workArray(j,k) = -(workArray(j,k))
!              else
!                 workArray(j,k) = workArray(j,k)
!              end if
!           end do
!        end do
!        call calc_hexp(nb,bestArray,EngParam,bestFit)
!        call calc_hexp(nb,workArray,EngParam,workFit)
!        if (workFit .lt. bestFit) then
!           bestArray = workArray 
!        else
!           write(iout,*) "Minimia found at iteration", i
!           write(iout,*) "Fitness = ", bestFit
!           ansArray = bestArray
!           EXIT
!        end if
!        write(iout,*) "Iteration ", i
!        write(iout,*) "Best Fitness = ", bestFit
!        ansArray = bestArray
!     end do
!   end subroutine EnergyMCM

  subroutine MCMAlp(MCMP,initalPt,eng,ansPt)
!------------------------------------------------------------------------------
!MCMAlp
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
    type(MCMParam), intent(in) :: MCMP
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
    integer :: j
    integer :: num
    real(wp) :: rand
    real(wp) :: scaledRand
    real(wp) :: ratio
    type(searchPt) :: point
    type(searchPt) :: newPt
    
!------------------------------------------------------------------------------
!Begin Code
!------------------------------------------------------------------------------
    !Initalialize the random number generate with MCMP%seed
    open(unit=ifp,file=MCMP%outputFileName,action='write')
    call searchPt_copy(initalPt, point)
    call ssearchPt_getNum(initalPt,num)
    call searchPt_calcEngAlp(point,bestEng)

    do i = 1, MCMP%maxIterations
       call searchPt_copy(point,workingPt)
       !Generate new point
       do j = 1, num
          !Generate a random number rand on the interval.
          call random_number(rand)
          scaledRand = ((MCMP%upRandLim-MCMP%lowRandLim)*rand) + MCMP%lowRandLim 
          call search_add2Elem(j,scaledRand,workingPt,newPt)
          if (j == num) exit
          call searchPt_copy(newPt,workingPt)
       end do
       call searchPt_calcEngAlp(newPt,eng2)
       ratio = (eng2/eng1)
       call random_number(rand)
       if (ratio >= rand) then
          call searchPt_copy(newPt, point)
       end if
       call searchPt_calcEngAlp(point,eng1)
       call searchPt_SDSConvTest(MCMP%funcTol,MCMP%distTol, point, newPt)
       write(iout,*) "Iteration # ", i, "Energy ", eng1,  " Converged: ", conv
       write(ifp,*)  "Iteration # ", i, "Energy ", eng1,  " Converged: ", conv
       if (conv) exit
!Still needs work. Not sure about some things. Also check the MCM that I implied in 
!DensConstVext. Ari seem to like that one.
    end do
    
    call searchPt_copy(newPt,ansPt)
!------------------------------------------------------------------------------
!End Code
!------------------------------------------------------------------------------
  end subroutine MCMAlp



  subroutine MCMAlp_fileReader(ifp,file_input,initalPt,MCMP)
!------------------------------------------------------------------------------
!MCMAlp_filereader
!------------------------------------------------------------------------------
!This procedure will read a correctly formatted input file (for example
!see ./MCMAlp.inp 
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
    type(MCMParam), intent(out) :: MCMP

!------------------------------------------------------------------------------
!Interals
!------------------------------------------------------------------------------
    character :: outputFileName
    integer :: i
    integer :: ierror
    integer :: num
    integer :: maxIterations
    integer :: iParamVary               !How many parameters are varied. 
    real(wp) :: lowRandLim              !Lower limit for random number generation
    real(wp) :: upRandLim               !Upper limit for random number generation
    real(wp) :: funcTol                 !Tolerance for func difference
    real(wp) :: distTol                 !Tolerenace for point difference
    integer :: i
    integer :: ierror
    integer :: num
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
    read(ifp,*) !Inital Point
    read(ifp,*) point
    read(ifp,*) !maxIterations
    read(ifp,*) maxIterations
    read(ifp,*) !Seed
    read(ifp,*) seed
    read(ifp,*) !lowRandLim
    read(ifp,*) lowRandLim
    read(ifp,*) !UpRandLim
    read(ifp,*) upRandLim
    read(ifp,*) !funcTol
    read(ifp,*) funcTol
    read(ifp,*) !distTol
    read(ifp,*) distTol

    call searchPt_init(num,point, initalPt)
    call MCMParam_init(outputFileName,maxIterations,seed,lowRandLim,&
                           upRandLim, funcTol, distTol, MCMP)

!------------------------------------------------------------------------------
!End Subroutines
!------------------------------------------------------------------------------
end module mod_MCM


