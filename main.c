#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include <atomic_ops_stack.h>

int main(int argc,  char** argv) {
    AO_stack_t st;
    AO_stack_init(&st);
    char* str = "yeehaw";
    AO_stack_push(&st, &str);
    void* ret;
    ret = AO_stack_pop(&st);
    printf("%s\n", (char*) ret);
}
