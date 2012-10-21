{
   Renato Davis - 22/11/2004

   /* Parametros */

         ParamStr(1) - Endereco do banco Ex: \\servidor\sistema\banco.fb
         ParamStr(2) - Path do sistema   Ex: \\servidor\sistema\
         ParamStr(3) - Nome do Sistema   Ex: sistema
         ParamStr(4) - Indica se é Backup ou Restação Ex: backup
                       Somente serão aceitos os valores (backup ou restore)

}

unit Unit1;

interface

uses
  SysUtils, Types, Classes, Variants, QTypes, QGraphics, QControls, QForms,
  QDialogs, QStdCtrls, QExtCtrls, QComCtrls,lib_compacta,lib_descompacta,
  QButtons,qt;

type
  MinhaThread = class(TThread)
  private
    iValorProgress : integer;

  protected
      procedure Execute; override;
  end;

  TFormBackup = class(TForm)
    Panel1: TPanel;
    Image1: TImage;
    Label4: TLabel;
    Bevel3: TBevel;
    odBackup: TOpenDialog;
    odRestore: TOpenDialog;
    Panel2: TPanel;
    Panel3: TPanel;
    PageControl1: TPageControl;
    tbInicio: TTabSheet;
    Label5: TLabel;
    Panel4: TPanel;
    rbBackup: TRadioButton;
    rbRestauracao: TRadioButton;
    tbBackup: TTabSheet;
    SpeedButton2: TSpeedButton;
    Label1: TLabel;
    sedtArquivoBackup: TEdit;
    Label2: TLabel;
    lblArquivoBackup: TLabel;
    Label6: TLabel;
    Label10: TLabel;
    tbRestore: TTabSheet;
    SpeedButton1: TSpeedButton;
    Label3: TLabel;
    sedtArquivoRestore: TEdit;
    Label8: TLabel;
    Label7: TLabel;
    lblArquivoRestore: TLabel;
    Label11: TLabel;
    tbProgresso: TTabSheet;
    ProgressBar1: TProgressBar;
    lblMensagem: TLabel;
    pnlFinalizado: TPanel;
    Panel5: TPanel;
    lblLocal: TLabel;
    Panel6: TPanel;
    lblTamanho: TLabel;
    Label9: TLabel;
    Panel7: TPanel;
    Panel8: TPanel;
    btnVoltar: TBitBtn;
    btnSistema: TButton;
    Bevel1: TBevel;
    tbErro: TTabSheet;
    Panel9: TPanel;
    Label14: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure sedtArquivoBackupExit(Sender: TObject);
    procedure btnSistemaClick(Sender: TObject);
    procedure tbBackupShow(Sender: TObject);
    procedure tbRestoreShow(Sender: TObject);
    procedure sedtArquivoBackupKeyPress(Sender: TObject; var Key: Char);
    procedure sedtArquivoRestoreKeyPress(Sender: TObject; var Key: Char);
    procedure SpeedButton1Click(Sender: TObject);
    procedure SpeedButton2Click(Sender: TObject);
    procedure btnVoltarClick(Sender: TObject);
    procedure PageControl1Change(Sender: TObject);
    procedure FormMouseWheel(Sender: TObject; Shift: TShiftState;
      WheelDelta: Integer; MousePos: TPoint; var Handled: Boolean);
    procedure FormMouseWheelDown(Sender: TObject; Shift: TShiftState;
      MousePos: TPoint; var Handled: Boolean);
    procedure FormMouseWheelUp(Sender: TObject; Shift: TShiftState;
      MousePos: TPoint; var Handled: Boolean);
    procedure PageControl1Changing(Sender: TObject;
      var AllowChange: Boolean);
  private
   Processo : TThread;
   Compacta : TCompacta;
   Descompacta : TDescompacta;
   sTamanhoArquivo :String;
//   ProgramaExterno :TProgramaexterno;


   bErro    : boolean;
   procedure ZipWorkBegin(Sender: TObject);
   procedure ZipWorkEnd(Sender: TObject);
   procedure ZipProgress(Sender: TObject; TamanhoArquivo,
      PercentualConcluido : Real);

    { Private declarations }
  public
    { Public declarations }
  end;

