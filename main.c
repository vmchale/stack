#include "CATS/stack.cats"

int main(int argc, char *argv[]) {

    struct stack_t* st;
    stack_init(st);

    push(st, "Some string idk");

    pop(st);

    return 0;
}
