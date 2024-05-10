as_flags = -32 -gstabs
ld_flags = -m elf_i386

all: bin/main bin/main_c

bin/main: obj/main.o obj/set_sette.o obj/input.o obj/ON_OFF.o obj/submenu.o
	ld $(ld_flags) -o bin/main obj/main.o obj/ON_OFF.o obj/set_sette.o obj/input.o obj/submenu.o

bin/main_c:	 
	gcc src/main_c.c -o bin/main_c

obj/submenu.o: src/submenu.s
	as $(as_flags) -o obj/submenu.o src/submenu.s

obj/input.o: src/input.s
	as $(as_flags) -o obj/input.o src/input.s

obj/set_sette.o: src/set_sette.s
	as $(as_flags) -o obj/set_sette.o src/set_sette.s

obj/ON_OFF.o: src/ON_OFF.s
	as $(as_flags) -o obj/ON_OFF.o src/ON_OFF.s

obj/main.o: src/main.s
	as $(as_flags) -o obj/main.o src/main.s

clean:
	rm -f obj/*.o  
	rm -f bin/*
