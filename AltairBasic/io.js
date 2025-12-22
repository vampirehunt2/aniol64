const DART_B_DAT = 0xED



API.writePort = (port, value) => {
	port = (port & 0xFF);
	if (port == DART_B_DAT) {         
		API.log(value);
	}
}


API.readPort = (port) => {

}