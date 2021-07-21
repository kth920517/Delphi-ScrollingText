object frmMain: TfrmMain
  Left = 0
  Top = 0
  Caption = 'Scrolling Text'
  ClientHeight = 118
  ClientWidth = 330
  Color = clBtnFace
  DoubleBuffered = True
  Font.Charset = HANGEUL_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = #46027#50880
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 12
  object pnlNotice: TPanel
    Left = 0
    Top = 0
    Width = 330
    Height = 65
    Align = alTop
    Caption = 'pnlNotice'
    ShowCaption = False
    TabOrder = 0
    object pbxTitleArea: TPaintBox
      Left = 42
      Top = 1
      Width = 287
      Height = 63
      Align = alClient
      ExplicitLeft = 47
      ExplicitTop = 2
      ExplicitWidth = 582
    end
    object lblTitle: TLabel
      AlignWithMargins = True
      Left = 42
      Top = 1
      Width = 287
      Height = 63
      Margins.Left = 0
      Margins.Top = 0
      Margins.Right = 0
      Margins.Bottom = 0
      Align = alClient
      Layout = tlCenter
      ExplicitWidth = 4
      ExplicitHeight = 12
    end
    object pnlButton: TPanel
      Left = 1
      Top = 1
      Width = 41
      Height = 63
      Align = alLeft
      Caption = 'Panel1'
      ShowCaption = False
      TabOrder = 0
      object btnDown: TButton
        Left = 1
        Top = 33
        Width = 39
        Height = 29
        Align = alClient
        Caption = 'Down'
        TabOrder = 0
        OnClick = btnDownClick
      end
      object btnUp: TButton
        Left = 1
        Top = 1
        Width = 39
        Height = 32
        Align = alTop
        Caption = 'Up'
        TabOrder = 1
        OnClick = btnUpClick
      end
    end
  end
  object btnStart: TButton
    Left = 8
    Top = 85
    Width = 75
    Height = 25
    Caption = 'Start'
    TabOrder = 1
    OnClick = btnStartClick
  end
  object cmbDirection: TComboBox
    Left = 89
    Top = 87
    Width = 88
    Height = 22
    Style = csOwnerDrawFixed
    ItemIndex = 0
    TabOrder = 2
    Text = 'Vertical'
    OnChange = cmbDirectionChange
    Items.Strings = (
      'Vertical'
      'Horizontal')
  end
  object tmrNextTitle: TTimer
    Enabled = False
    Interval = 10000
    OnTimer = tmrNextTitleTimer
    Left = 208
    Top = 16
  end
  object tmrScrollTitle: TTimer
    Enabled = False
    Interval = 60
    OnTimer = tmrScrollTitleTimer
    Left = 272
    Top = 16
  end
end
