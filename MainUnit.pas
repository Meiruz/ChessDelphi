Unit MainUnit;

Interface

Uses
    Global, Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
    Vcl.Graphics,
    Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, Vcl.StdCtrls,
    Vcl.Menus, Vcl.Imaging.Pngimage, Vcl.Grids, Math, FigureCheckers,
    ModalPownChanging, PointStack,
    System.Classes, Vcl.ExtDlgs, Vcl.MPlayer, EndProgramFormUnit, SympleModalUnit;

Type
    TStartForm = Class(TForm)
        MainMenu: TMainMenu;
        FileMenuBtn: TMenuItem;
        NewMenuBtn: TMenuItem;
        OpenMenuBtn: TMenuItem;
        SaveMenuBtn: TMenuItem;
        Diver: TMenuItem;
        ExitMenuBtn: TMenuItem;
        HelpMenuBtn: TMenuItem;
        AboutGameMenuBtn: TMenuItem;
        AboutDevMenuBtn: TMenuItem;
        RulesMenuBtn: TMenuItem;
        GameField: TDrawGrid;
        OpenTextFileDialog: TOpenTextFileDialog;
        SaveTextFileDialog: TSaveTextFileDialog;
        ChessSound: TMediaPlayer;
        Procedure FormCreate(Sender: TObject);
        Procedure FormResize(Sender: TObject);
        Procedure GameFieldDrawCell(Sender: TObject; ACol, ARow: LongInt;
            Rect: TRect; State: TGridDrawState);
        Procedure SwapElement(ARow, ACol: Integer);
        Procedure SwapActiveUser;
        Procedure GameFieldSelectCell(Sender: TObject; ACol, ARow: LongInt;
            Var CanSelect: Boolean);
        Procedure ChangePawn(ARow, ACol: Integer);
        Procedure CastlingSwap(ARow, ACol: Integer);
        Procedure ClickToCell(ARow, ACol: Integer; UseStack: Boolean = True);
        Procedure SetPicesImages(Const PathToImages: String);
        Procedure StartNewGame;
        Procedure GetGameDataFromFile;
        Procedure NewMenuBtnClick(Sender: TObject);
        Procedure OpenMenuBtnClick(Sender: TObject);
        Function IsFormatFile(Const Filename: String;
            IsMessage: Boolean = False): Boolean;
        Function IsFileExist(Const Filename: String): Boolean;
        Procedure SaveGameDataToFile;
        Procedure RunStack;
        Procedure SaveMenuBtnClick(Sender: TObject);
        Procedure ExitMenuBtnClick(Sender: TObject);
        Procedure EndGame(Winner: TFigureColors);
    procedure RulesMenuBtnClick(Sender: TObject);
    procedure AboutGameMenuBtnClick(Sender: TObject);
    procedure AboutDevMenuBtnClick(Sender: TObject);
    Private
        BoardWidth, CellWidth: Integer;
        Board: TBoardMatrix;
        ActiveRow, ActiveCol: Integer;
        ActiveUser: TFigureColors;
        GameStatus: TGameStatus;
        GameStack: PStack;
    End;

Const
    BStart = 2;
    BEnd = 10;

Var
    StartForm: TStartForm;
    BOARD_COLORS: Array [Boolean, 0 .. 1] Of Integer =
        ((ClWhite, ClWebCadetBlue), (ClWebLightCoral, ClWebBrown));

Implementation

{$R *.dfm}

{
  *** Form Settings ***
}
Procedure TStartForm.StartNewGame;
Begin
    InitializeBoard(Board);
    New(GameStack);
    GameStack^.First := Nil;

    ActiveUser := CWhite;
    GameStatus := GNone;

    GameField.Invalidate;
End;

Procedure TStartForm.FormCreate(Sender: TObject);
Begin
    DoubleBuffered := True;
    GameField.DoubleBuffered := True;

    SetPicesImages('pieces/');
    ChessSound.FileName := 'sound.mp3';

    StartNewGame;

    var Scale: real := Screen.PixelsPerInch / 96;

    Constraints.MinWidth := Round(400*Scale);
    Constraints.MinHeight := Round(400*Scale);
End;

Procedure TStartForm.SetPicesImages(Const PathToImages: String);
Var
    Filename: String;
Begin
    For Var I := Low(TFigureColors) To High(TFigureColors) Do
        For Var J := Low(TFigures) To High(TFigures) Do
            If Let[I][J] <> '' Then
            Begin
                Filename := PathToImages + Let[I][J] + '.png';

                Pieces[I][J] := TPngImage.Create;
                Pieces[I][J].LoadFromFile(Filename);
            End;
End;

Procedure TStartForm.FormResize(Sender: TObject);
Var
    NewWidth, NewHeight: Integer;
