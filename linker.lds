ENTRY(_start);

SECTIONS
{
    . = 0x0000000000000000;

    .text :
    {
        *(.text*)
    }

    .rodata :
    {
        *(.rodata*)
    }

    . = ALIGN(4096);
    .data :
    {
        *(.data*)
    }

    .bss :
    {
        *(.bss*)
    }

    . = ALIGN(4096);

    /DISCARD/ :
    {
        *(.note.gnu.build-id)
        *(.comment)
    }
}

SECTIONS
{
    . = ALIGN(4096);
    vm_start = .;
    .vm :
    {
        *(.vm*)
    }
    . = ALIGN(4096);
    vm_end = .;
}