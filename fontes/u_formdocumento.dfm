inherited FormMovDocumentos: TFormMovDocumentos
  Left = 133
  Top = 105
  Width = 515
  Height = 420
  Caption = 'Movimenta'#231#245'es'
  OldCreateOrder = True
  PixelsPerInch = 96
  TextHeight = 13
  inherited PnlTitulo: TPanel
    Width = 507
    inherited Image1: TImage
      Width = 507
    end
    inherited LblTitulo: TLabel
      Width = 139
      Caption = 'Controle de Documentos'
    end
  end
  inherited StbPadrao: TStatusBar
    Top = 374
    Width = 507
  end
  inherited Panel1: TPanel
    Top = 341
    Width = 507
  end
  object GroupBox1: TGroupBox [3]
    Left = 8
    Top = 52
    Width = 489
    Height = 257
    TabOrder = 4
    object Label1: TLabel
      Left = 16
      Top = 16
      Width = 14
      Height = 13
      Caption = 'RA'
    end
    object Label2: TLabel
      Left = 16
      Top = 71
      Width = 77
      Height = 13
      Caption = 'C'#243'd.Documento'
    end
    object Label3: TLabel
      Left = 280
      Top = 72
      Width = 77
      Height = 13
      Caption = 'Tipo Documento'
    end
    object Label4: TLabel
      Left = 352
      Top = 16
      Width = 51
      Height = 13
      Caption = 'Ano Letivo'
    end
    object Label5: TLabel
      Left = 152
      Top = 72
      Width = 64
      Height = 13
      Caption = 'Data Entrada'
    end
    object Label6: TLabel
      Left = 16
      Top = 128
      Width = 58
      Height = 13
      Caption = 'Observa'#231#227'o'
    end
    object DBEdit1: TDBEdit
      Left = 16
      Top = 32
      Width = 121
      Height = 21
      TabOrder = 0
    end
    object DBEdit2: TDBEdit
      Left = 352
      Top = 32
      Width = 121
      Height = 21
      TabOrder = 1
    end
    object DBEdit3: TDBEdit
      Left = 16
      Top = 87
      Width = 128
      Height = 21
      TabOrder = 2
    end
    object DBEdit5: TDBEdit
      Left = 152
      Top = 88
      Width = 121
      Height = 21
      TabOrder = 3
    end
    object DBComboBox1: TDBComboBox
      Left = 280
      Top = 88
      Width = 193
      Height = 21
      ItemHeight = 13
      TabOrder = 4
    end
    object DBMemo1: TDBMemo
      Left = 16
      Top = 144
      Width = 457
      Height = 97
      TabOrder = 5
    end
  end
  inherited pnlRegistros: TPanel
    Top = 319
    Width = 507
    inherited DBNavigator1: TDBNavigator
      Width = 505
      Hints.Strings = ()
    end
  end
end