Begin
    Var
    Margin := 15;

    NewWidth := ClientWidth;
    NewHeight := ClientHeight;

    With GameField Do
    Begin
        ClientWidth := Min(NewHeight, NewWidth) - Margin * 2;
        ClientWidth := ClientWidth - ClientWidth Mod 8;
        Height := Width;

        Left := (NewWidth - Width) Div 2;
        Top := (NewHeight - Height) Div 2;

        ColCount := 8;
        RowCount := 8;
        DefaultColWidth := (ClientWidth - GridLineWidth) Div 8 - 1;
        DefaultRowHeight := (ClientHeight - GridLineWidth) Div 8 - 1;
    End;
End;

{
  *** Interaction with player ***
}
Procedure TStartForm.EndGame(Winner: TFigureColors);
Begin
    GameField.Invalidate;
    If OpenEndProgramForm(Self, Self.GameStatus,
        NextColor(Self.ActiveUser), self.GameStack) Then
        StartNewGame
    Else
        Close;
End;

Procedure TStartForm.ChangePawn(ARow, ACol: Integer);
Begin
    Var
    Form := TPownChangingForm.Create(Self);
    Try
        Form.ShowModal;
        Board[ARow][ACol].Figure := Form.CurrentValue;
    Finally
        Form.Free;
    End;
End;

Procedure TStartForm.CastlingSwap(ARow, ACol: Integer);
    Procedure Swap(ACol1, ACol2: Integer);
    Begin
        Board[ARow][ACol1].IsFigure := True;
        Board[ARow][ACol1].Figure := Board[ARow][ACol2].Figure;
        Board[ARow][ACol1].Color := Board[ARow][ACol2].Color;
        Board[ARow][ACol2].IsFigure := False;
    End;

Begin
    If (ACol = 1) Then
        Swap(ACol + 1, ACol - 1)
    Else
        Swap(ACol - 1, ACol + 1);
End;

Procedure TStartForm.SwapElement(ARow, ACol: Integer);
Begin
    With Board[ARow, ACol] Do
    Begin
        IsFigure := True;
        Color := Board[ActiveRow][ActiveCol].Color;
        Figure := Board[ActiveRow][ActiveCol].Figure;

        If (Figure = FPawn) And (ARow = Ord(Color) * 7) Then
            ChangePawn(ARow, ACol);

        If (Figure = FKing) Then
            CastlingStates[Color][2] := False;

        If (Figure = FRook) And (ARow = 7 * (1 - Ord(Color))) Then
            CastlingStates[Color][ACol Mod 2] := False;

        If Value = -2 Then
            CastlingSwap(ARow, ACol);
    End;

    Board[ActiveRow][ActiveCol].IsFigure := False;
    ClearCells(Self.Board);

    SwapActiveUser;
End;

Procedure TStartForm.SwapActiveUser;
Begin
    ActiveUser := NextColor(ActiveUser);
End;

Procedure TStartForm.ClickToCell(ARow, ACol: Integer; UseStack: Boolean = True);
Begin
    If Board[ARow][ACol].IsAvaible Then
    Begin
        If UseStack Then
        Begin
            ChessSound.Open;
            ChessSound.Play;

            AddElement(GameStack, ARow, ACol,
                Board[Self.ActiveRow][Self.ActiveCol].figure);
        End;

        SwapElement(ARow, ACol);
        CheckGameStatus(Board, ActiveUser, GameStatus);
        ClearCells(Board);

        If (GameStatus = GMate) Or (GameStatus = GStatemate) Then
            EndGame(NextColor(ActiveUser));
    End
    Else
        If (Board[ARow][ACol].IsFigure) And
            (Board[ARow][ACol].Color = ActiveUser) Then
        Begin
            If UseStack Then
                AddElement(GameStack, ARow, ACol, FNone);

            Self.ActiveRow := ARow;
            Self.ActiveCol := ACol;

            CheckWays(Board, ARow, ACol);
            deleteCastlingIfCheck(Board, gameStatus);
            DeleteBadPoints(Board, ARow, ACol, GameStatus);
        End
        Else
            ClearCells(Self.Board);

    GameField.Invalidate;
End;

{
  *** File working ***
}
Function TStartForm.IsFormatFile(Const Filename: String;
    IsMessage: Boolean = False): Boolean;
Var
    FormatStr: String;
Begin
    Result := False;
    FormatStr := INTERFACE_TEXT[SFormat];

    If Length(FormatStr) < Length(Filename) Then
    Begin
        Result := True;
        For Var I := Low(FormatStr) To High(FormatStr) Do
            Result := (Result) And
                (FormatStr[I] = Filename[High(Filename) -
                Length(FormatStr) + I]);
    End;

    If (IsMessage) And (Not Result) Then
        Application.MessageBox(PWideChar(INTERFACE_TEXT[EFileType]),
            PWideChar(INTERFACE_TEXT[EError]), MB_OK Or MB_ICONERROR);
