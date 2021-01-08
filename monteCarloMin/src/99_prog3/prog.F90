program SDSAlpSearch
!------------------------------------------------------------------------------
!test
!------------------------------------------------------------------------------
!This program is to test that the ebasis file generator and the energy 
!calculation procedure are working
!
!    Date        Programmer        Comments
!    06/09/2011  C. Blanton        Original Code
!
!------------------------------------------------------------------------------
  use mod_param, only: wp,&
                       maxchar
  use class_searchPt, only: searchPt,&
                            searchPt_init,&
                            searchPt_displayPt,&
                            searchPt_calcEngAlp
  use class_steep, only: SDSParam,&
                         SDSAlp_filereader,&
                         SteepDescentSearchAlp
  implicit none

!------------------------------------------------------------------------------
!Parameters
!------------------------------------------------------------------------------
  integer, parameter :: inp = 5
  integer, parameter :: iout = 6
  integer, parameter :: ifp = 20
  character(maxchar), parameter :: file_input='SDSAlp.inp'
!------------------------------------------------------------------------------
!Inputs
!------------------------------------------------------------------------------


!------------------------------------------------------------------------------
!Outputs
!------------------------------------------------------------------------------
  real(wp) :: eng

!------------------------------------------------------------------------------
!Internals
!------------------------------------------------------------------------------
  integer :: num
  type(searchPt) :: initalPt
  type(SDSParam) :: SDSP
  type(searchPt) :: ansPt
  type(searchPt) :: BestAlphas  

!------------------------------------------------------------------------------
!Begin Code
!------------------------------------------------------------------------------
  call SDSAlp_filereader(ifp,file_input,initalPt,SDSP)
  call SteepDescentSearchAlp(SDSP,initalPt,eng,BestAlphas)
  write(iout,*) "The best alphas are: "
  call searchPt_displayPt(iout,BestAlphas)
  write(iout,*) "Energy = ", eng

!------------------------------------------------------------------------------
!End Code
!------------------------------------------------------------------------------
end program SDSAlpSearch
