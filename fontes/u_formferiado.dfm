inherited FormCad_Feriado: TFormCad_Feriado
  Left = 280
  Top = 232
  HelpContext = 104
  Caption = 'Cadastros'
  ClientHeight = 250
  ClientWidth = 495
  OldCreateOrder = True
  PixelsPerInch = 96
  TextHeight = 13
  inherited PnlTitulo: TPanel
    Width = 495
    inherited Image1: TImage
      Width = 495
    end
    inherited LblTitulo: TLabel
      Left = 16
      Top = 8
      Width = 55
      Height = 16
      Caption = 'Feriado'
      Font.Height = -13
      Font.Name = 'MS Sans Serif'
    end
  end
  inherited StbPadrao: TStatusBar
    Top = 231
    Width = 495
  end
  inherited Panel1: TPanel
    Top = 176
    Width = 495
    inherited btnConsultar: TBitBtn
      Left = 323
    end
    inherited btnFechar: TBitBtn
      Left = 403
    end
  end
  object GroupBox1: TGroupBox [3]
    Left = 8
    Top = 52
    Width = 481
    Height = 121
    TabOrder = 4
    object LablData: TLabel
      Left = 16
      Top = 17
      Width = 23
      Height = 13
      Caption = 'Data'
    end
    object LblDescricao: TLabel
      Left = 16
      Top = 65
      Width = 46
      Height = 13
      Caption = 'Descri'#231#227'o'
    end
    object DBEDescricao: TDBEdit
      Left = 16
      Top = 81
      Width = 449
      Height = 21
      DataField = 'DESC_FERIADO'
      DataSource = DataSource
      TabOrder = 0
    end
    object MaskEdit1: TMaskEdit
      Left = 16
      Top = 40
      Width = 104
      Height = 21
      EditMask = '99/99/9999;1;_'
      MaxLength = 10
      TabOrder = 1
      Text = '  /  /    '
      OnExit = MaskEdit1Exit
    end
  end
  inherited pnlRegistros: TPanel
    Top = 209
    Width = 495
    inherited DBNavigator1: TDBNavigator
      Width = 493
      Hints.Strings = ()
    end
  end
  inherited SQLQuery: TSQLQuery
    SQL.Strings = (
      'SELECT * FROM FERIADO')
    Left = 456
    object SQLQueryDATA_FERIADO: TDateField
      FieldName = 'DATA_FERIADO'
      Required = True
    end
    object SQLQueryDESC_FERIADO: TStringField
      FieldName = 'DESC_FERIADO'
      Size = 50
    end
  end
  inherited DataSetProvider: TDataSetProvider
    Left = 424
  end
  inherited ClientDataSet: TClientDataSet
    BeforePost = ClientDataSetBeforePost
    Left = 392
    object ClientDataSetDATA_FERIADO: TDateField
      FieldName = 'DATA_FERIADO'
      ProviderFlags = [pfInUpdate, pfInWhere, pfInKey]
      EditMask = '99/99/9999;1;_'
    end
    object ClientDataSetDESC_FERIADO: TStringField
      FieldName = 'DESC_FERIADO'
      Size = 50
    end
  end
  inherited DataSource: TDataSource
    Left = 360
  end
end
