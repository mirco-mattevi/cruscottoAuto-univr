.section .data

#strighe delle sezioni 

riga1:
    .ascii "1.Setting automobile:"
len1:
    .long . - riga1

riga2:
    .ascii "2.Data: 24/02/2024"
len2:
    .long . - riga2
    
riga3:
    .ascii "3.Ora: 08:00"
len3:
    .long . - riga3
    
riga4:
    .ascii "4.Blocco automatico porte: "
len4:
    .long . - riga4
    
riga5:
    .ascii "5.Back-home: "
len5:
    .long . - riga5
    
riga6:
    .ascii "6.Check olio"
len6:
    .long . - riga6
    
riga1s:
    .ascii "1.Setting automobile (supervisor):"
len1s:
    .long . - riga1s

riga7:
    .ascii "7.Frecce direzione: "
len7:
    .long . - riga7

riga8:
    .ascii "8.Reset pressione gomme"
len8:
    .long . - riga8

#"booleana" supervisor (inizializzata a 0)
#servirà per verificare se ci si trova in mod supervisor

supervisor:
    .byte 0

#status attuale deli menu 4,5,7

status4:
    .ascii "ON "
status4_len:
    .long . - status4

status5:
    .ascii "ON "
status5_len:
    .long . - status5

frecce_direzionali:
    .long '3' 

#stringa '2244' del parametro a riga di comando
supervisor_parameter:
    .ascii "2244"

.section .text
  .global _start

_start:

#controllo della presenza o meno di '2244' a riga di comando

parameter_control:
    popl %ecx
    popl %ecx
    popl %ecx
    testl %ecx, %ecx
    jz user_mode
    movl (%ecx), %eax
    cmpl %eax, supervisor_parameter
    je supervisor_mode

user_mode:
    movb $0, supervisor
    jmp uno
supervisor_mode:
    movb $1, supervisor
    jmp uno_s

#inizio

uno_s:
    #stampa stringa
    
    movl $4,%eax
    movl $1,%ebx
    leal riga1s,%ecx
    movl len1s,%edx
    int $0x80

    call input
  	cmpl $1, %edx #freccia su
  	je otto
  	cmpl $2, %edx #freccia giù
	je due
    cmpl $3, %edx #freccia dx
    je sub_uno_s
    
    jmp exit

sub_uno_s:

    movl $0,%eax
    call submenu

    jmp uno_s

uno: 
    #stampa stringa
    
    movl $4,%eax
    movl $1,%ebx
    leal riga1,%ecx
    movl len1,%edx
    int $0x80
    
    call input
  	cmpl $1, %edx #freccia su
  	je sei
  	cmpl $2, %edx #freccia giù
	je due
    cmpl $3, %edx #freccia dx
    je sub_uno

  	jmp exit

sub_uno:

    movl $1,%eax
    call submenu

    jmp uno

due:
    #stampa stringa
    
    movl $4,%eax
    movl $1,%ebx
    leal riga2,%ecx
    movl len2,%edx
    int $0x80
    
    call input
  	cmpl $1, %edx #freccia su
  	je due_su
  	cmpl $2, %edx #freccia giù
	je tre
    cmpl $3, %edx #freccia dx
    je sub_due

    jmp exit

#se faccio freccia su dal 2, cambia se sono in supervisor o no

due_su:
    movb supervisor, %al
    testb %al, %al
    jz uno
    jmp uno_s

sub_due:

    movl $2,%eax
    call submenu

    jmp tre
    
tre:
    #stampa stringa
    
    movl $4,%eax
    movl $1,%ebx
    leal riga3,%ecx
    movl len3,%edx
    int $0x80
   
    call input
  	cmp $1, %edx #freccia su
  	je due
  	cmp $2, %edx #freccia giù
	je quattro
    cmp $3, %edx #freccia dx
	je sub_tre

  	jmp exit
  	
sub_tre:

    movl $3,%eax
    call submenu

    jmp tre

quattro:
    #stampa stringa

    movl $4,%eax
    movl $1,%ebx
    leal riga4,%ecx
    movl len4,%edx
    int $0x80
    
    #stampa status

    movl $4,%eax
    movl $1,%ebx
    leal status4,%ecx
    movl status4_len,%edx
    int $0x80

    call input 
  	cmp $1, %edx #freccia su
  	je tre
  	cmp $2, %edx #freccia giù
	je cinque
  	cmp $3, %edx #freccia dx
  	je sub_quattro  

  	jmp exit

sub_quattro:

    movl status4,%edx
    call ON_OFF
    movl %edx, status4

    jmp quattro
  	
cinque:
    #stampa stringa

    movl $4,%eax
    movl $1,%ebx
    leal riga5,%ecx
    movl len5,%edx
    int $0x80

    #stampa status

    movl $4,%eax
    movl $1,%ebx
    leal status5,%ecx
    movl status5_len,%edx
    int $0x80
    
    call input
  	cmp $1, %edx #freccia su
  	je quattro
  	cmp $2, %edx #freccia giù
	je sei
  	cmp $3, %edx #freccia dx
  	je sub_cinque

  	jmp exit

sub_cinque:

    movl status5, %edx
    call ON_OFF
    movl %edx, status5

    jmp cinque
    
sei:
    #stampa stringa

    movl $4,%eax
    movl $1,%ebx
    leal riga6,%ecx
    movl len6,%edx
    int $0x80
    
    call input
  	cmp $1, %edx #freccia su
  	je cinque
  	cmp $2, %edx #freccia giù
	je giu_sei
    cmpl $3, %edx #freccia dx
    je sub_sei

	jmp exit

#se faccio freccia giù dal 6 cambia se sono in super o no

giu_sei:
    movb supervisor, %al
    testb %al, %al
    jz uno
    jmp sette

sub_sei:

    movl $6,%eax
    call submenu

    jmp sei

sette:
    #stampa stringa

    movl $4,%eax
    movl $1,%ebx
    leal riga7,%ecx
    movl len7,%edx
    int $0x80

    #stampa il valore attuale delle frecce
    movl $4,%eax
    movl $1,%ebx
    leal frecce_direzionali,%ecx
    movl $1,%edx
    int $0x80
    
    call input
  	cmp $1, %edx #freccia su
  	je sei
  	cmp $2, %edx #freccia giù
	je otto
    cmp $3, %edx #freccia dx
  	je sub_sette

	jmp exit

sub_sette:

    movl frecce_direzionali,%eax
    call set_sette
    movl %edx, frecce_direzionali

    jmp sette

otto:
    #stampa stringa

    movl $4,%eax
    movl $1,%ebx
    leal riga8,%ecx
    movl len8,%edx
    int $0x80
    
    call input
  	cmp $1, %edx #freccia su
  	je sette
  	cmp $2, %edx #freccia giù
	je uno_s
    cmp $3, %edx #freccia dx
  	je sub_otto

	jmp exit

sub_otto:

    movl $8,%eax
    call submenu

    jmp otto

exit:
	movl $1, %eax
	movl $0, %ebx
	int $0x80
    