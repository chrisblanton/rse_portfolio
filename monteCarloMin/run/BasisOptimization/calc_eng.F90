!************************************************!
SUBROUTINE calc_eng(nvar,var,eng)
!************************************************!
implicit none
integer,parameter :: wp = 8
integer,intent(in) :: nvar
real(wp),intent(in)  :: var(nvar)
real(wp),intent(out) :: eng

integer,parameter :: ng=1
integer,parameter :: na=1
integer,parameter :: iout=675

integer :: ista
integer :: iend
real(wp) :: bmat(ng)
real(wp) :: gmat(ng)
real(wp) :: amat(na)

real(wp) :: diff,tmp
logical :: Lcalc

integer :: i,j
!================================================================================
   eng = 999.9990e0_wp + sum( abs(var(:)) )
   Lcalc = .TRUE.

   do i=1,nvar
!     if(var(i) .le. 0.0e0_wp) Lcalc = .FALSE.
   end do
!--------------------------------------------------------------------------------
   ista = 1
   iend = 0

!  iend = ista+na-1  
!  amat(1:na) = var(ista:iend)

   ista = iend+1
   iend = ista+ng-1  
   bmat(1:ng) = var(ista:iend)

   ista = iend+1
   iend = ista+ng-1  
   gmat(1:ng) = var(ista:iend)
!--------------------------------------------------------------------------------
   call calc_diff(na,amat,diff)
   if( diff .le. 1.0e-5_wp ) Lcalc = .FALSE.
   call calc_diff(ng,bmat,diff)
   if( diff .le. 1.0e-5_wp ) Lcalc = .FALSE.
   call calc_diff(ng,gmat,diff)
   if( diff .le. 1.0e-5_wp ) Lcalc = .FALSE.
!--------------------------------------------------------------------------------
   if(Lcalc) then
      open(unit=iout,file="replace.sed",action='write')
      !write(iout,*) "s/XXX_1/",amat(1),"/g"
      !write(iout,*) "s/XXX_2/",amat(2),"/g"
      !write(iout,*) "s/XXX_3/",amat(3),"/g"
      write(iout,*) "s/XXX_1/",bmat(1),"/g"
      write(iout,*) "s/XXX_2/",gmat(1),"/g"
      close(iout)
      call get_eng(eng) 
   end if
   if( eng .le. 1.0e-3_wp ) eng = 999.9990e0_wp


END SUBROUTINE calc_eng



!************************************************!
SUBROUTINE get_eng(eng)
!************************************************!
implicit none
integer,parameter :: wp = 8
real(wp),intent(out) :: eng
integer,parameter :: IFP4=40

   eng = 999.999
   call system("sed -f replace.sed ebasis.tplate > ebasis.inp")
   call system("sed -f replace.sed pbasis.tplate > pbasis.inp")
   call system("sed -f replace.sed fort.tplate > fort.50")
   call system("./xcneo_1.0.exe >& 1.ans") 
   call system('grep SCF_ 1.ans > finaleng.fmt')
   open(unit=IFP4,file='finaleng.fmt',action='read',status='old')
      call read_eng(IFP4,eng)
   close(IFP4)


END SUBROUTINE get_eng
!******************************************!
SUBROUTINE read_eng(INP,eng)
!******************************************!
implicit none
integer,intent(in) :: INP
double precision,intent(out) :: eng


character(100) :: buff
integer :: is_conv
double precision :: totOvlap,totEng

   read(INP,*) buff,is_conv
   read(INP,*) buff,totOvlap
   read(INP,*) buff,totEng
   if(is_conv==1) then
      eng = totEng
   else
      eng = 1.0d6
   end if

END SUBROUTINE read_eng

SUBROUTINE calc_diff(n,a,diff)
implicit none
integer,parameter :: wp = 8
integer,intent(in) :: n
real(wp),intent(in) :: a(n)
real(wp),intent(out) :: diff

integer :: i,j
real(wp) :: tmp

   diff = 999.9990e0_wp
   do j=1,n
   do i=1,j-1
      tmp = abs( a(i)-a(j) ) 
      diff = min(diff,tmp)
   end do
   end do


END SUBROUTINE calc_diff

