�
 TRELEQUIPAMENTOS 01  TPF0�TRELEquipamentosRELEquipamentosLeft� Top� CaptionRELEquipamentosOldCreateOrder	PixelsPerInch`
TextHeight �	TRLReport	RLReport1
AfterPrintRLReport1AfterPrint �TRLBand	rlbTituloBorders.SidessdCustomBorders.DrawBottom	 �TRLLabelrlTituloLeft� Width>Caption(   Solicitação de Equipamento para Bancas   TRLBandRLBand2Left&Top� Width�HeightBandTypebtColumnHeaderBorders.SidessdCustomBorders.DrawLeftBorders.DrawTopBorders.DrawRightBorders.DrawBottom	ColorclSilverFont.CharsetDEFAULT_CHARSET
Font.ColorclBlackFont.Height�	Font.NameArial
Font.StylefsBold ParentColor
ParentFontTransparent TRLLabelRLLabel1Left Top WidthHeightCaptionDataTransparent  TRLLabelRLLabel2LeftJTop Width+HeightCaptionHorarioTransparent  TRLLabelRLLabel3Left� Top Width!Height	Alignment	taJustifyCaptionBlocoTransparent  TRLLabelRLLabel4Left� Top WidthHeightCaptionSalaTransparent  TRLLabelRLLabel5Left0Top Width� HeightCaption   Descrição de EquipamentosTransparent   TRLBandRLBand3Left&Top� Width�HeightBeforePrintRLBand3BeforePrint 	TRLDBText	RLDBText1Left Top WidthFHeightAutoSize	DataField
DATA_BANCA
DataSourceDataSource1  	TRLDBText	RLDBText2LeftJTop WidthFHeightAutoSize	DataFieldHORARIO_BANCA
DataSourceDataSource1  	TRLDBText	RLDBText3Left� Top WidthFHeightAutoSize	DataFieldBLOCO_BANCA
DataSourceDataSource1  	TRLDBText	RLDBText4Left� Top WidthFHeightAutoSize	DataField
SALA_BANCA
DataSourceDataSource1  	TRLDBText	RLDBText5Left0Top Width�HeightAutoSize   TRLBandRLBand4Left&Top� Width�HeightBorders.SidessdCustomBorders.DrawLeftBorders.DrawTopBorders.DrawRightBorders.DrawBottom	   �TClientDataSetClientDataSet1 TIntegerFieldClientDataSet1COD_BANCA	FieldName	COD_BANCARequired	  TIntegerFieldClientDataSet1ANO_LETIVO_BANCA	FieldNameANO_LETIVO_BANCARequired	  TIntegerFieldClientDataSet1RA	FieldNameRARequired	  
TDateFieldClientDataSet1DATA_BANCA	FieldName
DATA_BANCARequired	  
TTimeFieldClientDataSet1HORARIO_BANCA	FieldNameHORARIO_BANCARequired	  TIntegerFieldClientDataSet1SEQUENCIA_BANCA	FieldNameSEQUENCIA_BANCARequired	  TStringFieldClientDataSet1BLOCO_BANCA	FieldNameBLOCO_BANCASize
  TStringFieldClientDataSet1SALA_BANCA	FieldName
SALA_BANCASize
  TStringFieldClientDataSet1TITULO_TRAB_BANCA	FieldNameTITULO_TRAB_BANCASize2  TStringFieldClientDataSet1EQUIPAMENTO	FieldNameEQUIPAMENTOSize�    �	TSQLQuery	SQLQuery1SQL.StringsSELECT * FROM BANCA    TSimpleDataSetsdsBuscaParametro
Aggregates 
ConnectionDmGeral.SQLConnectionDataSet.CommandText!SELECT EQUIPAMENTO FROM PARAMETRODataSet.MaxBlobSize�DataSet.Params Params Left�Top�    