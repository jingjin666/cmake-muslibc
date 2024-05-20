#include <ipc.h>
#include <test.h>

int test_function(int arg)
{
    unsigned long buff[4];
    buff[0] = 0;
    buff[1] = 1;
    buff[2] = 2;
    buff[3] = 3;
    ipc_send(451, (void *)buff, sizeof(buff));
}
