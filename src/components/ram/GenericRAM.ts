import {System} from '../system/system';

export class GenericRAM implements RAM {
    private readonly memory: number[];

    system: System;

    constructor(system: System) {
        this.memory = new Array<number>(8192).fill(0);
        this.system = system;
    }

    public getByte(position: number) {
        return this.memory[position];
    }

    public setByte(position: number, value: number) {
        this.memory[position] = value;

        if (position === 1024) {
            this.system.video.redraw();
        }

    }
}
