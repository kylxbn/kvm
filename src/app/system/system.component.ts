import {AfterViewInit, Component, ElementRef, OnInit, ViewChild} from '@angular/core';

import {System} from '../../components/system/system';
import {GenericRAM} from '../../components/ram/GenericRAM';
import {KCPU1} from '../../components/cpu/KCPU1';
import {GenericVideo} from '../../components/video/GenericVideo';

@Component({
  selector: 'app-system',
  templateUrl: './system.component.html',
  styleUrls: ['./system.component.scss'],
})
export class SystemComponent implements OnInit, AfterViewInit {
  @ViewChild('display')
  display: ElementRef<HTMLCanvasElement>;

  system: System;

  constructor() {
  }

  ngOnInit() { }

  ngAfterViewInit(): void {
    this.system = new System();
    this.system.cpu = new KCPU1(this.system);
    this.system.ram = new GenericRAM(this.system);
    this.system.video = new GenericVideo(this.system, this.display.nativeElement);

    this.system.start();
  }
}
