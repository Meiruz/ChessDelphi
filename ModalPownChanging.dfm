object PownChangingForm: TPownChangingForm
  Left = 0
  Top = 0
  BorderIcons = []
  BorderStyle = bsNone
  Caption = 'PownChangingForm'
  ClientHeight = 85
  ClientWidth = 278
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  Position = poOwnerFormCenter
  OnShow = FormShow
  TextHeight = 15
  object RookImage: TImage
    Left = 16
    Top = 8
    Width = 65
    Height = 65
    Cursor = crHandPoint
    OnClick = BishopImageClick
  end
  object BishopImage: TImage
    Left = 104
    Top = 8
    Width = 65
    Height = 65
    Cursor = crHandPoint
    OnClick = BishopImageClick
  end
  object QueenImage: TImage
    Left = 192
    Top = 8
    Width = 65
    Height = 65
    Cursor = crHandPoint
    OnClick = BishopImageClick
  end
end
