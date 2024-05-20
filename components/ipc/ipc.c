#include <stdio.h>
#include <stdint.h>
#include <string.h>
#include <syscall_arch.h>

#include <ipc.h>

unsigned long ipc_send(unsigned long msg_id, void *buf, size_t len)
{
    if (len <= sizeof(long) * 5) {
        long param[5] = {0};
        memcpy(param, buf, len);
        __syscall6(msg_id, len, param[0], param[1], param[2], param[3], param[4]);
    }
}

