object Form1: TForm1
  Left = 0
  Top = 0
  Caption = #1052#1077#1090#1077#1086
  ClientHeight = 227
  ClientWidth = 177
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  object Button1: TButton
    Left = 8
    Top = 39
    Width = 162
    Height = 25
    Caption = #1059#1089#1090#1072#1085#1086#1074#1080#1090#1100' '#1089#1086#1077#1076#1080#1085#1077#1085#1080#1077
    TabOrder = 0
    OnClick = Button1Click
  end
  object ComboBox1: TComboBox
    Left = 8
    Top = 8
    Width = 162
    Height = 21
    ItemIndex = 5
    TabOrder = 1
    Text = 'COM6'
    Items.Strings = (
      'COM1'
      'COM2'
      'COM3'
      'COM4'
      'COM5'
      'COM6'
      'COM7'
      'COM8'
      'COM9')
  end
  object Memo1: TMemo
    Left = 8
    Top = 70
    Width = 162
    Height = 147
    TabOrder = 2
  end
  object Timer1: TTimer
    Enabled = False
    Interval = 500
    Left = 184
    Top = 8
  end
end
