�
 TRELALUNOS 0  TPF0�
TRELAlunos	RELAlunosLeft� TopeCaption	RELAlunosOldCreateOrder	PixelsPerInch`
TextHeight �	TRLReport	RLReport1 �TRLBand	rlbTitulo �TRLLabelrlTituloLeftWidth� Caption   Relatório de Alunos  TRLLabellblOrientadorLeft TopWidthMHeight   TRLBandRLBand2Left&Top� Width�HeightBandTypebtColumnHeaderBorders.SidessdCustomBorders.DrawLeftBorders.DrawTop	Borders.DrawRightBorders.DrawBottom	Borders.FixedTop	ColorclSilverParentColorTransparent TRLLabelRLLabel2Left TopWidth� HeightAutoSizeBorders.SidessdCustomBorders.DrawLeftBorders.DrawTopBorders.DrawRight	Borders.DrawBottomCaptionNomeFont.CharsetDEFAULT_CHARSET
Font.ColorclBlackFont.Height�	Font.NameArial
Font.StylefsBold 
ParentFontTransparent  TRLLabelRLLabel1Left� TopWidthUHeightAutoSizeBorders.SidessdCustomBorders.DrawLeftBorders.DrawTopBorders.DrawRight	Borders.DrawBottomCaptionTurmaFont.CharsetDEFAULT_CHARSET
Font.ColorclBlackFont.Height�	Font.NameArial
Font.StylefsBold 
ParentFontTransparent  TRLLabelRLLabel3Left0TopWidth� HeightAutoSizeCaptionProfessor orientadorFont.CharsetDEFAULT_CHARSET
Font.ColorclBlackFont.Height�	Font.NameArial
Font.StylefsBold 
ParentFontTransparent   TRLBandRLBand3Left&Top� Width�HeightBorders.SidessdCustomBorders.DrawLeftBorders.DrawTopBorders.DrawRightBorders.DrawBottomBeforePrintRLBand3BeforePrint 	TRLDBText	RLDBText1Left Top Width� HeightAutoSizeBorders.SidessdCustomBorders.DrawLeftBorders.DrawTopBorders.DrawRightBorders.DrawBottom	DataFieldNOME_ALU
DataSourceDataSource1  	TRLDBText	RLDBText2Left� Top WidthVHeight	AlignmenttaCenterAutoSizeBorders.SidessdCustomBorders.DrawLeft	Borders.DrawTopBorders.DrawRight	Borders.DrawBottom	DataField	TURMA_ALU
DataSourceDataSource1  TRLLabelrldbNomeProfLeft0Top Width� HeightAutoSize    �TClientDataSetClientDataSet1 TIntegerFieldClientDataSet1ANO_LETIVO	FieldName
ANO_LETIVORequired	  TIntegerFieldClientDataSet1RA_ALU	FieldNameRA_ALURequired	  TStringFieldClientDataSet1TURMA_ALU	FieldName	TURMA_ALUSize
  TStringFieldClientDataSet1NOME_ALU	FieldNameNOME_ALUSize2  TStringFieldClientDataSet1END_ALU	FieldNameEND_ALUSize  TStringFieldClientDataSet1CIDADE_ALU	FieldName
CIDADE_ALUSize  TStringFieldClientDataSet1UF_ALU	FieldNameUF_ALU	FixedChar	Size  TStringFieldClientDataSet1FONE_ALU	FieldNameFONE_ALU  TStringFieldClientDataSet1CELULAR_ALU	FieldNameCELULAR_ALU  TStringFieldClientDataSet1FONE_COMER_ALU	FieldNameFONE_COMER_ALU  TStringFieldClientDataSet1EMAIL_ALU	FieldName	EMAIL_ALUSize2  TStringFieldClientDataSet1CEP_ALU	FieldNameCEP_ALUSize
  TStringFieldClientDataSet1DISP_ORINT_ALU	FieldNameDISP_ORINT_ALUSize2  TStringFieldClientDataSet1CRONOGRAMA_ALU	FieldNameCRONOGRAMA_ALUSize2  
TDateField#ClientDataSet1DATA_CANCELAMENTO_ALU	FieldNameDATA_CANCELAMENTO_ALU  TStringField%ClientDataSet1MOTIVO_CANCELAMENTO_ALU	FieldNameMOTIVO_CANCELAMENTO_ALUSize(  TIntegerFieldClientDataSet1COD_PROFESSOR	FieldNameCOD_PROFESSOR   �	TSQLQuery	SQLQuery1SQL.StringsSELECT * FROM ALUNO   	TSQLQuerysqlProf
DataSourceDataSource1MaxBlobSize�ParamsDataType	ftIntegerNameCOD_PROFESSOR	ParamTypeptInputSize  SQL.Strings7SELECT * FROM PROFESSOR WHERE COD_PROF = :COD_PROFESSOR SQLConnectionDmGeral.SQLConnectionLeft0Top TStringFieldsqlProfNOME_PROF	FieldName	NOME_PROFSize2    