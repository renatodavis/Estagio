inherited ConsultaBancas: TConsultaBancas
  Caption = 'Pesquisa'
  OldCreateOrder = True
  PixelsPerInch = 96
  TextHeight = 13
  inherited Panel2: TPanel
    inherited pnlTitulo: TPanel
      inherited Label1: TLabel
        Width = 176
        Caption = 'Pesquisando Por Bancas'
      end
    end
  end
  inherited cdsConsulta: TClientDataSet
    object cdsConsultaNOME_ALU: TStringField
      DisplayLabel = 'Aluno'
      FieldName = 'NOME_ALU'
      Size = 50
    end
    object cdsConsultaCOD_BANCA: TIntegerField
      DisplayLabel = 'C'#243'digo'
      FieldName = 'COD_BANCA'
      Required = True
    end
    object cdsConsultaANO_LETIVO_BANCA: TIntegerField
      DisplayLabel = 'Ano Letivo'
      FieldName = 'ANO_LETIVO_BANCA'
    end
    object cdsConsultaRA: TIntegerField
      FieldName = 'RA'
    end
    object cdsConsultaDATA_BANCA: TDateField
      DisplayLabel = 'Data Banca'
      FieldName = 'DATA_BANCA'
    end
    object cdsConsultaHORARIO_BANCA: TTimeField
      DisplayLabel = 'Horario'
      FieldName = 'HORARIO_BANCA'
    end
    object cdsConsultaSEQUENCIA_BANCA: TIntegerField
      DisplayLabel = 'Sequencia'
      FieldName = 'SEQUENCIA_BANCA'
    end
    object cdsConsultaBLOCO_BANCA: TStringField
      DisplayLabel = 'Bloco'
      FieldName = 'BLOCO_BANCA'
      Size = 10
    end
    object cdsConsultaSALA_BANCA: TStringField
      DisplayLabel = 'Sala'
      FieldName = 'SALA_BANCA'
      Size = 10
    end
    object cdsConsultaTITULO_TRAB_BANCA: TStringField
      DisplayLabel = 'Titulo do Trabalho'
      FieldName = 'TITULO_TRAB_BANCA'
      Size = 50
    end
  end
  inherited sdsConsulta: TSQLDataSet
    CommandText = 
      'select a.nome_alu,b.* from BANCA b'#13#10'join aluno a on(b.ano_letivo' +
      '_banca = a.ano_letivo and b.ra = a.ra_alu)'#13#10
  end
end
