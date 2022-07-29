RS EQU P2.5
RW EQU P2.6
EN EQU P2.7

;setting up LCD display
org 00h
mov A,#38H ;8bit mode,2 line, font 5*8 dots
call lcd_cmd
mov A,#0EH ; cursor on
call lcd_cmd
mov A,#01H ; clear screen
call lcd_cmd
mov A,#06H ;right shift
call lcd_cmd
mov A,#80H ;line 1 position 1
call lcd_cmd



main : mov dptr,#string
;to display string and move to next once done
loop : clr A
		movc A,@A+dptr
		jz next
		call lcd_data
		inc dptr
		sjmp loop

;to display string
loopdone : clr A
		movc A,@A+dptr
		jz $
		call lcd_data
		inc dptr
		sjmp loopdone

next : ;checks if first digit entered is 3
clr P0.3
jnb P0.4,next1
jnb P0.5,bad
jnb P0.6,bad
setb P0.3
clr P0.2
jnb P0.4,bad
jnb P0.5,bad
jnb P0.6,bad
setb P0.2
clr P0.1
jnb P0.4,bad
jnb P0.5,bad
jnb P0.6,bad
setb P0.1
clr P0.0
jnb P0.4,bad
jnb P0.5,bad
jnb P0.6,bad
setb P0.0
sjmp next

next1: ;checks if second digit entered is 5
setb P0.3
clr P0.3
;jnb P0.4,bad
jnb P0.5,bad
jnb P0.6,bad
setb P0.3
clr P0.2
jnb P0.4,bad
jnb P0.5,next2
jnb P0.6,bad
setb P0.2
clr P0.1
jnb P0.4,bad
jnb P0.5,bad
jnb P0.6,bad
setb P0.1
clr P0.0
jnb P0.4,bad
jnb P0.5,bad
jnb P0.6,bad
setb P0.0
sjmp next1

;bad moves cursor to incorrect label
bad :mov A,#01H
call lcd_cmd
mov A,#06H
call lcd_cmd
mov A,#80H
call lcd_cmd
mov dptr,#incorrect
jmp loopdone

next2: ;checks if third digit entered is 7
setb P0.2
clr P0.3
jnb P0.5,bad
jnb P0.6,bad
setb P0.3
clr P0.2
jnb P0.4,bad
jnb P0.6,bad
setb P0.2
clr P0.1
jnb P0.4,bad
jnb P0.5,bad
jnb P0.6,next3
setb P0.1
clr P0.0
jnb P0.4,bad
jnb P0.5,bad
jnb P0.6,bad
setb P0.0
sjmp next2

next3: ;checks if fourth digit entered is 6
setb P0.1
clr P0.3
jnb P0.5,bad
jnb P0.6,bad
setb P0.3
clr P0.2
jnb P0.4,next4
jnb P0.6,bad
setb P0.2
clr P0.1
jnb P0.4,bad
jnb P0.5,bad
setb P0.1
clr P0.0
jnb P0.4,bad
jnb P0.5,bad
jnb P0.6,bad
setb P0.0
sjmp next3

next4:
setb P0.2
sjmp gud

;gud moves cursor to correct label
gud :clr P3.1
mov A,#01H
call lcd_cmd
mov A,#06H
call lcd_cmd
mov A,#80H
call lcd_cmd
mov dptr,#correct
jmp loopdone

;to give command to LCD
lcd_cmd:
mov p1,A
clr RS
clr RW
setb EN
acall delay
clr EN
ret

;to give data to LCD
lcd_data:
mov p1,A
setb RS
clr RW
setb EN
acall delay
clr EN
ret

;loop to generate delay
delay : mov R0,#0FFh
		djnz R0,$
		ret

;data stored in memory
string : DB 'I','n','p','u','t',' ','P','a','s','s','w','o','r','d',0
correct : DB 'C','o','r','r','e','c','t',0
incorrect : DB 'I','n','c','o','r','r','e','c','t',0
