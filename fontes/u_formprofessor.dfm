inherited FormCad_Professor: TFormCad_Professor
  Left = 283
  Top = 168
  HelpContext = 106
  Caption = 'Cadastros'
  ClientHeight = 398
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
      Left = 13
      Width = 54
      Caption = 'Professor'
    end
  end
  inherited StbPadrao: TStatusBar
    Top = 379
    Width = 499
  end
  inherited Panel1: TPanel
    Top = 346
    Width = 499
  end
  object GroupBox1: TGroupBox [3]
    Left = 5
    Top = 50
    Width = 488
    Height = 274
    TabOrder = 4
    object Label1: TLabel
      Left = 16
      Top = 24
      Width = 33
      Height = 13
      Caption = 'C'#243'digo'
    end
    object Label2: TLabel
      Left = 16
      Top = 72
      Width = 27
      Height = 13
      Caption = 'Nome'
    end
    object Label3: TLabel
      Left = 240
      Top = 72
      Width = 24
      Height = 13
      Caption = 'Fone'
    end
    object Label4: TLabel
      Left = 368
      Top = 72
      Width = 33
      Height = 13
      Caption = 'Celular'
    end
    object Label5: TLabel
      Left = 16
      Top = 112
      Width = 24
      Height = 13
      Caption = 'email'
    end
    object Label6: TLabel
      Left = 328
      Top = 112
      Width = 47
      Height = 13
      Caption = 'Categoria'
    end
    object Label7: TLabel
      Left = 16
      Top = 160
      Width = 63
      Height = 13
      Caption = 'Observa'#231#245'es'
    end
    object DBEdit1: TDBEdit
      Left = 16
      Top = 40
      Width = 81
      Height = 21
      DataField = 'COD_PROF'
      DataSource = DataSource
      TabOrder = 0
    end
    object DBEdit2: TDBEdit
      Left = 16
      Top = 88
      Width = 217
      Height = 21
      CharCase = ecUpperCase
      DataField = 'NOME_PROF'
      DataSource = DataSource
      TabOrder = 1
    end
    object DBEdit3: TDBEdit
      Left = 240
      Top = 88
      Width = 121
      Height = 21
      CharCase = ecUpperCase
      DataField = 'FONE_PROF'
      DataSource = DataSource
      TabOrder = 2
    end
    object DBEdit4: TDBEdit
      Left = 368
      Top = 88
      Width = 105
      Height = 21
      DataField = 'CELULAR_PROF'
      DataSource = DataSource
      TabOrder = 3
    end
    object DBEdit5: TDBEdit
      Left = 16
      Top = 128
      Width = 305
      Height = 21
      DataField = 'EMAIL_PROF'
      DataSource = DataSource
      TabOrder = 4
    end
    object DBMemo1: TDBMemo
      Left = 16
      Top = 175
      Width = 457
      Height = 84
      DataSource = DataSource
      TabOrder = 5
    end
    object DBLookupComboBox1: TDBLookupComboBox
      Left = 328
      Top = 128
      Width = 145
      Height = 21
      DataField = 'CATEGORIA_PROF'
      DataSource = DataSource
      KeyField = 'COD_CAT'
      ListField = 'DESC_CAT'
      ListSource = dsCategoria
      TabOrder = 6
    end
  end
  inherited pnlRegistros: TPanel
    Top = 324
    Width = 499
    inherited DBNavigator1: TDBNavigator
      Width = 497
      Hints.Strings = ()
    end
  end
  inherited SQLQuery: TSQLQuery
    SQL.Strings = (
      'SELECT * FROM PROFESSOR ORDER BY NOME_PROF')
    object SQLQueryCOD_PROF: TIntegerField
      FieldName = 'COD_PROF'
      ProviderFlags = [pfInUpdate, pfInWhere, pfInKey]
      Required = True
    end
    object SQLQueryNOME_PROF: TStringField
      FieldName = 'NOME_PROF'
      ProviderFlags = [pfInUpdate]
      Size = 50
    end
    object SQLQueryFONE_PROF: TStringField
      FieldName = 'FONE_PROF'
      ProviderFlags = [pfInUpdate]
    end
    object SQLQueryCELULAR_PROF: TStringField
      FieldName = 'CELULAR_PROF'
      ProviderFlags = [pfInUpdate]
    end
    object SQLQueryEMAIL_PROF: TStringField
      FieldName = 'EMAIL_PROF'
      ProviderFlags = [pfInUpdate]
      Size = 50
    end
    object SQLQueryCATEGORIA_PROF: TIntegerField
      FieldName = 'CATEGORIA_PROF'
      ProviderFlags = [pfInUpdate]
    end
  end
  inherited ClientDataSet: TClientDataSet
    object ClientDataSetCOD_PROF: TIntegerField
      FieldName = 'COD_PROF'
      ProviderFlags = [pfInUpdate, pfInWhere, pfInKey]
      Required = True
    end
    object ClientDataSetNOME_PROF: TStringField
      FieldName = 'NOME_PROF'
      ProviderFlags = [pfInUpdate]
      Size = 50
    end
    object ClientDataSetFONE_PROF: TStringField
      FieldName = 'FONE_PROF'
      ProviderFlags = [pfInUpdate]
      EditMask = '99-9999-9999'
    end
    object ClientDataSetCELULAR_PROF: TStringField
      FieldName = 'CELULAR_PROF'
      ProviderFlags = [pfInUpdate]
      EditMask = '9999-9999'
    end
    object ClientDataSetEMAIL_PROF: TStringField
      FieldName = 'EMAIL_PROF'
      ProviderFlags = [pfInUpdate]
      Size = 50
    end
    object ClientDataSetCATEGORIA_PROF: TIntegerField
      FieldName = 'CATEGORIA_PROF'
      ProviderFlags = [pfInUpdate]
    end
  end
  inherited sqlUltimoRegistro: TSQLQuery
    SQL.Strings = (
      'SELECT MAX(COD_PROF) FROM PROFESSOR ')
    object sqlUltimoRegistroMAX: TIntegerField
      FieldName = 'MAX'
    end
  end
  object dsCategoria: TDataSource
    DataSet = sdsCategoria
    Left = 421
    Top = 70
  end
  object sdsCategoria: TSimpleDataSet
    Aggregates = <>
    Connection = DmGeral.SQLConnection
    DataSet.CommandText = 'select * from CATEGORIA'
    DataSet.MaxBlobSize = -1
    DataSet.Params = <>
    Params = <>
    Left = 373
    Top = 70
  end
end
