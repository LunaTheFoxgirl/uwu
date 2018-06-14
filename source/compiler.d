/*
Copyright © 2018, Clipsey

Permission is hereby granted, free of charge, to any person or organization obtaining a copy of the software and accompanying documentation covered by this license (the "Software") to use, reproduce, display, distribute, execute, and transmit the Software, and to prepare derivative works of the Software, and to permit third-parties to whom the Software is furnished to do so, all subject to the following:

The copyright notices in the Software and this entire statement, including the above license grant, this restriction and the following disclaimer, must be included in all copies of the Software, in whole or in part, and all derivative works of the Software, unless such copies or derivative works are solely in the form of machine-executable object code generated by a source language processor.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE, TITLE AND NON-INFRINGEMENT. IN NO EVENT SHALL THE COPYRIGHT HOLDERS OR ANYONE DISTRIBUTING THE SOFTWARE BE LIABLE FOR ANY DAMAGES OR OTHER LIABILITY, WHETHER IN CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

*/
import std.conv;
import codebuilder;
import std.stdio;

public static bool OWO_ENABLED = false;

bool set(byte b, int pos)
{
   return (b & (1 << pos)) != 0;
}

void transpile(ubyte[] mcode, CodeBuilder* builder) {
	foreach(b; mcode) {
		foreach_reverse(i; 0 .. 8) {
			builder.PushBitU(set(b, i));
		}
	}
}

void compile(string code, CodeBuilder* builder) {
    if (code.length == 0 || code.length % 8 != 0) {
    	throw new Exception("No code specified, or code was not bytewords. (len%8 was "~(code.length%8).text~")");   
    }
    
    int acc = 0;
    ubyte instr = 0;
    foreach(i; 0 .. code.length) {
        acc++;
        char c = code[i];
        instr <<= 1;
		if (OWO_ENABLED) {
			if (c == 'o') instr |= (0);
			else if (c == 'w') instr |= (1);
			else throw new Exception("Unexpected token at index "~i.text~" <"~c.text~">...");
		} else {
			if (c == 'u') instr |= (0);
			else if (c == 'w') instr |= (1);
			else throw new Exception("Unexpected token at index "~i.text~" <"~c.text~">...");
		}
        if (acc >= 8) {
            builder.PushByte(instr);
            acc = 0;
            instr = 0;
        }
    }
}