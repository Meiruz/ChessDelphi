unit ModalChangePownUnit;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, Global;

type
  TTModalChangePown = class(TForm)
    QueenImage1: TImage;
    RookImage: TImage;
    BishopImage: TImage;
    procedure FormShow(Sender: TObject);
    procedure BishopImageClick(Sender: TObject);
  public
    CurrentValue: TFigures;
  end;

var
  TModalChangePown: TTModalChangePown;

implementation

{$R *.dfm}

procedure paintButton(image: TImage; figure: TFigures);
begin
    with image do
    begin
        Canvas.Brush.Color := clWebPowderBlue;
        Canvas.FillRect(ClientRect);
        DrawPngStretchProportional(Canvas, ClientRect, pieces[CWhite][figure]);
    end;
end;

procedure TTModalChangePown.BishopImageClick(Sender: TObject);
begin
    with TImage(Sender) do
    if name = 'BishopImage' then
        CurrentValue := FBishop
    else if name = 'RookImage' then
        CurrentValue := FRook
    else
        CurrentValue := FQueen;

    close;
end;

procedure TTModalChangePown.FormShow(Sender: TObject);
begin
    CurrentValue := FQueen;

    paintButton(RookImage, FRook);
    paintButton(BishopImage, FBishop);
    paintButton(QueenImage1, FQueen);
end;

end.
