unit ZipMstr;

(* TZipMaster VCL by Chris Vleghert and Eric W. Engler
   e-mail: problems@delphizip.net    englere@abraxis.com
   www:    http://www.geocities.com/SiliconValley/Network/2114
   www: http://www.delphizip.net
 v1.78 by Russell Peters November 4, 2004.

                        *)

{$INCLUDE '..\vcl\ZipConfig.inc'}

interface

uses
  Forms, WinTypes, Classes, SysUtils, Graphics, Dialogs,
{$IFNDEF NO_SFX}
  ZipSFX, SFXInterface,
{$ENDIF}
  ZipWrkr, ZipXcpt, ZipMsg, ZipBase, ZipProg;

const
  BUSY_ERROR    = -255;
  Reentry_Error = $4000000;

type
  LongWord = Cardinal;

type
  pZipDirEntry = ZipBase.pZipDirEntry;
  ZipDirEntry  = ZipBase.ZipDirEntry;

type
  AddOptsEnum  = ZipBase.AddOptsEnum;
  AddOpts      = ZipBase.AddOpts;
  ExtrOptsEnum = ZipBase.ExtrOptsEnum;
  ExtrOpts     = ZipBase.ExtrOpts;
  OvrOpts      = ZipBase.OvrOpts;
  TPasswordButton = ZipBase.TPasswordButton;
  ProgressType = ZipProg.ProgressType;
  ZipRenameRec = ZipBase.ZipRenameRec;
  pZipRenameRec = ^ZipRenameRec;
  TZipStream = ZipWrkr.TZipStream;

type
  TProgressDetails = ZipProg.TProgressDetails;

type
  TCheckTerminateEvent = ZipBase.TCheckTerminateEvent;   
  TItemProgressEvent = ZipBase.TItemProgressEvent;  
  TMessageEvent   = ZipBase.TMessageEvent;      
  TProgressEvent  = ZipBase.TProgressEvent;     
  TProgressDetailsEvent = ZipBase.TProgressDetailsEvent;   
  TTickEvent      = ZipBase.TTickEvent;
  TTotalProgressEvent = ZipBase.TTotalProgressEvent;
  TZipDialogEvent = ZipBase.TZipDialogEvent;
  TZipStrEvent = ZipBase.TZipStrEvent;
  TCopyZipOverwriteEvent = ZipBase.TCopyZipOverwriteEvent;
  TCRC32ErrorEvent = ZipBase.TCRC32ErrorEvent;
  TExtractOverwriteEvent = ZipBase.TExtractOverwriteEvent;
  TExtractSkippedEvent = ZipBase.TExtractSkippedEvent;
  TFileCommentEvent = ZipBase.TFileCommentEvent;
  TFileExtraEvent = ZipBase.TFileExtraEvent;
  TGetNextDiskEvent = ZipBase.TGetNextDiskEvent;
  TNewNameEvent   = ZipBase.TNewNameEvent;
  TPasswordErrorEvent = ZipBase.TPasswordErrorEvent;
  TSetAddNameEvent = ZipBase.TSetAddNameEvent;
  TSetExtNameEvent = ZipBase.TSetExtNameEvent;
  TSetNewNameEvent = ZipBase.TSetNewNameEvent;
  TStatusDiskEvent = ZipBase.TStatusDiskEvent;

{$IFDEF INTERNAL_SFX}
type
  SFXOptsEnum = (SFXAskCmdLine, SFXAskFiles, SFXAutoRun, SFXHideOverWriteBox,
    SFXCheckSize, SFXNoSuccessMsg);
  SFXOpts     = set of SFXOptsEnum;
{$ENDIF}

type
  TCustomZipMaster = class(TComponent)
  private
    FZip: TZipWorker;
    FReentry: Boolean;                      // true = re-entry attempted
    FBusy: Boolean;                         // true = busy
    FActive: Boolean;                       // true = active
{$IFNDEF NO_SFX}
    FSFXSlave: TCustomZipSFX;
{$ENDIF}
    FAddCompLevel: Integer;
    fAddOptions: AddOpts;
    FAddStoreSuffixes: AddStoreExts;
    fExtAddStoreSuffixes: String;
    { Private versions of property variables }
    //    fZipContents: TList;
    fExtrBaseDir: String;
    FFSpecArgs: TStrings;
    FFSpecArgsExcl: TStrings;
    //    FZipFileName: string;
    FTempDir: String; 
    FDLLDirectory: String;
    FRootDir: String;
    FPassword: String;
    FVerbose: Boolean;
    FTrace: Boolean;
    fHandle: HWND;
    FExtrOptions: ExtrOpts;
    FEncrypt: Boolean;
    FSpanOptions: SpanOpts;
    fFromDate: TDateTime;
    FUnattended: Boolean;
    FCodePage: CodePageOpts;
    FHowToDelete: DeleteOpts;
    FUseDirOnlyEntries: Boolean;
    FPasswordReqCount: Longword;
    fNotMainThread: Boolean;
{$IFNDEF NO_SPAN}
    //    FSpanOptions: SpanOpts;
    FConfirmErase: Boolean;
    FFreeOnDisk1: Cardinal;
    FFreeOnAllDisks: Cardinal;
    FMaxVolumeSize: Integer;
    FMinFreeVolSize: Integer;
{$ENDIF}
    { events }
    FOnCheckTerminate: TCheckTerminateEvent;
    FOnItemProgress: TItemProgressEvent;
    FOnMessage: TMessageEvent;
    FOnProgress: TProgressEvent;
    FOnProgressDetails: TProgressDetailsEvent;
    FOnTick: TTickEvent;
    FOnTotalProgress: TTotalProgressEvent;
    FOnZipDialog: TZipDialogEvent;
    FOnZipStr: TZipStrEvent;
    fOnCopyZipOverwrite: TCopyZipOverwriteEvent;
    fOnCRC32Error: TCRC32ErrorEvent;
    fOnDirUpdate: TNotifyEvent;
    fOnExtractOverwrite: TExtractOverwriteEvent;
    fOnExtractSkipped: TExtractSkippedEvent;
    fOnFileComment: TFileCommentEvent;
    fOnFileExtra: TFileExtraEvent;
    fOnNewName: TNewNameEvent;
    fOnPasswordError: TPasswordErrorEvent;
    fOnSetAddName: TSetAddNameEvent;
    fOnSetExtName: TSetExtNameEvent;
    fOnSetNewName: TSetNewNameEvent;
{$IFNDEF NO_SPAN}
    FOnGetNextDisk: TGetNextDiskEvent;
    FOnStatusDisk: TStatusDiskEvent;
{$ENDIF}
    { Property get/set functions }
    function GetBusy: Boolean;
    function GetCancel: Boolean;
    function GetCount: Integer;
    function GetDirEntry(idx: Integer): pZipDirEntry;
    function GetDirOnlyCount: Integer;
    function GetErrCode: Integer;
    function GetErrMessage: String;
    function GetFullErrCode: Integer;
    function GetIsSpanned: Boolean;
    function GetPPassword: String;
    function GetRealFileSize: Cardinal;
    function GetSFXOffset: Integer;
    function GetSuccessCnt: Integer;
    function GetTotalSizeToProcess: Int64;
    function GetUnzBusy: Boolean;
    function GetUnzVers: Integer;
    function GetVer: Integer;
    function GetZipBusy: Boolean;
    function GetZipComment: String;
    function GetZipContents: TList;
    function GetZipEOC: Cardinal;
    function GetZipFileName: String;
    function GetZipSOC: Cardinal;
    function GetZipStream: TZipStream;
    function GetZipVers: Integer;  
    function GetVersionInfo: String;

    procedure SetCancel(Value: Boolean);
    procedure SetErrCode(Value: Integer);
