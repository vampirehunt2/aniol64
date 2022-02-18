program CursorAdder2;

uses dos,
     crt;

var inputFn, outputFn: string;
    input, output: file of byte;
    b: byte;
    w: word;

begin
inputFn := 'test.fnt';
outputFn := 'test_c.fnt';
assign(input, inputFn);
assign(output, outputFn);
reset(input);
rewrite(output);
w := 0;
while not eof(input) do
      begin
      read(input, b);
      if w mod 8 = 7 then b := 255;
      write(output, b);
      w := w + 1;
      end;
close(input);
close(output);
end.