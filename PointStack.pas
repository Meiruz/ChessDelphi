Unit PointStack;

Interface

uses
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
Procedure AddElement(Stack: PStack; X, Y: ShortInt; figure: TFigures);
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

Procedure AddElement(Stack: PStack; X, Y: ShortInt; figure: TFigures);
Var
    Element: PElement;
    Points: PPoints;
Begin
    New(Points);
    Points^.X := X;
    Points^.Y := Y;
    Points^.Figure := figure;

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
    CurrentPoint, PrevPoint: PElement;
    OFile: TextFile;
Const
    FIGURE_SYM: Array [TFigures] Of Char = (
        #0, 'R', 'N', 'B', 'Q', 'K', #0
    );

    Function PosToStr(x, y: shortInt): string;
    begin
        Result := Char(ord('a') + 7-x) + Char(ord('1') + 7-y) ;
    end;
Begin
    AssignFile(OFile, Filepath);
    Rewrite(OFile);

    CurrentPoint := Stack^.First;
    PrevPoint := Stack^.First;
    While CurrentPoint <> Nil Do
    Begin
        if CurrentPoint^.Value^.Figure <> FNone then
        begin
            Write(OFile, FIGURE_SYM[CurrentPoint^.Value^.Figure]);
            Write(OFile, PosToStr(PrevPoint^.Value^.X, PrevPoint^.Value^.Y));
            Writeln(OFile, PosToStr(CurrentPoint^.Value^.X, CurrentPoint^.Value^.Y));
        end;

        PrevPoint := CurrentPoint;
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
