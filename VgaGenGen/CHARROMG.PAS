program CharacterRomGenerator;

uses dos;

var fontList: text;
    fontName: string;
    input, output: file of byte;
    b: byte;

begin
assign(fontList, 'fontlist.txt');
reset(fontList);
assign(output, 'chargen.bin');
rewrite(output);
while not eof(fontList) do
      begin
      readln(fontList, fontName);
      assign(input, fontName);
      reset(input);
      while not eof(input) do
            begin
            read(input, b);
            write(output, b);
            end;
      close(input);
      end;
close(output);
close(fontList);
end.