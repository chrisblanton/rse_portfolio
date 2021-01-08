!Basic pararmeters and constants for programming
!
!
!    Revisions
!        Date        Programmer    Comments
!        10/13/2010  C.Blanton     Original Code
!        06/11/2011  C. Blanton    Correct the real parameters to used wp!!!
!
!


module mod_param
  implicit none

  private
  public :: wp
  public :: inp
  public :: iout
  public :: maxchar
  public :: infile
  public :: ioutfile
  public :: hbar
  public :: pi
  public :: one
  public :: two
  public :: zero

!parameters
!  
  integer, parameter :: wp=8
!Remove these from the mod_param and pass the iout and inp locally as intent-in.
  integer, parameter :: inp=5
  integer, parameter :: iout=6 
  integer, parameter :: maxchar=120
!Move these as need. 
  integer, parameter :: infile=10
  integer, parameter :: ioutfile=11
  real(wp), parameter :: pi=(2.0e0_wp)*ACOS(0.0e0_wp)
  real(wp), parameter :: hbar=1.00e0_wp
  real(wp), parameter :: one=1.00e0_wp
  real(wp), parameter :: zero=0.00e0_wp
  real(wp), parameter :: two=2.00e0_wp
!
!



end module mod_param
