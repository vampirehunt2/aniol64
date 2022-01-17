unit Font8x8;

interface

type TFont8x8 = array[0..127, 0..7] of byte;

var font: TFont8x8;

procedure saveFont8x8(path: string);

procedure loadFont8x8(path: string);

implementation

procedure saveFont8x8(path: string);
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

procedure loadFont8x8(path: string);
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

end.