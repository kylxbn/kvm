import {System} from '../system/system';

export class KCPU1 implements CPU {
    START_EXEC = 512;

    system: System;
    stack: number[];
    currentAddress: number;

    constructor(system: System) {
        this.system = system;
        this.currentAddress = this.START_EXEC;
    }

    public run() {
        let value = 24;
        setInterval(
            () => {
                this.system.ram.setByte(1024, value);
                value++;
            }, 1000
        );
    }
}
