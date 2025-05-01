Unit ModalPownChanging;

Interface

Uses
    Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
    System.Classes, Vcl.Graphics,
    Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, Global;

Type
    TPownChangingForm = Class(TForm)
        RookImage: TImage;
        BishopImage: TImage;
        QueenImage: TImage;
        Procedure BishopImageClick(Sender: TObject);
        Procedure FormShow(Sender: TObject);
    Public
        CurrentValue: TFigures;
    End;

Var
    PownChangingForm: TPownChangingForm;

Implementation

{$R *.dfm}

Procedure PaintButton(Image: TImage; Figure: TFigures);
Begin
    With Image Do
    Begin
        Canvas.Brush.Color := ClWebPowderBlue;
        Canvas.FillRect(ClientRect);
        DrawPngStretchProportional(Canvas, ClientRect, Pieces[CWhite][Figure]);
    End;
End;

Procedure TPownChangingForm.BishopImageClick(Sender: TObject);
Begin
    With TImage(Sender) Do
        If Name = 'BishopImage' Then
            CurrentValue := FBishop
        Else
            If Name = 'RookImage' Then
                CurrentValue := FRook
            Else
                CurrentValue := FQueen;

    Close;
End;

Procedure TPownChangingForm.FormShow(Sender: TObject);
Begin
    CurrentValue := FQueen;

    PaintButton(RookImage, FRook);
    PaintButton(BishopImage, FBishop);
    PaintButton(QueenImage, FQueen);
End;

End.
