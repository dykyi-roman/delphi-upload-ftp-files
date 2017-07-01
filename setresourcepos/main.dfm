object MainForm: TMainForm
  Left = 298
  Top = 58
  BorderStyle = bsDialog
  Caption = 'Set a resource position sample'
  ClientHeight = 187
  ClientWidth = 461
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnCloseQuery = FormCloseQuery
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 14
    Top = 16
    Width = 59
    Height = 13
    Caption = 'Source URL'
  end
  object Label2: TLabel
    Left = 14
    Top = 70
    Width = 72
    Height = 13
    Caption = 'Destination File'
  end
  object edtURL: TEdit
    Left = 14
    Top = 36
    Width = 434
    Height = 21
    TabOrder = 0
    Text = 
      'http://www.clevercomponents.com/demo/inetsuite/v31/clInetSuiteDe' +
      'moD6.exe'
  end
  object edtFile: TEdit
    Left = 14
    Top = 90
    Width = 434
    Height = 21
    TabOrder = 1
    Text = 'c:\clInetSuiteDemoD6.exe'
  end
  object btnDownload: TButton
    Left = 289
    Top = 150
    Width = 75
    Height = 25
    Caption = 'Download'
    Default = True
    TabOrder = 2
    OnClick = btnDownloadClick
  end
  object btnStop: TButton
    Left = 373
    Top = 150
    Width = 75
    Height = 25
    Caption = 'Stop'
    TabOrder = 3
    OnClick = btnStopClick
  end
  object ProgressBar: TProgressBar
    Left = 14
    Top = 121
    Width = 434
    Height = 17
    TabOrder = 4
  end
end
