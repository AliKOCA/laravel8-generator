program laravel8_generator;

{$mode objfpc}{$H+}

uses {$IFDEF UNIX} {$IFDEF UseCThreads}
  cthreads, {$ENDIF} {$ENDIF}
  Interfaces, // this includes the LCL widgetset
  Forms,
  zcomponent,
  w__lg__ana,
  dm__lg__01, utility { you can add units after this };

{$R *.res}

begin
  RequireDerivedFormResource := True;
  Application.Scaled := True;
  Application.Initialize;
  Application.CreateForm(Tdm01, dm01);
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.

