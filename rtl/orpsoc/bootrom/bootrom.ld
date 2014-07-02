OUTPUT_FORMAT("elf32-or1k", "elf32-or1k", "elf32-or1k")
OUTPUT_ARCH(or1k)

ENTRY(_start)

SECTIONS
{
  . = 0xf0000000;
  .text : { *(.text) }
  .data : { *(.data) }
  .bss : { *(.bss) }
}
