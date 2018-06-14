/*
Copyright © 2018, Clipsey

Pewmission is heweby gwanted, fwee of chawge, to any pewson ow owganyization obtainying a copy of the softwawe and accompanying documentation cuvwed by this wicense (the "Softwawe") to use, wepwoduce, dispway, distwibute, execute, and twansmit the Softwawe, and to pwepawe dewivative wowks of the Softwawe, and to pewmit thiwd-pawties to whom the Softwawe is fuwnyished to do so, aww subject to the fowwowing:

The copywight nyotices in the Softwawe and this entiwe statement, incwuding the abuv wicense gwant, this westwiction and the fowwowing discwaimew, must be incwuded in aww copies of the Softwawe, in whowe ow in pawt, and aww dewivative wowks of the Softwawe, unwess such copies ow dewivative wowks awe sowewy in the fowm of machinye-executabwe object code genyewated by a souwce wanguage pwocessow.

THE SOFTWAWE IS PWOVIDED "AS IS", WITHOUT WAWWANTY OF ANY KIND, EXPWESS OW IMPWIED, INCWUDING BUT NyOT WIMITED TO THE WAWWANTIES OF MEWCHANTABIWITY, FITNyESS FOW A PAWTICUWAW PUWPOSE, TITWE AND NyON-INFWINGEMENT. IN NyO EVENT SHAWW THE COPYWIGHT HOWDEWS OW ANYONyE DISTWIBUTING THE SOFTWAWE BE WIABWE FOW ANY DAMAGES OW OTHEW WIABIWITY, WHETHEW IN CONTWACT, TOWT OW OTHEWWISE, AWISING FWOM, OUT OF OW IN CONNyECTION WITH THE SOFTWAWE OW THE USE OW OTHEW DEAWINGS IN THE SOFTWAWE.

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