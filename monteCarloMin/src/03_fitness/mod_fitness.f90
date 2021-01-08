module mod_fitness
!------------------------------------------------------------------------------
!fitness
!------------------------------------------------------------------------------
!The module contains subroutines for calculating the fitness for use with
!various Monte Carlo Minimization schemes
!
!    Date        Programmer        Comments
!    04/27/2011  C. Blanton        Original Codes
!    05/03/2011  C. Blanton        Added calc_hexp
!
!
!------------------------------------------------------------------------------
  use mod_param, only:wp,&
                      maxchar
  use mod_file, only: get_funit,&
                      free_funit
  use mod_io, only: io_read_mat

  private

!------------------------------------------------------------------------------
!Public 
!------------------------------------------------------------------------------

  public :: SumFitness
  public :: calc_hexp
  public :: fit_param
  public :: EngParam_reader
  public :: calc_engAlpha

type fit_param
   private
   real(wp), allocatable:: hmat(:,:)
   real(wp), allocatable :: phi0(:)
end type fit_param

contains
!------------------------------------------------------------------------------
!Begin subroutines
!------------------------------------------------------------------------------

  subroutine SumFitness(len,vec,ans)
    implicit none
 
    integer, intent(in) :: len
    real(wp), intent(in) :: vec(len)
    real(wp), intent(out) :: ans

    ans = sum(vec)

  end subroutine SumFitness



  subroutine calc_hexp(nb,vec,EngParam,ans)
!------------------------------------------------------------------------------
!Subroutine that calculates the energy for a given Hamiltonian matrix
!(nb x nb array) and set of phi's (nb array).
!------------------------------------------------------------------------------
    implicit none

!------------------------------------------------------------------------------
!Input
!------------------------------------------------------------------------------
    integer, intent(in) :: nb
    real(wp), intent(in) :: vec(nb)
    ! real(wp), intent(in) :: phi(nb)
    type(fit_param), intent(in) :: EngParam
    !real(wp), intent(in) :: hmat(nb,nb)

!------------------------------------------------------------------------------
!Output
!------------------------------------------------------------------------------
    real(wp), intent(out) :: ans

!------------------------------------------------------------------------------
!Internals
!----------------------------------------------------------------------------

!------------------------------------------------------------------------------
!Begin code
!------------------------------------------------------------------------------
    ans = dot_product((vec*EngParam%phi0),matmul(EngParam%hmat,(vec*EngParam%phi0)))

!------------------------------------------------------------------------------
!End Code
!------------------------------------------------------------------------------
  end subroutine calc_hexp
!------------------------------------------------------------------------------
!End subroutines
!------------------------------------------------------------------------------

  subroutine EngParam_reader(file_trans_phi0,file_trans_hmat,nb, EngParam)
!------------------------------------------------------------------------------
!EngParam_reader
!------------------------------------------------------------------------------
!This subroutine reads in the parameters for EngParm.
!
!    Date        Programmer        Comments
!    05/16/2011  C. Blanton        Original Code
!
!------------------------------------------------------------------------------
    implicit none

!------------------------------------------------------------------------------
!Inputs
!------------------------------------------------------------------------------
    character(maxchar), intent(in) ::  file_trans_phi0
    character(maxchar), intent(in) :: file_trans_hmat


!------------------------------------------------------------------------------
!Output
!------------------------------------------------------------------------------
    integer, intent(out) :: nb
    type(fit_param), intent(out) :: EngParam

!------------------------------------------------------------------------------
!Internals
!------------------------------------------------------------------------------
    integer :: i
    integer :: ifp
    integer :: iHumRead !Dummy variable used for human-readable label. 

!------------------------------------------------------------------------------
!Begin Code
!------------------------------------------------------------------------------
    call get_funit(ifp)
    open(unit=ifp,file=file_trans_phi0,action='read')
    read(ifp,*) !Nbasis label
    read(ifp,*) nb
    if(allocated(EngParam%phi0)) deallocate (EngParam%phi0)
    allocate(EngParam%phi0(nb))
    do i=1, nb
       read(ifp,*) iHumRead, EngParam%phi0(i) 
    end do
    call flush(ifp) 
    close(ifp) 
    call free_funit

!Allocating memory for the hmat and reading it.
    if(allocated(EngParam%hmat)) deallocate(EngParam%hmat)
    allocate(EngParam%hmat(nb,nb))
    call io_read_mat(nb,nb,file_trans_hmat,EngParam%hmat)

!------------------------------------------------------------------------------
!End EngParam_reader
!------------------------------------------------------------------------------
  end subroutine EngParam_reader

!------------------------------------------------------------------------------
!End module
!------------------------------------------------------------------------------
end module mod_fitness


