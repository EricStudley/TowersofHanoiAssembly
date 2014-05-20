TITLE Towers of Hanoi						(TowersOfHanoi.asm)

INCLUDE Irvine32.inc

.data
tower1 db "ooooooooooooo                                                       ",0Dh,0Ah,0
tower2 db "8'   888   `8                                                       ",0Dh,0Ah,0
tower3 db "     888       .ooooo.  oooo oooo    ooo  .ooooo.  oooo d8b  .oooo.o",0Dh,0Ah,0
tower4 db "     888      d88' `88b  `88. `88.  .8'  d88' `88b `888''8P d88(  '8",0Dh,0Ah,0
tower5 db "     888      888   888   `88..]88..8'   888ooo888  888     `'Y88b. ",0Dh,0Ah,0
tower6 db "     888      888   888    `888'`888'    888    .o  888     o.  )88b",0Dh,0Ah,0
tower7 db "    o888o     `Y8bod8P'     `8'  `8'     `Y8bod8P' d888b    8''888P'",0Dh,0Ah,0

of1 db "           .o88o.",0Dh,0Ah,0
of2 db "           888 `'",0Dh,0Ah,0
of3 db " .ooooo.  o888oo ",0Dh,0Ah,0
of4 db "d88' `88b  888   ",0Dh,0Ah,0
of5 db "888   888  888   ",0Dh,0Ah,0
of6 db "888   888  888   ",0Dh,0Ah,0
of7 db "`Y8bod8P' o888o  ",0Dh,0Ah,0

hanoi1 db "ooooo   ooooo                                  o8o ",0Dh,0Ah,0
hanoi2 db "`888'   `888'                                  `'' ",0Dh,0Ah,0
hanoi3 db " 888     888   .oooo.   ooo. .oo.    .ooooo.  oooo ",0Dh,0Ah,0
hanoi4 db " 888ooooo888  `P  )88b  `888P'Y88b  d88' `88b `888 ",0Dh,0Ah,0
hanoi5 db " 888     888   .oP'888   888   888  888   888  888 ",0Dh,0Ah,0
hanoi6 db " 888     888  d8(  888   888   888  888   888  888 ",0Dh,0Ah,0
hanoi7 db "o888o   o888o `Y888''8o o888o o888o `Y8bod8P' o888o",0Dh,0Ah,0

pillars1 db "|1|",0
pillars2 db "|2|",0
pillars3 db "|3|",0
pillarBottom db "           ==============================================================================",0Dh,0Ah,0



PressEnter	       db "Press enter to begin, or press I to see the instructions!",0Dh,0Ah,0
PEnter2				db "Press enter to go back to the title screen.",0dh,0ah,0
startingDiskMsg     db "How many disks would you like to start with? (2-8):",0Dh,0Ah,0
removeFromTowerMsg db "Which tower would you like to take a disk from?",0Dh,0Ah,0
addToTowerMsg      db "Which tower would you like to add a disk to?",0Dh,0Ah,0
invalidMove        db "What are you doing!? You can't do that! Try again.",0Dh,0Ah,0
PerfectScore	   db "You got a perfect score! in ",0
GreatScore		   db "You got a great score! in ",0
OkScore			   db "You got an ok score in ",0
BadScore		   db "You need more practice, it took you ",0
numberOfMovesMsg  db " moves.",0Dh,0Ah,0

;=======================INSTRUCTION TEXT===========================================;
intro db "INTRODUCTION:",0dh,0ah
	 db " ",0dh,0ah
	 db "		   Towers of Hanoi is a puzzle game consisting of three towers",0dh,0ah
	 db "		    and a variable number of discs. The object of the game is  ",0dh,0ah
	 db "		    to get all the discs from the left most tower to the right ",0dh,0ah
	 db "			     most tower, following a few simple rules.           ",0dh,0ah,0
