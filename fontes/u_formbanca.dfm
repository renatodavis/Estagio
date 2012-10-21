inherited FormMovBancas: TFormMovBancas
  Width = 505
  Height = 412
  Caption = 'FormMovBancas'
  OldCreateOrder = True
  PixelsPerInch = 96
  TextHeight = 13
  inherited PnlTitulo: TPanel
    Width = 497
    inherited LblTitulo: TLabel
      Width = 138
      Caption = 'Movimenta'#231'ao de Banca'
    end
  end
  inherited StbPadrao: TStatusBar
    Top = 366
    Width = 497
  end
  inherited Panel1: TPanel
    Top = 333
    Width = 497
  end
  object GroupBox1: TGroupBox [3]
    Left = 8
    Top = 41
    Width = 481
    Height = 283
    TabOrder = 3
    object Label2: TLabel
      Left = 21
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
      Left = 21
      Top = 71
      Width = 25
      Height = 13
      Caption = 'Bloco'
    end
    object Label8: TLabel
      Left = 135
      Top = 71
      Width = 20
      Height = 13
      Caption = 'Sala'
    end
    object Label9: TLabel
      Left = 21
      Top = 119
      Width = 84
      Height = 13
      Caption = 'T'#237'tulo do trabalho'
    end
    object Label10: TLabel
      Left = 249
      Top = 70
      Width = 27
      Height = 13
      Caption = 'Aluno'
    end
    object Label11: TLabel
      Left = 21
      Top = 167
      Width = 65
      Height = 13
      Caption = 'Professor(es)'
    end
    object Edit2: TDBEdit
      Left = 21
      Top = 39
      Width = 81
      Height = 21
      DataField = 'ANO_LETIVO_BANCA'
      TabOrder = 0
    end
    object Edit4: TDBEdit
      Left = 109
      Top = 39
      Width = 105
      Height = 21
      DataField = 'DATA_BANCA'
      TabOrder = 1
    end
    object Edit5: TDBEdit
      Left = 223
      Top = 39
      Width = 105
      Height = 21
      DataField = 'HORARIO_BANCA'
      TabOrder = 2
    end
    object Edit6: TDBEdit
      Left = 338
      Top = 39
      Width = 119
      Height = 21
      DataField = 'SEQUENCIA_BANCA'
      TabOrder = 3
    end
    object Edit7: TDBEdit
      Left = 21
      Top = 87
      Width = 105
      Height = 21
      DataField = 'BLOCO_BANCA'
      TabOrder = 4
    end
    object Edit8: TDBEdit
      Left = 135
      Top = 87
      Width = 105
      Height = 21
      DataField = 'SALA_BANCA'
      TabOrder = 5
    end
    object Edit9: TDBEdit
      Left = 21
      Top = 135
      Width = 438
      Height = 21
      DataField = 'TITULO_TRAB_BANCA'
      TabOrder = 6
    end
    object DBComboBox1: TDBComboBox
      Left = 249
      Top = 87
      Width = 210
      Height = 21
      DataField = 'RA'
      ItemHeight = 13
      TabOrder = 7
    end
    object DBGrid1: TDBGrid
      Left = 21
      Top = 184
      Width = 438
      Height = 77
      DataSource = dsProfessor
      TabOrder = 8
      TitleFont.Charset = ANSI_CHARSET
      TitleFont.Color = clWindowText
      TitleFont.Height = -11
      TitleFont.Name = 'Tahoma'
      TitleFont.Style = []
      Columns = <
        item
          Expanded = False
          FieldName = 'NOME_PROF'
          Title.Caption = 'Nome Professor'
          Width = 200
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'STATUS_PROF'
          Title.Caption = 'Status'
          Visible = True
        end>
    end
  end
  inherited SQLQuery: TSQLQuery
    SQL.Strings = (
      'SELECT * FROM BANCA')
  end
  inherited ClientDataSet: TClientDataSet
    object ClientDataSetCOD_BANCA: TIntegerField
      FieldName = 'COD_BANCA'
      Required = True
    end
    object ClientDataSetANO_LETIVO_BANCA: TIntegerField
      FieldName = 'ANO_LETIVO_BANCA'
    end
    object ClientDataSetRA: TIntegerField
      FieldName = 'RA'
    end
    object ClientDataSetDATA_BANCA: TDateField
      FieldName = 'DATA_BANCA'
    end
    object ClientDataSetHORARIO_BANCA: TTimeField
      FieldName = 'HORARIO_BANCA'
    end
    object ClientDataSetSEQUENCIA_BANCA: TIntegerField
      FieldName = 'SEQUENCIA_BANCA'
    end
    object ClientDataSetBLOCO_BANCA: TStringField
      FieldName = 'BLOCO_BANCA'
      Size = 10
    end
    object ClientDataSetSALA_BANCA: TStringField
      FieldName = 'SALA_BANCA'
      Size = 10
    end
    object ClientDataSetTITULO_TRAB_BANCA: TStringField
      FieldName = 'TITULO_TRAB_BANCA'
      Size = 50
    end
    object ClientDataSetsqlProfessor: TDataSetField
      FieldName = 'sqlProfessor'
    end
    object ClientDataSetsqlBancaProf: TDataSetField
      FieldName = 'sqlBancaProf'
    end
  end
  object dsProfessor: TDataSource
    DataSet = cdsProfessor
    Left = 344
    Top = 273
  end
  object cdsProfessor: TClientDataSet
    Aggregates = <>
    DataSetField = ClientDataSetsqlBancaProf
    IndexFieldNames = 'COD_BANCA'
    MasterFields = 'COD_BANCA'
    PacketRecords = 0
    Params = <>
    Left = 408
    Top = 273
    object cdsProfessorCOD_BANCA: TIntegerField
      FieldName = 'COD_BANCA'
      Required = True
    end
    object cdsProfessorCOD_PROF: TIntegerField
      FieldName = 'COD_PROF'
      Required = True
    end
    object cdsProfessorSTATUS_PROF: TStringField
      FieldName = 'STATUS_PROF'
    end
    object cdsProfessorNOME_PROF: TStringField
      FieldKind = fkLookup
      FieldName = 'NOME_PROF'
      LookupDataSet = sqlProfessor
      LookupKeyFields = 'COD_PROF'
      LookupResultField = 'NOME_PROF'
      KeyFields = 'COD_PROF'
      Lookup = True
    end
  end
  object sqlBancaProf: TSQLQuery
    DataSource = dsLINK
    MaxBlobSize = -1
    Params = <
      item
        DataType = ftInteger
        Name = 'COD_BANCA'
        ParamType = ptInput
        Size = 4
      end>
    SQL.Strings = (
      'SELECT * FROM PROF_BANCA WHERE COD_BANCA = :COD_BANCA')
    SQLConnection = dmGeral.SQLConnection
    Left = 376
    Top = 273
  end
  object dsLINK: TDataSource
    DataSet = SQLQuery
    Top = 177
  end
  object dsProf: TDataSource
    DataSet = SQLQuery
    Left = 32
    Top = 273
  end
  object sqlProfessor: TSQLQuery
    DataSource = dsProf
    MaxBlobSize = -1
    Params = <>
    SQL.Strings = (
      'SELECT * FROM PROFESSOR')
    SQLConnection = dmGeral.SQLConnection
    Left = 64
    Top = 273
  end
end