//    procedure SetExtAddStoreSuffixes(Value: String);
    procedure SetFileName(Value: String);
    procedure SetActive(Value: Boolean);
    procedure SetPassword(Value: String);
    procedure SetPasswordReqCount(Value: LongWord);
    procedure SetVersionInfo(Value: String);
    procedure SetZipComment(Value: String);     
    procedure SetFSpecArgs(const Value: TStrings);
    procedure SetSpecArgsExcl(const Value: TStrings);
{$IFNDEF NO_SFX}
{$IFNDEF INTERNAL_SFX}
    procedure SetSFXSlave(Value: TCustomZipSFX);
  protected
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;
  private
{$ELSE}
    function GetSFXCaption: String;
    function GetSFXCommandLine: String;
    function GetSFXDefaultDir: String;
    function GetSFXIcon: TIcon;
    function GetSFXMessage: String;
    function GetSFXOptions: SFXOpts;
    function GetSFXOverWriteMode: OvrOpts;
    function GetSFXPath: TFileName;
    procedure SetSFXCaption(Value: String);
    procedure SetSFXCommandLine(Value: String);
    procedure SetSFXDefaultDir(Value: String);
    procedure SetSFXIcon(Value: TIcon);
    procedure SetSFXMessage(Value: String);
    procedure SetSFXOptions(Value: SFXOpts);
    procedure SetSFXOverWriteMode(Value: OvrOpts);
    procedure SetSFXPath(Value: TFilename);
{$ENDIF}
{$ENDIF}
  protected
    function Stopped: Boolean;
    function CanStart: Boolean;
    procedure Starting;
    procedure Done;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure BeforeDestruction; override;
    procedure Loaded; override;
    { Public Properties (run-time only) }
  protected
    property Busy: Boolean Read GetBusy;
    property Cancel: Boolean Read GetCancel Write SetCancel;
    property Count: Integer Read GetCount;
    property DirEntry[idx: Integer]: pZipDirEntry Read GetDirEntry; default;
    property DirOnlyCount: Integer Read GetDirOnlyCount;
    property ErrCode: Integer Read GetErrCode Write SetErrCode;
    property FullErrCode: Integer Read GetFullErrCode;
    property Handle: HWND Read FHandle Write FHandle;
    property IsSpanned: Boolean Read GetIsSpanned;
    property Message: String Read GetErrMessage;
    property SFXOffset: Integer Read GetSFXOffset;
    property SuccessCnt: Integer Read GetSuccessCnt;
    property TotalSizeToProcess: Int64 Read GetTotalSizeToProcess;
    property UnzBusy: Boolean Read GetUnzBusy;
    property UnzVers: Integer Read GetUnzVers;
    property Ver: Integer Read GetVer;
    property ZipBusy: Boolean Read GetZipBusy;
    property ZipComment: String Read GetZipComment Write SetZipComment;
    property ZipContents: TList Read GetZipContents;
    property ZipEOC: Cardinal Read GetZipEOC;
    property ZipFileSize: Cardinal Read GetRealFileSize;
    property ZipSOC: Cardinal Read GetZipSOC;
    property ZipStream: TZipStream Read GetZipStream;
    property ZipVers: Integer Read GetZipVers;   
    property NotMainThread: Boolean Read fNotMainThread Write fNotMainThread;
    { Public Methods }
    { NOTE: Test is an sub-option of extract }
  public
    function Add: Integer;
    function AddStreamToFile(Filename: String; FileDate, FileAttr: Dword): Integer;
    function AddStreamToStream(InStream: TMemoryStream): TZipStream;
    function AppendSlash(sDir: String): String;
    function Copy_File(const InFileName, OutFileName: String): Integer;
    function CopyZippedFiles(DestZipMaster: TCustomZipMaster;
      DeleteFromSource: Boolean; OverwriteDest: OvrOpts): Integer;
    function Delete: Integer;
    function EraseFile(const Fname: String; How: DeleteOpts): Integer;
    function Extract: Integer;
    function ExtractFileToStream(Filename: String): TZipStream;
    function ExtractStreamToStream(InStream: TMemoryStream;
      OutSize: Longword): TZipStream;
    function Find(const fspec: String; var idx: Integer): pZipDirEntry;
    function FullVersionString: String;
    function GetAddPassword(var Response: TPasswordButton): String; overload;
    function GetAddPassword: String; overload;
    function GetExtrPassword(var Response: TPasswordButton): String; overload;
    function GetExtrPassword: String; overload;
    function GetPassword(DialogCaption, MsgTxt: String; pwb: TPasswordButtons;
      var ResultStr: String): TPasswordButton;
    function IndexOf(const fname: String): Integer;
    function List: Integer;
    function Load_Unz_Dll: Integer;
    function Load_Zip_Dll: Integer;
    function MakeTempFileName(Prefix, Extension: String): String;
    function QueryZip(const fname: TFileName): Integer;
    function Rename(RenameList: TList; DateTime: Integer): Integer;
    function TheErrorCode(errCode: Integer): Integer;
    function UnzDllPath: String;
    function ZipDllPath: String;
    procedure AbortDlls;
    procedure Clear;                        // new 1.73.3.4
    procedure ShowExceptionError(const ZMExcept: EZipMaster); //1.72 promoted
    procedure ShowZipMessage(Ident: Integer; UserStr: String);
    procedure Unload_Unz_Dll;
    procedure Unload_Zip_Dll;
{$IFNDEF NO_SPAN}
    function ReadSpan(InFileName: String; var OutFilePath: String): Integer;
    function WriteSpan(InFileName, OutFileName: String): Integer;
{$ENDIF}
{$IFNDEF NO_SFX}
    function NewSFXFile(const ExeName: String): Integer;
    function ConvertSFX: Integer;
    function ConvertZIP: Integer;
    function IsZipSFX(const SFXExeName: String): Integer;
{$ENDIF}
  protected//  public //published
    { Public properties that also show on Object Inspector }
    property Active: Boolean Read fActive Write SetActive default True;
    property AddCompLevel: Integer Read FAddCompLevel Write FAddCompLevel;
    property AddFrom: TDateTime Read fFromDate Write fFromDate;
    property AddOptions: AddOpts Read FAddOptions Write fAddOptions;
    property AddStoreSuffixes: AddStoreExts Read FAddStoreSuffixes
      Write FAddStoreSuffixes;
    property CodePage: CodePageOpts Read FCodePage Write FCodePage default cpAuto;
    property DLLDirectory: String Read FDLLDirectory Write FDLLDirectory;
    property ExtAddStoreSuffixes: String Read fExtAddStoreSuffixes
      Write {Set}FExtAddStoreSuffixes;
    property ExtrBaseDir: String Read FExtrBaseDir Write FExtrBaseDir;
    property ExtrOptions: ExtrOpts Read FExtrOptions Write FExtrOptions;
    property FSpecArgs: TStrings Read fFSpecArgs Write SetFSpecArgs;
    property FSpecArgsExcl: TStrings Read fFSpecArgsExcl Write SetSpecArgsExcl;
    property HowToDelete: DeleteOpts
      Read FHowToDelete Write FHowToDelete default htdAllowUndo;
    property PasswordReqCount: Longword Read FPasswordReqCount
      Write SetPasswordReqCount default 1;
    property RootDir: String Read FRootDir Write fRootDir;
    property TempDir: String Read FTempDir Write FTempDir;
    property Trace: Boolean Read FTrace Write FTrace;
    property Unattended: Boolean Read FUnattended Write FUnattended;
    property UseDirOnlyEntries: Boolean Read FUseDirOnlyEntries
      Write FUseDirOnlyEntries default False;
    property Verbose: Boolean Read FVerbose Write FVerbose;
    property VersionInfo: String Read GetVersionInfo Write SetVersionInfo;
    { At runtime: every time the filename is assigned a value,
   the ZipDir will automatically be read. }
    property ZipFileName: String Read GetZipFileName Write SetFileName;
    property Password: String Read GetPPassword Write SetPassword;
{$IFNDEF NO_SPAN}
    property ConfirmErase: Boolean Read fConfirmErase Write fConfirmErase default True;
    property KeepFreeOnAllDisks: Cardinal Read FFreeOnAllDisks Write FFreeOnAllDisks;
    property KeepFreeOnDisk1: Cardinal Read FFreeOnDisk1 Write FFreeOnDisk1;
    property MaxVolumeSize: Integer Read FMaxVolumeSize Write FMaxVolumesize;
    property MinFreeVolumeSize: Integer Read FMinFreeVolSize
      Write FMinFreeVolSize default 65536;
    property SpanOptions: SpanOpts Read FSpanOptions Write FSpanOptions;
{$ENDIF}
    { Events }
    property OnCheckTerminate: TCheckTerminateEvent
      Read FOnCheckTerminate Write FOnCheckTerminate;
    property OnItemProgress: TItemProgressEvent
      Read FOnItemProgress Write FOnItemProgress;
    property OnMessage: TMessageEvent Read FOnMessage Write FOnMessage;
    property OnProgress: TProgressEvent Read FOnProgress Write FOnProgress;
    property OnProgressDetails: TProgressDetailsEvent
      Read FOnProgressDetails Write FOnProgressDetails;
    property OnTick: TTickEvent Read FOnTick Write FOnTick;
    property OnTotalProgress: TTotalProgressEvent
      Read FOnTotalProgress Write FOnTotalProgress;
    property OnZipDialog: TZipDialogEvent Read FOnZipDialog Write FOnZipDialog;
    property OnZipStr: TZipStrEvent Read FOnZipStr Write FOnZipStr;
    property OnCopyZipOverwrite: TCopyZipOverwriteEvent
      Read FOnCopyZipOverwrite Write FOnCopyZipOverwrite;
    property OnCRC32Error: TCRC32ErrorEvent Read FOnCRC32Error Write FOnCRC32Error;
    property OnDirUpdate: TNotifyEvent Read FOnDirUpdate Write FOnDirUpdate;
    property OnExtractOverwrite: TExtractOverwriteEvent
      Read FOnExtractOverwrite Write FOnExtractOverwrite;
    property OnExtractSkipped: TExtractSkippedEvent
      Read FOnExtractSkipped Write FOnExtractSkipped;
    property OnFileComment: TFileCommentEvent Read FOnFileComment Write FOnFileComment;
    property OnFileExtra: TFileExtraEvent Read FOnFileExtra Write FOnFileExtra;
    property OnNewName: TNewNameEvent Read FOnNewName Write FOnNewName;
    property OnPasswordError: TPasswordErrorEvent
      Read FOnPasswordError Write FOnPasswordError;
    property OnSetAddName: TSetAddNameEvent Read FOnSetAddName Write FOnSetAddName;
    property OnSetExtName: TSetExtNameEvent Read FOnSetExtName Write FOnSetExtName;
    property OnSetNewName: TSetNewNameEvent Read FOnSetNewName Write FOnSetNewName;
{$IFNDEF NO_SPAN}
    property OnGetNextDisk: TGetNextDiskEvent Read FOnGetNextDisk Write FOnGetNextDisk;
    property OnStatusDisk: TStatusDiskEvent Read FOnStatusDisk Write FOnStatusDisk;
{$ENDIF}
{$IFNDEF NO_SFX}
{$IFNDEF INTERNAL_SFX}
    property SFXSlave: TCustomZipSFX Read {Get} FSFXSlave Write SetSFXSlave;
{$ELSE}
    property SFXCaption: String Read GetSFXCaption Write SetSFXCaption;
    property SFXCommandLine: String Read GetSFXCommandLine Write SetSFXCommandLine;
    property SFXDefaultDir: String Read GetSFXDefaultDir Write SetSFXDefaultDir;
    property SFXIcon: TIcon Read GetSFXIcon Write SetSFXIcon;
    property SFXMessage: String Read GetSFXMessage Write SetSFXMessage;
    property SFXOptions: SFXOpts {TSFXOptions} Read GetSFXOptions Write SetSFXOptions;
    property SFXOverWriteMode: OvrOpts {TSFXOverwriteMode}
      Read GetSFXOverWriteMode Write SetSFXOverWriteMode;
    property SFXPath: TFilename Read GetSFXPath Write SetSFXPath;
{$ENDIF}
{$ENDIF}
  end;

