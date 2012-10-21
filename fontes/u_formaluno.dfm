inherited FormCad_Aluno: TFormCad_Aluno
  Left = 295
  Top = 127
  HelpType = htKeyword
  HelpKeyword = '101'
  HelpContext = 101
  Caption = 'Cadastros'
  ClientHeight = 409
  ClientWidth = 503
  OldCreateOrder = True
  ShowHint = True
  OnMouseMove = FormMouseMove
  PixelsPerInch = 96
  TextHeight = 13
  inherited PnlTitulo: TPanel
    Width = 503
    inherited Image1: TImage
      Width = 503
    end
    inherited LblTitulo: TLabel
      Left = 10
      Top = 11
      Width = 127
      Height = 16
      Caption = 'Cadastro de Alunos'
      Font.Height = -13
    end
  end
  inherited StbPadrao: TStatusBar
    Top = 390
    Width = 503
  end
  inherited Panel1: TPanel
    Top = 357
    Width = 503
    inherited btnNovo: TBitBtn
      Left = 7
    end
    inherited btnExcluir: TBitBtn
      Left = 86
    end
    inherited btnConsultar: TBitBtn
      Width = 77
    end
    inherited btngravar: TBitBtn
      Left = 243
    end
  end
  object PageControl1: TPageControl [3]
    Left = 7
    Top = 56
    Width = 484
    Height = 270
    HelpContext = 101
    ActivePage = TabSheet1
    TabOrder = 4
    object TabSheet1: TTabSheet
      HelpContext = 101
      Caption = 'Principal'
      object Label1: TLabel
        Left = 11
        Top = 17
        Width = 44
        Height = 13
        Caption = 'RA Aluno'
        FocusControl = dbEditRa
      end
      object Label2: TLabel
        Left = 11
        Top = 59
        Width = 27
        Height = 13
        Caption = 'Nome'
        FocusControl = DBEdit2
      end
      object Label3: TLabel
        Left = 398
        Top = 17
        Width = 51
        Height = 13
        Caption = 'Ano Letivo'
        FocusControl = dbEditAno
      end
      object Label4: TLabel
        Left = 11
        Top = 102
        Width = 45
        Height = 13
        Caption = 'Endere'#231'o'
        FocusControl = DBEdit4
      end
      object Label5: TLabel
        Left = 11
        Top = 146
        Width = 33
        Height = 13
        Caption = 'Cidade'
        FocusControl = DBEdit5
      end
      object Label6: TLabel
        Left = 144
        Top = 146
        Width = 13
        Height = 13
        Caption = 'UF'
        FocusControl = DBEdit6
      end
      object Label7: TLabel
        Left = 277
        Top = 146
        Width = 24
        Height = 13
        Caption = 'Fone'
        FocusControl = DBEdit7
      end
      object Label8: TLabel
        Left = 369
        Top = 146
        Width = 33
        Height = 13
        Caption = 'Celular'
        FocusControl = DBEdit8
      end
      object Label9: TLabel
        Left = 14
        Top = 194
        Width = 73
        Height = 13
        Caption = 'Fone Comercial'
        FocusControl = DBEdit9
      end
      object Label10: TLabel
        Left = 104
        Top = 196
        Width = 24
        Height = 13
        Caption = 'Email'
        FocusControl = DBEdit10
      end
      object Label11: TLabel
        Left = 187
        Top = 146
        Width = 19
        Height = 13
        Caption = 'Cep'
        FocusControl = DBEdit11
      end
      object Label15: TLabel
        Left = 281
        Top = 102
        Width = 28
        Height = 13
        Caption = 'Bairro'
        FocusControl = DBEdit4
      end
      object Label18: TLabel
        Left = 298
        Top = 17
        Width = 30
        Height = 13
        Caption = 'Turma'
        FocusControl = dbEditAno
      end
      object dbEditRa: TDBEdit
        Left = 11
        Top = 33
        Width = 95
        Height = 21
        HelpContext = 101
        DataField = 'RA_ALU'
        DataSource = DataSource
        MaxLength = 7
        ParentShowHint = False
        ShowHint = True
        TabOrder = 0
        OnMouseMove = dbEditRaMouseMove
      end
      object DBEdit2: TDBEdit
        Left = 11
        Top = 75
        Width = 454
        Height = 21
        Hint = 'Precione <F4> para pesquisar.'
        CharCase = ecUpperCase
        DataField = 'NOME_ALU'
        DataSource = DataSource
        TabOrder = 3
      end
      object dbEditAno: TDBEdit
        Left = 398
        Top = 33
        Width = 66
        Height = 21
        DataField = 'ANO_LETIVO'
        DataSource = DataSource
        TabOrder = 2
        OnEnter = dbEditAnoEnter
      end
      object DBEdit4: TDBEdit
        Left = 11
        Top = 118
        Width = 262
        Height = 21
        CharCase = ecUpperCase
        DataField = 'END_ALU'
        DataSource = DataSource
        TabOrder = 4
      end
      object DBEdit5: TDBEdit
        Left = 11
        Top = 162
        Width = 124
        Height = 21
        CharCase = ecUpperCase
        DataField = 'CIDADE_ALU'
        DataSource = DataSource
        TabOrder = 6
      end
      object DBEdit6: TDBEdit
        Left = 142
        Top = 162
        Width = 39
        Height = 21
        CharCase = ecUpperCase
        DataField = 'UF_ALU'
        DataSource = DataSource
        TabOrder = 7
        OnExit = DBEdit6Exit
      end
      object DBEdit7: TDBEdit
        Left = 275
        Top = 162
        Width = 88
        Height = 21
        DataField = 'FONE_ALU'
        DataSource = DataSource
        TabOrder = 9
      end
      object DBEdit8: TDBEdit
        Left = 369
        Top = 162
        Width = 96
        Height = 21
        DataField = 'CELULAR_ALU'
        DataSource = DataSource
        TabOrder = 10
      end
      object DBEdit9: TDBEdit
        Left = 13
        Top = 210
        Width = 83
        Height = 21
        DataField = 'FONE_COMER_ALU'
        DataSource = DataSource
        TabOrder = 11
      end
      object DBEdit10: TDBEdit
        Left = 104
        Top = 211
        Width = 362
        Height = 21
        DataField = 'EMAIL_ALU'
        DataSource = DataSource
        TabOrder = 12
      end
      object DBEdit11: TDBEdit
        Left = 187
        Top = 162
        Width = 82
        Height = 21
        DataField = 'CEP_ALU'
        DataSource = DataSource
        TabOrder = 8
      end
      object DBEdit12: TDBEdit
        Left = 280
        Top = 118
        Width = 185
        Height = 21
        CharCase = ecUpperCase
        DataField = 'BAIRRO'
        DataSource = DataSource
        TabOrder = 5
      end
      object DBLookupComboBox3: TDBLookupComboBox
        Left = 298
        Top = 32
        Width = 92
        Height = 21
        DataField = 'COD_TURMA'
        DataSource = DataSource
        KeyField = 'COD_TURMA'
        ListField = 'DESCRICAO'
        ListSource = dsTurma
        TabOrder = 1
      end
    end
    object TabSheet2: TTabSheet
      Caption = 'Complemento'
      ImageIndex = 1
      object Label12: TLabel
        Left = 10
        Top = 135
        Width = 115
        Height = 13
        Caption = 'Disponibilidade do Aluno'
      end
      object Label13: TLabel
        Left = 9
        Top = 12
        Width = 59
        Height = 13
        Caption = 'Cronograma'
      end
      object Label14: TLabel
        Left = 373
        Top = 12
        Width = 94
        Height = 13
        Caption = 'Data Cancelamento'
        FocusControl = DBEdit14
      end
      object Label16: TLabel
        Left = 9
        Top = 62
        Width = 85
        Height = 13
        Caption = 'Empresa do aluno'
      end
      object Label17: TLabel
        Left = 265
        Top = 62
        Width = 96
        Height = 13
        Caption = 'Orientador do aluno'
      end
      object SpeedButton1: TSpeedButton
        Left = 235
        Top = 81
        Width = 23
        Height = 20
        Glyph.Data = {
          C6050000424DC605000000000000360400002800000014000000140000000100
          08000000000090010000120B0000120B0000000100002A000000523C290000F3
          FF00EFCB8400FF9E2900ADDFD600848284008C6D18009999990063F7FF00CCCC
          CC005A595A00C6C3C60052BED600DEA67B00846100009C7D3100D6B26B00FFFF
          CC0052DFFF00ADFFFF009CF7FF00B5B6B500FFE79C00AD8A420073717300DEDB
          DE00E7BE7B00393C39009999990052FFFF00A5A6A500FFD79400FFF3AD00BD96
          4A00AD8A3900E7BE73008C8E8C00ADAAAD0099FFFF0066666600E7E7E70052C3
          D600000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          00000000000000000000000000000000000000000000000000000B0B0B0B0B0B
          0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B
          0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B
          060B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0E03060B0B0B0B0B0B0B0B0B25
          1800001B1B150E030D030618181B1E0B0B0B0B07131414120C0E0D0D0D0D0306
          12291B0B0B0B0B07131313130E0D11110D0D0D0306121B0B0B0B0B071313131A
          06060611110D0606061A180B0B0B0B071313131313130F1111200F1514121B0B
          0B0B0B070B13131313131711110D1F1412041B0B0B0B0B071313131313210D20
          1117141414120A0B0B0B0B250B130B1313211620231F13131313270B0B0B0B15
          130B1313220D1F1A131313131313180B0B0B0B0B0B130B10101010020B0B040C
          0C0C050B0B0B0B09151515090404121212121212120C0B0B0B0B0B0B19010101
          010C28242424242424240B0B0B0B0B0B071D08080801150B0B0B0B0B0B0B0B0B
          0B0B0B0B0B07242424070B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B
          0B0B0B0B0B0B0B0B0B0B}
        OnClick = SpeedButton1Click
      end
      object Bevel1: TBevel
        Left = 8
        Top = 120
        Width = 457
        Height = 2
      end
      object SpeedButton2: TSpeedButton
        Left = 443
        Top = 81
        Width = 23
        Height = 20
        Glyph.Data = {
          C6050000424DC605000000000000360400002800000014000000140000000100
          08000000000090010000120B0000120B0000000100002A000000523C290000F3
          FF00EFCB8400FF9E2900ADDFD600848284008C6D18009999990063F7FF00CCCC
          CC005A595A00C6C3C60052BED600DEA67B00846100009C7D3100D6B26B00FFFF
          CC0052DFFF00ADFFFF009CF7FF00B5B6B500FFE79C00AD8A420073717300DEDB
          DE00E7BE7B00393C39009999990052FFFF00A5A6A500FFD79400FFF3AD00BD96
          4A00AD8A3900E7BE73008C8E8C00ADAAAD0099FFFF0066666600E7E7E70052C3
          D600000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          00000000000000000000000000000000000000000000000000000B0B0B0B0B0B
          0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B
          0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B
          060B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0E03060B0B0B0B0B0B0B0B0B25
          1800001B1B150E030D030618181B1E0B0B0B0B07131414120C0E0D0D0D0D0306
          12291B0B0B0B0B07131313130E0D11110D0D0D0306121B0B0B0B0B071313131A
          06060611110D0606061A180B0B0B0B071313131313130F1111200F1514121B0B
          0B0B0B070B13131313131711110D1F1412041B0B0B0B0B071313131313210D20
          1117141414120A0B0B0B0B250B130B1313211620231F13131313270B0B0B0B15
          130B1313220D1F1A131313131313180B0B0B0B0B0B130B10101010020B0B040C
          0C0C050B0B0B0B09151515090404121212121212120C0B0B0B0B0B0B19010101
          010C28242424242424240B0B0B0B0B0B071D08080801150B0B0B0B0B0B0B0B0B
          0B0B0B0B0B07242424070B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B
          0B0B0B0B0B0B0B0B0B0B}
        OnClick = SpeedButton2Click
      end
      object DBEdit14: TDBEdit
        Left = 373
        Top = 28
        Width = 95
        Height = 21
        DataField = 'DATA_CANCELAMENTO_ALU'
        DataSource = DataSource
        TabOrder = 0
        OnExit = DBEdit14Exit
      end
      object DBMemo1: TDBMemo
        Left = 8
        Top = 152
        Width = 460
        Height = 79
        DataField = 'DISP_ORINT_ALU'
        DataSource = DataSource
        TabOrder = 1
      end
      object DBLookupComboBox1: TDBLookupComboBox
        Left = 8
        Top = 80
        Width = 217
        Height = 21
        DataField = 'COD_EMPRESA'
        DataSource = DataSource
        KeyField = 'COD_EMP'
        ListField = 'NOME_EMP'
        ListFieldIndex = -1
        ListSource = dsEmpresa
        TabOrder = 2
      end
      object DBLookupComboBox2: TDBLookupComboBox
        Left = 272
        Top = 80
        Width = 161
        Height = 21
        DataField = 'COD_PROFESSOR'
        DataSource = DataSource
        KeyField = 'COD_PROF'
        ListField = 'NOME_PROF'
        ListFieldIndex = -1
        ListSource = dsOrientador
        TabOrder = 3
      end
      object DBComboBox1: TDBComboBox
        Left = 9
        Top = 28
        Width = 142
        Height = 21
        Style = csDropDownList
        DataField = 'CRONOGRAMA_ALU'
        DataSource = DataSource
        ItemHeight = 13
        Items.Strings = (
          'Semestral'
          'Anual')
        TabOrder = 4
      end
    end
  end
  inherited pnlRegistros: TPanel
    Top = 335
    Width = 503
    inherited DBNavigator1: TDBNavigator
      Width = 501
      Hints.Strings = ()
    end
  end
  inherited SQLQuery: TSQLQuery
    SQL.Strings = (
      'SELECT * FROM ALUNO')
    Left = 456
  end
  inherited DataSetProvider: TDataSetProvider
    Left = 416
  end
  inherited ClientDataSet: TClientDataSet
    BeforePost = ClientDataSetBeforePost
    Left = 376
    object ClientDataSetANO_LETIVO: TIntegerField
      FieldName = 'ANO_LETIVO'
      ProviderFlags = [pfInUpdate, pfInWhere, pfInKey]
    end
    object ClientDataSetRA_ALU: TIntegerField
      FieldName = 'RA_ALU'
      ProviderFlags = [pfInUpdate, pfInWhere, pfInKey]
    end
    object ClientDataSetTURMA_ALU: TStringField
      FieldName = 'TURMA_ALU'
      ProviderFlags = []
      Size = 10
    end
    object ClientDataSetNOME_ALU: TStringField
      FieldName = 'NOME_ALU'
      ProviderFlags = []
      Size = 50
    end
    object ClientDataSetEND_ALU: TStringField
      FieldName = 'END_ALU'
      ProviderFlags = []
      Size = 30
    end
    object ClientDataSetCIDADE_ALU: TStringField
      FieldName = 'CIDADE_ALU'
      ProviderFlags = []
      Size = 30
    end
    object ClientDataSetUF_ALU: TStringField
      FieldName = 'UF_ALU'
      ProviderFlags = []
      FixedChar = True
      Size = 2
    end
    object ClientDataSetFONE_ALU: TStringField
      FieldName = 'FONE_ALU'
      ProviderFlags = []
      EditMask = '99-9999-9999'
    end
    object ClientDataSetCELULAR_ALU: TStringField
      FieldName = 'CELULAR_ALU'
      ProviderFlags = []
    end
    object ClientDataSetFONE_COMER_ALU: TStringField
      FieldName = 'FONE_COMER_ALU'
      ProviderFlags = []
      EditMask = '99-9999-9999'
    end
    object ClientDataSetEMAIL_ALU: TStringField
      FieldName = 'EMAIL_ALU'
      ProviderFlags = []
      Size = 50
    end
    object ClientDataSetCEP_ALU: TStringField
      FieldName = 'CEP_ALU'
      ProviderFlags = []
      Size = 10
    end
    object ClientDataSetDISP_ORINT_ALU: TStringField
      FieldName = 'DISP_ORINT_ALU'
      ProviderFlags = []
      Size = 50
    end
    object ClientDataSetCRONOGRAMA_ALU: TStringField
      FieldName = 'CRONOGRAMA_ALU'
      ProviderFlags = []
      Size = 50
    end
    object ClientDataSetDATA_CANCELAMENTO_ALU: TDateField
      CustomConstraint = 'DATA_CANCELAMENTO_ALU<01/01/2000'
      ConstraintErrorMessage = 'Data  inv'#225'lida'
      FieldName = 'DATA_CANCELAMENTO_ALU'
      ProviderFlags = []
      OnValidate = ClientDataSetDATA_CANCELAMENTO_ALUValidate
      EditMask = '!99/99/9999;1;_'
    end
    object ClientDataSetMOTIVO_CANCELAMENTO_ALU: TStringField
      FieldName = 'MOTIVO_CANCELAMENTO_ALU'
      ProviderFlags = []
      Size = 40
    end
    object ClientDataSetCOD_PROFESSOR: TIntegerField
      FieldName = 'COD_PROFESSOR'
    end
    object ClientDataSetCOD_EMPRESA: TIntegerField
      FieldName = 'COD_EMPRESA'
    end
    object ClientDataSetCOD_TURMA: TIntegerField
      FieldName = 'COD_TURMA'
    end
    object ClientDataSetBAIRRO: TStringField
      FieldName = 'BAIRRO'
      ProviderFlags = []
      Size = 30
    end
  end
  inherited DataSource: TDataSource
    Left = 336
  end
  inherited sqlUltimoRegistro: TSQLQuery
    Left = 304
    Top = 8
  end
  object sdsEmpresa: TSimpleDataSet
    Aggregates = <>
    Connection = DmGeral.SQLConnection
    DataSet.CommandText = 'select * from EMPRESA ORDER BY NOME_EMP'
    DataSet.MaxBlobSize = -1
    DataSet.Params = <>
    Params = <>
    Left = 161
    Top = 135
  end
  object sdsOrientador: TSimpleDataSet
    Aggregates = <>
    Connection = DmGeral.SQLConnection
    DataSet.CommandText = 'select * from PROFESSOR ORDER BY NOME_PROF'
    DataSet.MaxBlobSize = -1
    DataSet.Params = <>
    Params = <>
    Left = 281
    Top = 63
    object sdsOrientadorCOD_PROF: TIntegerField
      FieldName = 'COD_PROF'
      Required = True
    end
    object sdsOrientadorNOME_PROF: TStringField
      FieldName = 'NOME_PROF'
      Size = 50
    end
    object sdsOrientadorFONE_PROF: TStringField
      FieldName = 'FONE_PROF'
    end
    object sdsOrientadorCELULAR_PROF: TStringField
      FieldName = 'CELULAR_PROF'
    end
    object sdsOrientadorEMAIL_PROF: TStringField
      FieldName = 'EMAIL_PROF'
      Size = 50
    end
    object sdsOrientadorCATEGORIA_PROF: TIntegerField
      FieldName = 'CATEGORIA_PROF'
    end
  end
  object sdsCronograma: TSimpleDataSet
    Aggregates = <>
    Connection = DmGeral.SQLConnection
    DataSet.CommandText = 'select  from ALUNO ORDER BY NOME_ALU'
    DataSet.MaxBlobSize = -1
    DataSet.Params = <>
    Params = <>
    Left = 89
    Top = 79
  end
  object dsEmpresa: TDataSource
    DataSet = sdsEmpresa
    Left = 129
    Top = 135
  end
  object dsOrientador: TDataSource
    DataSet = sdsOrientador
    Left = 313
    Top = 63
  end
  object sdsTurma: TSimpleDataSet
    Aggregates = <>
    Connection = DmGeral.SQLConnection
    DataSet.CommandText = 'select * from TURMA ORDER BY DESCRICAO'
    DataSet.MaxBlobSize = -1
    DataSet.Params = <>
    Params = <>
    Left = 281
    Top = 119
    object sdsTurmaCOD_TURMA: TIntegerField
      FieldName = 'COD_TURMA'
      Required = True
    end
    object sdsTurmaDESCRICAO: TStringField
      FieldName = 'DESCRICAO'
      Size = 50
    end
  end
  object dsTurma: TDataSource
    DataSet = sdsTurma
    Left = 321
    Top = 119
  end
  object sqlBuscaAluno: TSQLQuery
    MaxBlobSize = -1
    Params = <
      item
        DataType = ftUnknown
        Name = 'RA'
        ParamType = ptUnknown
      end
      item
        DataType = ftUnknown
        Name = 'ANO'
        ParamType = ptUnknown
      end
      item
        DataType = ftUnknown
        Name = 'CODIGO'
        ParamType = ptUnknown
      end>
    SQL.Strings = (
      'SELECT COUNT(*) FROM ALUNO A '
      'WHERE A.ra_alu = :RA AND A.ano_letivo = :ANO AND'
      'A.cod_professor = :CODIGO')
    SQLConnection = DmGeral.SQLConnection
    Top = 16
  end
end
