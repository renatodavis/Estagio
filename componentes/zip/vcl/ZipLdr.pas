unit ZipLdr;

(* Dll loader unit for ZipMaster  
 by R. Peters
 edited 10 September 2003
         2 October 2003
        18 April 2004
        28 April 2004 - Added procedure Abort;
        23 September 2004 - used FreeAndNil
 *)


interface

uses
  Classes, Windows, ZipBase, zipdll, UnzDll;

type
  TExecFunc = function(Rec: pointer): Integer{DWord}; stdcall;
  TVersFunc = function: DWord; stdcall;
  TPrivFunc = function: DWord; stdcall;

type
  TZipLibLoader = class(TObject)
  private
    hndl: HWND;
    ExecFunc: TExecFunc;//function(Rec: pointer): DWord; stdcall;
    VersFunc: TVersFunc;//function: DWord; stdcall;
    PrivFunc: TPrivFunc;//function: DWord; stdcall;
    IsZip: Boolean;
    FPath: String;
    FOwner: TZipBase;
    loadLevel: Integer;
    Ver: Integer;
    Priv: Integer;
    TmpFileName: String;
    function GetLoaded: Integer;
    function GetLoadedPath: String;
    function GetVer: Integer;
    function GetPath: String;
    function GetPriv: Integer;
  protected
    procedure Clear;
    function DoExec(Rec: pointer): Integer;
    function DoLoad(level: Integer): Integer;
    function DoUnload(level: Integer): Integer;
    function Expand(src: String; dest: String): Integer;
    function GetResDllPath: String;
    function LoadLib(FullPath: String; MustExist: Boolean): Integer;
  public
    constructor Create(master: TZipBase; zip: Boolean);
    destructor Destroy; override;
    function LoadDll(minVer: Integer; hold: Boolean): Integer; // return version
    procedure Unload(held: Boolean);
    procedure Abort;
    property Loaded: Integer Read GetLoaded;
    property Path: String Read GetPath;
    property Version: Integer Read GetVer;
    property Build: Integer Read GetPriv;
  end;

  TZipDll = class(TZipLibLoader)
  public
    constructor Create(owner: TZipBase);
    function Exec(Rec: pZipParms): Integer;
  end;

  TUnzDll = class(TZipLibLoader)
  public
    constructor Create(owner: TZipBase);
    function Exec(Rec: pUnZipParms): Integer;
  end;

implementation

{$Include '..\vcl\ZipConfig.inc'}

uses
  ZipMsg, SysUtils, LZExpand, ZipUtils, ZipStrs, ZipXcpt;

const
  RDLL_Zip  = 11605;
  RDLL_Unz  = 11606;
  RDLL_ZVer = 11607;
  RDLL_UVer = 11608;

const
  RType = 'BinFile';
  DllRes: array[False..True] of Integer = (RDLL_Unz, RDLL_Zip);
  VerRes: array[False..True] of Integer = (RDLL_UVer, RDLL_ZVer);
  DllNames: array[False..True] of String = ('UNZDLL.DLL', 'ZIPDLL.DLL');
  ExecNames: array[False..True] of String = ('UnzDllExec', 'ZipDllExec');
  VersNames: array[False..True] of String = ('GetUnzDllVersion', 'GetZipDllVersion');
  PrivNames: array[False..True] of String =
    ('GetUnzDllPrivVersion', 'GetZipDllPrivVersion');


  zldTemp  = 1;
  zldAuto  = 2;
  zldFixed = 4;

constructor TZipDll.Create(owner: TZipBase);
begin
  inherited Create(owner, True);
end;

function TZipDll.Exec(Rec: pZipParms): Integer;
begin
  Result := DoExec(Rec);
end;

constructor TUnzDll.Create(owner: TZipBase);
begin
  inherited Create(owner, False);
end;

function TUnzDll.Exec(Rec: pUnZipParms): Integer;
begin
  Result := DoExec(Rec);
end;

procedure TZipLibLoader.Clear;
begin
  hndl     := 0;
  ExecFunc := NIL;
  VersFunc := NIL;
  PrivFunc := NIL;
  Ver      := 0;
  Priv     := 0;
end;

procedure TZipLibLoader.Abort;
begin
  if (hndl <> 0) and ( @ExecFunc <> NIL) then
    ExecFunc(NIL);
end;

constructor TZipLibLoader.Create(master: TZipBase; zip: Boolean);
begin
  inherited Create;
  Clear;
  IsZip     := zip;
  FOwner    := master;
  loadLevel := 0;
  FPath     := DllNames[IsZip];
  TmpFileName := '';
end;

destructor TZipLibLoader.Destroy;
begin
  if hndl <> 0 then
    FreeLibrary(hndl);
  hndl := 0;
  if (TmpFileName <> '') and FileExists(TmpFileName) then
    SysUtils.DeleteFile(TmpFileName);
  inherited;
