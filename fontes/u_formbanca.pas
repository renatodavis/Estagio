unit u_formbanca;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, u_formpadrao, FMTBcd, DB, Grids, DBGrids, StdCtrls, DBCtrls,
  Mask, DBClient, Provider, SqlExpr, Buttons, ComCtrls, ExtCtrls;

type
  TFormMovBancas = class(TFormPadrao)
    GroupBox1: TGroupBox;
    Label2: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label4: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    Label10: TLabel;
    Label11: TLabel;
    Edit2: TDBEdit;
    Edit4: TDBEdit;
    Edit5: TDBEdit;
    Edit6: TDBEdit;
    Edit7: TDBEdit;
    Edit8: TDBEdit;
    Edit9: TDBEdit;
    DBComboBox1: TDBComboBox;
    DBGrid1: TDBGrid;
    dsProfessor: TDataSource;
    cdsProfessor: TClientDataSet;
    cdsProfessorCOD_BANCA: TIntegerField;
    cdsProfessorCOD_PROF: TIntegerField;
    cdsProfessorSTATUS_PROF: TStringField;
    sqlBancaProf: TSQLQuery;
    dsLINK: TDataSource;
    dsProf: TDataSource;
    sqlProfessor: TSQLQuery;
    ClientDataSetCOD_BANCA: TIntegerField;
    ClientDataSetANO_LETIVO_BANCA: TIntegerField;
    ClientDataSetRA: TIntegerField;
    ClientDataSetDATA_BANCA: TDateField;
    ClientDataSetHORARIO_BANCA: TTimeField;
    ClientDataSetSEQUENCIA_BANCA: TIntegerField;
    ClientDataSetBLOCO_BANCA: TStringField;
    ClientDataSetSALA_BANCA: TStringField;
    ClientDataSetTITULO_TRAB_BANCA: TStringField;
    ClientDataSetsqlProfessor: TDataSetField;
    ClientDataSetsqlBancaProf: TDataSetField;
    cdsProfessorNOME_PROF: TStringField;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FormMovBancas: TFormMovBancas;

implementation

{$R *.dfm}

end.
