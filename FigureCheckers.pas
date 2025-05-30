﻿Unit FigureCheckers;

Interface

Uses Global;

Type
    TProc = Procedure(Const Board: TBoardMatrix; ACol, ARow: Integer);
    TGameStatus = (GNone, GMate, GCheck, GStatemate);

Procedure CheckWays(Const Board: TBoardMatrix; ARow, ACol: Integer);
Procedure ClearCells(Const Board: TBoardMatrix);

Procedure PawnCheck(Const Board: TBoardMatrix; ACol, ARow: Integer);
Procedure RookCheck(Const Board: TBoardMatrix; ACol, ARow: Integer);
Procedure KnightCheck(Const Board: TBoardMatrix; ACol, ARow: Integer);
Procedure BishopCheck(Const Board: TBoardMatrix; ACol, ARow: Integer);
Procedure QueenCheck(Const Board: TBoardMatrix; ACol, ARow: Integer);
Procedure KingCheck(Const Board: TBoardMatrix; ACol, ARow: Integer);

Procedure CheckAllWays(Const Board: TBoardMatrix; Color: TFigureColors);
Procedure CheckGameStatus(Const Board: TBoardMatrix;
    CurrentColor: TFigureColors; Var GameStatus: TGameStatus);

Procedure DeleteBadPoints(Const Board: TBoardMatrix; ARow, ACol: Integer;
    GameStatus: TGameStatus);
Function NextColor(Color: TFigureColors): TFigureColors;
Procedure DeleteCastlingIfCheck(Const Board: TBoardMatrix;
    GameStatus: TGameStatus);

Var
    GetWaysFuntions: Array [TFigures] Of TProc = (
        PawnCheck,
        RookCheck,
        KnightCheck,
        BishopCheck,
        QueenCheck,
        KingCheck,
        PawnCheck
    );

Implementation

Procedure ClearCells(Const Board: TBoardMatrix);
Begin
    For Var I := Low(Board) To High(Board) Do
        For Var J := Low(Board) To High(Board) Do
            Board[I][J].IsAvaible := False;
End;

Procedure ClearValues(Const Board: TBoardMatrix);
Begin
    For Var I := Low(Board) To High(Board) Do
        For Var J := Low(Board) To High(Board) Do
            Board[I][J].Value := 0;
End;

Procedure CheckWays(Const Board: TBoardMatrix; ARow, ACol: Integer);
Begin
    ClearCells(Board);
    ClearValues(Board);

    GetWaysFuntions[Board[ARow][ACol].Figure](Board, ACol, ARow);
End;

Function Check(A: Integer; Const Board: TBoardMatrix): Boolean;
Begin
    Check := (A >= Low(Board)) And (A <= High(Board));
End;

Function CheckFigureColor(Const Board: TBoardMatrix;
    X1, Y1, X2, Y2: Integer): Boolean;
Begin
    If Board[X1, Y1].IsFigure Then
        CheckFigureColor := (Board[X1, Y1].Color <> Board[X2, Y2].Color)
    Else
        CheckFigureColor := True;
End;

Function SimpleCheckingForAvaible(Const Board: TBoardMatrix;
    X, Y, Dx, Dy: Integer): Boolean;
Begin
    If (Check(X + Dx, Board)) And (Check(Y + Dy, Board)) And
        CheckFigureColor(Board, X + Dx, Y + Dy, X, Y) And
        (Board[X + Dx, Y + Dy].Value <> -1) Then
    Begin
        SimpleCheckingForAvaible := Not Board[X + Dx, Y + Dy].IsFigure;
        Board[X + Dx, Y + Dy].IsAvaible := True;
    End;
End;

Procedure LoopOfChecking(Const Board: TBoardMatrix; X, Y, X2, Y2: Integer);
Var
    Dx, Dy: Integer;
    CurrentResult: Boolean;
