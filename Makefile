target/stack.c: test/stack.dats
	patsopt --output $@ -dd $< -cc

target/stack: target/stack.c
	gcc -o $@ $< -DATS_MEMALLOC_LIBC \
		-I $(PATSHOME) -I $(PATSHOME)/ccomp/runtime \
		-L $(PATSHOME)/ccomp/atslib/lib -latslib -lpthread -latomic
