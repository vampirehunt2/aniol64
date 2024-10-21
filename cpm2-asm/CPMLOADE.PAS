program CPMLoader;

uses dos, crt;

const CPM_START = (32 - 7) * 1024;
      INPUT_NAME = 'aniol64.bin';
      CPM_PATH = '..\cpm2-asm\cpm22.bin';
      TMP_NAME = 'aniol64.tmp';

var cpm, input, tmp: file of byte;
    a: byte;
    count: word;

begin
assign(input, INPUT_NAME);
reset(input);
assign(cpm, CPM_PATH);
reset(cpm);
assign(tmp, TMP_NAME);
rewrite(tmp);
count := 0;
while not eof(input) do
      begin
      read(input, a);
      write(tmp, a);
      count := count + 1;
      end;
if count >= CPM_START then
   begin
   writeln(INPUT_NAME, ' too large');
   readln;
   exit;
   end;
a := 0;
while count < CPM_START do
      begin
      write(tmp, a);
      count := count + 1;
      end;
while not eof(cpm) do
      begin
      read(cpm, a);
      write(tmp, a);
      end;
close(input);
close(cpm);
close(tmp);
erase(input);
rename(tmp, INPUT_NAME);
end.
