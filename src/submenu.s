#funzione che gestisce i sottomenu non settabili
#dal main viene passato il 'codice' della riga

#resta nel sottomenu solo con la freccia dx

.section .data

riga1:
    .ascii "Setting automobile"
len1:
    .long . - riga1

riga2:
    .ascii "24/02/2024"
len2:
    .long . - riga2
    
riga3:
    .ascii "08:00"
len3:
    .long . - riga3
    
riga6:
    .ascii "Check olio"
len6:
    .long . - riga6
    
riga1s:
    .ascii "Setting automobile (supervisor)"
len1s:
    .long . - riga1s

riga8:
    .ascii "Pressione gomme resettata"
len8:
    .long . - riga8

.section .text
	.global submenu
    .type submenu, @function

submenu:
    cmpl $0, %eax
    je set_uno_s
    cmpl $1, %eax
    je set_uno
    cmpl $2, %eax
    je set_due
    cmpl $3, %eax
    je set_tre
    cmpl $6, %eax
    je set_sei
    cmpl $8, %eax
    je set_otto

set_uno_s:

    movl $4, %eax
    movl $1, %ebx
    leal riga1s, %ecx
    movl len1s, %edx
    int $0x80

    call input
    cmpl $3, %edx
    je set_uno_s

    ret

set_uno:

    movl $4, %eax
    movl $1, %ebx
    leal riga1, %ecx
    movl len1, %edx
    int $0x80

    call input
    cmpl $3, %edx
    je set_uno

    ret

set_due:

    movl $4, %eax
    movl $1, %ebx
    leal riga2, %ecx
    movl len2, %edx
    int $0x80

    call input
    cmpl $3, %edx
    je set_due

    ret

set_tre:

    movl $4, %eax
    movl $1, %ebx
    leal riga3, %ecx
    movl len3, %edx
    int $0x80

    call input
    cmpl $3, %edx
    je set_tre

    ret

set_sei:

    movl $4, %eax
    movl $1, %ebx
    leal riga6, %ecx
    movl len6, %edx
    int $0x80

    call input
    cmpl $3, %edx
    je set_sei

    ret

set_otto:

    #stampa stringa

    movl $4,%eax
    movl $1,%ebx
    leal riga8,%ecx
    movl len8,%edx
    int $0x80

    #ristampa la stringa solo con la freccia a dx
    call input
    cmp $3, %edx #freccia dx
  	je set_otto

	ret

exit:
    movl $1,%eax
    movl $0,%ebx
    int $0x80
