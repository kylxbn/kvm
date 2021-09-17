# ak1 - Assembles K1 assembly code

import sys
import re

class Assembler:
    def _getBytesForInstruction(self, line):
        i = line.split(' ')
        if i[0] == 'ld' or i[0] == 'st':
            if self._isImmediate(i[2]):
                # this is immediate
                return 2
            else:
                return 3
        elif i[0] == 'ad' or i[0] == 'sb':
            if self._isImmediate(i[2]):
                return 3
            else:
                return 1
        elif i[0] == 'jp' or i[0] == 'jz':
            return 3
        else:
            print('Unknown instruction: ' + line)
            exit()
        
    def _isImmediate(self, arg):
        return arg[0] == '#'
    def _isRelative(self, arg):
        return '+x' in arg

    def _getLabels(self, lines):
        pc = 0
        labels = {}

        for line in lines:
            if line.startswith('#offset'):
                arg = line.split(' ')
                if arg[1][0] == '$':
                    pc = int(arg[1][1:], 16)
                else:
                    pc = int(arg[1])
            elif line.endswith(':'):
                labels[line[:-1]]  = pc
            else:
                pc += self._getBytesForInstruction(line)
        
        return labels

    def _decodeParam(self, p, sixteen):
        if p[0] == '#':
            p = p[1:]

        rel_idx = p.find('+')
        if rel_idx >= 0:
            p = p[0:rel_idx]

        if p[0] == '$':
            val = int(p[1:], 16)
        else:
            val = int(p)
        
        return self._toHex(val, sixteen)
    
    def _toHex(self, p, sixteen):
        if sixteen:
            return [p & 0xFF, (p & 0xFF00) >> 8]
        else:
            return [p & 0xFF]
    
    def _compile(self, lines, labels):
        binary = []

        for l in lines:
            if l[0] == '#' or l[-1] == ':':
                continue

            p = l.split(' ')

            if p[0] == 'ld':
                if p[1] == 'a':
                    if self._isImmediate(p[2]):
                        binary.append(0xA4)
                        binary.extend(self._decodeParam(p[2], False))
                    elif self._isRelative(p[2]):
                        binary.append(0xA6)
                        binary.extend(self._decodeParam(p[2], True))
                    else:
                        binary.append(0xA0)
                        binary.extend(self._decodeParam(p[2], True))
                elif p[1] == 'x':
                    if self._isImmediate(p[2]):
                        binary.append(0xA5)
                        binary.extend(self._decodeParam(p[2], False))
                    else:
                        binary.append(0xA2)
                        binary.extend(self._decodeParam(p[2], True))
            elif p[0] == 'st':
                if self._isImmediate(p[2]):
                    print('Immediate not supported on ST: ' + l)
                    exit()
                if p[1] == 'a':
                    if self._isRelative(p[2]):
                        binary.append(0xA7)
                    else:
                        binary.append(0xA1)
                elif p[1] == 'x':
                    binary.append(0xA3)
                binary.extend(self._decodeParam(p[2], True))
            elif p[0] == 'ad':
                if p[1] != 'a':
                    print('Cannot store AD result to different register: ' + l)
                    exit()
                if self._isImmediate(p[2]):
                    binary.append(0xB0)
                    binary.extend(self._decodeParam(p[2], True))
                elif p[2] == 'x':
                    binary.append(0xB2)
            elif p[0] == 'sb':
                if p[1] != 'a':
                    print('Cannot store SB result to different register: ' + l)
                    exit()
                if self._isImmediate(p[2]):
                    binary.append(0xB1)
                    binary.extend(self._decodeParam(p[2], True))
                elif p[2] == 'x':
                    binary.append(0xB3)
            elif p[0] == 'jp':
                if p[1] in labels:
                    binary.append(0x90)
                    binary.extend(self._toHex(labels[p[1]], True))
                elif re.match('(\$[0-9a-f]+)|([0-9])', p[1]):
                    binary.append(0x90)
                    binary.extend(self._decodeParam(p[1], True))
                else:
                    print('Label not defined: ' + p[1])
            elif p[0] == 'jz':
                if p[1] in labels:
                    binary.append(0x91)
                    binary.extend(self._toHex(labels[p[1]], True))
                elif re.match('(\$[0-9a-f]+)|([0-9])', p[1]):
                    binary.append(0x91)
                    binary.extend(self._decodeParam(p[1], True))
                else:
                    print('Label not defined: ' + p[1])
            else:
                print('Unknown instruction:' + l)

        return binary      

    def assemble(self, filePath, outFile):
        lines = []
        
        with open(filePath, 'r') as f:
            lines1 = f.readlines()
            for l in lines1:
                clean = l.split(';')[0].strip().lower()
                if len(clean) > 0:
                    lines.append(clean)

        labels = self._getLabels(lines)
        print('Pass 1: saw ' + str(len(labels)) + ' labels')
        print(labels)

        binary = self._compile(lines, labels)
        print('Pass 2: compiled ' + str(len(binary)) + ' bytes of code')

        with open(outFile, 'wb') as f:
            for byte in binary:
                f.write(byte.to_bytes(1, byteorder='little'))
        print('Wrote binary data to ' + outFile)

if __name__ == '__main__':
    params = sys.argv
    if len(params) > 1 and len(params) < 4:
        asm = Assembler()
        asm.assemble(
            params[1],
            (params[1] + '.bin') if (len(params) == 2) else params[2]
        )