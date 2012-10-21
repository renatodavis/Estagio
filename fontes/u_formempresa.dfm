inherited FormCad_Empresa: TFormCad_Empresa
  Left = 294
  Top = 142
  HelpContext = 103
  Caption = 'Cadastros'
  ClientHeight = 390
  ClientWidth = 506
  OldCreateOrder = True
  PixelsPerInch = 96
  TextHeight = 13
  inherited PnlTitulo: TPanel
    Width = 506
    inherited Image1: TImage
      Width = 506
    end
    inherited LblTitulo: TLabel
      Left = 9
      Top = 12
      Width = 55
      Height = 16
      Caption = 'Empresa'
      Font.Height = -13
    end
  end
  inherited StbPadrao: TStatusBar
    Top = 371
    Width = 506
  end
  inherited Panel1: TPanel
    Top = 338
    Width = 506
  end
  object GroupBox1: TGroupBox [3]
    Left = 9
    Top = 54
    Width = 491
    Height = 260
    TabOrder = 1
    object Label1: TLabel
      Left = 16
      Top = 68
      Width = 60
      Height = 13
      Caption = 'Raz'#227'o Social'
    end
    object Label2: TLabel
      Left = 358
      Top = 28
      Width = 25
      Height = 13
      Caption = 'CNPJ'
    end
    object Label3: TLabel
      Left = 16
      Top = 112
      Width = 71
      Height = 13
      Caption = 'Nome Fantasia'
    end
    object Label5: TLabel
      Left = 16
      Top = 21
      Width = 33
      Height = 13
      Caption = 'C'#243'digo'
      FocusControl = DBEdit1
    end
    object Label9: TLabel
      Left = 331
      Top = 112
      Width = 13
      Height = 13
      Caption = 'UF'
      FocusControl = DBEdit5
    end
    object Label10: TLabel
      Left = 379
      Top = 112
      Width = 19
      Height = 13
      Caption = 'CEP'
      FocusControl = DBEdit6
    end
    object Label11: TLabel
      Left = 16
      Top = 156
      Width = 24
      Height = 13
      Caption = 'Fone'
      FocusControl = DBEdit7
    end
    object Label12: TLabel
      Left = 118
      Top = 156
      Width = 19
      Height = 13
      Caption = 'FAX'
      FocusControl = DBEdit8
    end
    object Label13: TLabel
      Left = 220
      Top = 156
      Width = 24
      Height = 13
      Caption = 'Email'
      FocusControl = DBEdit9
    end
    object Label14: TLabel
      Left = 16
      Top = 202
      Width = 120
      Height = 13
      Caption = 'Orientador de Atividades'
      FocusControl = DBEdit10
    end
    object Label15: TLabel
      Left = 272
      Top = 202
      Width = 99
      Height = 13
      Caption = 'Cargo do Orientador'
      FocusControl = DBEdit11
    end
    object DBEdit1: TDBEdit
      Left = 16
      Top = 37
      Width = 85
      Height = 21
      DataField = 'COD_EMP'
      DataSource = DataSource
      MaxLength = 6
      TabOrder = 0
    end
    object DBEdit2: TDBEdit
      Left = 16
      Top = 84
      Width = 457
      Height = 21
      CharCase = ecUpperCase
      DataField = 'RAZAO_EMP'
      DataSource = DataSource
      TabOrder = 2
    end
    object DBEdit3: TDBEdit
      Left = 16
      Top = 128
      Width = 308
      Height = 21
      CharCase = ecUpperCase
      DataField = 'NOME_EMP'
      DataSource = DataSource
      TabOrder = 3
    end
    object DBEdit4: TDBEdit
      Left = 358
      Top = 44
      Width = 115
      Height = 21
      DataField = 'CNPJ_EMP'
      DataSource = DataSource
      MaxLength = 14
      TabOrder = 1
    end
    object DBEdit5: TDBEdit
      Left = 331
      Top = 128
      Width = 41
      Height = 21
      CharCase = ecUpperCase
      DataField = 'UF_EMP'
      DataSource = DataSource
      TabOrder = 4
      OnExit = DBEdit5Exit
    end
    object DBEdit6: TDBEdit
      Left = 379
      Top = 128
      Width = 95
      Height = 21
      CharCase = ecUpperCase
      DataField = 'CEP_EMP'
      DataSource = DataSource
      TabOrder = 5
    end
    object DBEdit7: TDBEdit
      Left = 16
      Top = 172
      Width = 95
      Height = 21
      CharCase = ecUpperCase
      DataField = 'FONE_EMP'
      DataSource = DataSource
      TabOrder = 6
    end
    object DBEdit8: TDBEdit
      Left = 118
      Top = 172
      Width = 95
      Height = 21
      CharCase = ecUpperCase
      DataField = 'FAX_EMP'
      DataSource = DataSource
      TabOrder = 7
    end
    object DBEdit9: TDBEdit
      Left = 220
      Top = 172
      Width = 253
      Height = 21
      DataField = 'EMAIL_EMP'
      DataSource = DataSource
      TabOrder = 8
    end
    object DBEdit10: TDBEdit
      Left = 16
      Top = 218
      Width = 249
      Height = 21
      CharCase = ecUpperCase
      DataField = 'ORI_ATIV_EMP'
      DataSource = DataSource
      MaxLength = 50
      TabOrder = 9
    end
    object DBEdit11: TDBEdit
      Left = 272
      Top = 218
      Width = 201
      Height = 21
      CharCase = ecUpperCase
      DataField = 'CARGO_ORI_EMP'
      DataSource = DataSource
      MaxLength = 50
      TabOrder = 10
    end
  end
  inherited pnlRegistros: TPanel
    Top = 316
    Width = 506
    inherited DBNavigator1: TDBNavigator
      Width = 504
      Hints.Strings = ()
    end
  end
  inherited SQLQuery: TSQLQuery
    SQL.Strings = (
      'SELECT * FROM EMPRESA')
  end
  inherited ClientDataSet: TClientDataSet
    object ClientDataSetCOD_EMP: TIntegerField
      FieldName = 'COD_EMP'
    end
    object ClientDataSetRAZAO_EMP: TStringField
      FieldName = 'RAZAO_EMP'
      Size = 50
    end
    object ClientDataSetNOME_EMP: TStringField
      FieldName = 'NOME_EMP'
      Size = 50
    end
    object ClientDataSetCNPJ_EMP: TFMTBCDField
      FieldName = 'CNPJ_EMP'
      EditFormat = '99.999.9999/99'
      Precision = 15
      Size = 0
    end
    object ClientDataSetUF_EMP: TStringField
      FieldName = 'UF_EMP'
      FixedChar = True
      Size = 2
    end
    object ClientDataSetCEP_EMP: TStringField
      FieldName = 'CEP_EMP'
      EditMask = '99.999-999'
      Size = 10
    end
    object ClientDataSetFONE_EMP: TStringField
      FieldName = 'FONE_EMP'
      EditMask = '9999-9999'
    end
    object ClientDataSetFAX_EMP: TStringField
      FieldName = 'FAX_EMP'
      EditMask = '9999-9999'
    end
    object ClientDataSetEMAIL_EMP: TStringField
      FieldName = 'EMAIL_EMP'
      Size = 50
    end
    object ClientDataSetORI_ATIV_EMP: TStringField
      FieldName = 'ORI_ATIV_EMP'
    end
    object ClientDataSetCARGO_ORI_EMP: TStringField
      FieldName = 'CARGO_ORI_EMP'
      Size = 30
    end
  end
end
