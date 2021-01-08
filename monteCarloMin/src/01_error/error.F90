SUBROUTINE error_header(iout)
implicit none
integer,intent(in) :: iout
    write(iout,*) '**************************************'
    write(iout,*) 'ERROR * ERROR * ERROR * ERROR * ERROR '
    write(iout,*) '**************************************'
END SUBROUTINE error_header

SUBROUTINE error_stop(iout,txt)
implicit none
integer,intent(in) :: iout
character(100) :: txt
  write(iout,*) trim(adjustL(txt))
  STOP "***ERROR TERMINATION***"
END SUBROUTINE error_stop
