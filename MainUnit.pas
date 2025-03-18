Unit MainUnit;

Interface

Uses
    Global, Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
    System.Classes, Vcl.Graphics,
    Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, Vcl.StdCtrls,
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
        Procedure BoardBoxPaint(Sender: TObject);
        Procedure FormResize(Sender: TObject);
        Function GetIndexOfCell(Const Points: TPoint): TPoint;
        Procedure BoardBoxClick(Sender: TObject);
        Procedure CreateGameBoard;
        Procedure getWays(x, y: integer);
        Procedure setWaysEmpty;
    procedure FormShow(Sender: TObject);
    procedure FormCreate(Sender: TObject);
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
    BOARD_COLORS: Array [Boolean, TFigureColors] Of Integer = (
        (ClWhite, ClWebCadetBlue),
        (clWebLightCoral, clWebBrown)
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
            end;

            Board[I][J].Value := 0;
        end;
end;

Function TStartForm.GetIndexOfCell(Const Points: TPoint): TPoint;
Var
    X, Y: Integer;
    Coord: TPoint;
Begin
    X := Points.Y;
    Y := Points.X;

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

Procedure TStartForm.getWays(x, y: integer);
begin
    board[x][y].IsAvaible := true;
    board[x + 1][y].IsAvaible := true;
end;

Procedure TStartForm.setWaysEmpty;
begin
    for var I := Low(board) to High(board) do
        for var J := Low(board) to High(board) do
            board[i][j].IsAvaible := false;
end;

Procedure TStartForm.BoardBoxClick(Sender: TObject);
Var
    Coord: TPoint;
Begin
    Coord := GetIndexOfCell(ScreenToClient(Mouse.CursorPos));

    if board[coord.x][coord.y].isFigure then
    begin
        setWaysEmpty;
        getWays(coord.x, coord.y);
    end
    else
        setWaysEmpty;

    BoardBox.Repaint;
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
                    Canvas.Brush.Color :=
                        BOARD_COLORS[board[i][j].IsAvaible and board[i][j].isFigure][CWhite]
                Else
                    Canvas.Brush.Color :=
                        BOARD_COLORS[board[i][j].IsAvaible and board[i][j].isFigure][CBlack];

                Canvas.Rectangle((I - 1) * CellWidth,
                    (J - 1) * CellWidth, I * CellWidth,
                    J * CellWidth);
            End;

    for I := Low(Board) to High(Board) do
        for J := Low(Board) to High(Board) do
            if board[i][j].isFigure then
            begin
                var DestRect := Rect((j-2)*CellWidth, (i-2)*CellWidth,
                    (j-2)*CellWidth + CellWidth, (i-2)*CellWidth + CellWidth);
                BoardBox.Canvas.StretchDraw(DestRect,
                    pieces[Board[I][J].Color][Board[I][J].Figure].Picture.Graphic);
            end;
End;

procedure TStartForm.FormCreate(Sender: TObject);
begin
    for var I := Low(TFigureColors) to High(TFigureColors) do
        for var J := Low(TFigures) to High(TFigures) do
            if let[I][J] <> '' then
            begin
                var filename: string := '../../pieces/'+let[I][J]+'.png';

                pieces[I][J] := TImage.Create(Self);
                pieces[I][J].Picture.LoadFromFile(filename);
            end;

end;

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
