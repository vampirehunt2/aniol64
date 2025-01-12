const DART_A_DAT = 0xEC;
const DART_A_CMD = 0xEE;

const CF_STATUS = 0xF7;
const CF_READY = 0x48;                // 01001000b D7=busy, D6=drvrdy, D3=drq

const lineOfBytes = new Uint8Array(5);
let i = 0;
// first directory entry
lineOfBytes[0] = 0x2C;		// t         
lineOfBytes[1] = 0x24;		// e      
lineOfBytes[2] = 0x1B;		// s
lineOfBytes[3] = 0x2C;		// t
lineOfBytes[4] = 0x5A;		// CR


API.readPort = (port) => {
	API.log(port);
    port = (port & 0xFF);
	if (port == DART_A_DAT) {         
		return lineOfBytes[i++];
	}
	if (port == DART_A_CMD) {
		return 0xFF;
	}
	if (port == CF_STATUS) {
		return CF_READY;
	}
	return undefined;
}