type
  TZipMaster = class(TCustomZipMaster)
  private
  public
    property Busy;
    property Cancel;
    property Count;
    property DirEntry;
    property DirOnlyCount;
    property ErrCode;
    property FullErrCode;
    property Handle;
    property IsSpanned;
    property Message;
    property SFXOffset;
    property SuccessCnt;
    property TotalSizeToProcess;
    property UnzBusy;
    property UnzVers;
    property Ver;
    property ZipBusy;
    property ZipComment;
    property ZipContents;
    property ZipEOC;
    property ZipFileSize;
    property ZipSOC;
    property ZipStream;
    property ZipVers;
    property NotMainThread;
  published
    property Active;
    property AddCompLevel;
    property AddFrom;
    property AddOptions;
    property AddStoreSuffixes;
    property CodePage;
    property DLLDirectory;
    property ExtAddStoreSuffixes;
    property ExtrBaseDir;
    property ExtrOptions;
    property FSpecArgs;
    property FSpecArgsExcl;
    property HowToDelete;
    property PasswordReqCount;
    property RootDir;
    property TempDir;
    property Trace;
    property Unattended;
    property UseDirOnlyEntries;
    property Verbose;
    property VersionInfo;
    property ZipFileName;
    property Password;
{$IFNDEF NO_SPAN}
    property ConfirmErase;
    property KeepFreeOnAllDisks;
    property KeepFreeOnDisk1;
    property MaxVolumeSize;
    property MinFreeVolumeSize;
    property SpanOptions;
{$ENDIF}
    property OnCheckTerminate;
    property OnItemProgress;
    property OnMessage;
    property OnProgress;
    property OnProgressDetails;
    property OnTick;
    property OnTotalProgress;
    property OnZipDialog;
    property OnZipStr;
    property OnCopyZipOverwrite;
    property OnCRC32Error;
    property OnDirUpdate;
    property OnExtractOverwrite;
    property OnExtractSkipped;
    property OnFileComment;
    property OnFileExtra;
    property OnNewName;
    property OnPasswordError;
    property OnSetAddName;
    property OnSetExtName;
    property OnSetNewName;
{$IFNDEF NO_SPAN}
    property OnGetNextDisk;
    property OnStatusDisk;
{$ENDIF}

