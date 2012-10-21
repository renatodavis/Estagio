inherited FormCad_Ocorrencias: TFormCad_Ocorrencias
  Top = 127
  HelpContext = 105
  Caption = 'Cadastros'
  ClientHeight = 310
  ClientWidth = 498
  OldCreateOrder = True
  PixelsPerInch = 96
  TextHeight = 13
  inherited PnlTitulo: TPanel
    Width = 498
    TabOrder = 3
    inherited Image1: TImage
      Width = 498
      HelpContext = 105
    end
    inherited LblTitulo: TLabel
      Width = 67
      Caption = 'Ocorr'#234'ncias'
    end
  end
  inherited StbPadrao: TStatusBar
    Top = 291
    Width = 498
  end
  inherited Panel1: TPanel
    Top = 258
    Width = 498
    HelpContext = 105
    TabOrder = 1
  end
  inherited pnlRegistros: TPanel
    Top = 236
    Width = 498
    TabOrder = 2
    inherited DBNavigator1: TDBNavigator
      Width = 496
      Hints.Strings = ()
    end
  end
  object GroupBox1: TGroupBox [4]
    Left = 8
    Top = 51
    Width = 481
    Height = 177
    HelpContext = 105
    TabOrder = 0
    object LblData: TLabel
      Left = 16
      Top = 24
      Width = 23
      Height = 13
      Caption = 'Data'
    end
    object LblHora: TLabel
      Left = 344
      Top = 24
      Width = 23
      Height = 13
      Caption = 'Hora'
    end
    object LblDescricao: TLabel
      Left = 16
      Top = 74
      Width = 46
      Height = 13
      Caption = 'Descri'#231#227'o'
    end
    object DBMDescricao: TDBMemo
      Left = 14
      Top = 90
      Width = 451
      Height = 73
      DataField = 'DESC_OCORRENCIA'
      DataSource = DataSource
      TabOrder = 2
    end
    object DBEdit1: TDBEdit
      Left = 16
      Top = 44
      Width = 121
      Height = 21
      DataField = 'DATA_OCORRENCIA'
      DataSource = DataSource
      TabOrder = 0
      OnExit = DBEdit1Exit
    end
    object DBEdit2: TDBEdit
      Left = 344
      Top = 44
      Width = 121
      Height = 21
      DataField = 'HORA_OCORRENCIA'
      DataSource = DataSource
      TabOrder = 1
    end
  end
  inherited SQLQuery: TSQLQuery
    SQL.Strings = (
      'SELECT * FROM OCORRENCIAS')
  end
  inherited ClientDataSet: TClientDataSet
    object ClientDataSetDATA_OCORRENCIA: TDateField
      FieldName = 'DATA_OCORRENCIA'
      Required = True
      EditMask = '99/99/9999'
    end
    object ClientDataSetHORA_OCORRENCIA: TTimeField
      ConstraintErrorMessage = 'Hora Inv'#225'lida'
      FieldName = 'HORA_OCORRENCIA'
      EditMask = '99:99:99'
    end
    object ClientDataSetDESC_OCORRENCIA: TStringField
      FieldName = 'DESC_OCORRENCIA'
      Size = 255
    end
  end
end
