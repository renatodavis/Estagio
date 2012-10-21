inherited FormCad_TipoAvaliacao: TFormCad_TipoAvaliacao
  Left = 316
  Top = 253
  HelpContext = 107
  Caption = 'Cadastros'
  ClientHeight = 390
  ClientWidth = 499
  OldCreateOrder = True
  PixelsPerInch = 96
  TextHeight = 13
  inherited PnlTitulo: TPanel
    Width = 499
    inherited Image1: TImage
      Width = 499
    end
    inherited LblTitulo: TLabel
      Left = 14
      Top = 11
      Width = 113
      Height = 16
      Caption = 'Tipo de Avalia'#231#227'o'
      Font.Height = -13
    end
  end
  inherited StbPadrao: TStatusBar
    Top = 371
    Width = 499
  end
  inherited Panel1: TPanel
    Top = 338
    Width = 499
  end
  object GroupBox1: TGroupBox [3]
    Left = 8
    Top = 51
    Width = 481
    Height = 264
    TabOrder = 4
    object Label2: TLabel
      Left = 16
      Top = 17
      Width = 51
      Height = 13
      Caption = 'Ano Letivo'
    end
    object Label6: TLabel
      Left = 17
      Top = 69
      Width = 79
      Height = 13
      Caption = 'Data Base Anual'
    end
    object Label7: TLabel
      Left = 18
      Top = 116
      Width = 99
      Height = 13
      Caption = 'Data Base Semestral'
    end
    object Label10: TLabel
      Left = 129
      Top = 116
      Width = 23
      Height = 13
      Caption = 'Peso'
    end
    object Label12: TLabel
      Left = 18
      Top = 166
      Width = 58
      Height = 13
      Caption = 'Observa'#231#227'o'
    end
    object Label1: TLabel
      Left = 129
      Top = 69
      Width = 46
      Height = 13
      Caption = 'Descri'#231#227'o'
    end
    object Label3: TLabel
      Left = 344
      Top = 17
      Width = 33
      Height = 13
      Caption = 'Codigo'
    end
    object DBMemo1: TDBMemo
      Left = 16
      Top = 182
      Width = 449
      Height = 66
      DataField = 'OBS_AVAL'
      DataSource = DataSource
      TabOrder = 0
    end
    object DBEdit1: TDBEdit
      Left = 16
      Top = 32
      Width = 100
      Height = 21
      DataField = 'ANO_LETIVO_AVAL'
      DataSource = DataSource
      MaxLength = 4
      TabOrder = 1
      OnExit = DBEdit1Exit
    end
    object DBEdit2: TDBEdit
      Left = 16
      Top = 88
      Width = 100
      Height = 21
      DataField = 'DATA_BASE_ANUAL_AVAL'
      DataSource = DataSource
      TabOrder = 2
    end
    object DBEdit3: TDBEdit
      Left = 128
      Top = 88
      Width = 337
      Height = 21
      BevelOuter = bvRaised
      CharCase = ecUpperCase
      DataField = 'DESC_AVAL'
      DataSource = DataSource
      TabOrder = 3
    end
    object DBEdit4: TDBEdit
      Left = 16
      Top = 136
      Width = 100
      Height = 21
      DataField = 'DATA_BASE_SEMESTRAL_AVAL'
      DataSource = DataSource
      TabOrder = 4
    end
    object DBEdit5: TDBEdit
      Left = 128
      Top = 136
      Width = 100
      Height = 21
      DataField = 'PESO_AVAL'
      DataSource = DataSource
      TabOrder = 5
    end
    object DBEdit6: TDBEdit
      Left = 344
      Top = 32
      Width = 121
      Height = 21
      DataField = 'COD_AVAL'
      DataSource = DataSource
      Enabled = False
      TabOrder = 6
    end
  end
  inherited pnlRegistros: TPanel
    Top = 316
    Width = 499
    inherited DBNavigator1: TDBNavigator
      Width = 497
      Hints.Strings = ()
    end
  end
  inherited SQLQuery: TSQLQuery
    SQL.Strings = (
      'SELECT * FROM TIPO_AVALIACAO')
    Left = 448
  end
  inherited DataSetProvider: TDataSetProvider
    Left = 408
  end
  inherited ClientDataSet: TClientDataSet
    Left = 368
    object ClientDataSetANO_LETIVO_AVAL: TIntegerField
      FieldName = 'ANO_LETIVO_AVAL'
      ProviderFlags = [pfInUpdate, pfInWhere, pfInKey]
      Required = True
    end
    object ClientDataSetCOD_AVAL: TIntegerField
      FieldName = 'COD_AVAL'
      Required = True
    end
    object ClientDataSetDESC_AVAL: TStringField
      FieldName = 'DESC_AVAL'
      ProviderFlags = [pfInUpdate]
      Size = 50
    end
    object ClientDataSetDATA_BASE_ANUAL_AVAL: TDateField
      FieldName = 'DATA_BASE_ANUAL_AVAL'
      ProviderFlags = [pfInUpdate]
      EditMask = '99/99/9999'
    end
    object ClientDataSetDATA_BASE_SEMESTRAL_AVAL: TDateField
      FieldName = 'DATA_BASE_SEMESTRAL_AVAL'
      ProviderFlags = [pfInUpdate]
      EditMask = '99/99/9999'
    end
    object ClientDataSetPESO_AVAL: TFMTBCDField
      FieldName = 'PESO_AVAL'
      ProviderFlags = [pfInUpdate]
      Precision = 15
      Size = 0
    end
    object ClientDataSetOBS_AVAL: TStringField
      FieldName = 'OBS_AVAL'
      ProviderFlags = [pfInUpdate]
      Size = 255
    end
  end
  inherited DataSource: TDataSource
    Left = 328
  end
  inherited sqlUltimoRegistro: TSQLQuery
    SQL.Strings = (
      'SELECT MAX(COD_AVAL) FROM TIPO_AVALIACAO')
    Left = 288
    Top = 8
    object sqlUltimoRegistroMAX: TIntegerField
      FieldName = 'MAX'
    end
  end
end