rulez db "RULES:",0dh,0ah
	 db " ",0dh,0ah
	 db "			   1. The disc you are moving cannot be placed ",0dh,0ah
	 db "				    on a disc of a smaller size.           ",0dh,0ah
	 db " ",0dh,0ah
	 db "			   2. You cannot remove discs from empty towers.",0dh,0ah
	 db "				There are no discs there to remove.			",0dh,0ah
	 db " ",0dh,0ah
	 db "			   3. You win the game when all discs have been ",0dh,0ah
	 db	"			        successfully moved from the left most  ",0dh,0ah
	 db	"				   tower to the right most tower.		     ",0dh,0ah,0
gplay db "GAMEPLAY:",0dh,0ah
	 db " ",0dh,0ah
	 db "          - From the start screen, press enter. You will be prompted to enter a number 2-8.",0dh,0ah
	 db "                       This is the number of discs with which you will play.                     ",0dh,0ah
	 db	"                           Remember, 8 discs requires 255 moves minimum!                         ",0dh,0ah
	 db "          - After selecting the number of discs, you will be presented with the game board.",0dh,0ah
	 db "                   There will be 3 towers with your discs on the left tower.",0dh,0ah
	 db "               - You will then be prompted to chose a tower to remove a disc from.",0dh,0ah
	 db "                   Remember you can only select from towers that are not empty.",0dh,0ah
	 db "       - Next, you will be prompted to select a tower to move the disc to. Any tower is legal,",0dh,0ah
	 db "                       however you cannot put a larger disc on a smaller one.",0dh,0ah
	 db "             - When all discs have been moved to the right tower, you have won!",0dh,0ah
	 db "                               Stay put for a special surprise!",0dh,0ah,0

pillar1 db 15 dup(0)
pillar2 db 15 dup(0)
pillar3 db 15 dup(0)
startingDisks db ?
minimumDisks db ?
placeholder db 0
gameWon db 0
currentPillar db 0
moves dd 0
wrongmovetrue db 0
placement db 0


.code
main PROC						;========================================MAIN PROC========================================
RESTART:
mov eax, 0
call welcomescreen
call createGame

continueGame:
	call borders
	call moveBlocks
	call drawPillars
	call checkWin
	cmp gameWon,1
jne continueGame
call resetGame
call gameWinMessage
mov moves, 0
mov gamewon, 0
JMP RESTART
exit
main ENDP						;======================================END MAIN PROC======================================

resetGame PROC               ;======================================RESET PILLARS======================================

movzx ecx, startingDisks
mov esi, 0

settozero:
mov pillar3[esi], 0
inc esi
loop settozero


ret
resetGame ENDP               ;======================================END RESET PILLARS==================================

welcomescreen PROC				;=====================================WELCOME SCREEN PROC==================================
start:								; Prints welcome screen.
call clrscr
call drawWelcome
call borders

pressEnterKey:					; Makes the user press Enter to begin game.
	mov dl, 22
	mov dh, 44
	call gotoxy
	mov edx, offset PressEnter
	call writestring
	call readchar
.IF(al == 13) ;enter
	jmp next
.ELSEIF(al == 99) ;lower case c
	jmp randomColor
.ELSEIF(al == 105) ;lower case i
	jmp instructions
.ELSE
	jmp pressEnterKey
.ENDIF

next:
call clrscr
call borders
mov dl, 23
mov dh, 13
call gotoxy
mov edx, offset startingDiskMsg
call writestring
mov dl, 48
mov dh, 15
call gotoxy
call readchar
sub eax, 48
cmp al, 2
jl next
cmp al, 8
jg next
mov startingdisks, al
jmp return

instructions:
call clrscr

mov dl, 43
mov dh, 5
call gotoxy
mov edx, offset intro
call writestring
call crlf

mov dl, 46
mov dh, 15
call gotoxy
mov edx, offset rulez
call writestring
call crlf

mov dl, 45
mov dh, 30
call gotoxy
mov edx, offset gplay
call writestring
call crlf

call borders
jmp p2

randomColor:
jmp start

p2:
mov dl, 28
mov dh, 46
call gotoxy
mov edx, offset PEnter2
call writestring
call readchar
cmp al, 13
jne p2
je start

return:
ret
welcomescreen ENDP				;===================================END WELCOME SCREEN PROC================================


createGame PROC					;=====================================CREATEGAME PROC=====================================

