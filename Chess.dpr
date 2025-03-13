program Chess;

uses
  Vcl.Forms,
  MainUnit in 'MainUnit.pas' {StartForm},
  Vcl.Themes,
  Vcl.Styles;

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.Title := 'Chess';
  TStyleManager.TrySetStyle('Windows11 Modern Dark');
  Application.CreateForm(TStartForm, StartForm);
  Application.Run;
end.