{$IFNDEF NO_SFX}
{$IFNDEF INTERNAL_SFX}
    property SFXSlave;
{$ELSE}
    property SFXCaption;
    property SFXCommandLine;
    property SFXDefaultDir;
    property SFXIcon;
    property SFXMessage;
    property SFXOptions;
    property SFXOverWriteMode;
    property SFXPath;
{$ENDIF}
{$ENDIF}
  end;

const
  AddDirNames  = ZipBase.AddDirNames;
  AddRecurseDirs = ZipBase.AddRecurseDirs;
  AddMove      = ZipBase.AddMove;
  AddFreshen   = ZipBase.AddFreshen;
  AddUpdate    = ZipBase.AddUpdate;
  AddZipTime   = ZipBase.AddZipTime;
  AddForceDOS  = ZipBase.AddForceDOS;
  AddHiddenFiles = ZipBase.AddHiddenFiles;
  AddArchiveOnly = ZipBase.AddArchiveOnly;
  AddResetArchive = ZipBase.AddResetArchive;
  AddEncrypt   = ZipBase.AddEncrypt;
  AddSeparateDirs = ZipBase.AddSeparateDirs;
  AddVolume    = ZipBase.AddVolume;
  AddFromDate  = ZipBase.AddFromDate;
  AddSafe      = ZipBase.AddSafe;
  AddForceDest = ZipBase.AddForceDest;
  AddDiskSpan  = ZipBase.AddDiskSpan;
  AddDiskSpanErase = ZipBase.AddDiskSpanErase;

  spNoVolumeName = ZipBase.spNoVolumeName;
  spCompatName   = ZipBase.spCompatName;
  spWipeFiles    = ZipBase.spWipeFiles;
  spTryFormat    = ZipBase.spTryFormat;

  ExtrDirNames  = ZipBase.ExtrDirNames;
  ExtrOverWrite = ZipBase.ExtrOverWrite;
  ExtrFreshen   = ZipBase.ExtrFreshen;
  ExtrUpdate    = ZipBase.ExtrUpdate;
  ExtrTest      = ZipBase.ExtrTest;
  ExtrForceDirs = ZipBase.ExtrForceDirs;

  OvrConfirm = ZipBase.OvrConfirm;
  OvrAlways  = ZipBase.OvrAlways;
  OvrNever   = ZipBase.OvrNever;

  cpAuto = ZipBase.cpAuto;
  cpNone = ZipBase.cpNone;
  cpOEM  = ZipBase.cpOEM;

  htdFinal     = ZipBase.htdFinal;
  htdAllowUndo = ZipBase.htdAllowUndo;

  pwbOk     = mbOK;
  pwbCancel = mbCancel;
  pwbCancelAll = mbAll;
  pwbAbort  = mbAbort;

  NewFile     = ZipProg.NewFile;
  ProgressUpdate = ZipProg.ProgressUpdate;
  EndOfBatch  = ZipProg.EndOfBatch;
  TotalFiles2Process = ZipProg.TotalFiles2Process;
  TotalSize2Process = ZipProg.TotalSize2Process;
  NewExtra    = ZipProg.NewExtra;
  ExtraUpdate = ZipProg.ExtraUpdate;

//  procedure Register;

implementation

uses ZipUtils, ZipStrs;

function TCustomZipMaster.TheErrorCode(errCode: Integer): Integer;
begin
  Result := errCode and (Reentry_Error - 1);
end;