End;

Function TStartForm.IsFileExist(Const Filename: String): Boolean;
Begin
    Result := FileExists(Filename);
    If Not Result Then
        Application.MessageBox(PWideChar(INTERFACE_TEXT[EFileNotExist]),
            PWideChar(INTERFACE_TEXT[EError]), MB_OK Or MB_ICONERROR);
End;

Procedure TStartForm.GetGameDataFromFile;
Begin
    OpenTextFileDialog.Filter := INTERFACE_TEXT[FormatName] + '| *' +
        INTERFACE_TEXT[SFormat];

    With OpenTextFileDialog Do
        If (Execute(Self.Handle)) And (IsFormatFile(Filename, True)) And
            (IsFileExist(Filename)) Then
        Begin
            StartNewGame;
            ImportElementsFromFile(GameStack, Filename);
            RunStack;
        End;
End;

Procedure TStartForm.RunStack;
Var
    CurrentElement: PElement;
Begin
    CurrentElement := GameStack^.First;
    While CurrentElement <> Nil Do
    Begin
        ClickToCell(CurrentELement^.Value^.X, CurrentELement^.Value^.Y, False);
        CurrentElement := CurrentElement^.Next;
    End;
End;

Procedure TStartForm.SaveGameDataToFile;
Begin
    SaveTextFileDialog.Filter := INTERFACE_TEXT[FormatName] + '| *' +
        INTERFACE_TEXT[SFormat];

    With SaveTextFileDialog Do
        If (Execute(Self.Handle)) Then
        Begin
            If Not IsFormatFile(Filename) Then
                Filename := Filename + INTERFACE_TEXT[SFormat];
            SaveElementsToFile(GameStack, Filename);
        End;
End;

{
  *** Events ***
}
Procedure TStartForm.GameFieldSelectCell(Sender: TObject; ACol, ARow: LongInt;
    Var CanSelect: Boolean);
Begin
    ClickToCell(ARow, ACol);
End;

Procedure TStartForm.GameFieldDrawCell(Sender: TObject; ACol, ARow: LongInt;
    Rect: TRect; State: TGridDrawState);
Var
    Grid: TDrawGrid;
Begin
    Grid := Sender As TDrawGrid;

    Grid.Canvas.Brush.Color := BOARD_COLORS[False][(ACol + ARow) Mod 2];
    Grid.Canvas.FillRect(Rect);

    With Board[ARow][ACol] Do
        If IsFigure And (Pieces[Color][Figure] <> Nil) Then
        Begin
            If IsAvaible Then
            Begin
                Grid.Canvas.Brush.Color := ClWebOrangeRed;
                Grid.Canvas.FillRect(Rect);
            End;
            If (GameStatus = GCheck) And (Figure = FKing) And
                (Color = ActiveUser) Then
            Begin
                Grid.Canvas.Brush.Color := clPurple;
                Grid.Canvas.FillRect(Rect);
            End;
            DrawPngStretchProportional(Grid.Canvas, Rect,
                Pieces[Color][Figure]);
        End
        Else
            If IsAvaible Then
            Begin
                Var
                Margin := Round(Rect.Width - Rect.Width * 0.4) Div 2;

                If Value = -2 Then
                    Grid.Canvas.Brush.Color := ClWebCornFlowerBlue
                Else
                    Grid.Canvas.Brush.Color := ClWebMediumSeaGreen;

                Grid.Canvas.Ellipse(Rect.Left + Margin, Rect.Top + Margin,
                    Rect.Left + Rect.Width - Margin,
                    Rect.Top + Rect.Width - Margin);
            End;
End;

Procedure TStartForm.NewMenuBtnClick(Sender: TObject);
Begin
    StartNewGame;
End;

Procedure TStartForm.OpenMenuBtnClick(Sender: TObject);
Begin
    GetGameDataFromFile;
    GameField.Invalidate;
End;

Procedure TStartForm.SaveMenuBtnClick(Sender: TObject);
Begin
    SaveGameDataToFile;
    Application.MessageBox('Game data has been saved successful!', 'Saved!',
        MB_OK Or MB_ICONINFORMATION);
End;

Procedure TStartForm.ExitMenuBtnClick(Sender: TObject);
Begin
    Close;
End;

procedure TStartForm.RulesMenuBtnClick(Sender: TObject);
begin
    OpenSympleModal(Self, 'Rules', INTERFACE_TEXT[IRules]);
end;

procedure TStartForm.AboutDevMenuBtnClick(Sender: TObject);
begin
    OpenSympleModal(Self, 'About developer', INTERFACE_TEXT[IAboutDev]);
end;

procedure TStartForm.AboutGameMenuBtnClick(Sender: TObject);
begin
    OpenSympleModal(Self, 'About game', INTERFACE_TEXT[IAboutProg]);
end;



End.
