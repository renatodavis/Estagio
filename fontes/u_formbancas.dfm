inherited FormMovBancas: TFormMovBancas
  Left = 262
  Top = 218
  Caption = 'Movimenta'#231#245'es'
  ClientHeight = 451
  ClientWidth = 519
  OldCreateOrder = True
  PixelsPerInch = 96
  TextHeight = 13
  inherited PnlTitulo: TPanel
    Width = 519
    inherited Image1: TImage
      Width = 519
    end
    inherited LblTitulo: TLabel
      Width = 138
      Caption = 'Movimenta'#231'ao de Banca'
    end
    object Label1: TLabel
      Left = 311
      Top = 50
      Width = 80
      Height = 13
      Alignment = taRightJustify
      Caption = 'C'#243'digo da banca'
      Font.Charset = ANSI_CHARSET
      Font.Color = clSilver
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
    end
    object DBEdit1: TDBEdit
      Left = 394
      Top = 51
      Width = 85
      Height = 21
      BevelInner = bvNone
      BevelOuter = bvNone
      BiDiMode = bdLeftToRight
      BorderStyle = bsNone
      DataField = 'COD_BANCA'
      DataSource = DataSource
      Enabled = False
      ParentBiDiMode = False
      TabOrder = 0
    end
  end
  inherited StbPadrao: TStatusBar
    Top = 432
    Width = 519
  end
  inherited Panel1: TPanel
    Top = 399
    Width = 519
    inherited btnConsultar: TBitBtn
      Left = 330
    end
    inherited btnFechar: TBitBtn
      Left = 410
    end
  end
  object GroupBox1: TGroupBox [3]
    Left = 8
    Top = 49
    Width = 505
    Height = 322
    TabOrder = 4
    object Label2: TLabel
      Left = 22
      Top = 24
      Width = 51
      Height = 13
      Caption = 'Ano Letivo'
    end
    object Label5: TLabel
      Left = 109
      Top = 23
      Width = 55
      Height = 13
      Caption = 'Data banca'
    end
    object Label6: TLabel
      Left = 223
      Top = 23
      Width = 35
      Height = 13
      Caption = 'Horario'
    end
    object Label7: TLabel
      Left = 340
      Top = 23
      Width = 49
      Height = 13
      Caption = 'Sequ'#234'ncia'
    end
    object Label4: TLabel
      Left = 315
      Top = 71
      Width = 25
      Height = 13
      Caption = 'Bloco'
    end
    object Label8: TLabel
      Left = 397
      Top = 71
      Width = 20
      Height = 13
      Caption = 'Sala'
    end
    object Label9: TLabel
      Left = 22
      Top = 119
      Width = 84
      Height = 13
      Caption = 'T'#237'tulo do trabalho'
    end
    object Label10: TLabel
      Left = 24
      Top = 71
      Width = 27
      Height = 13
      Caption = 'Aluno'
    end
    object Label3: TLabel
      Left = 204
      Top = 70
      Width = 66
      Height = 13
      Caption = 'Oportunidade'
    end
    object Edit6: TDBEdit
      Left = 340
      Top = 39
      Width = 146
      Height = 21
      DataField = 'SEQUENCIA_BANCA'
      DataSource = DataSource
      MaxLength = 1
      TabOrder = 3
      OnExit = Edit6Exit
      OnKeyPress = Edit6KeyPress
    end
    object Edit7: TDBEdit
      Left = 314
      Top = 87
      Width = 76
      Height = 21
      DataField = 'BLOCO_BANCA'
      DataSource = DataSource
      TabOrder = 6
    end
    object Edit8: TDBEdit
      Left = 396
      Top = 87
      Width = 88
      Height = 21
      DataField = 'SALA_BANCA'
      DataSource = DataSource
      TabOrder = 7
    end
    object Edit9: TDBEdit
      Left = 22
      Top = 135
      Width = 464
      Height = 21
      CharCase = ecUpperCase
      DataField = 'TITULO_TRAB_BANCA'
      DataSource = DataSource
      TabOrder = 8
      OnExit = Edit9Exit
    end
    object iedtAnoLetivo: TDBEdit
      Left = 22
      Top = 39
      Width = 78
      Height = 21
      DataField = 'ANO_LETIVO_BANCA'
      DataSource = DataSource
      MaxLength = 4
      TabOrder = 0
      OnExit = iedtAnoLetivoExit
    end
    object DBEdit3: TDBEdit
      Left = 108
      Top = 39
      Width = 107
      Height = 21
      DataField = 'DATA_BANCA'
      DataSource = DataSource
      TabOrder = 1
    end
    object DBLookupComboBoxAluno: TDBLookupComboBox
      Left = 23
      Top = 88
      Width = 173
      Height = 21
      DataField = 'RA'
      DataSource = DataSource
      KeyField = 'RA_ALU'
      ListField = 'NOME_ALU'
      ListSource = dsAlunos
      TabOrder = 4
      OnCloseUp = DBLookupComboBoxAlunoCloseUp
    end
    object PageControl1: TPageControl
      Left = 20
      Top = 168
      Width = 465
      Height = 134
      ActivePage = TabSheet1
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      ParentFont = False
      Style = tsFlatButtons
      TabOrder = 9
      TabStop = False
      object TabSheet1: TTabSheet
        Caption = 'Professores'
        object DBGrid1: TDBGrid
          Left = 0
          Top = 0
          Width = 457
          Height = 102
          Align = alClient
          DataSource = dsProfBanca
          Font.Charset = ANSI_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          TabOrder = 0
          TitleFont.Charset = ANSI_CHARSET
          TitleFont.Color = clWindowText
          TitleFont.Height = -11
          TitleFont.Name = 'Arial'
          TitleFont.Style = []
          OnDblClick = DBGrid1DblClick
          OnEnter = DBGrid1Enter
          Columns = <
            item
              Expanded = False
              FieldName = 'COD_BANCA'
              Visible = False
            end
            item
              Expanded = False
              FieldName = 'COD_PROF'
              Visible = False
            end
            item
              Expanded = False
              FieldName = 'nomeprofessor'
              Title.Caption = 'Professor'
              Width = 270
              Visible = True
            end
            item
              Expanded = False
              FieldName = 'STATUS_PROF'
              PickList.Strings = (
                'Orientador'
                'Convidado')
              Visible = True
            end>
        end
      end
      object TabSheet2: TTabSheet
        Caption = 'Equipamentos'
        ImageIndex = 1
        object DBMemo1: TDBMemo
          Left = 0
          Top = 0
          Width = 457
          Height = 102
          Align = alClient
          DataField = 'EQUIPAMENTO'
          DataSource = DataSource
          Font.Charset = ANSI_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          MaxLength = 5000
          ParentFont = False
          ScrollBars = ssVertical
          TabOrder = 0
        end
      end
    end
    object mEdit5: TMaskEdit
      Left = 224
      Top = 38
      Width = 109
      Height = 21
      EditMask = '!99:99;1;_'
      MaxLength = 5
      TabOrder = 2
      Text = '  :  '
      OnKeyPress = mEdit5KeyPress
    end
    object cbbOportunidade: TDBComboBox
      Left = 203
      Top = 87
      Width = 105
      Height = 22
      Style = csOwnerDrawFixed
      DataField = 'OPORTUNIDADE'
      DataSource = DataSource
      ItemHeight = 16
      Items.Strings = (
        '1 Oportunidade'
        '2 Oportunidade')
      TabOrder = 5
      OnExit = cbbOportunidadeExit
    end
  end
  inherited pnlRegistros: TPanel
    Top = 377
    Width = 519
    inherited DBNavigator1: TDBNavigator
      Width = 517
      Hints.Strings = ()
      OnClick = DBNavigator1Click
    end
  end
  inherited SQLQuery: TSQLQuery
    SQL.Strings = (
      'SELECT * FROM BANCA')
  end
  inherited DataSetProvider: TDataSetProvider
    Options = [poCascadeDeletes]
    Left = 424
  end
  inherited ClientDataSet: TClientDataSet
    AfterOpen = ClientDataSetAfterOpen
    BeforePost = ClientDataSetBeforePost
    AfterRefresh = ClientDataSetAfterRefresh
    Left = 384
    object ClientDataSetCOD_BANCA: TIntegerField
      FieldName = 'COD_BANCA'
      ProviderFlags = [pfInUpdate, pfInWhere, pfInKey]
    end
    object ClientDataSetANO_LETIVO_BANCA: TIntegerField
      FieldName = 'ANO_LETIVO_BANCA'
    end
    object ClientDataSetRA: TIntegerField
      FieldName = 'RA'
    end
    object ClientDataSetDATA_BANCA: TDateField
      FieldName = 'DATA_BANCA'
      ProviderFlags = [pfInUpdate]
      OnValidate = ClientDataSetDATA_BANCAValidate
      EditMask = '99/99/9999'
    end
    object ClientDataSetHORARIO_BANCA: TTimeField
      FieldName = 'HORARIO_BANCA'
      ProviderFlags = [pfInUpdate]
      EditMask = '!99:99;1;_'
    end
    object ClientDataSetSEQUENCIA_BANCA: TIntegerField
      FieldName = 'SEQUENCIA_BANCA'
      ProviderFlags = [pfInUpdate]
    end
    object ClientDataSetBLOCO_BANCA: TStringField
      FieldName = 'BLOCO_BANCA'
      ProviderFlags = [pfInUpdate]
      Size = 10
    end
    object ClientDataSetSALA_BANCA: TStringField
      FieldName = 'SALA_BANCA'
      ProviderFlags = [pfInUpdate]
      Size = 10
    end
    object ClientDataSetTITULO_TRAB_BANCA: TStringField
      FieldName = 'TITULO_TRAB_BANCA'
      ProviderFlags = [pfInUpdate]
      Size = 50
    end
    object ClientDataSetEQUIPAMENTO: TStringField
      FieldName = 'EQUIPAMENTO'
      ProviderFlags = [pfInUpdate]
      FixedChar = True
      Size = 5000
    end
    object ClientDataSetsqlProfBanca: TDataSetField
      FieldName = 'sqlProfBanca'
    end
    object ClientDataSetOPORTUNIDADE: TStringField
      DisplayWidth = 20
      FieldName = 'OPORTUNIDADE'
    end
  end
  inherited DataSource: TDataSource
    Left = 336
  end
  inherited sqlUltimoRegistro: TSQLQuery
    SQL.Strings = (
      'SELECT MAX(COD_BANCA) FROM BANCA ')
    Left = 272
    Top = 8
    object sqlUltimoRegistroMAX: TIntegerField
      FieldName = 'MAX'
    end
  end
  object sqlProfBanca: TSQLQuery
    DataSource = dsLink
    MaxBlobSize = -1
    Params = <
      item
        DataType = ftInteger
        Name = 'COD_BANCA'
        ParamType = ptInput
        Size = 4
      end>
    SQL.Strings = (
      'SELECT * FROM PROF_BANCA WHERE COD_BANCA = :COD_BANCA '
      'ORDER BY COD_BANCA')
    SQLConnection = DmGeral.SQLConnection
    Left = 368
    Top = 297
  end
  object cdsProfBanca: TClientDataSet
    Aggregates = <>
    DataSetField = ClientDataSetsqlProfBanca
    Params = <>
    BeforePost = cdsProfBancaBeforePost
    Left = 400
    Top = 297
    object cdsProfBancaCOD_BANCA: TIntegerField
      DisplayLabel = 'C'#243'd.Banca'
      FieldName = 'COD_BANCA'
      ProviderFlags = [pfInUpdate, pfInWhere, pfInKey]
    end
    object cdsProfBancaCOD_PROF: TIntegerField
      DisplayLabel = 'Professor'
      FieldName = 'COD_PROF'
      ProviderFlags = [pfInUpdate, pfInWhere, pfInKey]
      OnValidate = cdsProfBancaCOD_PROFValidate
    end
    object cdsProfBancaSTATUS_PROF: TStringField
      DisplayLabel = 'Status Prof.'
      FieldName = 'STATUS_PROF'
      ProviderFlags = [pfInUpdate]
    end
    object cdsProfBancanomeprofessor: TStringField
      FieldKind = fkLookup
      FieldName = 'nomeprofessor'
      LookupDataSet = sdsProfessor
      LookupKeyFields = 'COD_PROF'
      LookupResultField = 'NOME_PROF'
      KeyFields = 'COD_PROF'
      Lookup = True
    end
  end
  object dsProfBanca: TDataSource
    DataSet = cdsProfBanca
    Left = 336
    Top = 297
  end
  object dsAlunos: TDataSource
    DataSet = sdsAlunos
    Left = 416
    Top = 97
  end
  object dsLink: TDataSource
    DataSet = SQLQuery
    Top = 169
  end
  object sdsAlunos: TSimpleDataSet
    Aggregates = <>
    Connection = DmGeral.SQLConnection
    DataSet.CommandText = 
      'SELECT * FROM ALUNO WHERE ANO_LETIVO = :ANO_LETIVO order by nome' +
      '_alu'
    DataSet.MaxBlobSize = -1
    DataSet.Params = <
      item
        DataType = ftInteger
        Name = 'ANO_LETIVO'
        ParamType = ptInput
      end>
    Params = <>
    Left = 448
    Top = 97
    object sdsAlunosANO_LETIVO: TIntegerField
      FieldName = 'ANO_LETIVO'
      Required = True
    end
    object sdsAlunosRA_ALU: TIntegerField
      FieldName = 'RA_ALU'
      Required = True
    end
    object sdsAlunosTURMA_ALU: TStringField
      FieldName = 'TURMA_ALU'
      Size = 10
    end
    object sdsAlunosNOME_ALU: TStringField
      FieldName = 'NOME_ALU'
      Size = 50
    end
    object sdsAlunosEND_ALU: TStringField
      FieldName = 'END_ALU'
      Size = 30
    end
    object sdsAlunosCIDADE_ALU: TStringField
      FieldName = 'CIDADE_ALU'
      Size = 30
    end
    object sdsAlunosUF_ALU: TStringField
      FieldName = 'UF_ALU'
      FixedChar = True
      Size = 2
    end
    object sdsAlunosFONE_ALU: TStringField
      FieldName = 'FONE_ALU'
    end
    object sdsAlunosCELULAR_ALU: TStringField
      FieldName = 'CELULAR_ALU'
    end
    object sdsAlunosFONE_COMER_ALU: TStringField
      FieldName = 'FONE_COMER_ALU'
    end
    object sdsAlunosEMAIL_ALU: TStringField
      FieldName = 'EMAIL_ALU'
      Size = 50
    end
    object sdsAlunosCEP_ALU: TStringField
      FieldName = 'CEP_ALU'
      Size = 10
    end
    object sdsAlunosDISP_ORINT_ALU: TStringField
      FieldName = 'DISP_ORINT_ALU'
      Size = 50
    end
    object sdsAlunosCRONOGRAMA_ALU: TStringField
      FieldName = 'CRONOGRAMA_ALU'
      Size = 50
    end
    object sdsAlunosDATA_CANCELAMENTO_ALU: TDateField
      FieldName = 'DATA_CANCELAMENTO_ALU'
    end
    object sdsAlunosMOTIVO_CANCELAMENTO_ALU: TStringField
      FieldName = 'MOTIVO_CANCELAMENTO_ALU'
      Size = 40
    end
    object sdsAlunosCOD_PROFESSOR: TIntegerField
      FieldName = 'COD_PROFESSOR'
    end
  end
  object sdsProfessor: TSimpleDataSet
    Active = True
    Aggregates = <>
    Connection = DmGeral.SQLConnection
    DataSet.CommandText = 'SELECT * FROM PROFESSOR'
    DataSet.MaxBlobSize = -1
    DataSet.Params = <>
    Params = <>
    Left = 176
    Top = 265
  end
  object sdsExcluir: TSQLQuery
    MaxBlobSize = -1
    Params = <
      item
        DataType = ftUnknown
        Name = 'banca'
        ParamType = ptUnknown
      end>
    SQL.Strings = (
      'delete from banca where cod_banca =:banca')
    SQLConnection = DmGeral.SQLConnection
    Left = 72
    Top = 309
  end
end
