#include <stdio.h>

#include "CATS/stack.cats"

int main(int argc, char *argv[]) {
  struct stack_t *st;
  push(st, "res");
  push(st, "res2");
  char* res;
  res = pop(st);
  printf("%s\n", res);
  res = pop(st);
  printf("%s\n", res);
}
