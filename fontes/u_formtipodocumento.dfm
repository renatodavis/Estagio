inherited FormCad_TipoDocumento: TFormCad_TipoDocumento
  HelpContext = 108
  Caption = 'Cadastros'
  ClientHeight = 364
  ClientWidth = 503
  OldCreateOrder = True
  PixelsPerInch = 96
  TextHeight = 13
  inherited PnlTitulo: TPanel
    Width = 503
    inherited Image1: TImage
      Width = 503
    end
    inherited LblTitulo: TLabel
      Left = 8
      Top = 12
      Width = 141
      Height = 16
      Caption = ' Tipo de Documento'
      Font.Height = -13
      Font.Name = 'MS Sans Serif'
    end
  end
  inherited StbPadrao: TStatusBar
    Top = 345
    Width = 503
  end
  inherited Panel1: TPanel
    Top = 312
    Width = 503
  end
  object GroupBox1: TGroupBox [3]
    Left = 8
    Top = 51
    Width = 489
    Height = 238
    TabOrder = 4
    object Label1: TLabel
      Left = 16
      Top = 19
      Width = 33
      Height = 13
      Caption = 'C'#243'digo'
    end
    object Label2: TLabel
      Left = 16
      Top = 62
      Width = 46
      Height = 13
      Caption = 'Descri'#231#227'o'
    end
    object Label3: TLabel
      Left = 16
      Top = 116
      Width = 23
      Height = 13
      Caption = 'Obs:'
    end
    object DBEdit1: TDBEdit
      Left = 16
      Top = 34
      Width = 95
      Height = 21
      DataField = 'COD_DOC'
      DataSource = DataSource
      MaxLength = 6
      TabOrder = 0
    end
    object DBEdit2: TDBEdit
      Left = 16
      Top = 80
      Width = 457
      Height = 21
      CharCase = ecUpperCase
      DataField = 'DESC_DOS'
      DataSource = DataSource
      TabOrder = 1
    end
    object DBMemo1: TDBMemo
      Left = 16
      Top = 132
      Width = 457
      Height = 89
      DataField = 'OBS_DOC'
      DataSource = DataSource
      MaxLength = 5000
      TabOrder = 2
    end
  end
  inherited pnlRegistros: TPanel
    Top = 290
    Width = 503
    inherited DBNavigator1: TDBNavigator
      Width = 501
      Hints.Strings = ()
    end
  end
  inherited SQLQuery: TSQLQuery
    SQL.Strings = (
      'SELECT * FROM TIPO_DOCUMENTO')
    Left = 472
  end
  inherited DataSetProvider: TDataSetProvider
    Left = 440
  end
  inherited ClientDataSet: TClientDataSet
    Left = 408
    object ClientDataSetCOD_DOC: TIntegerField
      FieldName = 'COD_DOC'
      ProviderFlags = [pfInUpdate, pfInWhere, pfInKey]
      Required = True
    end
    object ClientDataSetDESC_DOS: TStringField
      FieldName = 'DESC_DOS'
      Size = 50
    end
    object ClientDataSetOBS_DOC: TStringField
      FieldName = 'OBS_DOC'
      Size = 255
    end
  end
  inherited DataSource: TDataSource
    Left = 376
  end
end
