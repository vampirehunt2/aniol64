program FontGen;

uses crt,
     graph,
     dos;

const RASTER_SIZE = 256;
      CELL_SIZE = 32;
      FONT_AREA_X = 300;
      FONT_AREA_Y = 10;
      MENU_AREA_X = 10;
      MENU_AREA_Y = 300;

var gd, gm: integer;
    font: array[0..127, 0..7] of byte;
    curX, curY: word;
    showCursor: boolean;
    k, currChar: char;
    b: byte;



procedure cleanMenuArea;
begin
setFillStyle(solidFill, black);
bar(MENU_AREA_X, MENU_AREA_Y, GetMaxX, GetMaxY);
end;

procedure printMenu(s: string);
begin
cleanMenuArea;
outTextXY(MENU_AREA_X, MENU_AREA_Y, s);
end;

procedure printCurrentChar;
begin
printMenu('Current character: ' + currChar);
end;

procedure displayRaster;
var x, y: word;
begin
for x := 0 to 8 do line(x * CELL_SIZE, 0, x * CELL_SIZE, RASTER_SIZE);
for y := 0 to 8 do line(0, y * CELL_SIZE, RASTER_SIZE, y * CELL_SIZE);
end;

function getCellForChar(x, y: word; ch: char): boolean;
var b, d, mask: byte;
begin
b := byte(ch);
d := font[b, y];
mask := 1;
mask := mask shl x;
d := d and mask;
getCellForChar := d > 0;
end;

function getCell(x, y: word): boolean;
begin
getCell := getCellForChar(x, y, currChar);
end;

procedure setCell(x, y: word);
var b, d, mask: byte;
begin
b := byte(currChar);
d := font[b, y];
mask := 1;
mask := mask shl x;
d := d or mask;
font[b, y] := d;
end;

procedure clearCell(x, y: word);
var b, d, mask: byte;
begin
b := byte(currChar);
d := font[b, y];
mask := 1;
mask := mask shl x;
mask := not mask;
d := d and mask;
font[b, y] := d;
end;

procedure paintCell(x, y: word);
var c: word;
    x0, x1, y0, y1: integer;
begin
if getCell(x, y) then c := white
else c := black;
setFillStyle(SolidFill, c);
x0 := x * CELL_SIZE + 1;
x1 := (x + 1) * CELL_SIZE - 1;
y0 := y * CELL_SIZE + 1;
y1 := (y + 1) * CELL_SIZE - 1;
bar(x0, y0, x1, y1);
end;

procedure toggleCell(x, y: word);
begin
if getCell(x, y) then clearCell(x, y)
else setCell(x, y);
paintCell(x, y)
end;

procedure paintRaster;
var x, y: word;
begin
for x := 0 to 7 do
    for y := 0 to 7 do
        paintCell(x, y);
end;

procedure paintCursor;
var x0, x1, y0, y1: word;
begin
if getCell(curX, curY) then setColor(black)
else setColor(white);
x0 := curX * CELL_SIZE + 1;
x1 := (curX + 1) * CELL_SIZE - 1;
y0 := curY * CELL_SIZE + 1;
y1 := (curY + 1) * CELL_SIZE - 1;
rectangle(x0, y0, x1, y1);
setcolor(white);
end;

procedure cleanCursor;
begin
paintCell(curX, curY);
end;

procedure put2x2Pixel(x, y, c: word);
begin
putPixel(x, y, c);
putPixel(x + 1, y, c);
putPixel(x, y + 1, c);
putPixel(x + 1, y + 1, c);
end;

procedure paintFont;
var col, row, x, y, px, py: word;
    b: byte;
begin
b := byte(currChar);
row := b div 16;
col := b mod 16;
for x := 0 to 7 do
    for y := 0 to 7 do
        begin
        px := FONT_AREA_X + col * 16 + x * 2;
        py := FONT_AREA_Y + row * 16 + y * 2;
        if getCell(x, y) then put2x2Pixel(px, py, white)
        else put2x2Pixel(px, py, black);
        end;
end;

procedure paintFontXY(x0, y0: word; ch: char);
var x, y, px, py: word;
begin
for x := 0 to 7 do
    for y := 0 to 7 do
        begin
        px := x0 + x * 2;
        py := y0 + y * 2;
        if getCellForChar(x, y, ch) then put2x2Pixel(px, py, white)
        else put2x2Pixel(px, py, black);
        end;
end;

procedure paintAllFonts;
var i: byte;
begin
for i := 0 to 127 do
    begin
    currChar := char(i);
    paintFont;
    end;
currChar := char(0);
end;

procedure moveCursor(x, y: word);
begin
if (x >= 0) and (x <= 7) and (y >= 0) and (y <= 7) then
   begin
   cleanCursor;
   curX := x;
   curY := y;
   paintCursor;
   end;
end;

procedure editFont;
begin
printCurrentChar;
curX := 0;
curY := 0;
repeat
      paintCursor;
      k := readKey;
      case k of
           'l': moveCursor(curX + 1, curY);
           'j': moveCursor(curX - 1, curY);
           'i': moveCursor(curX, curY - 1);
           'k': moveCursor(curX, curY + 1);
           ' ': toggleCell(curX, curY);
      end;
until k = char(13);
paintFont;
cleanMenuArea;
end;

procedure init;
var c, l: byte;
begin
for c := 0 to 127 do
    for l := 0 to 7 do
        font[c, l] := 0;
end;

procedure save(path: string);
var f: file of byte;
    c, l: byte;
begin
assign(f, path);
rewrite(f);
for c := 0 to 127 do
    for l := 0 to 7 do
        write(f, font[c, l]);
close(f);
end;

procedure load(path: string);
var f: file of byte;
    c, l, d: byte;
begin
assign(f, path);
reset(f);
for c := 0 to 127 do
    for l := 0 to 7 do
        begin
        read(f, d);
        font[c, l] := d;
        end;
close(f);
end;

procedure cleanMenu;
begin
setFillStyle(SolidFill, black);
bar(MENU_AREA_X, MENU_AREA_Y, getMaxX, getMaxY);
end;

procedure runSave;
var filename: string;
begin
printMenu('Enter filename');
readLn(filename);
save(filename);
printCurrentChar;
end;

procedure runLoad;
var filename: string;
begin
printMenu('Enter filename');
goToXy(2, 21);
readLn(filename);
load(filename);
paintAllFonts;
end;

procedure test;
var x, y: word;
    k: char;
begin
x := MENU_AREA_X;
y := MENU_AREA_Y;
cleanMenuArea;
repeat
      k := readKey;
      if (byte(k) >= 32) and (byte(k) <= 127) then
         begin
         paintFontXY(x, y, k);
         x := x + 16;
         end;
until k = char(13);
cleanMenuArea;
end;

procedure runMenu;
var k: char;
begin
printMenu('[L]oad, [S]ave, [Q]uit, [T]est, [C]ancel');
k := readKey;
case k of
     'L': runLoad;
     'S': runSave;
     'T': test;
     'Q': halt;
end;
cleanMenu;
end;

begin
init;
detectGraph(gd, gm);
initGraph(gd, gm, '');
setColor(white);
setBkColor(black);
displayRaster;
while true do
      begin
      k := readKey;
      b := byte(k);
      if (b >= 32) and (b <= 127) then
         begin
         currChar := k;
         paintRaster;
         editFont;
         end;
      if b = 27 then runMenu;
      end;
end.