var
  FormBackup: TFormBackup;

implementation

uses StrUtils, lib_zip, Math;

{$R *.xfm}

procedure TFormBackup.FormCreate(Sender: TObject);
begin
   Try
       bErro := true;
      Processo := MinhaThread.Create(true);
      {********************************* Compacta *******************************}
      if (ParamStr(4) = 'backup') or (ParamStr(4) = '') then
      begin

         compacta:=TCompacta.Create(Self);
         compacta.OnWorkBegin:=ZipWorkBegin;
         compacta.OnWorkEnd:=ZipWorkEnd;
         compacta.OnProgress:=ZipProgress;
         //seta a o arquivo que sera compactado
         compacta.Origem  := ParamStr(1);
         //sugere onde o arquivo de backup sera gerado
         sedtArquivoBackup.Text  := ParamStr(2);
         //mostra o arquivo do banco na tela
         lblArquivoBackup.Caption := ParamStr(1);
         //seta o diretorio padrao , do dialogo backup
         odBackup.InitialDir  := ExtractFilePath(ParamStr(1));
      end
      else
      begin

      {********************************* Descompacta *******************************}
         Descompacta := TDescompacta.Create(self);
         Descompacta.OnWorkBegin := ZipWorkBegin;
         Descompacta.OnWorkEnd   := ZipWorkEnd;
         Descompacta.OnProgress  := ZipProgress;
         //seta o local onde o arquivo sera descompactado
         Descompacta.Destino := ParamStr(2);


         //mostra o local onde sera restaurado
         lblArquivoRestore.Caption :=ParamStr(2); //path do FB

         //seta o diretorio padrao , do dialogo restauracao
         odRestore.InitialDir := ParamStr(2);
      end;

      if ParamStr(4)<>'' then
      begin
         if ParamStr(4) = 'backup' then tbBackup.show else
         if ParamStr(4) = 'restore' then tbRestore.show else
            tbInicio.Show;
      end
      else
         tbInicio.Show;
         
      btnVoltar.Visible := false;
   except
      ShowMessage('O sistema será fechado!');
      halt;
   end;
end;

procedure TFormBackup.ZipProgress(Sender: TObject; TamanhoArquivo,
  PercentualConcluido: Real);
begin
   ProgressBar1.Position:=Trunc(PercentualConcluido);
   Label1.Caption:=Format('%9.2f KB', [TamanhoArquivo]);
   if TamanhoArquivo > 0 then
      lblTamanho.Caption := 'Tamanho do arquivo '+FormatFloat('#,##',(TamanhoArquivo/1024)) + ' KB.';

end;

procedure TFormBackup.ZipWorkBegin(Sender: TObject);
begin
   Caption:='Cerprosoft informática';
end;

procedure TFormBackup.ZipWorkEnd(Sender: TObject);
begin
   lblMensagem.caption := 'Operação Executada Com Sucesso.';
   btnSistema.Caption  := '&Fechar';
   pnlFinalizado.Visible := true;
end;

procedure TFormBackup.sedtArquivoBackupExit(Sender: TObject);
begin
   if sedtArquivoBackup.Text <>'' then
   begin
      if DirectoryExists(sedtArquivoBackup.text) then
      begin
         if copy(sedtArquivoBackup.Text,length(sedtArquivoBackup.Text), 1) <> '\' then
            sedtArquivoBackup.Text := sedtArquivoBackup.Text + '\';
      end
      else
      begin
         messagedlg('O Diretório informado não existe!',mtError,[mbOk],0);
         sedtArquivoBackup.SetFocus;
         PageControl1.ActivePageIndex := 1;
      end;
   end;
end;

{ MinhaThread }

procedure MinhaThread.Execute;
begin
   inherited;
   with FormBackup do
   begin
      Try

         if ParamStr(4) = 'backup' then
            compacta.Iniciar
         else
            Descompacta.Iniciar;
            
      except
         bErro := true;
      end;
   end;
end;

