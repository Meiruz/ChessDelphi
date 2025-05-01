unit EndProgramFormUnit;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.Imaging.pngimage,
  Vcl.ExtCtrls, Global, FigureCheckers, Vcl.ExtDlgs, PointStack;

type
  TEndGameForm = class(TForm)
    StatusLabel: TLabel;
    WinnerLabel: TLabel;
    NotationBtn: TButton;
    NewGameBtn: TButton;
    CloseBtn: TButton;
    BgImg: TImage;
    SaveTextFileDialog: TSaveTextFileDialog;
    procedure FormShow(Sender: TObject);
    procedure CloseBtnClick(Sender: TObject);
    procedure NewGameBtnClick(Sender: TObject);
    Procedure SaveNotation;
    Function IsFormatFile(Const Filename: String): Boolean;
    procedure NotationBtnClick(Sender: TObject);
  public
    gameState: TGameStatus;
    gameStack: PStack;
    winner: TFigureColors;
    CloseState: boolean;
  end;

var
  EndGameForm: TEndGameForm;

const
    WINNER_NAMES: Array [TFigureColors] of string = (
        'White victory', 'Black victory'
    );

Function OpenEndProgramForm(Form: TForm; formGameState: TGameStatus;
    formWinner: TFigureColors; history: PStack): boolean;

implementation

{$R *.dfm}

Function OpenEndProgramForm(Form: TForm; formGameState: TGameStatus;
    formWinner: TFigureColors; history: PStack): boolean;
begin
    with TEndGameForm.Create(Form) do
    try
        GameState := formGameState;
        gameStack := history;
        Winner := formWinner;
        ShowModal;

        Result := CloseState;
    finally
        Free;
    end;
end;

procedure TEndGameForm.FormShow(Sender: TObject);
begin
    CloseState := false;

    if gameState = GMate then
    begin
        StatusLabel.Caption := 'Mate';
        WinnerLabel.Caption := WINNER_NAMES[winner];
    end
    else
    begin
        StatusLabel.Caption := 'Statemate';
        WinnerLabel.Caption := 'Dead heat';
    end;

    CenterLabelOnScreen(Self, StatusLabel);
    CenterLabelOnScreen(Self, WinnerLabel);
end;

Function TEndGameForm.IsFormatFile(Const Filename: String): Boolean;
Var
    FormatStr: String;
Begin
    Result := False;
    FormatStr := '.txt';

    If Length(FormatStr) < Length(Filename) Then
    Begin
        Result := True;
        For Var I := Low(FormatStr) To High(FormatStr) Do
            Result := (Result) And
                (FormatStr[I] = Filename[High(Filename) -
                Length(FormatStr) + I]);
    End;
End;

Procedure TEndGameForm.SaveNotation;
begin
    SaveTextFileDialog.Filter := 'Text document | *.txt';

    With SaveTextFileDialog Do
        If (Execute(Self.Handle)) Then
        Begin
            If Not IsFormatFile(Filename) Then
                Filename := Filename + '.txt';
            SaveNotationToFile(gamestack, Filename);
        End;
end;


{
    *** Events ***
}
procedure TEndGameForm.CloseBtnClick(Sender: TObject);
begin
    Close;
end;

procedure TEndGameForm.NewGameBtnClick(Sender: TObject);
begin
    CloseState := true;
    Close;
end;

procedure TEndGameForm.NotationBtnClick(Sender: TObject);
begin
    SaveNotation;
end;

end.
