unit u_relatorio_etiquetas_empresa;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, DB, DBClient, SimpleDS, RLReport;

type
  TREL_EtiquetasEmpresa = class(TForm)
    RLReport1: TRLReport;
    RLDetailGrid2: TRLDetailGrid;
    RLDBText1: TRLDBText;
    dsProfessor: TDataSource;
    sdsEmpresa: TSimpleDataSet;
    sdsEmpresaCOD_EMP: TIntegerField;
    sdsEmpresaRAZAO_EMP: TStringField;
    sdsEmpresaNOME_EMP: TStringField;
    sdsEmpresaCNPJ_EMP: TFMTBCDField;
    sdsEmpresaUF_EMP: TStringField;
    sdsEmpresaCEP_EMP: TStringField;
    sdsEmpresaFONE_EMP: TStringField;
    sdsEmpresaFAX_EMP: TStringField;
    sdsEmpresaEMAIL_EMP: TStringField;
    sdsEmpresaORI_ATIV_EMP: TStringField;
    sdsEmpresaCARGO_ORI_EMP: TStringField;
    RLDBText2: TRLDBText;
    sdsEmpresaENDERECO: TStringField;
    RLDBText3: TRLDBText;
    RLDBText4: TRLDBText;
    sdsEmpresaCIDADE: TStringField;
    RLDBText5: TRLDBText;
    RLLabel1: TRLLabel;
    RLDBText6: TRLDBText;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  REL_EtiquetasEmpresa: TREL_EtiquetasEmpresa;

implementation

{$R *.dfm}

end.