mov esi, 0
movzx ecx, startingDisks		; Loops startingDisks amount of times.
fillPillar1:	
	mov pillar1[esi], cl		; Moves disks to pillar1, largest to smallest.
	inc esi
loop fillPillar1

call writeint

call drawPillars
ret
createGame ENDP					;===================================END CREATE GAME PROC==================================

drawPillars PROC uses ebx		;===================================DRAW PILLARS PROC=====================================
call clrscr
mov esi, 14
mov ebx, 0
mov ecx, 15

call crlf
call crlf
call crlf
PillarsLoop:
mov placeholder, cl
call checkDisk
dec esi
mov cl, placeholder
loop PillarsLoop

mov edx, offset pillarbottom
call writestring

ret 
drawPillars ENDP				;====================================END DRAW PILLARS PROC===============================

gameWinMessage PROC					;====================================GAME WON PROC=======================================

mov eax, 400
call delay
call clrscr
call borders

mov ecx, 10

endPlay:

	call borders
	mov dl, 25
	mov dh, 12
	call gotoxy
	call playGrade

	mov eax, 72
	call randomrange
	add al, 4
	mov dl, al

	mov eax, 15
	call randomrange
	add al, 5
	mov dh, al

	COLORISBLACK:
	mov eax, 16
	call randomrange
	cmp eax, BLACK
	JZ COLORISBLACK
	call settextcolor
	
	call gotoXY
	call firework

	mov eax, 5
	call delay
loop endPlay

CheckContinue:
	call borders
	mov dl, 30
	mov dh, 25
	call gotoxy
	mov edx, offset PEnter2
	call writestring
	call readchar
	cmp al, 13
	JNE CheckContinue


ret
gameWinMessage ENDP					;====================================END GAME WON PROC===================================

playGrade PROC uses ecx	    		;=======================================PLAY GRADE==========================================

	;Finds the possible minimum number of moves to win
	Minimum:
	mov eax, 1
	mov cl, startingDisks
	SHL eax, cl
	sub eax, 1
	mov minimumDisks, al

	cmp moves, eax
	JNE GREAT
	mov dl, 33
	mov dh, 25
	call gotoxy
	mov edx, offset PerfectScore
	call writestring
	JMP endMsg
	
	GREAT:
	mov ebx, eax
	SHL eax, 1
	SHR ebx, 1
	sub eax, ebx
	cmp moves, eax
	JG OK
	mov dl, 33
	mov dh, 25
	call gotoxy
	mov edx, offset GreatScore
	call writestring
	JMP endMsg

	OK:
	add eax, ebx
	cmp moves, eax
	JG BAD
	mov dl, 33
	mov dh, 25
	call gotoxy
	mov edx, offset OkScore
	call writestring
	JMP endMsg

	BAD:
	mov dl, 28
	mov dh, 25
	call gotoxy
	mov edx, offset BadScore
	call writestring

	endMsg:

	mov eax, moves
	call writedec
	mov edx, offset numberOfMovesMsg
	call writestring

ret
playGrade ENDP
checkDisk PROC					;====================================CHECK DISK PROC=====================================
mov ecx, 8
mov currentPillar, 1
cmp pillar1[esi], 0
JNE DiskCheck1
mov ecx, 0
call getSpaceVal
mov ecx, ebx
mov eax, 32
loopSpace1:
call writechar
loop loopSpace1
mov edx, offset pillars1
call writestring
JMP Begin2

DiskCheck1:
cmp pillar1[esi], cl			;checks pillar1 for disks
JNE notEqual
mov edx, ecx
call printDisk
JMP Begin2
notEqual:
loop DiskCheck1

Begin2:
mov ecx, 8
mov currentPillar, 2
cmp pillar2[esi], 0
JNE DiskCheck2
mov ecx, 0
call getSpaceVal
mov ecx, ebx
mov eax, 32
loopSpace2:
call writechar
loop loopSpace2
mov edx, offset pillars2
call writestring
JMP Begin3

