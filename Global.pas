unit Global;

interface

uses Vcl.ExtCtrls;

type
    TFigures = (FPawn, FRook, FKnight, FBishop, FQueen, FKing, FNone);
    TFigureColors = (CWhite, CBlack);
    TCell = Record
        Value: Integer;
        IsAvaible: Boolean;
        Case isFigure: Boolean Of
            true:
                (Figure: TFigures;
                Color: TFigureColors;
                Pointer: TImage;)
        end;
    TBoardMatrix = Array Of Array Of TCell;

const StartBoard: Array [0..7, 0..7] Of TFigures = (
    (FRook, FKnight, FBishop, FQueen, FKing, FBishop, FKnight, FRook),
    (FPawn, FPawn, FPawn, FPawn, FPawn, FPawn, FPawn, FPawn),
    (FNone, FNone, FNone, FNone, FNone, FNone, FNone, FNone),
    (FNone, FNone, FNone, FNone, FNone, FNone, FNone, FNone),
    (FNone, FNone, FNone, FNone, FNone, FNone, FNone, FNone),
    (FNone, FNone, FNone, FNone, FNone, FNone, FNone, FNone),
    (FPawn, FPawn, FPawn, FPawn, FPawn, FPawn, FPawn, FPawn),
    (FRook, FKnight, FBishop, FQueen, FKing, FBishop, FKnight, FRook)
);
const let: array [TFigureColors, TFigures] of string =
    (('wp', 'wr', 'wn', 'wb', 'wq', 'wk', ''),
     ('bp', 'br', 'bn', 'bb', 'bq', 'bk', ''));

Function Min(A, B: Integer): Integer;

implementation

Function Min(A, B: Integer): Integer;
Begin
    If A > B Then
        Min := B
    Else
        Min := A;
End;

end.