end;

(*? TZipLibLoader.LoadDll
1.73 27 July 2003 RA / RP unload wrong version
*)
function TZipLibLoader.LoadDll(minVer: Integer; hold: Boolean): Integer;
begin
  Result := 0;
  if hold then
    DoLoad(zldFixed)
  else
    DoLoad(zldAuto);
  if hndl <> 0 then
    Result := Ver;
  if Ver < minVer then
  begin
    DoUnload(zldFixed + zldAuto + zldTemp);
    raise EZipMaster.CreateResDrive(LD_BadDll, FPath);
  end;
end;
//? TZipLibLoader.LoadDll

(*? TZipLibLoader.LoadLib
1.73.2.4 10 Srptember 2003 RP new function
*)
function TZipLibLoader.LoadLib(FullPath: String; MustExist: Boolean): Integer;
var
  oldMode: Cardinal;
begin
  if hndl > 0 then
    FreeLibrary(hndl);
  Clear;
  oldMode := SetErrorMode(SEM_FAILCRITICALERRORS or SEM_NOGPFAULTERRORBOX);
  try
    hndl := LoadLibrary(PChar(Fullpath));
    if hndl > HInstance_Error then
    begin
      @ExecFunc := GetProcAddress(hndl, PChar(ExecNames[IsZip]));
      @VersFunc := GetProcAddress(hndl, PChar(VersNames[IsZip]));
      @PrivFunc := GetProcAddress(hndl, PChar(PrivNames[IsZip]));
      FPath     := GetLoadedPath;
    end;
  finally
    SetErrorMode(oldMode);
  end;
  if hndl <= HInstance_Error then
  begin
    Clear;
    LoadLevel := 0;
    if MustExist then
      raise EZipMaster.CreateResDrive(LD_NoDll, fullpath);
    Result := 0;
    exit;
  end;
  if ( @ExecFunc <> NIL) and ( @VersFunc <> NIL) then
  begin
    Ver := VersFunc;
    if @PrivFunc <> NIL then
      Priv := PrivFunc;
  end;
  if (Ver < 153) or (Ver > 300) then
  begin
    fullpath := FPath;
    FreeLibrary(hndl);
    Clear;
    LoadLevel := 0;
    if MustExist then
      raise EZipMaster.CreateResDrive(LD_BadDll, fullpath);
  end;
  Result := Priv;
end;
//? TZipLibLoader.LoadLib

procedure TZipLibLoader.Unload(held: Boolean);
begin
  if held then
    DoUnload(zldFixed)
  else
    DoUnload(zldAuto);
end;

function TZipLibLoader.Expand(src: String; dest: String): Integer;
var
  sTOF, dTOF: TOFStruct;
  sH, dH:     Integer;
begin
  sH     := -1;
  dH     := -1;
  Result := 0;
  try
    sH := LZOpenFile(PChar(src), sTOF, OF_READ);
    dH := LZOpenFile(PChar(dest), dTOF, OF_CREATE);
    if (sH > 0) and (dH >= 0) then
      Result := LZCopy(sH, dH);
  finally
    if sH >= 0 then
      LZClose(sH);
    if dH >= 0 then
      LZClose(dH);
  end;
end;

function TZipLibLoader.GetLoaded: Integer;
begin
  Result := 0;
  if hndl <> 0 then
    Result := Ver;
end;

function TZipLibLoader.GetLoadedPath: String;
var
  buf: String;
begin
  Result := '';
  if hndl <> 0 then
  begin
    SetLength(buf, 4096);
    if GetModuleFileName(hndl, PChar(buf), 4096) <> 0 then
      Result := PChar(buf);
  end;
end;


function TZipLibLoader.DoExec(Rec: pointer): Integer;
begin
  DoLoad(zldTemp);
  Result := ExecFunc(Rec);
  DoUnload(zldTemp);
  if Result < 0 then
    case Result of
      -1, -2: raise EZipMaster.CreateResDisp(GE_DLLAbort, True);
      -3: raise EZipMaster.CreateResDisp(GE_DLLBusy, True);
      -4: raise EZipMaster.CreateResDisp(GE_DLLCancel, True);
      -5: raise EZipMaster.CreateResDisp(GE_DLLMem, True);
      -6: raise EZipMaster.CreateResDisp(GE_DLLStruct, True);
      -8: raise EZipMaster.CreateResDisp(GE_DLLEvent, True);
      else
        raise EZipMaster.CreateResFmt(GE_DLLCritical, [Result]);
    end;
end;

(*? TZipLibLoader.DoLoad
1.73.2.6 10 September 2003 RP only load resource if later or no other found
1.73 24 July 2003 RA fix
*)
function TZipLibLoader.DoLoad(level: Integer): Integer;
var
  DllDir, FullPath: String;
  RVer: Integer;
  RVrs: String;
