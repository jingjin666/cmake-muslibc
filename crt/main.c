#include <stdio.h>
#include <stdint.h>
#include <string.h>
#include <stdlib.h>
#include <math.h>
#include <unistd.h>
#include <test.h>

int data = 0x1234;
int bss;

int main(int argc, char *argv[])
{
    printf("\n\n---hello world---\n\n");

    printf("argc = %p, argv = %p\n", argc, argv);

    printf("data = %p, bss = %p\n", data, bss);

    char test[10];
    memset(test, 0, 10);

    test_function(1);
    
    while(1)
    {
        printf("+++\n");
        printf("main data = %p, bss = %p\n", data++, bss--);
        printf("---\n");
        sleep(1);
    }
}

