program FontVisualiser;

uses graph,
     dos;

var f: file of byte;
    gd, gm: integer;
    b, b0, i: byte;
    x, y: word;
    c: word;

begin
assign(f, 'bitmapgn.bin');
reset(f);
detectgraph(gd, gm);
initgraph(gd, gm, '');
for y := 1 to 240 do
    for x := 1 to 64 do
        begin
        read(f, b0);
        for i := 0 to 7 do
            begin
            b := b0 and 128;
            c := black;
            if b > 0 then c:= white;
            putpixel((x - 1) * 16 + i * 2 + 1, (y - 1) * 2 + 1, c);
            putpixel((x - 1) * 16 + i * 2 + 2, (y - 1) * 2 + 1, c);
            putpixel((x - 1) * 16 + i * 2 + 1, (y - 1) * 2 + 2, c);
            putpixel((x - 1) * 16 + i * 2 + 2, (y - 1) * 2 + 2, c);
            b0 := b0 shl 1;
            end;
        end;
close(f);
readln;
end.