procedure TFormBackup.btnSistemaClick(Sender: TObject);
begin
   Try
      case PageControl1.ActivePageIndex of
         0:begin
         { Principal }
            if rbBackup.Checked then
               tbBackup.Show
            else
               tbRestore.show;
         end;
         1:begin
         { Backup }
               if sedtArquivoBackup.Text = '' then
               begin
                  messagedlg('Informe o local para efetuar backup!',mtWarning,[mbOk],0);
                  sedtArquivoBackup.SetFocus;
                  exit;
               end;
               bErro := false;
               tbProgresso.show;
               compacta.Destino := sedtArquivoBackup.Text + ParamStr(3)+'_'+FormatDateTime('dd-mm-yyyy',(Date))+'.zip';
               lblLocal.Caption := 'O Arquivo foi salvo em '+Compacta.Destino;
               Processo.Resume;
         end;
         2:begin
         { Restauração }
               { Verifica se o foi informado alguns arquivo }
               if sedtArquivoRestore.Text = '' then
               begin
                  messagedlg('Informe qual o arquivo zip para efetuar a restauração!',mtWarning,[mbOk],0);
                  sedtArquivoRestore.SetFocus;
                  exit;
               end;
               { Valida o arquivo informado }
               if sedtArquivoRestore.Text<>'' then
               begin
                  If not FileExists(sedtArquivoRestore.Text) then
                  begin
                     messagedlg('O arquivo informado não existe!',MtWarning,[mbOk],0);
                     PageControl1.ActivePageIndex := 2;
                     sedtArquivoRestore.SetFocus;
                     exit;
                  end;
               end;
               bErro := false;
               Descompacta.Destino   := ParamStr(2);
               Descompacta.Origem    := sedtArquivoRestore.Text;
               Processo.Resume;
               lblLocal.Caption := 'O Arquivo foi restaurado em '+Descompacta.Destino;
               tbProgresso.show;
         end;
         3,4:begin
            Close;
         end;
      end;
   except
      bErro := true;
      PageControl1.ActivePageIndex := 4;
   end;
end;



procedure TFormBackup.tbBackupShow(Sender: TObject);
begin
   sedtArquivoBackup.SetFocus;
end;

procedure TFormBackup.tbRestoreShow(Sender: TObject);
begin
   sedtArquivoRestore.SetFocus;
end;

procedure TFormBackup.sedtArquivoBackupKeyPress(Sender: TObject;
  var Key: Char);
begin
//   if not (key in['A'..'Z','a'..'z',':','\','/',#8,#13,'0'..'9']) then
//      Key := #0;
end;

procedure TFormBackup.sedtArquivoRestoreKeyPress(Sender: TObject;
  var Key: Char);
begin
//   if not (key in['A'..'Z','a'..'z',':','\','/',#8,#13,'0'..'9']) then
//      Key := #0;

end;

procedure TFormBackup.SpeedButton1Click(Sender: TObject);
begin
   if odRestore.Execute then
      sedtArquivoRestore.Text := odRestore.FileName;

end;

procedure TFormBackup.SpeedButton2Click(Sender: TObject);
var
   dir :WideString;
begin
   SelectDirectory('Selecione um diretório...','',dir);
   sedtArquivoBackup.Text := dir;
end;

procedure TFormBackup.btnVoltarClick(Sender: TObject);
begin
   PageControl1.ActivePageIndex := 0;
end;

procedure TFormBackup.PageControl1Change(Sender: TObject);
begin
   btnVoltar.Visible := PageControl1.ActivePageIndex in [1,2];
end;

procedure TFormBackup.FormMouseWheel(Sender: TObject; Shift: TShiftState;
  WheelDelta: Integer; MousePos: TPoint; var Handled: Boolean);
begin
   Handled := false;
end;

procedure TFormBackup.FormMouseWheelDown(Sender: TObject;
  Shift: TShiftState; MousePos: TPoint; var Handled: Boolean);
begin
   Handled := false;
end;

procedure TFormBackup.FormMouseWheelUp(Sender: TObject; Shift: TShiftState;
  MousePos: TPoint; var Handled: Boolean);
begin
   Handled := false;
end;

procedure TFormBackup.PageControl1Changing(Sender: TObject;
  var AllowChange: Boolean);
begin
   AllowChange := false;

end;

end.
