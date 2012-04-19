object MemoryForm: TMemoryForm
  Left = 0
  Top = 500
  Caption = 'Memory Analysis'
  ClientHeight = 249
  ClientWidth = 902
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poDesigned
  OnClose = FormClose
  PixelsPerInch = 96
  TextHeight = 13
  object lvMemory: TListView
    Left = 0
    Top = 0
    Width = 902
    Height = 249
    Align = alClient
    Columns = <
      item
        Caption = 'Function'
        Width = 300
      end
      item
        Alignment = taRightJustify
        Caption = 'Memory'
        Width = 100
      end
      item
        Alignment = taRightJustify
        Caption = 'Count'
      end>
    RowSelect = True
    TabOrder = 0
    ViewStyle = vsReport
    OnCompare = lvMemoryCompare
    ExplicitWidth = 454
    ExplicitHeight = 527
  end
end
