using System;

namespace VGAGenGen {
    class Generator {

        static readonly short X_ADDRESS_MASK = 32256;
        static readonly short Y_ADDRESS_MASK =

        static void Main(string[] args) {
            Console.WriteLine("Hello World!");

            new Generator().Generate();


        }

        void Generate() {
            short address;
            for (address = 0; address <= Int16.MaxValue / 2; ++address) {

            }

        }

        private short getXAddress(short address) {
            short xAddress = address & 0111111000000000;


        }
    }
}
