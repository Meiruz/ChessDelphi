Unit Global;

Interface

Uses Vcl.ExtCtrls, Vcl.Imaging.Pngimage, Winapi.Windows, Vcl.Graphics, Math,
    System.Classes, Vcl.StdCtrls, Vcl.Forms;

Type
    TFigures = (FPawn, FRook, FKnight, FBishop, FQueen, FKing, FNone);
    TFigureColors = (CWhite = 0, CBlack);

    TCell = Record
        Value: Integer;
        IsAvaible: Boolean;
        Case IsFigure: Boolean Of
            True: (Figure: TFigures;
                    Color: TFigureColors;)
    End;

    TBoardMatrix = Array Of Array Of TCell;

    TInterfaceText = (IAboutProg, IAboutDev, IRules, FFName, EError, EFileNotExist,
        EFileType, FormatName, SFormat);

Const
    INTERFACE_TEXT: Array [TInterfaceText] Of String = (
        // Information
        'Ivanov Pavel'#13#10'gr. 451004'#13#10'tg: @Meiruz',
        'Simple Chess Game: A two-player turn-based chess'#13#10+
        'program following standard rules, including piece'#13#10+
        'movement, checkmate, and special moves like castling.'#13#10+
        'Players input moves in algebraic notation, with'#13#10+
        'validation to prevent illegal plays.',
        'The goal is to checkmate the opponent''s king.'#13#10 +
        'The king moves 1 square in any direction. The queen '#13#10 +
        'moves any distance in any direction. The rook moves any distance'#13#10 +
        'straight. The bishop moves any distance diagonally. The knight'#13#10 +
        'moves in an "L"-shape (2 squares one way, then 1 square'#13#10 +
        'perpendicular). Pawns move forward 1 square (or 2 on their'#13#10+
        'first move) and capture diagonally. Special moves: '#13#10+
        'castling (king and rook swap under conditions), en passant'#13#10+
        ' (pawn captures another pawn that moved two squares), and'#13#10+
        ' promotion (pawn reaches the far rank, turns into any piece'#13#10+
        'except king). Check means the king is under attack; checkmate'#13#10+
        'means the king cannot escape. Stalemate is a draw (no legal'#13#10+
        'moves, but king not in check). The game also ends in a draw by'#13#10+
        'agreement, repetition, or the 50-move rule (no captures/pawn'#13#10+
        ' moves in 50 turns).',
        // First Form
        '451004 Ivanov Pavel', // Name
        // Error
        'Error!', // Title for messagebox
        'File not exist. Try again!', // File not exist
        'Error with file format. Please, try again!', // File format error
        // File Format
        'Chess game format', // Format name
        '.chess' // Format
        );

    StartBoard: Array [0 .. 7, 0 .. 7] Of TFigures = ((FRook, FKnight, FBishop,
        FQueen, FKing, FBishop, FKnight, FRook), (FPawn, FPawn, FPawn, FPawn,
        FPawn, FPawn, FPawn, FPawn), (FNone, FNone, FNone, FNone, FNone, FNone,
        FNone, FNone), (FNone, FNone, FNone, FNone, FNone, FNone, FNone, FNone),
        (FNone, FNone, FNone, FNone, FNone, FNone, FNone, FNone),
        (FNone, FNone, FNone, FNone, FNone, FNone, FNone, FNone),
        (FPawn, FPawn, FPawn, FPawn, FPawn, FPawn, FPawn, FPawn),
        (FRook, FKnight, FBishop, FQueen, FKing, FBishop, FKnight, FRook));

Const
    Let: Array [TFigureColors, TFigures] Of String =
        (('wp', 'wr', 'wn', 'wb', 'wq', 'wk', ''),
        ('bp', 'br', 'bn', 'bb', 'bq', 'bk', ''));

Var
    Pieces: Array [TFigureColors, TFigures] Of TPngImage;
    CastlingStates: Array [TFigureColors, 0 .. 2] Of Boolean =
        ((True, True, True), (True, True, True));
    // Left rock, right rock, king

Procedure InitializeBoard(Var Board: TBoardMatrix);
Procedure DrawPngStretchProportional(Canvas: TCanvas; DestRect: TRect;
    Png: TPNGImage);
Procedure CenterLabelOnScreen(Form: TForm; CurrentLabel: TLabel);

Implementation

Procedure InitializeBoard(Var Board: TBoardMatrix);
Begin
    SetLength(Board, 8, 8);
    For Var I := Low(Board) To High(Board) Do
        For Var J := Low(Board[I]) To High(Board[I]) Do
            With Board[I][J] Do
            Begin
                Value := 0;
                IsAvaible := False;

                If StartBoard[I][J] = FNone Then
                    IsFigure := False
                Else
                Begin
                    IsFigure := True;
                    Figure := StartBoard[I][J];
                    Color := CBlack;
                    If I > 4 Then
                        Color := CWhite;
                End;

            End;
End;

Procedure DrawPngStretchProportional(Canvas: TCanvas; DestRect: TRect;
    Png: TPNGImage);
Var
    Ratio: Double;
    NewWidth, NewHeight: Integer;
    NewRect: TRect;
Begin
    If (Png = Nil) Or (Png.Width = 0) Or (Png.Height = 0) Then
        Exit;

    Ratio := Min(DestRect.Width / Png.Width, DestRect.Height / Png.Height);
    NewWidth := Round(Png.Width * Ratio);
    NewHeight := Round(Png.Height * Ratio);

    NewRect := Rect(DestRect.Left + (DestRect.Width - NewWidth) Div 2,
        DestRect.Top + (DestRect.Height - NewHeight) Div 2,
        DestRect.Left + (DestRect.Width + NewWidth) Div 2,
        DestRect.Top + (DestRect.Height + NewHeight) Div 2);

    Canvas.StretchDraw(NewRect, Png);
End;

Procedure CenterLabelOnScreen(Form: TForm; CurrentLabel: TLabel);
begin
    with CurrentLabel do
        Left := (Form.ClientWidth - Width) div 2;
end;

End.
