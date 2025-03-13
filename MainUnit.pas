Unit MainUnit;

Interface

Uses
    Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
    System.Classes, Vcl.Graphics,
    Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, Vcl.StdCtrls, GameUnit,
    Vcl.Menus, Global;

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
        PaintBox: TPaintBox;
        SettingsMainBtn: TMenuItem;
        Procedure FormCreate(Sender: TObject);
        Procedure PaintBoxPaint(Sender: TObject);
        Procedure FormResize(Sender: TObject);
        Function GetIndexOfCell(Const Points: TPoint): TPoint;
        Procedure PaintBoxClick(Sender: TObject);
        Procedure PaintBoxMouseMove(Sender: TObject; Shift: TShiftState;
            X, Y: Integer);
        Procedure CreateGameBoard;
    Private
        BoardWidth, CellWidth, StartX, StartY: Integer;
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

Procedure TStartForm.FormCreate(Sender: TObject);
Begin
    CreateGameBoard;
    PaintBox.Repaint;
End;

Procedure TStartForm.CreateGameBoard;
begin
    SetLength(Board, 12, 12);
    for var I := 0 to High(Board) do
        for var J := 0 to High(Board) do
            Board[I][J].Value := -1;

    for var I := BStart to BEnd do
        for var J := BStart to BEnd do
        begin
            Board[I][J].Figure := King;
            if i = j then
                Board[I][J].Color := Black
            else
                Board[I][J].Color := White;
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

    Dec(X, StartX);
    Dec(Y, StartY);

    Coord.X := X Div CellWidth;
    Coord.Y := Y Div CellWidth;

    If (Coord.X > 7) Or (Coord.Y > 7) Or (X < 0) Or (Y < 0) Then
    Begin
        Coord.X := -1;
        Coord.Y := -1;
    End;

    GetIndexOfCell := Coord;
End;

Procedure TStartForm.PaintBoxClick(Sender: TObject);
Var
    Coord: TPoint;
Begin
    Coord := GetIndexOfCell(ScreenToClient(Mouse.CursorPos));
End;

Procedure TStartForm.PaintBoxMouseMove(Sender: TObject; Shift: TShiftState;
    X, Y: Integer);
Var
    Point: TPoint;
Begin
    Point := ScreenToClient(Mouse.CursorPos);

    If (Point.X > StartX) And (Point.X < StartX + BoardWidth) And
        (Point.Y > StartY) And (Point.Y < StartY + BoardWidth) Then
        PaintBox.Cursor := crHandPoint
    else
        PaintBox.Cursor := crDefault;
End;

Procedure TStartForm.PaintBoxPaint(Sender: TObject);
Var
    I, J: Integer;
Begin
    BoardWidth := Min(Self.ClientHeight, Self.ClientWidth) - 20;
    Dec(BoardWidth, BoardWidth Mod 8);
    CellWidth := BoardWidth Div 8;

    StartX := (Self.ClientWidth - BoardWidth) Div 2;
    StartY := (Self.ClientHeight - BoardWidth) Div 2;

    For I := 1 To 8 Do
        For J := 1 To 8 Do
            With PaintBox Do
            Begin
                If (I + J) Mod 2 = 0 Then
                    Canvas.Brush.Color := BOARD_COLORS[White]
                Else
                    Canvas.Brush.Color := BOARD_COLORS[Black];

                Canvas.Rectangle(StartX + (I - 1) * CellWidth,
                    StartY + (J - 1) * CellWidth, StartX + I * CellWidth,
                    StartY + J * CellWidth);
            End;

    For I := BStart To BEnd Do
        For J := BStart To Bend Do
            With Board[I][J] Do
            Begin
                
            End;
End;

Procedure TStartForm.FormResize(Sender: TObject);
Begin
    PaintBox.Repaint;
End;

End.