DiskCheck2:
cmp pillar2[esi], cl			;checks pillar2 for disks
JNE notEqual2
mov edx, ecx
call printDisk
JMP Begin3
notEqual2:
loop DiskCheck2

Begin3:
mov ecx, 8
mov currentPillar, 3
cmp pillar3[esi], 0
JNE DiskCheck3
mov ecx, 0
call getSpaceVal
mov ecx, ebx
mov eax, 32
loopSpace3:
call writechar
loop loopSpace3
mov edx, offset pillars3
call writestring
JMP endOfProc

DiskCheck3:
cmp pillar3[esi], cl			;checks pillar3 for disks
JNE notEqual3
mov edx, ecx
call printDisk
JMP endOfProc
notEqual3:
loop DiskCheck3
endOfProc:

call crlf

ret
checkDisk ENDP					;====================================END CHECK DISK PROC=================================

getSpaceVal PROC uses edx		;====================================GET SPACE VAL PROC==================================

mov ebx, 23
sub ebx, ecx

cmp currentPillar, 1
JE endOfSpace

cmp currentPillar, 2
JE pillar2Space

cmp currentPillar, 3
JE pillar3Space

pillar2Space:
mov edx, 0
mov dl, pillar1[esi]
sub ebx, edx
JMP endOfSpace

pillar3Space:
mov edx, 0
mov dl, pillar2[esi]
sub ebx, edx
JMP endOfSpace

endOfSpace:
ret
getSpaceVal ENDP				;====================================END GET SPACE VAL PROC==============================

printDisk PROC					;====================================PRINT DISK PROC=====================================

call getSpaceVal

mov ecx, ebx
mov eax, 32
writeSpaces:
call writechar
loop writeSpaces

mov ecx, edx
mov eax, 64

createDiskL:
call writechar
loop createDiskL

mov eax, 91
call writechar

mov eax, edx
call writedec

mov eax, 93
call writechar
 
mov ecx, edx
mov eax, 64
createDiskR:
call writechar
loop createDiskR

ret
printDisk ENDP					;====================================END PRINT DISK PROC=================================

moveBlocks PROC					;====================================MOVE BLOCKS PROC==================================
mov esi, 0
mov edi, 0

removeFromTower:
call crlf
mov dl, 28
mov dh, 24 
call gotoxy
mov edx, offset removeFromTowerMsg
call writestring
mov dl, 50
mov dh, 27 
call gotoxy
call readchar
call writechar
cmp al,49						; If char input for which to remove from is "1"
mov esi, offset pillar1
je addToTower					; Jump to addToTower
cmp al,50						; If char input for which to remove from is "2"
mov esi, offset pillar2
je addToTower					; Jump to addToTower
cmp al,51						; If char input for which to remove from is NOT "3"
mov esi, offset pillar3
jne removeFromTower				; Jump to removeFromTower

mov al, [esi]
sub al, 0
jz removeFromTower

addToTower:
call crlf
mov dl, 28
mov dh, 29
call gotoxy					
mov edx, offset addToTowerMsg
call writestring
mov dl, 50
mov dh, 31
call gotoxy		
call readchar
call writechar

cmp al,49						; If char input for which to add to is "1":
mov edi, offset pillar1			;	Move the offset of pillar1 to EDI.
je addDone						;	Jump to addDone.
cmp al,50						; If char input for which to add to is "2":
mov edi, offset pillar2			;	Move the offset of pillar2 to EDI.
je addDone						;	Jump to addDone.
cmp al,51						; If char input for which to add to is NOT "3":
mov edi, offset pillar3			;	Move the offset of pillar3 to EDI.
jne addToTower					; Else, Jump back to addToTower.

addDone:
call crlf
movzx ecx, startingDisks
cmp wrongmovetrue, 1
JZ StartAdd

mov eax, 0
movzx ecx, startingDisks
findTopRemove:					; Increment ESI until it's at the highest non-zero block's address in pillar to remove from.
	mov al, [esi]
	sub al, 0
	JZ zeroValRemove			; Leave loop when a zero value at an index is found in the pillar to remove from.
	inc esi
loop findTopRemove

