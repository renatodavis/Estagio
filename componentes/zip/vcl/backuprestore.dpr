program BackupRestore;

uses
  QForms,
  Unit1 in 'Unit1.pas' {FormBackup};

{$R *.res}

begin
  Application.Initialize;
  Application.Title := 'CerproSoft Informática Ltda.';
  Application.CreateForm(TFormBackup, FormBackup);
  Application.Run;
end.
