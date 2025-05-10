Unit PointStack;

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

    PStack = ^TStack;

    TStack = Record
        Head: PElement;
        First: PElement;
    End;

    TPointFile = File Of TPoints;

Procedure DeleteStck(Stack: PStack);
Procedure AddElement(Stack: PStack; X, Y: ShortInt; Figure: TFigures);
Procedure PopElement(Stack: PStack);
Function IsEmptyStack(Stack: PStack): Boolean;

Procedure SaveElementsToFile(Stack: PStack; Const Filepath: String);
Procedure ImportElementsFromFile(Stack: PStack; Const Filepath: String);

Procedure SaveNotationToFile(Stack: PStack; Const Filepath: String);

Implementation

Procedure DeleteStck(Stack: PStack);
Begin
    While Stack.First <> Nil Do
        PopElement(Stack);
    Dispose(Stack);
End;

Procedure AddElement(Stack: PStack; X, Y: ShortInt; Figure: TFigures);
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

    If Stack^.Head = Nil Then
    Begin
        Stack^.Head := Element;
        Stack^.First := Element;
    End
    Else
    Begin
        Element^.Prev := Stack^.Head;
        Stack^.Head^.Next := Element;
        Stack^.Head := Element;
    End;
End;

Procedure PopElement(Stack: PStack);
Var
    Temp: PElement;
    Points: PPoints;
Begin
    If Stack^.Head <> Nil Then
    Begin
        Temp := Stack^.Head;
        Stack^.Head := Temp^.Prev;
        Dispose(Temp);

        If Stack^.Head = Nil Then
            Stack^.First := Nil;
    End;
End;

Function IsEmptyStack(Stack: PStack): Boolean;
Begin
    IsEmptyStack := Stack^.First = Nil;
End;

Procedure SaveElementsToFile(Stack: PStack; Const Filepath: String);
Var
    CurrentPoint: PElement;
    OFile: TPointFile;
Begin
    AssignFile(OFile, Filepath);
    Rewrite(OFile);
    Seek(OFile, 0);

    CurrentPoint := Stack^.First;
    While CurrentPoint <> Nil Do
    Begin
        Write(OFile, CurrentPoint^.Value^);
        CurrentPoint := CurrentPoint^.Next;
    End;

    CloseFile(OFile);
End;

Procedure SaveNotationToFile(Stack: PStack; Const Filepath: String);
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
    CurrentPoint := Stack^.First;
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

Procedure ImportElementsFromFile(Stack: PStack; Const Filepath: String);
Var
    OFile: TPointFile;
    Point: TPoints;
Begin
    If Stack^.First = Nil Then
    Begin
        AssignFile(OFile, Filepath);
        Reset(OFile);
        Seek(OFile, 0);

        While Not EOF(OFile) Do
        Begin
            Read(OFile, Point);
            AddElement(Stack, Point.X, Point.Y, Point.Figure);
        End;

        CloseFile(OFile);
    End;
End;

End.
