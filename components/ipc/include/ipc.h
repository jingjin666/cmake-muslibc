#ifndef __IPC_H
#define __IPC_H

#include <sys/types.h>

unsigned long ipc_send(unsigned long msg_id, void *buf, size_t len);

#endif
