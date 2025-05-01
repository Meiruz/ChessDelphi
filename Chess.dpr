program Chess;

uses
  Vcl.Forms,
  MainUnit in 'MainUnit.pas' {StartForm},
  Vcl.Themes,
  Vcl.Styles,
  Global in 'Global.pas',
  FigureCheckers in 'FigureCheckers.pas',
  ModalPownChanging in 'ModalPownChanging.pas' {PownChangingForm},
  PointStack in 'PointStack.pas',
  EndProgramFormUnit in 'EndProgramFormUnit.pas' {EndGameForm},
  SympleModalUnit in 'SympleModalUnit.pas' {SympleModalForm};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  TStyleManager.TrySetStyle('Windows11 Modern Dark');
  Application.Title := 'Chess';
  Application.CreateForm(TStartForm, StartForm);
  Application.CreateForm(TPownChangingForm, PownChangingForm);
  Application.CreateForm(TEndGameForm, EndGameForm);
  Application.CreateForm(TSympleModalForm, SympleModalForm);
  Application.Run;
end.