procedure TCustomZipMaster.Starting;
begin
  fBusy    := True;
  fReentry := False;
  FZip.Master := Self;
  FZip.OnCheckTerminate := OnCheckTerminate;
  FZip.OnItemProgress := OnItemProgress;
  FZip.OnMessage := OnMessage;
  FZip.OnProgress := OnProgress;
  FZip.OnProgressDetails := OnProgressDetails;
  FZip.OnTick := OnTick;
  FZip.OnTotalProgress := OnTotalProgress;
  FZip.OnZipDialog := OnZipDialog;
  FZip.OnZipStr := OnZipStr;
  FZip.OnCopyZipOverwrite := OnCopyZipOverwrite;
  FZip.OnCRC32Error := OnCRC32Error;
  FZip.OnDirUpdate := OnDirUpdate;
  FZip.OnExtractOverwrite := OnExtractOverwrite;
  FZip.OnExtractSkipped := OnExtractSkipped;
  FZip.OnFileComment := OnFileComment;
  FZip.OnFileExtra := OnFileExtra;
  FZip.OnNewName := OnNewName;
  FZip.OnPasswordError := OnPasswordError;
  FZip.OnSetAddName := OnSetAddName;
  FZip.OnSetExtName := OnSetExtName;
  FZip.OnSetNewName := OnSetNewName;
{$IFNDEF NO_SPAN}
  FZip.OnGetNextDisk := OnGetNextDisk;
  FZip.OnStatusDisk := OnStatusDisk;  
  FZip.KeepFreeOnAllDisks := KeepFreeOnAllDisks;
  FZip.KeepFreeOnDisk1 := KeepFreeOnDisk1;
  FZip.MaxVolumeSize := MaxVolumeSize;
  FZip.MinFreeVolumeSize := MinFreeVolumeSize;
  FZip.SpanOptions := SpanOptions;
  FZip.ConfirmErase := ConfirmErase;
{$ENDIF}
  FZip.AddCompLevel := AddCompLevel;
  FZip.AddFrom    := AddFrom;
  FZip.AddOptions := AddOptions;
  FZip.AddStoreSuffixes := AddStoreSuffixes;
  FZip.ExtAddStoreSuffixes := ExtAddStoreSuffixes;
  FZip.CodePage   := CodePage;
  FZip.ExtrBaseDir := ExtrBaseDir;
  FZip.ExtrOptions := ExtrOptions; 
  FZip.Unattended := Unattended;
  FZip.Verbose    := Verbose;
  FZip.Trace      := Trace;
  FZip.DLLDirectory := DLLDirectory;
  FZip.TempDir    := TempDir;
  fZip.NotMainTask := NotMainThread;
  FZip.FSpecArgs.Assign(FSpecArgs);
  FZip.FSpecArgsExcl.Assign(FSpecArgsExcl);
  FZip.Handle      := Handle;
  FZip.HowToDelete := HowToDelete;
  FZip.Password    := Password;
  FZip.PasswordReqCount := PasswordReqCount;
  FZip.RootDir     := RootDir; 
  FZip.Unattended  := Unattended;
  FZip.UseDirOnlyEntries := UseDirOnlyEntries;
  FZip.Starting;
end;

procedure TCustomZipMaster.Done;
begin
  fZip.Done;
  fBusy := False;
  if fZip.Reentry then
    fReentry := True;
  FFSpecArgs.Assign(fzip.FSpecArgs);
  FFSpecArgsExcl.Assign(fzip.FSpecArgsExcl);
end;

function TCustomZipMaster.Stopped: Boolean;
begin
  if not fBusy then
    Result := True
  else begin
    Result   := False;
    fReentry := True;
    fZip.Attacked(self);
  end;
end;

function TCustomZipMaster.CanStart: Boolean;
begin
  if (csDesigning in ComponentState) or (csLoading in ComponentState) then
    Result := False
  else
    Result := (Active and Stopped);
end;

function TCustomZipMaster.GetCancel: Boolean;
begin
  Result := FZip.Cancel;
end;

function TCustomZipMaster.GetCount: Integer;
begin
  if Active then
    Result := FZip.Count
  else
    Result := 0;
end;

function TCustomZipMaster.GetDirEntry(idx: Integer): pZipDirEntry;
begin
  if Active then
    Result := FZip[idx]
  else
    Result := NIL;
end;

function TCustomZipMaster.GetDirOnlyCount: Integer;
begin
  Result := FZip.DirOnlyCount;
end;

function TCustomZipMaster.GetErrCode: Integer;
begin
  Result := FZip.ErrCode;
  if FReentry then
    Result := Result or Reentry_Error
  else if not Active then
    Result := GE_Inactive;
end;

function TCustomZipMaster.GetErrMessage: String;
begin
  if Active then
    Result := FZip.Message
  else
    Result := ZipLoadStr(GE_Inactive);
  if FReentry then
    Result := ZipFmtLoadStr(GE_WasBusy, [Result]);
end;

function TCustomZipMaster.GetFullErrCode: Integer;
begin
  Result := FZip.FullErrCode;
end;

function TCustomZipMaster.GetIsSpanned: Boolean;
begin
  Result := FZip.IsSpanned;
end;

function TCustomZipMaster.GetPPassword: String;
begin
  Result := FZip.Password;
end;

function TCustomZipMaster.GetRealFileSize: Cardinal;
begin
  Result := FZip.ZipFileSize;
end;

function TCustomZipMaster.GetSFXOffset: Integer;
begin
  Result := FZip.SFXOffset;
end;

function TCustomZipMaster.GetSuccessCnt: Integer;
begin
  Result := FZip.SuccessCnt;
end;

function TCustomZipMaster.GetTotalSizeToProcess: Int64;
begin
  Result := FZip.TotalSizeToProcess;
end;

function TCustomZipMaster.GetUnzBusy: Boolean;
begin
  Result := FZip.UnzBusy;
end;

function TCustomZipMaster.GetUnzVers: Integer;
begin
  Result := FZip.UnzVers;
end;

function TCustomZipMaster.GetVer: Integer;
begin
  Result := FZip.Ver;
end;

function TCustomZipMaster.GetZipBusy: Boolean;
begin
  Result := FZip.ZipBusy;
end;

function TCustomZipMaster.GetZipComment: String;
begin
  Result := FZip.ZipComment;
end;

function TCustomZipMaster.GetZipContents: TList;
begin
  Result := FZip.ZipContents;
end;

function TCustomZipMaster.GetZipEOC: Cardinal;
begin
  Result := FZip.ZipEOC;
end;

function TCustomZipMaster.GetZipFileName: String;
begin
  Result := FZip.ZipFileName;
end;

function TCustomZipMaster.GetZipSOC: Cardinal;
begin
  Result := FZip.ZipSOC;
end;

function TCustomZipMaster.GetZipStream: TZipStream;
begin
  Result := FZip.ZipStream;
end;

function TCustomZipMaster.GetZipVers: Integer;
begin
  Result := FZip.ZipVers;
end;
  
function TCustomZipMaster.GetVersionInfo: String;
begin
  Result := FZip.VersionInfo;
end;

procedure TCustomZipMaster.SetCancel(Value: Boolean);
begin
  FZip.Cancel := Value;
