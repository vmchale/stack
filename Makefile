.PHONY: test

target/cstack: main.c
	@mkdir -p $(dir $@)
	gcc $< -o $@ -latomic_ops_gpl -latomic_ops

test: target/cstack
	./target/cstack