begin
  loadLevel := (loadLevel or level) and 7;
  if hndl = 0 then
    with FOwner do
      try
        StartWaitCursor;
        Ver      := 0;
        fullpath := '';
        DllDir   := DllDirectory;
        if TmpFileName <> '' then
          fullpath := TmpFileName;
        if fullpath = '' then
          if DLLDir <> '' then
          begin
            fullpath := PathConcat(DLLDir, DllNames[IsZip]);
            if DLLDir[1] = '.' then
              fullpath := PathConcat(ExtractFilePath(ParamStr(0)), fullpath);
            if not FileExists(fullpath) then
              fullpath := '';
          end;
        if fullpath = '' then
          fullpath := DllNames[IsZip];      // Let Windows search the std dirs
        RVrs := LoadStr(VerRes[IsZip]);
        RVer := StrToIntDef(copy(RVrs, 1, 5), 0);
        if RVer > LoadLib(fullPath, RVer < 17300) then
          if LoadLib(GetResDllPath, False) < 17300 then
            LoadLib(fullPath, True);
        if Verbose then
          Report(zacMessage, 0, ZipLoadStr(LD_DllLoaded, 'loaded ') + FPath, 0);
      finally
        StopWaitCursor;
      end;
  Result := Ver;
end;
//? TZipLibLoader.DoLoad

function TZipLibLoader.DoUnload(level: Integer): Integer;
begin
  loadLevel := (loadLevel and ( not level)) and 7;
  if (loadLevel = 0) and (hndl <> 0) then
  begin
    with  FOwner do
      if Verbose then
        Report(zacMessage, 0, ZipLoadStr(LD_DllUnloaded, 'unloaded ') + FPath, 0);
    FreeLibrary(hndl);
    hndl := 0;
  end;
  if hndl = 0 then
  begin
    Clear;
    LoadLevel := 0;
  end;
  Result := Ver;
end;

(*? TZipLoader.GetResDllPath
1.74.4.0 23 September 2004 replace Free with FreeAndNil
1.73.2.6 7 September 2003 extract 'compressed' resource files
*)
function TZipLibLoader.GetResDllPath: String;
var
  m:    Word;
  fs:   TFileStream;
  rs:   TResourceStream;
  done: Boolean;
  tmp:  String;
  ver:  Integer;
begin
  Result := '';
  done   := False;
  fs     := NIL;
  tmp    := LoadStr(VerRes[IsZip]);
  ver    := StrToIntDef(copy(tmp, 1, 5), 0);
  if ver > 17300 then
  begin
    if IsZip then
      TmpFileName := FOwner.MakeTempFileName('ZMZ', '.DLL')
    else
      TmpFileName := FOwner.MakeTempFileName('ZMU', '.dll');
    rs := TResourceStream.CreateFromID(HInstance, DllRes[IsZip], RType);
    try
      if assigned(rs) then
        try
          rs.Read(m, 2);
          if m = 0 then
          begin
            fs   := TFileStream.Create(TmpFileName, fmCreate);
            rs.Position := 6;
            done := fs.CopyFrom(rs, rs.Size - 6) = (rs.Size - 6);
          end
          else if m = 2 then
          begin
            Tmp  := FOwner.MakeTempFileName('ZMt', '.tmp');
            rs.Position := 6;
            fs   := TFileStream.Create(Tmp, fmCreate);
            done := fs.CopyFrom(rs, rs.Size - 6) = (rs.Size - 6);
            FreeAndNil(fs);
            if done then
            begin
              done := Expand(tmp, TmpFileName) > 100000;
              DeleteFile(tmp);
            end;
          end;
        finally
          FreeAndNil(fs);//fs.Free;
        end;
    finally
      FreeAndNil(rs);//rs.Free;
      if ( not done) and FileExists(TmpFileName) then
        DeleteFile(TmpFileName);
      if not FileExists(TmpFileName) then
        TmpFileName := ''
      else
        Result      := TmpFileName;
    end;
  end;
end;
//? TZipLoader.GetResDllPath

(*? TZipLibLoader.GetVer
1.73.2.8 2 Oct 2003 new getter
*)
function TZipLibLoader.GetVer: Integer;
begin
  DoLoad(zldTemp);
  Result := Ver;
  DoUnload(zldTemp);
end;
//? TZipLibLoader.GetVer

(*? TZipLibLoader.GetPath
1.73.2.8 2 Oct 2003 new getter
*)
function TZipLibLoader.GetPath: String;
begin
  DoLoad(zldTemp);
  Result := FPath;
  DoUnload(zldTemp);
end;
//? TZipLibLoader.GetPath

(*? TZipLibLoader.GetPriv
1.73.2.8 2 Oct 2003 new getter
*)
function TZipLibLoader.GetPriv: Integer;
begin
  DoLoad(zldTemp);
  Result := Priv;
  DoUnload(zldTemp);
end;
//? TZipLibLoader.GetPriv

end.
