Unit PointList;

Interface

Uses
    Global;

Type
    PPoints = ^TPoints;

    TPoints = Record
        Figure: TFigures;
        X, Y: ShortInt;
    End;

    PElement = ^TElement;

    TElement = Record
        Value: PPoints;
        Next, Prev: PElement;
    End;

    PPointList = ^TPointList;

    TPointList = Record
        Head: PElement;
        First: PElement;
    End;

    TPointFile = File Of TPoints;

Procedure DeleteList(List: PPointList);
Procedure AddElement(List: PPointList; X, Y: ShortInt; Figure: TFigures);
Procedure PopElement(List: PPointList);
Function IsEmptyList(List: PPointList): Boolean;

Procedure SaveElementsToFile(List: PPointList; Const Filepath: String);
Procedure ImportElementsFromFile(List: PPointList; Const Filepath: String);

Procedure SaveNotationToFile(List: PPointList; Const Filepath: String);

Implementation

Procedure DeleteList(List: PPointList);
Begin
    While List.First <> Nil Do
        PopElement(List);
    Dispose(List);
End;

Procedure AddElement(List: PPointList; X, Y: ShortInt; Figure: TFigures);
Var
    Element: PElement;
    Points: PPoints;
Begin
    New(Points);
    Points^.X := X;
    Points^.Y := Y;
    Points^.Figure := Figure;

    New(Element);
    Element^.Value := Points;

    If List^.Head = Nil Then
    Begin
        List^.Head := Element;
        List^.First := Element;
    End
    Else
    Begin
        Element^.Prev := List^.Head;
        List^.Head^.Next := Element;
        List^.Head := Element;
    End;
End;

Procedure PopElement(List: PPointList);
Var
    Temp: PElement;
    Points: PPoints;
Begin
    If List^.Head <> Nil Then
    Begin
        Temp := List^.Head;
        List^.Head := Temp^.Prev;
        Dispose(Temp);

        If List^.Head = Nil Then
            List^.First := Nil;
    End;
End;

Function IsEmptyList(List: PPointList): Boolean;
Begin
    IsEmptyList := List^.First = Nil;
End;

Procedure SaveElementsToFile(List: PPointList; Const Filepath: String);
Var
    CurrentPoint: PElement;
    OFile: TPointFile;
Begin
    AssignFile(OFile, Filepath);
    Rewrite(OFile);
    Seek(OFile, 0);

    CurrentPoint := List^.First;
    While CurrentPoint <> Nil Do
    Begin
        Write(OFile, CurrentPoint^.Value^);
        CurrentPoint := CurrentPoint^.Next;
    End;

    CloseFile(OFile);
End;

Procedure SaveNotationToFile(List: PPointList; Const Filepath: String);
Var
    CurrentPoint: PElement;
    OFile: TextFile;
    i: byte;
Const
    FIGURE_SYM: Array [TFigures] Of Char = (#0, 'R', 'N', 'B', 'Q', 'K', #0);

    Function PosToStr(X, Y: ShortInt): String;
    Begin
        Result := Char(Ord('a') + Y) + Char(Ord('1') + 7 - X);
    End;

Begin
    AssignFile(OFile, Filepath);
    Rewrite(OFile);

    i := 0;
    CurrentPoint := List^.First;
    While CurrentPoint <> Nil Do
    Begin
        If CurrentPoint^.Value^.Figure <> FNone Then
        Begin
            if i = 1 then
                write(OFile, ' - ');

            Write(OFile, FIGURE_SYM[CurrentPoint^.Value^.Figure]);
            Write(OFile, PosToStr(CurrentPoint^.Value^.X,
                CurrentPoint^.Value^.Y));

            if i = 1 then
                writeln(OFile);

            i := (i + 1) mod 2;
        End;

        CurrentPoint := CurrentPoint^.Next;
    End;

    CloseFile(OFile);
End;

Procedure ImportElementsFromFile(List: PPointList; Const Filepath: String);
Var
    OFile: TPointFile;
    Point: TPoints;
Begin
    If List^.First = Nil Then
    Begin
        AssignFile(OFile, Filepath);
        Reset(OFile);
        Seek(OFile, 0);

        While Not EOF(OFile) Do
        Begin
            Read(OFile, Point);
            AddElement(List, Point.X, Point.Y, Point.Figure);
        End;

        CloseFile(OFile);
    End;
End;

End.
