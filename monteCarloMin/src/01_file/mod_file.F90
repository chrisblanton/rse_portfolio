!****************************************************!
MODULE mod_file
!****************************************************!
implicit none
private
public :: get_funit
public :: free_funit
public :: file_sys_inp
public :: file_bas_inp
public :: file_eng_out
public :: file_phi0_out
public :: file_hmat
public :: file_smat
public :: file_vec
public :: file_root
public :: file_ke
public :: file_pot12
public :: file_pot_ext


character(100),parameter ::  file_sys_inp  = 'sys.inp'
character(100),parameter ::  file_bas_inp  = 'basis.inp'
character(100),parameter ::  file_eng_out  = "eng.fmt"
character(100),parameter ::  file_phi0_out = "phi0.fmt"
character(100),parameter ::  file_hmat     = "hmat.ufm"
character(100),parameter ::  file_smat     = "smat.ufm"
character(100),parameter ::  file_vec      = "vec.ufm"
character(100),parameter ::  file_root     = "root.ufm"
character(100),parameter ::  file_ke       = "ke.ufm"
character(100),parameter ::  file_pot12    = "pot12.ufm"
character(100),parameter ::  file_pot_ext  = "pot_ext.ufm"

CONTAINS

SUBROUTINE get_funit(ifp)
implicit none
integer,intent(out) :: ifp
  call keep_track(1,ifp)
END SUBROUTINE get_funit

SUBROUTINE free_funit()
implicit none
integer :: junk
  call keep_track(-1,junk)
END SUBROUTINE free_funit

SUBROUTINE keep_track(inc,iu)
implicit none
integer,intent(in) :: inc
integer,intent(out) :: iu
integer,save :: iunit = 9
  iunit = iunit + inc
  iu    = iunit
END SUBROUTINE keep_track

END MODULE mod_file


