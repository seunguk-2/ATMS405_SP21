program textext
implicit none
integer :: i,k,ios,ios2,llen
logical :: j
character*150 :: ln,time,headf,ofn
character*200 :: cntf
character*50  :: fns,fn,stid
character(len=:),allocatable :: ltok
real,dimension(21) :: vars
integer,dimension(22) :: ind

fns = 'list.txt'
!fns = '5mblist.txt'
open(11,file=fns,status='old',access='sequential',action='read')

do while(.true.)
read(11,'(A)',iostat=ios2) fn
  if (ios2 /= 0) exit
!fn = './test.txt'
open(1,file=fn,status='old',access='sequential',action='read')

print *, fn

headf = '(A4,A,A5,A,A4,A,A5,A,A2,A,A4,A,A4,A,A3,A,A3,A,A3,A,A4,A,A3,A,A3,A,A3,A,A3,A,A3,A,A2,A,A2,A,A3,A,A2,A,A2,A,A3,A)'
!cntf = '(F6.1,F7.1,F6.1,F6.1,F6.1,F7.1,F7.1,F6.1,F6.1,F6.1,F9.3,F8.3,F6.1,F6.1,F8.1,F5.1,F5.1,F5.1,F5.1,F5.1,F5.1)'
cntf = '(F6.1,A,F7.1,A,F6.1,A,F6.1,A,F6.1,A,F7.1,A,F7.1,A,F6.1,A,F6.1,A,F6.1,A,&
         F9.3,A,F8.3,A,F6.1,A,F6.1,A,F8.1,A,F5.1,A,F5.1,A,F5.1,A,F5.1,A,F5.1,A,F5.1)'
!cntf = '(A6,A7,A6,A6,A6,A7,A7,A6,A6,A6,A9,A8,A6,A6,A8,A5,A5,A5,A5,A5,A5)'
ind = (/1,7,14,20,26,32,39,46,52,58,64,73,81,87,93,101,106,111,116,121,126,131/)

i = 100
do while(.true.)
read(1,'(A)',iostat=ios) ln
  if (ios /= 0) exit

if (ln(19:22) == 'Site') then
   ltok = trim(ln)
   llen = len(ltok)
!   stid = ltok(llen-4:llen)
   stid = 'M1_Co'
!   read(ltok(llen-4:llen),*) stid
   print *, 'Station ID = ',stid
endif
if (ln(1:7) == 'Nominal') then
   write(time,'(A4,A2,A2,A2)') ln(36:39),ln(42:43),ln(46:47),ln(50:51)
   write(ofn,'(A2,A5,A1,A10,A5)') './', stid, '_', time, 'Z.csv'
   print *, ofn
   open(unit=i,file=ofn)
endif

if (ln(1:4) == 'Data') then
   i = i + 1
   inquire(i-1,opened = j)
   if (j) then
       close(i-1)
   endif
endif

if (ln(1:5) == ' Time') then
   write(i,headf) ln(2:5),',',ln(8:12),',',ln(15:18),',',ln(21:25),',',ln(28:29),',',ln(34:37),',',ln(41:44),',',&
              ln(48:50),',',ln(54:56),',',ln(60:63),',',ln(69:71),',',ln(77:79),',',ln(83:85),',',ln(89:91),',', &
          ln(96:98),',',ln(103:104),',',ln(108:109),',',ln(113:115),',',ln(118:119),',',ln(123:124),',',ln(128:130)
endif

inquire(i,opened=j)
if (j) then
   if (ln(1:4) /= ' Tim') then
   if (ln(1:4) /= '  se') then
   if (ln(1:4) /= 'Nomi') then
   if (ln(1:4) /= '----') then
   do k = 1,21
      read(ln(ind(k):(ind(k+1)-1)),*) vars(k)
   enddo
   write(i,cntf) vars(1),',',vars(2),',',vars(3),',',vars(4),',',vars(5),',',vars(6),',',vars(7),',',&
              vars(8),',',vars(9),',',vars(10),',',vars(11),',',vars(12),',',vars(13),',',vars(14),',',&
              vars(15),',',vars(16),',',vars(17),',',vars(18),',',vars(19),',',vars(20),',',vars(21)
   !write(i,cntf) ln(1:6),',',ln(7:13),',',ln(14:19),',',ln(20:25),',',ln(26:31),',',ln(32:38),',',ln(39:45),',',&
   !           ln(46:51),',',ln(52:57),',',ln(58:63),',',ln(64:72),',',ln(73:80),',',ln(81:86),',',ln(87:92),',',&
   !       ln(93:100),',',ln(101:105),',',ln(106:110),',',ln(111:115),',',ln(116:120),',',ln(121:125),',',ln(126:130)
   endif
   endif
   endif
   endif
endif

enddo

close(i)

enddo 
end program

