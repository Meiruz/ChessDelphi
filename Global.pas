unit Global;

interface

type
    TFigures = (King, None);
    TFigureColors = (White, Black);
    TCell = Record
        Figure: TFigures;
        Color: TFigureColors;
        Value: Integer;
        IsAvaible: Boolean;
    End;
    TBoardMatrix = Array Of Array Of TCell;

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
