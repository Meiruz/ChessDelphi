object GameForm: TGameForm
  Left = 0
  Top = 0
  Caption = 'GameForm'
  ClientHeight = 869
  ClientWidth = 1046
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  Position = poScreenCenter
  OnClose = FormClose
  OnCreate = FormCreate
  OnResize = FormResize
  TextHeight = 15
  object PaintField: TPaintBox
    Left = 0
    Top = 0
    Width = 1046
    Height = 869
    Align = alClient
    ExplicitLeft = 16
    ExplicitTop = 24
    ExplicitWidth = 105
    ExplicitHeight = 105
  end
end
