export class System {
    cpu: CPU;
    ram: RAM;
    video: Video;

    constructor() {

    }

    start() {
        this.cpu.run();
    }
}
