program FontConv;

uses dos, crt;

var input, output: file of byte;
    d, d0, d1: byte;

begin
assign(input, 'lazenby.fnt');
assign(output, 'lazenby1.fnt');
reset(input);
rewrite(output);
while not eof(input) do
begin
d1 := 0;
read(input, d0);

d := d0 and 128;
d := d shr 7;
d1 := d1 or d;

d := d0 and 64;
d := d shr 5;
d1 := d1 or d;

d := d0 and 32;
d := d shr 3;
d1 := d1 or d;

d := d0 and 16;
d := d shr 1;
d1 := d1 or d;

d := d0 and 8;
d := d shl 1;
d1 := d1 or d;

d := d0 and 4;
d := d shl 3;
d1 := d1 or d;

d := d0 and 2;
d := d shl 5;
d1 := d1 or d;

d := d0 and 1;
d := d shl 7;
d1 := d1 or d;

write(output, d1);
end;
close(input);
close(output);
end.