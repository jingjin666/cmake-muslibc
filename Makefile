.PHONY: all clean

TOP_DIR = $(shell pwd)

CROSS_COMPILE = aarch64-none-elf-

LIBGCC = $(shell ${CROSS_COMPILE}gcc -print-libgcc-file-name)

all:env_prepare
	@mkdir -p $(TOP_DIR)/build && cd $(TOP_DIR)/build && cmake ../ -DCROSS_COMPILE=$(CROSS_COMPILE) -DLIBGCC=$(LIBGCC) && make

$(TOP_DIR)/musl-1.2.3/out/lib/libc.a:
	@cd $(TOP_DIR)/musl-1.2.3 && ./configure --prefix=./out CROSS_COMPILE=$(CROSS_COMPILE) && make && make install

env_prepare:$(TOP_DIR)/musl-1.2.3/out/lib/libc.a
	@echo "General env prepare..."

clean:
	@echo "clean..."
	@rm $(TOP_DIR)/build -rf
	@rm $(TOP_DIR)/musl-1.2.3/out/* -rf