Begin
    Dx := X2;
    Dy := Y2;
    CurrentResult := True;

    While (Check(X + Dx, Board)) And (Check(Y + Dy, Board)) And
        (CurrentResult) Do
    Begin
        CurrentResult := SimpleCheckingForAvaible(Board, X, Y, Dx, Dy);
        Inc(Dx, X2);
        Inc(Dy, Y2);
    End;
End;

Function IsFigureCell(Const Board: TBoardMatrix; ARow, ACol: Integer): Boolean;
Begin
    If (ARow < 8) And (ARow > -1) And (ACol > -1) And (ACol < 8) Then
        Result := Board[ARow, ACol].IsFigure
    Else
        Result := False;
End;

Procedure PawnCheck(Const Board: TBoardMatrix; ACol, ARow: Integer);
Var
    Value, Pos: Shortint;
Begin
    Value := 1;
    Pos := 1;
    If Board[ARow, ACol].Color = CWhite Then
    Begin
        Pos := 6;
        Value := -1;
    End;

    If (Not IsFigureCell(Board, ARow + Value, ACol)) Then
        SimpleCheckingForAvaible(Board, ARow, ACol, Value, 0);
    If (ARow = Pos) And (Not Board[ARow + Value][ACol].IsFigure) And
        (Not IsFigureCell(Board, ARow + Value * 2, ACol)) Then
        SimpleCheckingForAvaible(Board, ARow, ACol, Value * 2, 0);
    If IsFigureCell(Board, ARow + Value, ACol - 1) Then
        SimpleCheckingForAvaible(Board, ARow, ACol, Value, -1);
    If IsFigureCell(Board, ARow + Value, ACol + 1) Then
        SimpleCheckingForAvaible(Board, ARow, ACol, Value, 1);
End;

Procedure RookCheck(Const Board: TBoardMatrix; ACol, ARow: Integer);
Begin
    LoopOfChecking(Board, ARow, ACol, 1, 0);
    LoopOfChecking(Board, ARow, ACol, 0, 1);
    LoopOfChecking(Board, ARow, ACol, -1, 0);
    LoopOfChecking(Board, ARow, ACol, 0, -1);
End;

Procedure KnightCheck(Const Board: TBoardMatrix; ACol, ARow: Integer);
Begin
    SimpleCheckingForAvaible(Board, ARow, ACol, 2, 1);
    SimpleCheckingForAvaible(Board, ARow, ACol, 2, -1);
    SimpleCheckingForAvaible(Board, ARow, ACol, -2, 1);
    SimpleCheckingForAvaible(Board, ARow, ACol, -2, -1);
    SimpleCheckingForAvaible(Board, ARow, ACol, 1, 2);
    SimpleCheckingForAvaible(Board, ARow, ACol, 1, -2);
    SimpleCheckingForAvaible(Board, ARow, ACol, -1, 2);
    SimpleCheckingForAvaible(Board, ARow, ACol, -1, -2);
End;

Procedure BishopCheck(Const Board: TBoardMatrix; ACol, ARow: Integer);
Begin
    LoopOfChecking(Board, ARow, ACol, 1, 1);
    LoopOfChecking(Board, ARow, ACol, 1, -1);
    LoopOfChecking(Board, ARow, ACol, -1, 1);
    LoopOfChecking(Board, ARow, ACol, -1, -1);
End;

Procedure QueenCheck(Const Board: TBoardMatrix; ACol, ARow: Integer);
Begin
    LoopOfChecking(Board, ARow, ACol, 1, 0);
    LoopOfChecking(Board, ARow, ACol, 0, 1);
    LoopOfChecking(Board, ARow, ACol, -1, 0);
    LoopOfChecking(Board, ARow, ACol, 0, -1);
    LoopOfChecking(Board, ARow, ACol, 1, 1);
    LoopOfChecking(Board, ARow, ACol, 1, -1);
    LoopOfChecking(Board, ARow, ACol, -1, 1);
    LoopOfChecking(Board, ARow, ACol, -1, -1);
End;

Procedure CheckAllFigures(Const Board: TBoardMatrix;
    CurrentColor: TFigureColors);
