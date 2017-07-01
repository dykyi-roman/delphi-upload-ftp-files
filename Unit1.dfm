object Form1: TForm1
  Left = 0
  Top = 0
  Caption = 'Form1'
  ClientHeight = 286
  ClientWidth = 388
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object Button4: TButton
    Left = 8
    Top = 224
    Width = 185
    Height = 23
    Caption = 'Url Download'
    TabOrder = 0
    OnClick = Button4Click
  end
  object Memo1: TMemo
    Left = 8
    Top = 35
    Width = 185
    Height = 171
    TabOrder = 1
  end
  object btnRead: TButton
    Left = 215
    Top = 39
    Width = 75
    Height = 25
    Caption = 'Read'
    TabOrder = 2
    OnClick = btnReadClick
  end
  object Button6: TButton
    Left = 8
    Top = 253
    Width = 185
    Height = 25
    Caption = 'Work with not determinate variable'
    TabOrder = 3
    OnClick = Button6Click
  end
  object btnFree: TButton
    Left = 215
    Top = 253
    Width = 156
    Height = 25
    Caption = 'Free'
    TabOrder = 4
    OnClick = btnFreeClick
  end
  object btnCreate: TButton
    Left = 215
    Top = 8
    Width = 156
    Height = 25
    Caption = 'Create'
    TabOrder = 5
    OnClick = btnCreateClick
  end
  object btnWrite: TButton
    Left = 296
    Top = 39
    Width = 75
    Height = 25
    Caption = 'Write'
    TabOrder = 6
    OnClick = btnWriteClick
  end
  object edwrite: TEdit
    Left = 8
    Top = 8
    Width = 185
    Height = 21
    TabOrder = 7
    Text = 'edwrite'
  end
  object Button5: TButton
    Left = 215
    Top = 70
    Width = 75
    Height = 25
    Caption = 'download'
    TabOrder = 8
    OnClick = Button5Click
  end
  object btnDelete: TButton
    Left = 296
    Top = 70
    Width = 75
    Height = 25
    Caption = 'Delete'
    TabOrder = 9
    OnClick = btnDeleteClick
  end
  object btnrename: TButton
    Left = 215
    Top = 101
    Width = 75
    Height = 25
    Caption = 'Rename'
    TabOrder = 10
    OnClick = btnrenameClick
  end
  object btnCreateDir: TButton
    Left = 296
    Top = 101
    Width = 75
    Height = 25
    Caption = 'CreateDir'
    TabOrder = 11
    OnClick = btnCreateDirClick
  end
  object Button1: TButton
    Left = 215
    Top = 132
    Width = 75
    Height = 25
    Caption = 'GetCurDir'
    TabOrder = 12
    OnClick = Button1Click
  end
  object Button2: TButton
    Left = 296
    Top = 132
    Width = 75
    Height = 25
    Caption = 'SetCurDir'
    TabOrder = 13
    OnClick = Button2Click
  end
  object Button7: TButton
    Left = 215
    Top = 163
    Width = 75
    Height = 25
    Caption = 'ScanFtpDir'
    TabOrder = 14
    OnClick = Button7Click
  end
end
