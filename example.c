#include <stdio.h>

#include "CATS/stack.cats"

int main(int argc, char *argv[]) {

    struct stack_t *st;

    __cats_push(st, "res");
    __cats_push(st, "res2");

    char *res;

    res = __cats_pop(st);
    __cats_push(st, "res");
    printf("%s\n", res);

    res = __cats_pop(st);
    printf("%s\n", res);

    res = __cats_pop(st);
    printf("%s\n", res);
}
