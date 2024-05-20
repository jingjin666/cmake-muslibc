file(GLOB COMPONENTS_SRCS "*.c")

set(sub_dirs "")

list(APPEND sub_dirs "arch")
list(APPEND sub_dirs "ipc")

foreach(dir ${sub_dirs})
	file(GLOB_RECURSE SUB_SRCS "${dir}/*.c")
	list(APPEND COMPONENTS_SRCS "${SUB_SRCS}")
endforeach()

add_library (components STATIC ${COMPONENTS_SRCS})
