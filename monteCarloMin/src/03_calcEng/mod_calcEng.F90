module mod_calcEng
!------------------------------------------------------------------------------
!mod_calcEng
!------------------------------------------------------------------------------
!This module contains the procedures to calculate various energies via different 
!means.
!
!    Date        Programmer        Comments
!    06/09/2011  C. Blanton        Original Code
!
!------------------------------------------------------------------------------
  use mod_param, only: wp,&
                       maxchar
  use mod_fileGen, only: ebasis1_gen,&
                         ebasis3_gen
  private

  public :: calc_engAlpha



contains

  subroutine calc_engAlpha(nalp,calcType,alpha,eng)
!------------------------------------------------------------------------------
!calc_engAlpha
!------------------------------------------------------------------------------
!This procedure will take an array of alphas (alpha(nalp)) and will then 
!will calculate the energy using an external programming
!
!    Date        Programmer        Comments
!    06/09/2011  C. Blanton        Original Code
!
!------------------------------------------------------------------------------
    implicit none

!------------------------------------------------------------------------------
!Parameters
!------------------------------------------------------------------------------
    character(maxchar), parameter :: file_ans = 'ans.2'
    integer, parameter :: ifp=20

!------------------------------------------------------------------------------
!Inputs
!------------------------------------------------------------------------------
    integer, intent(in) :: nalp
    integer, intent(in) :: calcType
    real(wp), intent(in) :: alpha(nalp)

!------------------------------------------------------------------------------
!Outputs
!------------------------------------------------------------------------------
    real(wp), intent(out) :: eng

!------------------------------------------------------------------------------
!Internals
!------------------------------------------------------------------------------
    integer :: iHumRead

!------------------------------------------------------------------------------
!Begin Code
!------------------------------------------------------------------------------
    select case (calcType)
       case (1)
          call ebasis1_gen(nalp,alpha)
       case (3)
          call ebasis3_gen(nalp,alpha)
       case default
          stop "***Invalid Type for energy calculation:mod_calcEng.F90***"
       end select
    call system('./script1.sh')
    open(unit=ifp, file=file_ans, action='read')
    read(ifp,*) !Basis function junk
    read(ifp,*) iHumRead, eng

!------------------------------------------------------------------------------
!End Code
!------------------------------------------------------------------------------
  end subroutine calc_engAlpha

end module mod_calcEng
