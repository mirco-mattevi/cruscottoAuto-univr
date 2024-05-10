#funzione che si occupa di settare lo status di 4 e 5
.section .data

#costanti ON e OFF che serviranno a confrontare (e modificare)
on:
    .ascii "ON "
on_len:
    .long . - on

off:
    .ascii "OFF"
off_len:
    .long . - off

.section .text
    .global ON_OFF
    .type ON_OFF, @function

ON_OFF:
    #guardo qual è lo status e agisco di conseguenza

    cmpl on, %edx
    je ON
    jmp OFF
    
ON:
    #stampa lo status attuale (ON)

    movl $4,%eax
    movl $1,%ebx
    leal on,%ecx
    movl on_len,%edx
    int $0x80

    call input
    cmpl $1, %edx #freccia su
  	je OFF
  	cmp $2, %edx #freccia giù
	je OFF

    movl on, %edx
    ret

OFF:
    #stampa lo status attuale (OFF)

    movl $4,%eax
    movl $1,%ebx
    leal off,%ecx
    movl off_len,%edx
    int $0x80

    call input
    cmpl $1, %edx #freccia su
  	je ON
  	cmpl $2, %edx #freccia giù
	je ON

    movl off, %edx
    ret
