cmake_minimum_required(VERSION 3.16)

set(CMAKE_C_COMPILER_FORCED ON)
set(CMAKE_CXX_COMPILER_FORCED ON)

set(CONFIG_PREFIX ${CROSS_COMPILE})
set(CMAKE_C_COMPILER "${CONFIG_PREFIX}gcc")
set(CMAKE_CXX_COMPILER "${CONFIG_PREFIX}g++")
set(CMAKE_ASM_COMPILER "${CONFIG_PREFIX}gcc")
set(CMAKE_LD "${CONFIG_PREFIX}ld")
set(CMAKE_OBJCOPY "${CONFIG_PREFIX}objcopy")
set(CMAKE_OBJDUMP "${CONFIG_PREFIX}objdump")
set(CMAKE_C_AR "${CONFIG_PREFIX}ar")
set(CMAKE_SIZE "${CONFIG_PREFIX}size")

project(app)

set(ARCH_CPU_FLAGS "-mcpu=cortex-a55")
set(ARCH_CFLAGS "-nostdlib \
                    -nostdinc \
                    -fno-builtin \
                    -fno-common \
                    -fno-stack-protector \
                    -fno-strict-aliasing")
set(DEBUG_FLAGS "-g -Wall -Wstrict-prototypes -Wshadow -Wundef")
set(OPTIMAZTION_FLAGS "-O0")

set(CMAKE_C_FLAGS   "${CMAKE_C_FLAGS} ${ARCH_CPU_FLAGS} ${ARCH_CFLAGS} ${DEBUG_FLAGS} ${OPTIMAZTION_FLAGS} -std=gnu99")
set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} ${ARCH_CPU_FLAGS} ${ARCH_CFLAGS} ${DEBUG_FLAGS} ${OPTIMAZTION_FLAGS} -std=gnu++17")
set(CMAKE_ASM_FLAGS "${CMAKE_ASM_FLAGS} ${ARCH_CPU_FLAGS} ${ARCH_CFLAGS} ${DEBUG_FLAGS} ${OPTIMAZTION_FLAGS} -D__ASSEMBLY__")

include_directories(
    ${PROJECT_SOURCE_DIR}/components/ipc/include
    ${PROJECT_SOURCE_DIR}/components/arch/aarch64/include
    ${PROJECT_SOURCE_DIR}/test/include
    ${PROJECT_SOURCE_DIR}/musl-1.2.3/out/include
)

add_subdirectory(components)
add_subdirectory(test)

set(CRT_SRCS 
    "${PROJECT_SOURCE_DIR}/crt/crt1.c"
    "${PROJECT_SOURCE_DIR}/crt/main.c"
)

set(CMAKE_EXECUTABLE_SUFFIX ".elf")
add_executable(${PROJECT_NAME} ${CRT_SRCS})

set(EXTRA_LIBS "${LIBGCC}")
set(EXTRA_LIBS "${EXTRA_LIBS} ${PROJECT_SOURCE_DIR}/musl-1.2.3/out/lib/libc.a")
set(EXTRA_LIBS "${EXTRA_LIBS} ${PROJECT_SOURCE_DIR}/musl-1.2.3/out/lib/libm.a")
set(EXTRA_LIBS "${EXTRA_LIBS} ${PROJECT_SOURCE_DIR}/musl-1.2.3/out/lib/librt.a")

set(LD_SCRIPTS "-T${PROJECT_SOURCE_DIR}/linker.lds")

target_link_libraries(${PROJECT_NAME} PRIVATE test components "-z max-page-size=4096 -g -Wl,--start-group ${EXTRA_LIBS} -Wl,--end-group" ${LD_SCRIPTS})

add_custom_target(gen_dump ALL
	COMMAND ${CMAKE_OBJDUMP} -D -Slx ${PROJECT_SOURCE_DIR}/build/app.elf > ${PROJECT_SOURCE_DIR}/build/app.dump
	DEPENDS ${PROJECT_SOURCE_DIR}/build/app.elf
)
add_dependencies(gen_dump app)

add_custom_target(gen_binary ALL
	COMMAND ${CMAKE_OBJCOPY} -O binary ${PROJECT_SOURCE_DIR}/build/app.elf  ${PROJECT_SOURCE_DIR}/build/app.bin
	DEPENDS ${PROJECT_SOURCE_DIR}/build/app.elf
)
add_dependencies(gen_binary app)