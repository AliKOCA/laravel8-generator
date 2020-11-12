unit utility;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, LazUTF8;

function UTF8UppercaseFirstChar(s: string): string;

implementation

function UTF8UppercaseFirstChar(s: string): string;
var
  ch, rest: string;
begin
  ch := UTF8Copy(s, 1, 1);
  rest := Copy(s, Length(ch) + 1, MaxInt);
  Result := UTF8Uppercase(ch) + rest;
end;

end.