end;

procedure TCustomZipMaster.SetErrCode(Value: Integer);
begin
  if Stopped then
    FZip.ErrCode := Value;
end;
{
procedure TCustomZipMaster.SetExtAddStoreSuffixes(Value: String);
begin
  if Stopped then
    FZip.ExtAddStoreSuffixes := Value;
end;
}
procedure TCustomZipMaster.SetFileName(Value: String);
begin
  if (csDesigning in ComponentState) or (csLoading in ComponentState) then
    FZip.Active := False;                   // stop any actions
  if Stopped then
    try
      Starting;
      FZip.ZipFileName := Value;
    finally
      Done;
    end;
end;

procedure TCustomZipMaster.SetPassword(Value: String);
begin
  {  if Stopped then}
  FZip.Password := Value;
end;

procedure TCustomZipMaster.SetPasswordReqCount(Value: LongWord);
begin
  if Value <> FPasswordReqCount then
  begin
    if Value > 15 then
      Value := 15;
    FPasswordReqCount := Value;
  end;
  {  if Stopped then}
  //  FZip.PasswordReqCount := Value;
end;

procedure TCustomZipMaster.SetVersionInfo(Value: String);
begin
  //    FZip.VersionInfo := Value;
end;

procedure TCustomZipMaster.SetZipComment(Value: String);
begin
  if (csDesigning in ComponentState) or (csLoading in ComponentState) then
    FZip.Active := False;                   // stop any actions
  if Stopped then
    try
      Starting;
      FZip.ZipComment := Value;
    finally
      Done;
    end;
end;

