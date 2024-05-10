#funzione che gestisce l'input delle frecce
#assegno un codice ad ogni freccia (0 = no, 1 = su, 2 = giu, 3 = dx)
#nel main faccio il controllo con questo valore

.section .data

freccia:
    .long 0

.section .text
	.global input
    .type input,@function

input:

    movl $3, %eax
  	movl $0, %ebx
  	leal freccia, %ecx
  	movl $4, %edx
  	int $0x80

    leal freccia, %eax
    cmpb $27, (%eax)
    jne no
    cmpb $91, 1(%eax)
    jne no
    cmpb $'A', 2(%eax)
    je su
    cmpb $'B', 2(%eax)
    je giu
    cmpb $'C', 2(%eax)
    je dx
    
    jmp no

no:
    movl $0, %edx
    ret
su:

    movl $1, %edx
    ret
giu:
    movl $2, %edx
    ret
dx:
    movl $3, %edx
    ret




