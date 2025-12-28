{ creating bitmapped text image for ROM }
{ testing 80 column display testing 80 column display testing 80 column }
{$M $4000,0,0 }   { 16K stack, no heap }
program BitMapGenerator;

uses
	crt,
	dos,
	Font8x8;

var
	input: text;
    output: file of byte;
    inputFn, outputFn, fontFn: string;
    charLine, textLine: byte;
    line: string;
    charCount, i, b: byte;
    c: char;
    width: byte;
    widthStr: string[1];
    visibleChars, charPerLine: byte;
    code: integer;

function min(a, b: byte): byte;
begin
if a < b then min := a
else min := b;
end;

begin
{ parsing command line arguments }
if (ParamCount < 2) or
   (ParamStr(1) = '-h') or
   (ParamStr(1) = '?' ) then
	begin
   	writeLn('bitmapgn <input file> <fontfile> (-w <font width>)');
	exit;
	end;
width := 8;
if ParamStr(3) = '-w' then
	begin
    Val(ParamStr(4), width, code);
    if code <> 0 then
    	begin
        writeLn('Invalid font width');
        exit;
        end;
    end;
visibleChars := 320 div width;
charPerLine := 512 div width;

{initializing files}
inputFn := ParamStr(1);
fontFn := ParamStr(2);
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
           charCount := min(visibleChars, length(line));
           for i := 1 to charPerLine do
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

{ running FONT VISUALISER }
str(width, widthStr);
swapVectors;
exec('fontvis.exe', '-w ' + widthStr);
swapVectors;
clrScr;
end.