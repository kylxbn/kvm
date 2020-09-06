# K Virtual Machine

## What is this?

This is my attempt at creating my own virtual machine with custom
replaceable components (CPU, RAM, graphics) with the goal of creating
my own operating system that runs on this virtual machine.

## What is working?

Currently, this is extremely incomplete and more like a proof of concept
that "it might work". The RAM, video card, and CPU are currently
being "virtualized", in that the CPU is constantly incrementing
RAM address 1024, and this causes the video card to redraw the screen,
showing the value of that RAM address on screen.

## What do you plan to do next?

Well, currently, this is extremely incomplete, too incomplete to
the point that I do not know what will happen yet. However, these are
things that I plan to do soon:

* Virtualizing a hard drive
* Implementing the BIOS
* Writing a bootloader
* Deciding on the CPU opcode list
* Writing the CPU emulator
* Writing a graphics device that can draw pixels and lines at least
* Writing a basic proof of concept program (simple looping animation?)
* Writing basic keyboard device
* Writing an operating system (the hardest task, I guess)

## License

GPL-3, I guess. Not like anyone would care about this useless project.