constructor TCustomZipMaster.Create(AOwner: TComponent);
begin
  inherited;
  FZip      := TZipWorker.Create;//(Self);
  FActive   := False;
  FBusy     := False;
  fNotMainThread := False;
  FFSpecArgs := TStringList.Create;
  FFSpecArgsExcl := TStringList.Create;
  FAddCompLevel := 9;                       { dflt to tightest compression }
  FAddStoreSuffixes := [assGIF, assPNG, assZ, assZIP, assZOO, assARC, assLZH,
    assARJ, assTAZ, assTGZ, assLHA, assRAR, assACE, assCAB,
    assGZ, assGZIP, assJAR];
  FCodePage := cpAuto;
  FEncrypt  := False;
{$IFNDEF NO_SPAN}
  FFreeOnAllDisks := 0;                     // 1.72 { use all space }
  FFreeOnDisk1 := 0;                        { Don't leave any freespace on disk 1. }
  FMaxVolumeSize := 0;                      { Use the maximum disk size. }
  FMinFreeVolSize := 65536;                 { Reject disks with less free bytes than... }
{$ENDIF}
  FFromDate := 0;
  fHandle   := Application.Handle;
  FHowToDelete := htdAllowUndo;
  FPassword := '';
  FPasswordReqCount := 1;
  FSpanOptions := [];
  FUnattended := False;
  FUseDirOnlyEntries := False;
{$IFNDEF NO_SPAN}
  fConfirmErase := True;
{$ENDIF}
  { events }
  FOnCheckTerminate := NIL;
  FOnItemProgress := NIL;
  FOnMessage := NIL;
  FOnProgress := NIL;
  FOnProgressDetails := NIL;
  FOnTick   := NIL;
  FOnTotalProgress := NIL;
  FOnZipDialog := NIL;
  fOnCopyZipOverwrite := NIL;
  fOnCRC32Error := NIL;
  fOnDirUpdate := NIL;
  fOnExtractOverwrite := NIL;
  fOnExtractSkipped := NIL;
  fOnFileComment := NIL;
  fOnFileExtra := NIL;
  fOnNewName := NIL;
  fOnPasswordError := NIL;
  fOnSetAddName := NIL;
  fOnSetExtName := NIL;
  fOnSetNewName := NIL;
{$IFNDEF NO_SPAN}
  FOnGetNextDisk := NIL;
  FOnStatusDisk := NIL;
{$ENDIF}
{$IFNDEF NO_SFX}
{$IFDEF INTERNAL_SFX}
  FSFXSlave := TCustomZipSFX.Create(self);
{$ELSE}
  FSFXSlave := NIL;
{$ENDIF}
  FZip.SFXSlave := FSFXSlave;
{$ENDIF}
  FActive   := True;
  FZip.Active := Active;
end;

destructor TCustomZipMaster.Destroy;
begin
  FreeAndNil(FZip);
  inherited;
end;

procedure TCustomZipMaster.BeforeDestruction;
begin
  if assigned(FZip) then
    FZip.Active := False;
  inherited;
end;


procedure TCustomZipMaster.Loaded;
begin
  inherited;
  if not (csDesigning in ComponentState) then
    FZip.Active := Active;
end;

function TCustomZipMaster.Add: Integer;
begin
  Result := BUSY_ERROR;
  if CanStart then
    try
      Starting;
      Result := FZip.Add;
    finally
      Done;
    end;
end;

function TCustomZipMaster.AddStreamToFile(Filename: String;
  FileDate, FileAttr: Dword): Integer;
begin
  Result := BUSY_ERROR;
  if CanStart then
    try
      Starting;
      Result := FZip.AddStreamToFile(Filename, FileDate, FileAttr);
    finally
      Done;
    end;
end;

function TCustomZipMaster.AddStreamToStream(InStream: TMemoryStream): TZipStream;
begin
  Result := NIL;
  if CanStart then
    try
      Starting;
      Result := FZip.AddStreamToStream(InStream);
    finally
      Done;
    end;
end;

function TCustomZipMaster.AppendSlash(sDir: String): String;
begin
  Result := DelimitPath(sDir, True);
end;

function TCustomZipMaster.Copy_File(const InFileName, OutFileName: String): Integer;
begin
  Result := BUSY_ERROR;
  if CanStart then
    try
      Starting;
      Result := FZip.Copy_File(InFileName, OutFileName);
    finally
      Done;
    end;
end;

function TCustomZipMaster.CopyZippedFiles(DestZipMaster: TCustomZipMaster;
  DeleteFromSource: Boolean; OverwriteDest: OvrOpts {ReplaceOpts}): Integer;
begin
  Result := BUSY_ERROR;
  if CanStart then
    try
      Starting;
      Result := FZip.CopyZippedFiles(DestZipMaster.FZip, DeleteFromSource,
        OverwriteDest);
    finally
      Done;
    end;
end;

function TCustomZipMaster.Delete: Integer;
begin
  Result := BUSY_ERROR;
  if CanStart then
    try
      Starting;
      Result := FZip.Delete;
    finally
      Done;
    end;
end;

function TCustomZipMaster.EraseFile(const Fname: String; How: DeleteOpts): Integer;
begin
  Result := ZipUtils.EraseFile(Fname, How = htdFinal);
end;

function TCustomZipMaster.Extract: Integer;
begin
  Result := BUSY_ERROR;
  if CanStart then
    try
      Starting;
      Result := FZip.Extract;
    finally
      Done;
    end;
end;

function TCustomZipMaster.ExtractFileToStream(Filename: String): TZipStream;
begin
  Result := NIL;
  if CanStart then
    try
      Starting;
      Result := FZip.ExtractFileToStream(Filename);
    finally
      Done;
    end;
end;

function TCustomZipMaster.ExtractStreamToStream(InStream: TMemoryStream;
  OutSize: Longword): TZipStream;
begin
  Result := NIL;
  if CanStart then
    try
      Starting;
      Result := FZip.ExtractStreamToStream(InStream, OutSize);
    finally
      Done;
    end;
end;

function TCustomZipMaster.Find(const fspec: String; var idx: Integer): pZipDirEntry;
begin
  Result := NIL;
  if CanStart then
    try
      Starting;
      Result := FZip.Find(fspec, idx);
    finally
      Done;
    end;
end;

function TCustomZipMaster.FullVersionString: String;
begin
  { Result := '';
    if  Stopped then}
  Result := FZip.FullVersionString;
end;

function TCustomZipMaster.GetAddPassword: String;
var
  Resp: TPasswordButton;
begin
  Result := FZip.GetAddPassword(Resp);
end;

function TCustomZipMaster.GetExtrPassword: String;
var
  Resp: TPasswordButton;
begin
  Result := FZip.GetExtrPassword(Resp);
end;

function TCustomZipMaster.GetAddPassword(var Response: TPasswordButton): String;
begin
  Result := FZip.GetAddPassword(Response);
end;

function TCustomZipMaster.GetExtrPassword(var Response: TPasswordButton): String;
begin
  Result := FZip.GetExtrPassword(Response);
end;

function TCustomZipMaster.GetPassword(DialogCaption, MsgTxt: String;
  pwb: TPasswordButtons; var ResultStr: String): TPasswordButton;
begin
  //  Result := pwbCancel;
  //  if  Stopped then
  Result := FZip.GetPassword(DialogCaption, MsgTxt, pwb, ResultStr);
end;

function TCustomZipMaster.IndexOf(const fname: String): Integer;
begin
  Result := -1;
  if CanStart then
    try
      Starting;
      Result := FZip.IndexOf(fname);
    finally
      Done;
    end;
end;

function TCustomZipMaster.List: Integer;
begin
  Result := BUSY_ERROR;
  if CanStart then
    try
      Starting;
      Result := FZip.List;
    finally
      Done;
    end;
end;

function TCustomZipMaster.Load_Unz_Dll: Integer;
begin
  Result := BUSY_ERROR;
  if CanStart then
    try
      Starting;
      Result := FZip.Load_Unz_Dll;
    finally
      Done;
    end;
end;

function TCustomZipMaster.Load_Zip_Dll: Integer;
begin
  Result := BUSY_ERROR;
  if CanStart then
    try
      Starting;
      Result := FZip.Load_Zip_Dll;
    finally
      Done;
    end;
end;

function TCustomZipMaster.MakeTempFileName(Prefix, Extension: String): String;
begin
  Result := FZip.MakeTempFileName(Prefix, Extension);
end;

function TCustomZipMaster.Rename(RenameList: TList; DateTime: Integer): Integer;
begin
  Result := BUSY_ERROR;
  if CanStart then
    try
      Starting;
      Result := FZip.Rename(RenameList, DateTime);
    finally
      Done;
    end;
end;

function TCustomZipMaster.UnzDllPath: String;
begin
  Result := FZip.UnzDllPath;
end;

function TCustomZipMaster.ZipDllPath: String;
begin
  Result := FZip.ZipDllPath;
end;

procedure TCustomZipMaster.AbortDlls;
begin
  FZip.AbortDlls;
end;

procedure TCustomZipMaster.Clear;
begin
  if CanStart {or FZip.Cancel} then
  begin
    FZip.Clear;
    Done;
    FReentry := False;
  end;
end;

function TCustomZipMaster.QueryZip(const fname: TFileName): Integer;
begin
  Result := ZipUtils.QueryZip(fname);
end;

procedure TCustomZipMaster.ShowExceptionError(const ZMExcept: EZipMaster);
begin
  FZip.ShowExceptionError(ZMExcept);
end;

procedure TCustomZipMaster.ShowZipMessage(Ident: Integer; UserStr: String);
begin
  FZip.ShowZipMessage(Ident, UserStr);
end;

procedure TCustomZipMaster.Unload_Unz_Dll;
begin
  if CanStart then
    FZip.Unload_Unz_Dll;
end;

procedure TCustomZipMaster.Unload_Zip_Dll;
begin
  if CanStart then
    FZip.Unload_Zip_Dll;
end;

{$IFNDEF NO_SPAN}
function TCustomZipMaster.ReadSpan(InFileName: String; var OutFilePath: String): Integer;
begin
  Result := BUSY_ERROR;
  if CanStart then
    try
      Starting;
      Result := FZip.ReadSpan(InFileName, OutFilePath, False);
    finally
      Done;
    end;
end;

function TCustomZipMaster.WriteSpan(InFileName, OutFileName: String): Integer;
begin
  Result := BUSY_ERROR;
  if CanStart then
    try
      Starting;
      Result := FZip.WriteSpan(InFileName, OutFileName, False);
    finally
      Done;
    end;
end;

{$ENDIF}

{$IFNDEF NO_SFX}
{$IFNDEF INTERNAL_SFX}
(*? TCustomZipMaster.SetSFXSlave
1.76 29 May 2004 Force slave to notify of destruction
*)
procedure TCustomZipMaster.SetSFXSlave(Value: TCustomZipSFX);
begin
  if CanStart and (Value <> FSFXSlave) then
  begin
    if assigned(FSFXSlave) then
      FSFXSlave.RemoveFreeNotification(self);
    FSFXSlave := Value;
    if assigned(FSFXSlave) then
      FSFXSlave.FreeNotification(self);

    FZip.SFXSlave := Value;
  end;
end;
//? TCustomZipMaster.SetSFXSlave

procedure TCustomZipMaster.Notification(AComponent: TComponent; Operation: TOperation);
begin
  if (Operation = opRemove) and (AComponent = FSFXSlave) then
    FSFXSlave := NIL;
end;

{$ENDIF}

{$IFDEF INTERNAL_SFX}
function TCustomZipMaster.GetSFXCaption: String;
begin
  Result := TZipSFX(FSFXSlave).DialogTitle;
end;

function TCustomZipMaster.GetSFXCommandLine: String;
begin
  Result := TZipSFX(FSFXSlave).CommandLine;
end;

function TCustomZipMaster.GetSFXDefaultDir: String;
begin
  Result := TZipSFX(FSFXSlave).DefaultExtractPath;
end;

function TCustomZipMaster.GetSFXIcon: TIcon;
begin
  Result := TZipSFX(FSFXSlave).Icon;
end;

function TCustomZipMaster.GetSFXMessage: String;
begin
  Result := TZipSFX(FSFXSlave).Message;
end;

function TCustomZipMaster.GetSFXOptions: SFXOpts; //TSFXOptions;
var
  o: TSFXOptions;
begin
  //  Result := TZipSFX(FSFXSlave).Options;
  Result := [];
  o      := TZipSFX(FSFXSlave).Options;
  if soAskCmdLine in o then // allow user to prevent execution of the command line
    Result := [SFXAskCmdLine];
  if soAskFiles in o then // allow user to prevent certain files from extraction
    Result := Result + [SFXAskFiles];
  if soHideOverWriteBox in o then
    // do not allow user to choose the overwrite mode
    Result := Result + [SFXHideOverWriteBox];
  if soAutoRun in o then // start extraction + evtl. command line automatically
    Result := Result + [SFXAutoRun];
  // only if sfx filename starts with "!" or is "setup.exe"
  if soNoSuccessMsg in o then
    // don't show success message after extraction
    Result := Result + [SFXNoSuccessMsg];
end;

function TCustomZipMaster.GetSFXOverWriteMode: OvrOpts; // TSFXOverwriteMode;
begin
  //  Result := TZipSFX(FSFXSlave).OverWriteMode;
  case TZipSFX(FSFXSlave).OverWriteMode of
    somAsk: Result  := ovrConfirm;
    somOverwrite: Result := ovrAlways;
    somSkip: Result := ovrNever;
    else
      Result := ovrConfirm;
  end;
end;

function TCustomZipMaster.GetSFXPath: TFilename;
begin
  Result := TZipSFX(FSFXSlave).SFXPath;
end;

procedure TCustomZipMaster.SetSFXCaption(Value: String);
begin
  {  if Stopped then}
  TZipSFX(FSFXSlave).DialogTitle := Value;
end;

procedure TCustomZipMaster.SetSFXCommandLine(Value: String);
begin
  {  if Stopped then}
  TZipSFX(FSFXSlave).CommandLine := Value;
end;

procedure TCustomZipMaster.SetSFXDefaultDir(Value: String);
begin
  {  if Stopped then}
  TZipSFX(FSFXSlave).DefaultExtractPath := Value;
end;

procedure TCustomZipMaster.SetSFXIcon(Value: TIcon);
begin
  {  if Stopped then}
  TZipSFX(FSFXSlave).Icon := Value;
end;

procedure TCustomZipMaster.SetSFXMessage(Value: String);
begin
  {  if Stopped then begin }
  TZipSFX(FSFXSlave).MessageFlags := MB_OK;
  if Value <> '' then
    case Value[1] of
      #1:
      begin
        TZipSFX(FSFXSlave).MessageFlags := MB_OKCANCEL or MB_ICONINFORMATION;
        System.Delete(Value, 1, 1);
      end;
      #2:
      begin
        TZipSFX(FSFXSlave).MessageFlags := MB_YESNO or MB_ICONQUESTION;
        System.Delete(Value, 1, 1);
      end;
    end;
  TZipSFX(FSFXSlave).Message := Value;
  //  end;
end;

procedure TCustomZipMaster.SetSFXOptions(Value: SFXOpts); //TSFXOptions);
var
  o: TSFXOptions;
begin
  {  if Stopped then}
  //    TZipSFX(FSFXSlave).Options := Value;
  o := [];
  if SFXAskCmdLine in Value then
    o := o + [soAskCmdLine];
  if SFXAskFiles in Value then
    o := o + [soAskFiles];
  if SFXHideOverWriteBox in Value then
    o := o + [soHideOverWriteBox];
  if SFXAutoRun in Value then
    o := o + [soAutoRun];
  if SFXNoSuccessMsg in Value then
    o := o + [soNoSuccessMsg];
  TZipSFX(FSFXSlave).Options := o;
end;

procedure TCustomZipMaster.SetSFXOverWriteMode(Value: OvrOpts); //TSFXOverwriteMode);
var
  om: TSFXOverwriteMode;
begin
  case Value of
    ovrConfirm: om := somAsk;
    ovrAlways: om  := somOverwrite;
    ovrNever: om   := somSkip;
    else
      om := somAsk;
  end;
  TZipSFX(FSFXSlave).OverWriteMode := om;
end;

procedure TCustomZipMaster.SetSFXPath(Value: TFilename);
begin
  {  if Stopped then}
  TZipSFX(FSFXSlave).SFXPath := Value;
end;

{$ENDIF}

function TCustomZipMaster.NewSFXFile(const ExeName: String): Integer;
begin
  Result := BUSY_ERROR;
  if CanStart then
    Result := FZip.NewSFXFile(ExeName);
end;

function TCustomZipMaster.ConvertSFX: Integer;
begin
  Result := BUSY_ERROR;
  if CanStart then
    Result := FZip.ConvertSFX;
end;

function TCustomZipMaster.ConvertZIP: Integer;
begin
  Result := BUSY_ERROR;
  if CanStart then
    Result := FZip.ConvertZIP;
end;

function TCustomZipMaster.IsZipSFX(const SFXExeName: String): Integer;
begin
  {  Result   := BUSY_ERROR;
    if  Stopped then }
  Result := FZip.IsZipSFX(SFXExeName);
end;

{$ENDIF}

procedure TCustomZipMaster.SetActive(Value: Boolean);
begin
  if Active <> Value then
    FActive := Value;
  if (csDesigning in ComponentState) or (csLoading in ComponentState) then
    FZip.Active := False
  else
    FZip.Active := Active;
end;


function TCustomZipMaster.GetBusy: Boolean;
begin
  Result := FBusy;
end;

procedure TCustomZipMaster.SetFSpecArgs(const Value: TStrings);
begin
  fFSpecArgs.Assign(Value);
end;

procedure TCustomZipMaster.SetSpecArgsExcl(const Value: TStrings);
begin
  fFSpecArgsExcl.Assign(Value);
end;

end.