zeroValRemove:
dec esi							; Decrement the zero value to the index of the top block in pillar to remove from.
mov bl, [esi]					; BL has top block of tower to remove from.
mov ecx, 0
mov [esi], ecx					; Clear the top block that was removed (into BL) from pillar to remove from.

StartAdd:
mov al, [edi]					
sub al, 0						; Checks if the pillar chosen to move a block to is empty.
JZ validMove1					; If it is, skip to adding the disc to that empty pillar

movzx ecx, startingDisks

findTopAdd:						; Increment EDI until it's at the highest non-zero block's address in pillar to add to.
	mov al, [edi]
	sub al, 0
	;JZ decrease
	JZ checker				; Leave loop when a zero value at an index is found in pillar to add to.
	inc edi
loop findTopAdd

	
checker:
dec edi
mov eax, [edi]
.IF (al == 0)
	jmp validMove1
.ELSEIF(bl < al)
	jmp validMove
.ELSEIF(bl > al)	
	jmp badMove
.ENDIF

badMove:
	mov dl, 28
	mov dh, 37
	call gotoxy
	mov edx, offset invalidMove
	call writestring
	mov wrongmovetrue, 1
	jmp addToTower

validMove:
mov [edi+ 1], bl					; Moves top of block from pillar to be removed from to top free spot of pillar to be added to.
jmp nxt

validMove1:
mov [edi], bl
jmp nxt

nxt:
mov wrongmovetrue, 0
inc moves

mov eax, 200
call delay
ret
moveBlocks ENDP					;====================================END MOVE BLOCKS PROC==================================

checkWin PROC					;====================================CHECK WIN PROC========================================
mov esi, 0
mov ecx, 8

checkEmpty1:
cmp pillar1[esi], 0
JNE noWin
loop checkEmpty1

mov ecx, 8

checkEmpty2:
cmp pillar2[esi], 0
JNE noWin
loop checkEmpty2

mov gameWon, 1

noWin:

ret
checkWin ENDP					;====================================END CHECK WIN PROC====================================

borders PROC					;=========================================BORDERS PROC=====================================

mov dl, 0
mov dh, 0

mov eax, 219
call writechar

top:
inc dl
call gotoxy
mov eax, 219
call writechar
cmp dl, 100
jne top

mov dh, 0
mov eax, 219
call writechar

sides:
inc dh
call gotoxy
mov eax, 219
call writechar
add dl, 91
mov eax, 219
call writechar
sub dl, 91
cmp dh, 49
jne sides

add dh, 1
mov dl, 0

bottom:
inc dl
call gotoxy
mov eax, 219
call writechar
cmp dl, 100
jne bottom

mov edx, 0
call gotoxy
call writechar
ret
borders ENDP					;========================================END BORDERS PROC==================================

drawWelcome PROC				;====================================DRAW WELCOME PROC=====================================
INVALIDCOLOR2:
mov eax, 16
call randomrange
cmp eax, BLACK
JE INVALIDCOLOR2
call settextcolor

mov dl, 17
mov dh, 7
call gotoxy
mov edx, offset tower1
call writestring

mov dl, 17
mov dh, 8
call gotoxy
mov edx, offset tower2
call writestring


mov dl, 17
mov dh, 9
call gotoxy
mov edx, offset tower3
call writestring

mov dl, 17
mov dh, 10
call gotoxy
mov edx, offset tower4
call writestring

mov dl, 17
mov dh, 11
call gotoxy
mov edx, offset tower5
call writestring

mov dl, 17
mov dh, 12
call gotoxy
mov edx, offset tower6
call writestring

mov dl, 17
mov dh, 13
call gotoxy
mov edx, offset tower7
call writestring

mov dl, 41
mov dh, 20
call gotoxy
mov edx, offset of1
call writestring

mov dl, 41
mov dh, 21
call gotoxy
mov edx, offset of2
call writestring

mov dl, 41
mov dh, 22
call gotoxy
mov edx, offset of3
call writestring

mov dl, 41
mov dh, 23
call gotoxy
mov edx, offset of4
call writestring

mov dl, 41
mov dh, 24
call gotoxy
mov edx, offset of5
call writestring