Begin
    For Var I := Low(Board) To High(Board) Do
        For Var J := Low(Board) To High(Board) Do
            With Board[I][J] Do
                If (IsFigure) And (Color <> CurrentColor) Then
                    GetWaysFuntions[Figure](Board, J, I);

End;

Function IsEmptyLine(Const Board: TBoardMatrix;
    ARow, ACol, Count, Step: Integer): Boolean;
Begin
    Result := True;
    For Var I := 1 To Count Do
        Result := (Result) And (Not Board[ARow][ACol + Step * I].IsFigure);
End;

Procedure SetCastlingState(Var Cell: TCell);
Begin
    Cell.IsAvaible := True;
    Cell.Value := -2;
End;

Procedure SetCastlingPoints(Const Board: TBoardMatrix; ARow, ACol: Integer);
Begin
    Var
    CurrentColor := Board[ARow][ACol].Color;

    If CastlingStates[CurrentColor][2] Then
    Begin
        If (CastlingStates[CurrentColor][0]) And
            (IsEmptyLine(Board, ARow, ACol, 3, -1)) Then
            SetCastlingState(Board[ARow][ACol - 3]);
        If ((CastlingStates[CurrentColor][1]) And
            (IsEmptyLine(Board, ARow, ACol, 2, 1))) Then
            SetCastlingState(Board[ARow][ACol + 2]);
    End;
End;

Procedure KingCheck(Const Board: TBoardMatrix; ACol, ARow: Integer);
Begin
    SimpleCheckingForAvaible(Board, ARow, ACol, 1, 0);
    SimpleCheckingForAvaible(Board, ARow, ACol, 1, 1);
    SimpleCheckingForAvaible(Board, ARow, ACol, 0, 1);
    SimpleCheckingForAvaible(Board, ARow, ACol, 0, -1);
    SimpleCheckingForAvaible(Board, ARow, ACol, -1, -1);
    SimpleCheckingForAvaible(Board, ARow, ACol, -1, 0);
    SimpleCheckingForAvaible(Board, ARow, ACol, -1, 1);
    SimpleCheckingForAvaible(Board, ARow, ACol, 1, -1);

    SetCastlingPoints(Board, ARow, ACol);
End;

Procedure CheckAllWays(Const Board: TBoardMatrix; Color: TFigureColors);
Begin
    For Var I := Low(Board) To High(Board) Do
        For Var J := Low(Board[I]) To High(Board[I]) Do
            If (Board[I][J].Color = Color) And (Board[I][J].IsFigure) Then
                GetWaysFuntions[Board[I][J].Figure](Board, J, I);
End;

Procedure ChangeAvaibleToValue(Const Board: TBoardMatrix);
Begin
    For Var I := Low(Board) To High(Board) Do
        For Var J := Low(Board[I]) To High(Board[I]) Do
            If Board[I][J].IsAvaible Then
                Board[I][J].Value := -1;
End;

Procedure CopyMatrix(Var Dest: TBoardMatrix; Const Src: TBoardMatrix);
Begin
    SetLength(Dest, 8, 8);

    For Var I := Low(Src) To High(Src) Do
        For Var J := Low(Src[I]) To High(Src[I]) Do
            Dest[I][J] := Src[I][J];
End;

Procedure SwapElement(Const Board: TBoardMatrix; X1, Y1, X2, Y2: ShortInt);
Begin
    With Board[X2][Y2] Do
    Begin
        IsFigure := True;
        Figure := Board[X1][Y1].Figure;
        Color := Board[X1][Y1].Color;
        Value := Board[X1][Y1].Value;
    End;
    Board[X1][Y1].IsFigure := False;
    Board[X1][Y1].Value := 0;
End;

Function IsKingUnderAttack(Const Board: TBoardMatrix;
    CurrentColor: TFigureColors): Boolean;
Var
    NewBoard: TBoardMatrix;
