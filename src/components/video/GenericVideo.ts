import {System} from '../system/system';

export class GenericVideo implements Video {
    system: System;
    canvas: HTMLCanvasElement;

    constructor(system: System, canvas: HTMLCanvasElement) {
        this.system = system;
        this.canvas = canvas;
        this.canvas.height = 128;
        this.canvas.width = 128;
    }

    redraw() {
        const ctx = this.canvas.getContext('2d');

        ctx.clearRect(0, 0, this.canvas.width, this.canvas.height);

        ctx.font = '30px Arial';
        ctx.fillText(this.system.ram.getByte(1024), 10, 50);
    }
}
