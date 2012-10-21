inherited FormCad_Categoria: TFormCad_Categoria
  Left = 249
  Top = 147
  HelpContext = 102
  Caption = 'Cadastros'
  ClientHeight = 314
  ClientWidth = 496
  OldCreateOrder = True
  PixelsPerInch = 96
  TextHeight = 13
  inherited PnlTitulo: TPanel
    Width = 496
    inherited Image1: TImage
      Width = 496
    end
    inherited LblTitulo: TLabel
      Left = 11
      Top = 14
      Width = 126
      Caption = 'Cadastro de Categoria'
    end
  end
  inherited StbPadrao: TStatusBar
    Top = 295
    Width = 496
  end
  inherited Panel1: TPanel
    Top = 240
    Width = 496
  end
  object GroupBox1: TGroupBox [3]
    Left = 5
    Top = 50
    Width = 485
    Height = 185
    TabOrder = 4
    object Label2: TLabel
      Left = 88
      Top = 144
      Width = 288
      Height = 13
      Caption = 
        '................................................................' +
        '........'
    end
    object LblCodigo: TLabel
      Left = 16
      Top = 21
      Width = 33
      Height = 13
      Caption = 'C'#243'digo'
    end
    object LblDescricao: TLabel
      Left = 17
      Top = 70
      Width = 46
      Height = 13
      Caption = 'Descri'#231#227'o'
    end
    object Label1: TLabel
      Left = 16
      Top = 144
      Width = 112
      Height = 13
      Caption = 'Recebe por Orientando'
    end
    object DBECodigo: TDBEdit
      Left = 16
      Top = 37
      Width = 95
      Height = 21
      DataField = 'COD_CAT'
      DataSource = DataSource
      TabOrder = 0
    end
    object DBEDescricao: TDBEdit
      Left = 16
      Top = 85
      Width = 449
      Height = 21
      CharCase = ecUpperCase
      DataField = 'DESC_CAT'
      DataSource = DataSource
      TabOrder = 1
    end
    object cbbSimNao: TComboBox
      Left = 384
      Top = 135
      Width = 85
      Height = 22
      Style = csOwnerDrawFixed
      ItemHeight = 16
      TabOrder = 2
      OnChange = cbbSimNaoChange
      Items.Strings = (
        'N'#227'o'
        'Sim')
    end
  end
  inherited pnlRegistros: TPanel
    Top = 273
    Width = 496
    inherited DBNavigator1: TDBNavigator
      Width = 494
      Hints.Strings = ()
      OnClick = DBNavigator1Click
    end
  end
  inherited SQLQuery: TSQLQuery
    SQL.Strings = (
      'SELECT * FROM CATEGORIA')
    Left = 456
    object SQLQueryCOD_CAT: TIntegerField
      FieldName = 'COD_CAT'
      ProviderFlags = [pfInUpdate, pfInWhere, pfInKey]
      Required = True
    end
    object SQLQueryDESC_CAT: TStringField
      FieldName = 'DESC_CAT'
      ProviderFlags = [pfInUpdate]
      Size = 50
    end
    object SQLQueryREC_POR_ORIENTADOR_CAT: TIntegerField
      FieldName = 'REC_POR_ORIENTADOR_CAT'
      ProviderFlags = [pfInUpdate]
    end
  end
  inherited DataSetProvider: TDataSetProvider
    Left = 416
  end
  inherited ClientDataSet: TClientDataSet
    AfterOpen = ClientDataSetAfterOpen
    BeforePost = ClientDataSetBeforePost
    AfterRefresh = ClientDataSetAfterRefresh
    Left = 384
    object ClientDataSetCOD_CAT: TIntegerField
      FieldName = 'COD_CAT'
      Required = True
    end
    object ClientDataSetDESC_CAT: TStringField
      FieldName = 'DESC_CAT'
      Size = 50
    end
    object ClientDataSetREC_POR_ORIENTADOR_CAT: TIntegerField
      FieldName = 'REC_POR_ORIENTADOR_CAT'
    end
  end
  inherited DataSource: TDataSource
    Left = 352
  end
  inherited sqlUltimoRegistro: TSQLQuery
    SQL.Strings = (
      'SELECT MAX(COD_CAT) FROM CATEGORIA')
  end
end
