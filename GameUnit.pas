Unit GameUnit;

Interface

Uses
    Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
    System.Classes, Vcl.Graphics,
    Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.Grids, Vcl.ExtCtrls;

Type
    TFigures = (None, King);
    THand = (White, Black);

    TCell = Record
        Figure: TFigures;
        Hand: THand;
        Value: Integer;
        IsPainted: Boolean;
        IsChecked: Boolean;
    End;

    TGameForm = Class(TForm)
    PaintField: TPaintBox;
        Procedure FormCreate(Sender: TObject);
        Procedure PaintDesk();
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormResize(Sender: TObject);
    Private
        { Private declarations }
    Public
        { Public declarations }
    End;

Var
    GameForm: TGameForm;

Implementation

{$R *.dfm}

Function Min(A, B: Integer): Integer;
Begin
    If A > B Then
        Min := B
    Else
        Min := A;
End;

Procedure TGameForm.PaintDesk();
Var
    ScaleFactor: Real;
    CurrentWidth, CellWidth, StartX, StartY: Integer;
Begin
    ScaleFactor := Screen.PixelsPerInch / 96;

    CurrentWidth := Min(Self.ClientHeight, Self.ClientWidth);
    Dec(CurrentWidth, CurrentWidth Mod 8);
    CellWidth := CurrentWidth Div 8;
    StartX := (Self.ClientWidth - CurrentWidth) Div 2;
    StartY := (Self.ClientHeight - CurrentWidth) Div 2;

    PaintField.Canvas.Brush.Color := ClInactiveCaption;
    PaintField.Canvas.Rectangle(StartX, StartY, StartX + CellWidth, StartY + CellWidth);

End;

procedure TGameForm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
    Application.Terminate;
end;

Procedure TGameForm.FormCreate(Sender: TObject);
Begin
    PaintDesk();
End;

procedure TGameForm.FormResize(Sender: TObject);
begin
    PaintDesk();
end;

End.
