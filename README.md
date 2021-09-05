# K Virtual Machine

## What is this?

This is my attempt at creating my own virtual machine with custom
replaceable components (CPU, RAM, graphics) with the goal of creating
my own operating system that runs on this virtual machine.

## What is working?

Currently, this is extremely incomplete and more like a proof of concept
that "it might work". The RAM, video card, and CPU are currently
being "virtualized", in that:

1. The graphics card (named X1) is initialized (which contains a 256x256 framebuffer and 16 bytes of RAM)
2. The RAM is created (which contains 4,096 bytes worth of memory mapped from `0x0000-0x0FFF`. However, currently, the CPU can only address the range `0x00` to `0xFF`.)
3. A device that provides random numbers is connected to address `0xE9`.
4. The graphics card is connected to RAM with its address space mapped to `0xF0-0xFF`.
5. A program is then loaded to RAM space `0x00-`. It's coded entirely in machine code and does nothing more than draw multicolored lines into the screen:
    1. The CPU gets random numbers as line coordinates from the random generator device
    2. Similar X1/X2 or Y1/Y2 values are avoided by detecting those and getting new random values as necessary
    4. The coordinates are saved into `0x00-0x03`.
    3. The CPU gets random numbers to choose a random color and saved at `0x04-0x06`.
    4. The CPU transfers the data into the GPU's address space `0xF0-0xFF`.
    5. The CPU triggers a GPU line draw by writing something into `0xFF`.

### CPU (K1)

The CPU is a barely-working RISC variant with A and X registers. It is a tiny bit similar to the MOS 6502 CPU. It can

* load data into A or X either from an immediate value or from address space
* subtract or add X from A (the result left in A)
* zero flags for when subtraction results in a 0 A value
* conditional jump (if zero flag is set) and jumps

### RAM

It has 4,096 bytes. That's it.

### GPU (X1)

Has a 256x256 pixel RGBA8 buffer, has 16-byte RAM where the CPU can send data to, and can draw lines in any color.

## What do you plan to do next?

Well, currently, this is extremely incomplete, too incomplete to
the point that I do not know what will happen yet. However, these are
things that I plan to do soon:

* Virtualizing a hard drive
* Implementing the BIOS
* Writing a bootloader
* Deciding on the CPU opcode list
* Finishing the CPU emulator
* DONE! ~~Writing a graphics device that can draw pixels and lines at least~~
* DONE! ~~Writing a basic proof of concept program (simple looping animation?)~~
* Writing basic keyboard device
* Writing an operating system (the hardest task, I guess)

## License

GPL-3, I guess. Not like anyone would care about this useless project.
