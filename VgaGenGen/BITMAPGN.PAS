{creating bitmapped text image for ROM}
program BitMapGenerator;

uses crt,
     dos,
     Font8x8;

const CHAR_PER_LINE = 64;
      VISIBLE_CHARS = 40;

var input: text;
    output: file of byte;
    inputFn, outputFn, fontFn: string;
    charLine, textLine: byte;
    line: string;
    charCount, i, b: byte;
    c: char;

function min(a, b: byte): byte;
begin
if a < b then min := a
else min := b;
end;

begin
{initializing files}
inputFn := 'rogue.txt'; { ParamStr(1);}
fontFn := 'test.fnt'; {ParamStr(2);}
writeLn('input file: ', inputFn);
outputFn := 'bitmapgn.bin';
assign(input, inputFn);
reset(input);
assign(output, outputFn);
rewrite(output);
writeLn('font file: ', fontFn);
loadFont8x8(fontFn);
{processing}
for textLine := 0 to 29 do
    if not eof(input) then
       begin
       readLn(input, line);
       for charLine := 0 to 7 do
           begin
           charCount := min(VISIBLE_CHARS, length(line));
           for i := 1 to CHAR_PER_LINE do
               begin
               if i <= charCount then
                  begin
                  c := line[i];
                  b := byte(c);
                  b := font[b, charLine];
                  end
               else b := 0;
               write(output, b);
               end;
           end;
       end;
{closing files}
close(input);
close(output);
end.