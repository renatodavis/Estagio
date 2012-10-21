inherited FormMovControleDocumentos: TFormMovControleDocumentos
  Left = 209
  Caption = 'FormMovControleDocumentos'
  ClientHeight = 405
  ClientWidth = 561
  OldCreateOrder = True
  PixelsPerInch = 96
  TextHeight = 13
  inherited PnlTitulo: TPanel
    Width = 561
    inherited Image1: TImage
      Width = 561
    end
    inherited LblTitulo: TLabel
      Width = 139
      Caption = 'Controle de Documentos'
    end
  end
  inherited StbPadrao: TStatusBar
    Top = 386
    Width = 561
  end
  inherited Panel1: TPanel
    Top = 353
    Width = 561
    inherited btnNovo: TBitBtn
      Visible = False
    end
    inherited btnExcluir: TBitBtn
      Visible = False
    end
    inherited btnConsultar: TBitBtn
      Left = 165
      Visible = False
    end
    inherited btnCancelar: TBitBtn
      Left = 262
    end
    inherited btngravar: TBitBtn
      Left = 340
    end
  end
  object GroupBox1: TGroupBox [3]
    Left = 8
    Top = 52
    Width = 545
    Height = 272
    TabOrder = 4
    object Label2: TLabel
      Left = 16
      Top = 19
      Width = 51
      Height = 13
      Caption = 'Ano Letivo'
    end
    object Label11: TLabel
      Left = 16
      Top = 69
      Width = 54
      Height = 13
      Caption = 'Documento'
    end
    object Label3: TLabel
      Left = 412
      Top = 19
      Width = 30
      Height = 13
      Caption = 'Turma'
    end
    object Label1: TLabel
      Left = 412
      Top = 69
      Width = 64
      Height = 13
      Caption = 'Data Entrega'
    end
    object chbEntregue: TDBCheckBox
      Left = 216
      Top = 92
      Width = 122
      Height = 17
      Caption = 'chbEntregue'
      DataField = 'ENTREGUE'
      DataSource = DataSource
      TabOrder = 3
      ValueChecked = 'True'
      ValueUnchecked = 'False'
      OnClick = chbEntregueClick
    end
    object DBGrid1: TDBGrid
      Left = 13
      Top = 127
      Width = 516
      Height = 132
      DataSource = dsAluno
      Options = [dgTitles, dgIndicator, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgRowSelect, dgAlwaysShowSelection, dgConfirmDelete, dgCancelOnExit]
      ReadOnly = True
      TabOrder = 4
      TitleFont.Charset = ANSI_CHARSET
      TitleFont.Color = clWindowText
      TitleFont.Height = -11
      TitleFont.Name = 'Tahoma'
      TitleFont.Style = []
      OnCellClick = DBGrid1CellClick
      Columns = <
        item
          Expanded = False
          FieldName = 'RA_ALU'
          Title.Caption = 'R.A.'
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'NOME_ALU'
          Title.Caption = 'Nome aluno'
          Width = 350
          Visible = True
        end
        item
          Alignment = taCenter
          Expanded = False
          FieldName = 'ENTREGUE'
          PickList.Strings = (
            'sim'
            'nao')
          Visible = True
        end>
    end
    object dbDataEntrega: TDBEdit
      Left = 412
      Top = 88
      Width = 116
      Height = 21
      DataField = 'DATA_ENTREGA'
      DataSource = DataSource
      TabOrder = 5
    end
    object comboturma: TComboBox
      Left = 411
      Top = 40
      Width = 117
      Height = 21
      Style = csDropDownList
      ItemHeight = 13
      TabOrder = 1
      OnChange = comboTurmaChange
    end
    object comboDocumentos: TComboBox
      Left = 16
      Top = 88
      Width = 189
      Height = 21
      Style = csDropDownList
      ItemHeight = 13
      TabOrder = 2
      OnChange = comboDocumentosChange
      OnCloseUp = comboDocumentosCloseUp
    end
    object dbAno: TEdit
      Left = 16
      Top = 40
      Width = 100
      Height = 21
      MaxLength = 4
      TabOrder = 0
      OnExit = dbAnoExit
      OnKeyPress = dbAnoKeyPress
    end
  end
  inherited pnlRegistros: TPanel
    Top = 331
    Width = 561
    inherited DBNavigator1: TDBNavigator
      Width = 559
      Hints.Strings = ()
    end
  end
  inherited SQLQuery: TSQLQuery
    Params = <
      item
        DataType = ftString
        Name = 'RA'
        ParamType = ptInput
      end
      item
        DataType = ftString
        Name = 'ANO'
        ParamType = ptInput
      end
      item
        DataType = ftString
        Name = 'DOCUMENTO'
        ParamType = ptInput
      end>
    SQL.Strings = (
      
        'SELECT D.ANO_LETIVO,D.RA,TD.DESC_DOS,D.ENTREGUE,D.DATA_ENTREGA,D' +
        '.COD_DOCUMENTO FROM DOCUMENTO D'
      
        '    JOIN ALUNO A ON(D.RA = A.RA_ALU AND D.ANO_LETIVO = A.ANO_LET' +
        'IVO)'
      '    JOIN  TIPO_DOCUMENTO TD ON (D.COD_DOCUMENTO = TD.COD_DOC)'
      'WHERE D.RA = :RA AND'
      '      D.ANO_LETIVO = :ANO AND'
      '      TD.DESC_DOS =:DOCUMENTO')
    object SQLQueryANO_LETIVO: TIntegerField
      FieldName = 'ANO_LETIVO'
      ProviderFlags = [pfInUpdate, pfInWhere, pfInKey]
    end
    object SQLQueryRA: TIntegerField
      FieldName = 'RA'
      ProviderFlags = [pfInUpdate, pfInWhere, pfInKey]
    end
    object SQLQueryDESC_DOS: TStringField
      FieldName = 'DESC_DOS'
      ProviderFlags = [pfInUpdate]
      Size = 50
    end
    object SQLQueryENTREGUE: TStringField
      FieldName = 'ENTREGUE'
      ProviderFlags = [pfInUpdate]
      FixedChar = True
      Size = 3
    end
    object SQLQueryDATA_ENTREGA: TDateField
      FieldName = 'DATA_ENTREGA'
      ProviderFlags = [pfInUpdate]
    end
    object SQLQueryCOD_DOCUMENTO: TIntegerField
      FieldName = 'COD_DOCUMENTO'
      ProviderFlags = [pfInUpdate, pfInWhere, pfInKey]
    end
  end
  inherited ClientDataSet: TClientDataSet
    BeforePost = ClientDataSetBeforePost
    object ClientDataSetANO_LETIVO: TIntegerField
      FieldName = 'ANO_LETIVO'
      ProviderFlags = [pfInUpdate, pfInWhere, pfInKey]
    end
    object ClientDataSetRA: TIntegerField
      FieldName = 'RA'
      ProviderFlags = [pfInUpdate, pfInWhere, pfInKey]
    end
    object ClientDataSetDESC_DOS: TStringField
      FieldName = 'DESC_DOS'
      ProviderFlags = [pfInUpdate]
      Size = 50
    end
    object ClientDataSetENTREGUE: TStringField
      FieldName = 'ENTREGUE'
      FixedChar = True
      Size = 3
    end
    object ClientDataSetDATA_ENTREGA: TDateField
      ConstraintErrorMessage = 'Data inv'#225'lida'
      FieldName = 'DATA_ENTREGA'
      EditMask = '99/99/9999'
    end
    object ClientDataSetCOD_DOCUMENTO: TIntegerField
      FieldName = 'COD_DOCUMENTO'
      ProviderFlags = [pfInUpdate, pfInWhere, pfInKey]
    end
  end
  inherited sqlUltimoRegistro: TSQLQuery
    Left = 168
    Top = 8
  end
  object CDSAluno: TClientDataSet
    Aggregates = <>
    Params = <>
    ProviderName = 'dspAluno'
    BeforeRowRequest = CDSAlunoBeforeRowRequest
    Left = 128
    Top = 217
    object CDSAlunoANO_LETIVO: TIntegerField
      FieldName = 'ANO_LETIVO'
      Required = True
    end
    object CDSAlunoRA_ALU: TIntegerField
      FieldName = 'RA_ALU'
      Required = True
    end
    object CDSAlunoTURMA_ALU: TStringField
      FieldName = 'TURMA_ALU'
      Size = 10
    end
    object CDSAlunoNOME_ALU: TStringField
      FieldName = 'NOME_ALU'
      Size = 50
    end
    object CDSAlunoEND_ALU: TStringField
      FieldName = 'END_ALU'
      Size = 30
    end
    object CDSAlunoCIDADE_ALU: TStringField
      FieldName = 'CIDADE_ALU'
      Size = 30
    end
    object CDSAlunoUF_ALU: TStringField
      FieldName = 'UF_ALU'
      FixedChar = True
      Size = 2
    end
    object CDSAlunoFONE_ALU: TStringField
      FieldName = 'FONE_ALU'
    end
    object CDSAlunoCELULAR_ALU: TStringField
      FieldName = 'CELULAR_ALU'
    end
    object CDSAlunoFONE_COMER_ALU: TStringField
      FieldName = 'FONE_COMER_ALU'
    end
    object CDSAlunoEMAIL_ALU: TStringField
      FieldName = 'EMAIL_ALU'
      Size = 50
    end
    object CDSAlunoCEP_ALU: TStringField
      FieldName = 'CEP_ALU'
      Size = 10
    end
    object CDSAlunoDISP_ORINT_ALU: TStringField
      FieldName = 'DISP_ORINT_ALU'
      Size = 50
    end
    object CDSAlunoCRONOGRAMA_ALU: TStringField
      FieldName = 'CRONOGRAMA_ALU'
      Size = 50
    end
    object CDSAlunoDATA_CANCELAMENTO_ALU: TDateField
      FieldName = 'DATA_CANCELAMENTO_ALU'
    end
    object CDSAlunoMOTIVO_CANCELAMENTO_ALU: TStringField
      FieldName = 'MOTIVO_CANCELAMENTO_ALU'
      Size = 40
    end
    object CDSAlunoCOD_PROFESSOR: TIntegerField
      FieldName = 'COD_PROFESSOR'
    end
    object CDSAlunoENTREGUE: TStringField
      FieldName = 'ENTREGUE'
      FixedChar = True
      Size = 3
    end
  end
  object dsAluno: TDataSource
    DataSet = CDSAluno
    Left = 96
    Top = 217
  end
  object SQLaLUNO: TSQLQuery
    MaxBlobSize = -1
    Params = <
      item
        DataType = ftString
        Name = 'ANO_LETIVO'
        ParamType = ptInput
      end
      item
        DataType = ftString
        Name = 'TURMA'
        ParamType = ptInput
      end>
    SQL.Strings = (
      'SELECT DISTINCT  a.*,d.ENTREGUE FROM ALUNO A'
      'join turma t on (t.cod_turma = a.cod_turma)'
      
        'left join documento d on(d.ano_letivo = a.ano_letivo and d.ra = ' +
        'a.ra_alu)'
      'WHERE A.ANO_LETIVO = :ANO_LETIVO AND t.descricao=:TURMA'
      'ORDER BY a.nome_alu')
    SQLConnection = DmGeral.SQLConnection
    Left = 160
    Top = 217
    object SQLaLUNOANO_LETIVO: TIntegerField
      FieldName = 'ANO_LETIVO'
      Required = True
    end
    object SQLaLUNORA_ALU: TIntegerField
      FieldName = 'RA_ALU'
      Required = True
    end
    object SQLaLUNOTURMA_ALU: TStringField
      FieldName = 'TURMA_ALU'
      Size = 10
    end
    object SQLaLUNONOME_ALU: TStringField
      FieldName = 'NOME_ALU'
      Size = 50
    end
    object SQLaLUNOEND_ALU: TStringField
      FieldName = 'END_ALU'
      Size = 30
    end
    object SQLaLUNOCIDADE_ALU: TStringField
      FieldName = 'CIDADE_ALU'
      Size = 30
    end
    object SQLaLUNOUF_ALU: TStringField
      FieldName = 'UF_ALU'
      FixedChar = True
      Size = 2
    end
    object SQLaLUNOFONE_ALU: TStringField
      FieldName = 'FONE_ALU'
    end
    object SQLaLUNOCELULAR_ALU: TStringField
      FieldName = 'CELULAR_ALU'
    end
    object SQLaLUNOFONE_COMER_ALU: TStringField
      FieldName = 'FONE_COMER_ALU'
    end
    object SQLaLUNOEMAIL_ALU: TStringField
      FieldName = 'EMAIL_ALU'
      Size = 50
    end
    object SQLaLUNOCEP_ALU: TStringField
      FieldName = 'CEP_ALU'
      Size = 10
    end
    object SQLaLUNODISP_ORINT_ALU: TStringField
      FieldName = 'DISP_ORINT_ALU'
      Size = 50
    end
    object SQLaLUNOCRONOGRAMA_ALU: TStringField
      FieldName = 'CRONOGRAMA_ALU'
      Size = 50
    end
    object SQLaLUNODATA_CANCELAMENTO_ALU: TDateField
      FieldName = 'DATA_CANCELAMENTO_ALU'
    end
    object SQLaLUNOMOTIVO_CANCELAMENTO_ALU: TStringField
      FieldName = 'MOTIVO_CANCELAMENTO_ALU'
      Size = 40
    end
    object SQLaLUNOCOD_PROFESSOR: TIntegerField
      FieldName = 'COD_PROFESSOR'
    end
    object SQLaLUNOENTREGUE: TStringField
      FieldName = 'ENTREGUE'
      FixedChar = True
      Size = 3
    end
  end
  object cdsDocumento: TClientDataSet
    Aggregates = <>
    Filtered = True
    Params = <>
    ProviderName = 'dspDucumento'
    Left = 104
    Top = 121
    object cdsDocumentoCOD_DOC: TIntegerField
      FieldName = 'COD_DOC'
      Required = True
    end
    object cdsDocumentoDESC_DOS: TStringField
      FieldName = 'DESC_DOS'
      Size = 50
    end
    object cdsDocumentoOBS_DOC: TStringField
      FieldName = 'OBS_DOC'
      Size = 255
    end
  end
  object dspDucumento: TDataSetProvider
    DataSet = sqlQueryDocumento
    Left = 136
    Top = 121
  end
  object dsDocumento: TDataSource
    DataSet = cdsDocumento
    Left = 168
    Top = 121
  end
  object sqlQueryDocumento: TSQLQuery
    MaxBlobSize = -1
    Params = <>
    SQL.Strings = (
      'SELECT * FROM TIPO_DOCUMENTO')
    SQLConnection = DmGeral.SQLConnection
    Left = 200
    Top = 121
  end
  object cdsTurma: TClientDataSet
    Active = True
    Aggregates = <>
    Params = <>
    ProviderName = 'dspTurma'
    Left = 360
    Top = 146
    object cdsTurmaCOD_TURMA: TIntegerField
      FieldName = 'COD_TURMA'
      Required = True
    end
    object cdsTurmaDESCRICAO: TStringField
      FieldName = 'DESCRICAO'
      Size = 50
    end
  end
  object dspTurma: TDataSetProvider
    DataSet = sqlTurma
    Left = 392
    Top = 146
  end
  object dsTurma: TDataSource
    DataSet = cdsTurma
    Left = 424
    Top = 146
  end
  object sqlTurma: TSQLQuery
    MaxBlobSize = -1
    Params = <>
    SQL.Strings = (
      'SELECT * FROM TURMA ORDER BY DESCRICAO')
    SQLConnection = DmGeral.SQLConnection
    Left = 456
    Top = 146
  end
  object dspAluno: TDataSetProvider
    DataSet = SQLaLUNO
    Left = 64
    Top = 217
  end
end
