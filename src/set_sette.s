#funzione che gestisce il sottomenu del 7

.section .data

#valore attuale delle frecce
frecce_direzionali:
    .long '3'

#nuovo valore delle frecce
new_frecce:
    .long 0

#variabile che memorizza l'andata a capo    
invio: 
    .byte 0

.section .text
    .global set_sette
    .type set_sette, @function

set_sette:

    #stampa valore attuale
    movl $4,%eax
    movl $1,%ebx
    leal frecce_direzionali,%ecx
    movl $1,%edx
    int $0x80

    #lettura nuovo input
    movl $3, %eax
  	movl $0, %ebx
  	leal new_frecce, %ecx
  	movl $1, %edx
  	int $0x80

    #memorizzazione invio
    movl $3, %eax
  	movl $0, %ebx
  	leal invio, %ecx
  	movl $1, %edx
  	int $0x80

    #se l'input ha più di un char esce dal programma
    cmpb $10, invio
    jne exit

    cmpl $'0', new_frecce
    jl return
    cmpl $'9', new_frecce
    jg return
    cmpl $'2',new_frecce
    jle val_2
    cmpl $'3',new_frecce
    je val_3
    cmpl $'4',new_frecce
    je val_4
    cmpl $'5',new_frecce
    jge val_5

return:
    movl frecce_direzionali, %edx
    ret

val_2:
    movl $'2',frecce_direzionali
    jmp set_sette

val_3:
    movl $'3',frecce_direzionali
    jmp set_sette

val_4:
    movl $'4',frecce_direzionali
    jmp set_sette

val_5:
    movl $'5',frecce_direzionali
    jmp set_sette

exit:
    movl $1, %eax
    movl $0, %ebx
    int $0x80
