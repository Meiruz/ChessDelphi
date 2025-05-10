Unit EndProgramFormUnit;

Interface

Uses
    Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
    System.Classes, Vcl.Graphics,
    Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.Imaging.Pngimage,
    Vcl.ExtCtrls, Global, FigureCheckers, Vcl.ExtDlgs, PointStack;

Type
    TEndGameForm = Class(TForm)
        StatusLabel: TLabel;
        WinnerLabel: TLabel;
        NotationBtn: TButton;
        NewGameBtn: TButton;
        CloseBtn: TButton;
        BgImg: TImage;
        SaveTextFileDialog: TSaveTextFileDialog;
        Procedure FormShow(Sender: TObject);
        Procedure CloseBtnClick(Sender: TObject);
        Procedure NewGameBtnClick(Sender: TObject);
        Procedure SaveNotation;
        Function IsFormatFile(Const Filename: String): Boolean;
        Procedure NotationBtnClick(Sender: TObject);
    Public
        GameState: TGameStatus;
        GameStack: PStack;
        Winner: TFigureColors;
        CloseState: Boolean;
    End;

Var
    EndGameForm: TEndGameForm;

Const
    WINNER_NAMES: Array [TFigureColors] Of String = ('White victory',
        'Black victory');

Function OpenEndProgramForm(Form: TForm; FormGameState: TGameStatus;
    FormWinner: TFigureColors; History: PStack): Boolean;

Implementation

{$R *.dfm}

Function OpenEndProgramForm(Form: TForm; FormGameState: TGameStatus;
    FormWinner: TFigureColors; History: PStack): Boolean;
Begin
    With TEndGameForm.Create(Form) Do
        Try
            GameState := FormGameState;
            GameStack := History;
            Winner := FormWinner;
            ShowModal;

            Result := CloseState;
        Finally
            Free;
        End;
End;

Procedure TEndGameForm.FormShow(Sender: TObject);
Begin
    CloseState := False;

    If GameState = GMate Then
    Begin
        StatusLabel.Caption := 'Mate';
        WinnerLabel.Caption := WINNER_NAMES[Winner];
    End
    Else
    Begin
        StatusLabel.Caption := 'Statemate';
        WinnerLabel.Caption := 'Dead heat';
    End;

    CenterLabelOnScreen(Self, StatusLabel);
    CenterLabelOnScreen(Self, WinnerLabel);
End;

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
Begin
    SaveTextFileDialog.Filter := 'Text document | *.txt';

    With SaveTextFileDialog Do
        If (Execute(Self.Handle)) Then
        Begin
            If Not IsFormatFile(Filename) Then
                Filename := Filename + '.txt';
            SaveNotationToFile(Gamestack, Filename);
            Application.MessageBox('Notation has been saved!',
                'Success', MB_OK Or MB_ICONINFORMATION);
        End;
End;

{
  *** Events ***
}
Procedure TEndGameForm.CloseBtnClick(Sender: TObject);
Begin
    Close;
End;

Procedure TEndGameForm.NewGameBtnClick(Sender: TObject);
Begin
    CloseState := True;
    Close;
End;

Procedure TEndGameForm.NotationBtnClick(Sender: TObject);
Begin
    SaveNotation;
End;

End.