mov dl, 41
mov dh, 25
call gotoxy
mov edx, offset of6
call writestring

mov dl, 41
mov dh, 26
call gotoxy
mov edx, offset of7
call writestring

mov dl, 25
mov dh, 33
call gotoxy
mov edx, offset hanoi1
call writestring

mov dl, 25
mov dh, 34
call gotoxy
mov edx, offset hanoi2
call writestring

mov dl, 25
mov dh, 35
call gotoxy
mov edx, offset hanoi3
call writestring

mov dl, 25
mov dh, 36
call gotoxy
mov edx, offset hanoi4
call writestring

mov dl, 25
mov dh, 37
call gotoxy
mov edx, offset hanoi5
call writestring

mov dl, 25
mov dh, 38
call gotoxy
mov edx, offset hanoi6
call writestring

mov dl, 25
mov dh, 39
call gotoxy
mov edx, offset hanoi7
call writestring

mov dl, 38
mov dh, 44
call gotoxy

ret
drawWelcome ENDP				;====================================END DRAW WELCOME PROC=================================

diskMoveAni PROC uses ecx		;====================================DISK MOVE ANIMATION PROC==============================

ret
diskMoveAni ENDP				;====================================END DISK MOVE ANIMATION PROC=========================
firework PROC uses ecx			;====================================FIREWORK PROC=======================================

mov ecx, 25
sub cl, dh
mov ebx, edx
mov dh, 25

shot:
mov eax, 200
dec dh
call gotoxy
call writechar
mov eax, 25
call delay
call gotoxy
mov eax, 32
call writechar
loop shot


mov eax, 200

add dl, 1
add dh, 1
call gotoxy
call writechar

sub dl, 2
call gotoxy
call writechar

sub dh, 2
call gotoxy
call writechar

add dl, 2
call gotoxy
call writechar

sub dl, 1
add dh, 1
mov eax, 100
call delay

mov eax, 32
call writechar
mov eax, 200

add dl, 2
add dh, 2
call gotoxy
call writechar

sub dl, 4
call gotoxy
call writechar

sub dh, 4
call gotoxy
call writechar

add dl, 4
call gotoxy
call writechar

sub dl, 2
add dh, 2
mov eax, 100
call delay

mov eax, 32
call writechar

mov eax, 32

add dl, 1
add dh, 1
call gotoxy
call writechar

sub dl, 2
call gotoxy
call writechar

sub dh, 2
call gotoxy
call writechar

add dl, 2
call gotoxy
call writechar

sub dl, 1
add dh, 1

mov eax, 200

add dl, 3
add dh, 3
call gotoxy
call writechar

sub dl, 6
call gotoxy
call writechar

sub dh, 4
call gotoxy
call writechar

add dl, 6
call gotoxy
call writechar

sub dl, 3
add dh, 1
mov eax, 100
call delay

mov eax, 32

add dl, 2
add dh, 2
call gotoxy
call writechar

sub dl, 4
call gotoxy
call writechar

sub dh, 4
call gotoxy
call writechar

add dl, 4
call gotoxy
call writechar

sub dl, 2
add dh, 2

mov eax, 200

add dl, 3
add dh, 4
call gotoxy
call writechar

sub dl, 6
call gotoxy
call writechar

sub dh, 4
call gotoxy
call writechar

add dl, 6
call gotoxy
call writechar

sub dl, 3
mov eax, 100
call delay

mov eax, 32

add dl, 3
add dh, 3
call gotoxy
call writechar

sub dl, 6
call gotoxy
call writechar

sub dh, 4
call gotoxy
call writechar

add dl, 6
call gotoxy
call writechar

sub dl, 3
add dh, 1

mov eax, 100
call delay

mov eax, 32

add dl, 3
add dh, 4
call gotoxy
call writechar

sub dl, 6
call gotoxy
call writechar

sub dh, 4
call gotoxy
call writechar

add dl, 6
call gotoxy
call writechar

add dl, 3

mov eax, 100
call clrscr
call delay

ret
firework ENDP						;====================================END FIREWORK PROC===================================
END main
