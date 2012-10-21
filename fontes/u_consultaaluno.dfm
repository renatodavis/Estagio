inherited ConsultaAlunos: TConsultaAlunos
  Left = 232
  Top = 248
  Caption = 'ConsultaAlunos'
  OldCreateOrder = True
  PixelsPerInch = 96
  TextHeight = 13
  inherited Panel2: TPanel
    inherited pnlTitulo: TPanel
      inherited Label1: TLabel
        Width = 167
        Caption = 'Pesquisando Por  Aluno'
      end
    end
  end
  inherited cdsConsulta: TClientDataSet
    object cdsConsultaANO_LETIVO: TIntegerField
      DisplayLabel = 'Ano'
      FieldName = 'ANO_LETIVO'
      Required = True
    end
    object cdsConsultaRA_ALU: TIntegerField
      DisplayLabel = 'RA'
      FieldName = 'RA_ALU'
      Required = True
    end
    object cdsConsultaTURMA_ALU: TStringField
      DisplayLabel = 'Turma'
      FieldName = 'TURMA_ALU'
      Size = 10
    end
    object cdsConsultaNOME_ALU: TStringField
      DisplayLabel = 'Nome'
      FieldName = 'NOME_ALU'
      Size = 50
    end
    object cdsConsultaEND_ALU: TStringField
      DisplayLabel = 'Endere'#231'o'
      FieldName = 'END_ALU'
      Size = 30
    end
    object cdsConsultaCIDADE_ALU: TStringField
      DisplayLabel = 'Cidade'
      FieldName = 'CIDADE_ALU'
      Size = 30
    end
    object cdsConsultaUF_ALU: TStringField
      DisplayLabel = 'UF'
      FieldName = 'UF_ALU'
      FixedChar = True
      Size = 2
    end
    object cdsConsultaFONE_ALU: TStringField
      DisplayLabel = 'Fone'
      FieldName = 'FONE_ALU'
    end
    object cdsConsultaCELULAR_ALU: TStringField
      DisplayLabel = 'Celular'
      FieldName = 'CELULAR_ALU'
    end
    object cdsConsultaFONE_COMER_ALU: TStringField
      DisplayLabel = 'Fone Com'
      FieldName = 'FONE_COMER_ALU'
    end
    object cdsConsultaEMAIL_ALU: TStringField
      DisplayLabel = 'email'
      FieldName = 'EMAIL_ALU'
      Size = 50
    end
    object cdsConsultaCEP_ALU: TStringField
      DisplayLabel = 'CEP'
      FieldName = 'CEP_ALU'
      Size = 10
    end
    object cdsConsultaDISP_ORINT_ALU: TStringField
      DisplayLabel = 'Disponibilidade'
      FieldName = 'DISP_ORINT_ALU'
      Size = 50
    end
    object cdsConsultaCRONOGRAMA_ALU: TStringField
      DisplayLabel = 'Cronograma'
      FieldName = 'CRONOGRAMA_ALU'
      Size = 50
    end
    object cdsConsultaDATA_CANCELAMENTO_ALU: TDateField
      DisplayLabel = 'Dta Cancelamento'
      FieldName = 'DATA_CANCELAMENTO_ALU'
    end
    object cdsConsultaMOTIVO_CANCELAMENTO_ALU: TStringField
      DisplayLabel = 'Motivo Cancelamento'
      FieldName = 'MOTIVO_CANCELAMENTO_ALU'
      Size = 40
    end
    object cdsConsultaCOD_PROFESSOR: TIntegerField
      DisplayLabel = 'Professor'
      FieldName = 'COD_PROFESSOR'
    end
  end
  inherited sdsConsulta: TSQLDataSet
    CommandText = 'SELECT * FROM ALUNO'
  end
end
