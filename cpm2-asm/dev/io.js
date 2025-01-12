let CF_STATUS = 0x7F;
let DART_A_DAT = 0xEC;
let DART_B_DAT = 0xED;

let CF_READY = 0x48;                // 01001000b D7=busy, D6=drvrdy, D3=drq

// array that holds data of a CF sector that contains the CP/M directory structure
// note, only the first byte out of each four is significant.
const cfSector = new Uint8Array(512);
let sectorCounter = 0;

// first directory entry
cfSector[0 * 4] = 0;                    // user ID
cfSector[1 * 4] = 'T';                  // 8 bytes for filename
cfSector[2 * 4] = 'E';
cfSector[3 * 4] = 'S';
cfSector[4 * 4] = 'T';
cfSector[5 * 4] = ' ';
cfSector[6 * 4] = ' ';
cfSector[7 * 4] = ' ';
cfSector[8 * 4] = ' ';
cfSector[9 * 4] = 'B';                  // three bytes for extension
cfSector[10 * 4] = 'I';
cfSector[11 * 4] = 'N';



API.readPort = (port) => {
    port = (port & 0xFF);
    if (port == CF_STATUS) {         // CF_STATUS         
        return CF_READY;
    }
	if (port == DART_A_DAT) {         // 
		return 0x5A;
	}
	return undefined;
}


API.writePort = (port, value) => {
    port = (port & 0xFF);
	if(port == DART_B_DAT) {         // 
		API.log(value)
	}
}