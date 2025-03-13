Unit MainUnit;

Interface

Uses
    Global, Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
    System.Classes, Vcl.Graphics,
    Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, Vcl.StdCtrls, GameUnit,
    Vcl.Menus, Vcl.Imaging.pngimage;

Type
    TStartForm = Class(TForm)
        MainMenu: TMainMenu;
        FileMenuBtn: TMenuItem;
        NewMenuBtn: TMenuItem;
        OpenMenuBtn: TMenuItem;
        SaveMenuBtn: TMenuItem;
        NotationMenuBtn: TMenuItem;
        Diver: TMenuItem;
        ExitMenuBtn: TMenuItem;
        HelpMenuBtn: TMenuItem;
        AboutGameMenuBtn: TMenuItem;
        AboutDevMenuBtn: TMenuItem;
        RulesMenuBtn: TMenuItem;
        BoardBox: TPaintBox;
        SettingsMainBtn: TMenuItem;
    ScrollBox1: TScrollBox;
        Procedure BoardBoxPaint(Sender: TObject);
        Procedure FormResize(Sender: TObject);
        Function GetIndexOfCell(Const Points: TPoint): TPoint;
        Procedure BoardBoxClick(Sender: TObject);
        Procedure CreateGameBoard;
    procedure FormShow(Sender: TObject);
    Private
        BoardWidth, CellWidth: Integer;
        Board: TBoardMatrix;
    Public
        { Public declarations }
    End;

Const
    BStart = 2;
    BEnd = 10;

Var
    StartForm: TStartForm;
    BOARD_COLORS: Array [TFigureColors] Of Integer = (
        ClWhite,
        ClWebCadetBlue
    );

Implementation

{$R *.dfm}

Procedure TStartForm.CreateGameBoard;
var
    I, J: integer;
begin
    SetLength(Board, 12, 12);
    for  I := 0 to High(Board) do
        for J := 0 to High(Board) do
            Board[I][J].Value := -1;

    var but := TBitmap.Create;

    for I := 2 to 9 do
        for J := 2 to 9 do
        begin
            Board[I][J].isFigure := StartBoard[I-2][J-2] <> FNONE;
            If Board[I][J].isFigure Then
            begin

                Board[I][J].Figure := StartBoard[I - 2][J - 2];
                if i > 6 then
                    Board[I][J].Color := cWhite
                else
                    Board[I][J].Color := cBlack;

                var piece: TImage;
                var filename: string := '../../pieces/'+let[Board[I][J].Color][Board[I][J].Figure]+'.png';

                piece := TImage.Create(Self);
                piece.Picture.LoadFromFile(filename);
                piece.Width := cellWidth;
                piece.Height := cellWidth;
                piece.Parent := ScrollBox1;
                piece.left := 20;
                piece.top := 20;
                Board[I][J].Pointer := piece;
                piece.Stretch := true;
            end;

            Board[I][J].Value := 0;
        end;
end;

Function TStartForm.GetIndexOfCell(Const Points: TPoint): TPoint;
Var
    X, Y: Integer;
    Coord: TPoint;
Begin
    X := Points.X;
    Y := Points.Y;

    Dec(X, BoardBox.Left);
    Dec(Y, BoardBox.Top);

    Coord.X := X Div CellWidth;
    Coord.Y := Y Div CellWidth;

    If (Coord.X > 7) Or (Coord.Y > 7) Or (X < 0) Or (Y < 0) Then
    Begin
        Coord.X := -1;
        Coord.Y := -1;
    End;

    GetIndexOfCell := Coord;
End;

Procedure TStartForm.BoardBoxClick(Sender: TObject);
Var
    Coord: TPoint;
Begin
    Coord := GetIndexOfCell(ScreenToClient(Mouse.CursorPos));
End;

Procedure TStartForm.BoardBoxPaint(Sender: TObject);
Var
    I, J: Integer;
Begin
    BoardWidth := Min(Self.ClientHeight, Self.ClientWidth) - 20;
    Dec(BoardWidth, BoardWidth Mod 8);
    CellWidth := BoardWidth Div 8;

    BoardBox.width := BoardWidth;
    BoardBox.height := BoardWidth;
    BoardBox.left := (self.Clientwidth - BoardBox.Width) div 2;
    BoardBox.top := (self.Clientheight - BoardBox.height) div 2;

    For I := 1 To 8 Do
        For J := 1 To 8 Do
            With BoardBox Do
            Begin
                If (I + J) Mod 2 = 0 Then
                    Canvas.Brush.Color := BOARD_COLORS[CWhite]
                Else
                    Canvas.Brush.Color := BOARD_COLORS[CBlack];

                Canvas.Rectangle((I - 1) * CellWidth,
                    (J - 1) * CellWidth, I * CellWidth,
                    J * CellWidth);
            End;

    for I := Low(Board) to High(Board) do
        for J := Low(Board) to High(Board) do
            if board[i][j].isFigure then
            begin
                var point := Board[i][j].Pointer;
                point.Width := cellWidth;
                point.Height := cellWidth;
                point.Left := 0;
                point.top := 0;
            end;
End;

Procedure TStartForm.FormResize(Sender: TObject);
Begin
    BoardBox.Repaint;
End;

procedure TStartForm.FormShow(Sender: TObject);
begin
   CreateGameBoard;
   BoardBox.Repaint;
end;

End.
