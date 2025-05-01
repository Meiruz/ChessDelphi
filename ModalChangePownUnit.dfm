object TModalChangePown: TTModalChangePown
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsNone
  Caption = 'TModalChangePown'
  ClientHeight = 77
  ClientWidth = 360
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  Position = poOwnerFormCenter
  OnShow = FormShow
  TextHeight = 15
  object QueenImage1: TImage
    Left = 224
    Top = 8
    Width = 57
    Height = 57
    OnClick = BishopImageClick
  end
  object RookImage: TImage
    Left = 144
    Top = 8
    Width = 57
    Height = 57
    OnClick = BishopImageClick
  end
  object BishopImage: TImage
    Left = 64
    Top = 8
    Width = 57
    Height = 57
    OnClick = BishopImageClick
  end
end