Begin
    Result := True;
    CopyMatrix(NewBoard, Board);
    ClearCells(NewBoard);
    ClearValues(NewBoard);

    CheckAllFigures(NewBoard, CurrentColor);

    For Var I := Low(Board) To High(Board) Do
        For Var J := Low(Board[I]) To High(Board[I]) Do
            With NewBoard[I][J] Do
                If (IsFigure) And (Figure = FKing) And
                    (Color = CurrentColor) Then
                    Result := IsAvaible;
End;

Procedure CheckGameStatus(Const Board: TBoardMatrix;
    CurrentColor: TFigureColors; Var GameStatus: TGameStatus);
Var
    KingX, KingY: ShortInt;
    IsKingInCheck, HasAnyValidMove: Boolean;
    TempBoard, CheckTempBoard: TBoardMatrix;
    I, J, X, Y: Integer;
Begin
    ClearCells(Board);
    ClearValues(Board);

    CheckAllFigures(Board, CurrentColor);
    For I := Low(Board) To High(Board) Do
        For J := Low(Board[I]) To High(Board[I]) Do
            With Board[I][J] Do
                If (IsFigure) And (Figure = FKing) And
                    (Color = CurrentColor) Then
                Begin
                    KingX := I;
                    KingY := J;
                End;

    IsKingInCheck := Board[KingX][KingY].IsAvaible;

    ClearCells(Board);
    ClearValues(Board);

    HasAnyValidMove := False;
    For I := Low(Board) To High(Board) Do
        For J := Low(Board[I]) To High(Board[I]) Do
            With Board[I][J] Do
                If (IsFigure) And (Color = CurrentColor) Then
                Begin
                    CopyMatrix(TempBoard, Board);
                    GetWaysFuntions[TempBoard[I][J].Figure](TempBoard, J, I);
                    For X := Low(TempBoard) To High(TempBoard) Do
                        For Y := Low(TempBoard[X]) To High(TempBoard[X]) Do
                            If TempBoard[X][Y].IsAvaible Then
                            Begin
                                CopyMatrix(CheckTempBoard, TempBoard);
                                ClearCells(CheckTempBoard);
                                ClearValues(CheckTempBoard);

                                SwapElement(CheckTempBoard, I, J, X, Y);
                                If Not IsKingUnderAttack(CheckTempBoard,
                                    CurrentColor) Then
                                    HasAnyValidMove := True;
                                SwapElement(CheckTempBoard, X, Y, I, J);
                            End;
                    If HasAnyValidMove Then
                        Break;
                End;

    If IsKingInCheck Then
    Begin
        If HasAnyValidMove Then
            GameStatus := GCheck
        Else
            GameStatus := GMate;
    End
    Else
    Begin
        If HasAnyValidMove Then
            GameStatus := GNone
        Else
            GameStatus := GStatemate;
    End;
End;

Function NextColor(Color: TFigureColors): TFigureColors;
Begin
    Result := TFigureColors((Ord(Color) + 1) Mod 2);
End;

Procedure DeleteBadPoints(Const Board: TBoardMatrix; ARow, ACol: Integer;
    GameStatus: TGameStatus);
Begin
    For Var X := Low(Board) To High(Board) Do
        For Var Y := Low(Board[X]) To High(Board[X]) Do
            If Board[X][Y].IsAvaible Then
            Begin
                Var
                    NewBoard: TBoardMatrix;

                CopyMatrix(NewBoard, Board);
                ClearCells(NewBoard);
                ClearValues(NewBoard);

                SwapElement(NewBoard, ARow, ACol, X, Y);
                Board[X, Y].IsAvaible := Not IsKingUnderAttack(NewBoard,
                    Board[ARow][ACol].Color);
            End;
End;

Procedure DeleteCastlingIfCheck(Const Board: TBoardMatrix;
    GameStatus: TGameStatus);
Begin
    If GameStatus = GCheck Then
        For Var X := Low(Board) To High(Board) Do
            For Var Y := Low(Board[X]) To High(Board[X]) Do
                With Board[X][Y] Do
                    If Value = -2 Then
                        IsAvaible := False;
End;

End.
