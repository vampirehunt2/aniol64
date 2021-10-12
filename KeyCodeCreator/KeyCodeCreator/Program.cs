using System;
using System.IO;

namespace KeyCodeCreator {
    class Program {

        KeyCode[] keycodes = new KeyCode[256];
        string inFilename;
        string outFilename;

        static void Main(string[] args) {
            string inFilename = args[0];
            string outFilename = args[1];
            new Program().Run(inFilename, outFilename);
        }


        void Run(string inFilename, string outFilename) {
            initTable();
            this.inFilename = inFilename;
            this.outFilename = outFilename;
            FileStream fs = File.OpenRead(this.inFilename);
            StreamReader sr = new StreamReader(fs);
            while (!sr.EndOfStream) {
                string line = sr.ReadLine();
                if (line.StartsWith("0") || line.StartsWith("1")) {
                    processLine(line);
                }
            }
            outputResult();
            sr.Close();
        }

        void initTable() {
            for (int i = 0; i < 256; ++i) keycodes[i] = new KeyCode();
        }

        void outputResult() {
            FileStream fs = File.OpenWrite(outFilename);
            StreamWriter sw = new StreamWriter(fs);
            for (int i = 0; i < 256; ++i) {
                sw.Write(
                    "\tdefb " + 
                    keycodes[i].hexValue +
                    "\t; " +
                    keycodes[i].binaryAddress +
                    "\t" +
                    keycodes[i].character +
                    "\n");
            }
            sw.Flush();
            sw.Close();
        }

        void processLine(string line) {
            string[] tokens = line.Split("\t");
            string binaryAddressToken = tokens[0].Trim();
            string charValueToken = tokens[2].Trim();
            string hexValueToken = tokens[3].Trim();
            int address = parseBinaryAddress(binaryAddressToken);
            byte value = parseHexValue(hexValueToken);

            if (charValueToken.Length == 1) {
                if (Convert.ToByte(charValueToken[0]) != value) throw new Exception("Value mismatch: " + line);
            }

            keycodes[address].hexValue = hexValueToken;
            keycodes[address].character = charValueToken;
            keycodes[address].binaryAddress = binaryAddressToken;
        }

        int parseBinaryAddress(string binaryAddress) {
            binaryAddress =
                binaryAddress.Substring(0, 2) +
                binaryAddress.Substring(3, 2) +
                binaryAddress.Substring(6, 4);
            return Convert.ToInt32(binaryAddress, 2);
        }

        byte parseHexValue(string hexValue) {
            hexValue = hexValue.Substring(0, 2);
            return Convert.ToByte(hexValue, 16);
        }

    }

    class KeyCode {
        public string hexValue = "00h";
        public string binaryAddress;
        public string character;
    }

}
