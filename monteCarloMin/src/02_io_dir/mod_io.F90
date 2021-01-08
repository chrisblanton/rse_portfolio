MODULE mod_io
use mod_param,only: wp
use mod_file,only:  get_funit,free_funit
implicit none
private
public :: io_eng_fmt
public :: io_phi_fmt
public :: io_write_upper_pack
public :: io_read_upper_pack
public :: io_write_mat
public :: io_read_mat

interface io_write_mat
  module procedure m_write_mat_1D
  module procedure m_write_mat_2D
end interface io_write_mat

interface io_read_mat
  module procedure m_read_mat_1D
  module procedure m_read_mat_2D
end interface io_read_mat


CONTAINS
!! write formatted energy
!****************************************************!
SUBROUTINE io_eng_fmt(nb,root,infile)
!****************************************************!
implicit none
integer,intent(in) :: nb
real(wp),intent(in) :: root(nb)
character*(*),intent(in) :: infile

integer :: ifp
integer :: i

  call get_funit(ifp)
  open(unit=ifp,file=trim(adjustL(infile)),action='write')
  write(ifp,*) "NBASIS"
  write(ifp,*) nb
  do i=1,nb
    write(ifp,*) i,root(i)
  end do
  call flush(ifp)
  close(ifp)
  call free_funit
  
END SUBROUTINE io_eng_fmt

!! write formatted eigen vector
!****************************************************!
SUBROUTINE io_phi_fmt(nb,vec,infile)
!****************************************************!
implicit none
integer,intent(in) :: nb
real(wp),intent(in) :: vec(nb)
character*(*),intent(in) :: infile

integer :: ifp
integer :: i

  call get_funit(ifp)
  open(unit=ifp,file=trim(adjustL(infile)),action='write')
  write(ifp,*) "NBASIS"
  write(ifp,*) nb
  do i=1,nb
    write(ifp,*) i,vec(i)
  end do
  call flush(ifp)
  close(ifp)
  call free_funit


END SUBROUTINE io_phi_fmt


!! write unformatted upper-packed matrices
!****************************************************!
SUBROUTINE io_write_upper_pack(nb,infile,smat)
!****************************************************!
implicit none
integer,intent(in) :: nb
character*(*),intent(in) :: infile
real(wp),intent(in) :: smat(nb*(nb+1)/2)

integer :: ifp

  call get_funit(ifp)
  open(unit=ifp,file=trim(adjustL(infile)),action='write',form='unformatted')
  write(ifp) nb
  write(ifp) smat
  call flush(ifp)
  close(ifp)
  call free_funit

END SUBROUTINE io_write_upper_pack

!! read unformated upper-packed matrices
!****************************************************!
SUBROUTINE io_read_upper_pack(nb,infile,smat)
!****************************************************!
implicit none
integer,intent(in) :: nb
character*(*),intent(in) :: infile
real(wp),intent(out) :: smat(nb*(nb+1)/2)

integer :: ifp
integer :: junk
character(100),parameter :: buff = "subroutine name: io_read_upper_pack"
integer,parameter :: iout = 6

  call get_funit(ifp)
  open(unit=ifp,file=trim(adjustL(infile)),action='read',form='unformatted')
  read(ifp) junk
  read(ifp) smat
  if( junk /= nb) then
    call error_header(iout)
    write(iout,*) "basis size in file and code are different!"
    write(iout,*) "nb in code: ",nb
    write(iout,*) "nb in file: ",junk
    write(iout,*) "file name : ",trim(adjustL(infile))
    call error_stop(iout,buff)
  end if
  call flush(ifp)
  close(ifp)
  call free_funit

END SUBROUTINE io_read_upper_pack

!! write unformatted 1D matrices
!****************************************************!
SUBROUTINE m_write_mat_1D(nb,infile,vec)
!****************************************************!
implicit none
integer,intent(in) :: nb
character*(*),intent(in) :: infile
real(wp),intent(in) :: vec(nb)

integer :: ifp

  call get_funit(ifp)
  open(unit=ifp,file=trim(adjustL(infile)),action='write',form='unformatted')
  write(ifp) nb
  write(ifp) vec
  call flush(ifp)
  close(ifp)
  call free_funit

END SUBROUTINE m_write_mat_1D

!! read unformatted 1D matrices
!****************************************************!
SUBROUTINE m_read_mat_1D(nb,infile,vec)
!****************************************************!
implicit none
integer,intent(in) :: nb
character*(*),intent(in) :: infile
real(wp),intent(out) :: vec(nb)

integer,parameter :: iout = 6
integer :: ifp
integer :: junk
character(100),parameter :: buff = "subroutine name: io_read_mat_1D"

  call get_funit(ifp)
  open(unit=ifp,file=trim(adjustL(infile)),action='read',form='unformatted')
  read(ifp) junk
  if( junk /= nb) then
    call error_header(iout)
    write(iout,*) "basis size in file and code are different!"
    write(iout,*) "nb in code: ",nb
    write(iout,*) "nb in file: ",junk
    write(iout,*) "file name : ",trim(adjustL(infile))
    call error_stop(iout,buff)
  end if
  read(ifp) vec
  call flush(ifp)
  close(ifp)
  call free_funit

END SUBROUTINE m_read_mat_1D


!! write unformatted 2D matrices
!****************************************************!
SUBROUTINE m_write_mat_2D(nb1,nb2,infile,vec)
!****************************************************!
implicit none
integer,intent(in) :: nb1
integer,intent(in) :: nb2
character*(*),intent(in) :: infile
real(wp),intent(in) :: vec(nb1,nb2)

integer :: ifp

  call get_funit(ifp)
  open(unit=ifp,file=trim(adjustL(infile)),action='write',form='unformatted')
  write(ifp) nb1,nb2
  write(ifp) vec
  call flush(ifp)
  close(ifp)
  call free_funit

END SUBROUTINE m_write_mat_2D

!! read unformatted 2D matrices
!****************************************************!
SUBROUTINE m_read_mat_2D(nb1,nb2,infile,vec)
!****************************************************!
implicit none
integer,intent(in) :: nb1
integer,intent(in) :: nb2
character*(*),intent(in) :: infile
real(wp),intent(out) :: vec(nb1,nb2)

integer,parameter :: iout = 6
integer :: ifp
integer :: j1,j2
character(100),parameter :: buff = "subroutine name: io_read_mat_2D"

  call get_funit(ifp)
  open(unit=ifp,file=trim(adjustL(infile)),action='read',form='unformatted')
  read(ifp) j1,j2
  if( (j1 /= nb1) .or. (j2 /= nb2) ) then
    call error_header(iout)
    write(iout,*) "basis size in file and code are different!"
    write(iout,*) "nb1 and nb2 in code: ",nb1,nb2
    write(iout,*) "nb1 and nb2 in file: ",j1,j2
    write(iout,*) "file name : ",trim(adjustL(infile))
    call error_stop(iout,buff)
  end if
  read(ifp) vec
  call flush(ifp)
  close(ifp)
  call free_funit

END SUBROUTINE m_read_mat_2D





END MODULE mod_io


















