program CursorAdder1;

uses dos,
     crt;

var inputFn, outputFn: string;
    input, output: file of byte;
    b: byte;

begin
inputFn := 'rogue.fnt';
outputFn := 'rogue_c.fnt';
assign(input, inputFn);
assign(output, outputFn);
reset(input);
rewrite(output);
while not eof(input) do
      begin
      read(input, b);
      b := not b;
      write(output, b);
      end;
close(input);
close(output);
end.