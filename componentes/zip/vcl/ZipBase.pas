unit ZipBase;

interface

{$INCLUDE '..\vcl\ZipConfig.inc'}
 {.$DEFINE DEBUG_PROGRESS}

uses
  Classes, SysUtils, Controls, Forms, Dialogs,
    ZCallBck, ZipXcpt, ZipProg;

const
  zprFile     = 0;
  zprArchive  = 1;
  zprCopyTemp = 2;
  zprSFX      = 3;
  zprHeader   = 4;
  zprFinish   = 5;
  zprCompressed = 6;
  zprCentral  = 7;
  zprChecking = 8;
  zprLoading  = 9;
  zprJoining  = 10;
  zprSplitting = 11;

type
  TPasswordButton  = TMsgDlgBtn; 
  TPasswordButtons = TMsgDlgButtons;//set of TPasswordButton;

type
  // new 1.73
  ActionCodes = (zacTick, zacItem, zacProgress, zacEndOfBatch, zacMessage,
    zacCount, zacSize, zacNewName, zacPassword, zacCRCError, zacOverwrite,
    zacSkipped, zacComment, zacStream, zacData, zacXItem, zacXProgress,
    zacExtName, zacNone);

type
  AddOptsEnum  = (AddDirNames, AddRecurseDirs, AddMove, AddFreshen, AddUpdate,
    AddZipTime, AddForceDOS, AddHiddenFiles, AddArchiveOnly, AddResetArchive,
    AddEncrypt, AddSeparateDirs, AddVolume, AddFromDate, AddSafe, AddForceDest,
    AddDiskSpan, AddDiskSpanErase);
  AddOpts      = set of AddOptsEnum;
  // new 1.72
  SpanOptsEnum = (spNoVolumeName, spCompatName, spWipeFiles, spTryFormat);
  SpanOpts     = set of SpanOptsEnum;

  // When changing this enum also change the pointer array in the function AddSuffix,
  // and the initialisation of ZipMaster. Also keep assGIF as first and assEXE as last value.
  AddStoreSuffixEnum = (assGIF, assPNG, assZ, assZIP, assZOO, assARC,
    assLZH, assARJ, assTAZ, assTGZ, assLHA, assRAR,
    assACE, assCAB, assGZ, assGZIP, assJAR, assEXE, assEXT);

  AddStoreExts = set of AddStoreSuffixEnum;

  ExtrOptsEnum = (ExtrDirNames, ExtrOverWrite, ExtrFreshen, ExtrUpdate,
    ExtrTest, ExtrForceDirs);
  ExtrOpts     = set of ExtrOptsEnum;

  OvrOpts     = (OvrConfirm, OvrAlways, OvrNever);
  ReplaceOpts = (rplConfirm, rplAlways, rplNewer, rplNever);

  CodePageOpts      = (cpAuto, cpNone, cpOEM);
  CodePageDirection = (cpdOEM2ISO, cpdISO2OEM);

  DeleteOpts = (htdFinal, htdAllowUndo);

  UnZipSkipTypes = (stOnFreshen, stNoOverwrite, stFileExists, stBadPassword,
    stNoEncryptionDLL, stCompressionUnknown, stUnknownZipHost,
    stZipFileFormatWrong, stGeneralExtractError);

  ZipDiskStatusEnum = (zdsEmpty, zdsHasFiles, zdsPreviousDisk, zdsSameFileName,
    zdsNotEnoughSpace);
  TZipDiskStatus    = set of ZipDiskStatusEnum;
  TZipDiskAction    = (zdaYesToAll, zdaOk, zdaErase, zdaReject, zdaCancel);

  TZipDelayedItems = (zdiList, zdiComment);
  TZipDelays = set of TZipDelayedItems;

  TZipShowProgress = (zspNone, zspFull, zspExtra);

  TZipAllwaysItems = (zaaYesOvrwrt);//, zyaDummy);
  TZipAnswerAlls = set of TZipAllwaysItems;

type
  ZipDirEntry = packed record               // fixed part size = 42
    MadeByVersion: Byte;
    HostVersionNo: Byte;
    Version: Word;
    Flag: Word;
    CompressionMethod: Word;
    DateTime: Integer;                      // Time: Word; Date: Word; }
    CRC32: Integer;
    CompressedSize: Integer;
    UncompressedSize: Integer;
    FileNameLength: Word;
    ExtraFieldLength: Word;
    FileCommentLen: Word;
    StartOnDisk: Word;
    IntFileAttrib: Word;
    ExtFileAttrib: Longword;
    RelOffLocalHdr: Longword;
    FileName: String;                       // variable size
    FileComment: String;                    // variable size
    Encrypted: Boolean;
    ExtraData: String;
  end;
  pZipDirEntry    = ^ZipDirEntry;

type
  pZipRenameRec = ^ZipRenameRec;

  ZipRenameRec = record
    Source: String;
    Dest: String;
    DateTime: Integer;
  end;


type
  TCheckTerminateEvent = procedure(Sender: TObject; var abort: Boolean) of object;
  TCopyZipOverwriteEvent = procedure(Sender: TObject; ForFile: String;
    var DoOverwrite: Boolean) of object;
  TCRC32ErrorEvent = procedure(Sender: TObject; ForFile: String;
    FoundCRC, ExpectedCRC: Longword; var DoExtract: Boolean) of object;
  TExtractOverwriteEvent = procedure(Sender: TObject; ForFile: String;
    IsOlder: Boolean; var DoOverwrite: Boolean; DirIndex: Integer) of object;
  TExtractSkippedEvent = procedure(Sender: TObject; ForFile: String;
    SkipType: UnZipSkipTypes; ExtError: Integer) of object;
  TFileCommentEvent = procedure(Sender: TObject; ForFile: String;
    var FileComment: String; var IsChanged: Boolean) of object;
  TFileExtraEvent = procedure(Sender: TObject; ForFile: String;
    var Data: String; var IsChanged: Boolean) of object;
  TGetNextDiskEvent = procedure(Sender: TObject; DiskSeqNo, DiskTotal: Integer;
    Drive: String; var AbortAction: Boolean) of object;
  TItemProgressEvent = procedure(Sender: TObject; Item: String;
    TotalSize: Cardinal; PerCent: Integer) of object;
  TMessageEvent = procedure(Sender: TObject; ErrCode: Integer;
    Message: String) of object;
  TNewNameEvent = procedure(Sender: TObject; SeqNo: Integer;
    ZipEntry: ZipDirEntry) of object;
  TPasswordErrorEvent = procedure(Sender: TObject; IsZipAction: Boolean;
    var NewPassword: String; ForFile: String; var RepeatCount: Longword;
    var Action: TMsgDlgBtn{TPasswordButton}) of object;
  TProgressDetailsEvent = procedure(Sender: TObject;
    details: TProgressDetails) of object;
  TProgressEvent = procedure(Sender: TObject; ProgrType: ProgressType;
    Filename: String; FileSize: TProgressSize) of object;
  TSetAddNameEvent = procedure(Sender: TObject; var FileName: String;
    const ExtName: String; var IsChanged: Boolean) of object;
  TSetExtNameEvent = procedure(Sender: TObject; var FileName: String;
    var IsChanged: Boolean) of object;
  TSetNewNameEvent = procedure(Sender: TObject; var OldFileName: String;
    var IsChanged: Boolean) of object;
  TStatusDiskEvent = procedure(Sender: TObject; PreviousDisk: Integer;
    PreviousFile: String; Status: TZipDiskStatus; var Action: TZipDiskAction) of object;
  TTickEvent = procedure(Sender: TObject) of object;
  TTotalProgressEvent = procedure(Sender: TObject; TotalSize: TProgressSize;
    PerCent: Integer) of object;     
  TZipDialogEvent = procedure(Sender: TObject; const title: String;
    var msg: String; var Result: Integer; btns: TMsgDlgButtons) of object; 
  TZipStrEvent = procedure(Ident: Integer; var DefStr: String) of object;

type
  TZipBase = class
  private
    FCurWaitCount: Integer;
    FSaveCursor: TCursor;
    // events
    FOnCheckTerminate: TCheckTerminateEvent;
    FOnItemProgress: TItemProgressEvent;
    FOnMessage: TMessageEvent;
    FOnProgress: TProgressEvent;
    FOnProgressDetails: TProgressDetailsEvent;
    FOnTick: TTickEvent;
    FOnTotalProgress: TTotalProgressEvent;
    FOnZipDialog: TZipDialogEvent;
//    FOnZipStr: TZipStrEvent;

    function GetMessage: String;    
    function GetOnZipStr: TZipStrEvent;
    procedure SetOnZipStr(Value: TZipStrEvent);
  protected
    FMaster: TObject;//TComponent;
    FActive: Boolean;
    FBusy: Boolean;
    FReenter: Boolean;
    FMessage: String;
    fCancel: Boolean;
    FErrCode: Integer;
//private
    fFullErrCode: Integer;
    FUnattended: Boolean;
    fVerbose: Boolean;
    fTrace: Boolean;
    FProgDetails: {TObject;//} TProgressDetails;
    FEventErr: String;
    fIsDestructing: Boolean;
    FDLLDirectory: String;
    FTempDir: String;
    FNotMainTask: Boolean;  // 1.77.2.0
    FAnswerAll: TZipAnswerAlls;

    procedure SetDLLDirectory(Value: String);
protected                                        
    procedure SetCancel(Value: Boolean); virtual;
    function ZipMessageDialog(const title: String; var msg: String;
       context: Integer; btns: TMsgDlgButtons): TModalResult;
    function ZipMessageDlg(const title, msg: String; context: Integer;
       btns: TMsgDlgButtons): TModalResult; overload;
    procedure ZipMessageDlg(const msg: String; context: Integer); overload;

    function Call_back(ActionCode: ActionCodes; ErrorCode: Integer;
      Msg: String; FileSize: Cardinal): Boolean; virtual;
protected//  public
    procedure Starting; virtual;
    procedure Done; virtual;
public    
    procedure Clear; virtual;
    procedure ShowZipMessage(Ident: Integer; const UserStr: String);
    procedure ShowExceptionError(const ZMExcept: EZipMaster);
    procedure StartWaitCursor;
    procedure StopWaitCursor;
    procedure Report(ActionCode: ActionCodes; ErrorCode: Integer;
      Msg: String; FileSize: Int64); overload;
    procedure Report(ActionCode: ActionCodes; ErrorCode: Integer;
      Msg: String; FileSize: Int64; written: Cardinal); overload;
    function MakeTempFileName(Prefix, Extension: String): String;
    procedure Attacked(AnObject: TObject);
    function GetTotalSizeToProcess: Int64;
  public
    constructor Create;
    destructor Destroy; override;
    //    property Active: boolean read fActive write SetActive;
    property Master: TObject Read fMaster Write fMaster;
    property Cancel: Boolean Read fCancel Write SetCancel;
    property Busy: Boolean Read FBusy Write fBusy;
    property Reentry: Boolean Read FReenter Write FReenter;
    property ErrCode: Integer Read fErrCode Write fErrCode; 
    property FullErrCode: Integer Read FFullErrCode;
    property Message: String Read GetMessage Write fMessage;
    property Verbose: Boolean Read FVerbose Write FVerbose;
    property Trace: Boolean Read FTrace Write FTrace;
    property Unattended: Boolean Read FUnattended Write FUnattended;
    property DLLDirectory: String Read FDLLDirectory Write SetDLLDirectory;
    property TempDir: String Read FTempDir Write FTempDir;
    property NotMainTask: Boolean Read fNotMainTask Write fNotMainTask;
    property OnMessage: TMessageEvent Read FOnMessage Write FOnMessage;
//    property OnDirUpdate: TNotifyEvent Read FOnDirUpdate Write FOnDirUpdate;
    property OnProgress: TProgressEvent Read FOnProgress Write FOnProgress;
    property OnTotalProgress: TTotalProgressEvent
      Read FOnTotalProgress Write FOnTotalProgress;
    property OnItemProgress: TItemProgressEvent
      Read FOnItemProgress Write FOnItemProgress;
    property OnProgressDetails: TProgressDetailsEvent
      Read FOnProgressDetails Write FOnProgressDetails;
    property OnTick: TTickEvent Read FOnTick Write FOnTick;
    property OnCheckTerminate: TCheckTerminateEvent
      Read fOnCheckTerminate Write fOnCheckTerminate;
    property OnZipDialog: TZipDialogEvent read FOnZipDialog write FOnZipDialog;
    property OnZipStr: TZipStrEvent read GetOnZipStr write SetOnZipStr;
  end;                                      { TZipBase }

implementation
 

uses WinProcs, ZipUtils, ZipDlg, ZipMsg, ZipStrs, ZipCtx;

const
  RESOURCE_ERROR: String =
    'ZipMsgXX.res is probably not linked to the executable' + #10 +
    'Missing String ID is: %d ';

function TZipBase.GetTotalSizeToProcess: Int64;
begin
  Result := TProgDetails(FProgDetails).TotalSize;
end;

function TZipBase.GetOnZipStr: TZipStrEvent;
begin
  Result := SetZipStr(pointer(-1));
end;

procedure TZipBase.SetOnZipStr(Value: TZipStrEvent);
begin
  SetZipStr(Value);
end;

procedure TZipBase.Attacked(AnObject: TObject);
begin
  fReenter := True;
  if Verbose then
    Report(zacMessage, 0, 'Re-entry', 0);
end;
   
(*? TZipBase.Starting
*)
procedure TZipBase.Starting;
begin
  fReenter := False;
  fBusy    := True;
  FAnswerAll := [];
  if GetCurrentThreadID <> MainThreadID then
    NotMainTask := true;
end;
//? TZipBase.Starting

procedure TZipBase.Done;
begin
  fBusy := False;
end;

procedure TZipBase.Clear;
begin
  FReenter := False;
  FMessage := '';
  fCancel := False;
  FErrCode := 0;
  fFullErrCode := 0;
  FUnattended := False;
  fVerbose := False;
  fTrace := False;
  TProgDetails(FProgDetails).Clear;
  FEventErr      := '';
  fIsDestructing := False;
  //    FDLLDirectory:= '';
  //    FTempDir:= '';
end;

procedure TZipBase.SetCancel(Value: Boolean);
begin
  fCancel := Value;
end;

 // NOTE: we will allow a dir to be specified that doesn't exist,
 // since this is not the only way to locate the DLLs.

procedure TZipBase.SetDLLDirectory(Value: String);
var
  ValLen: Integer;
begin
  if Value <> FDLLDirectory then
  begin
    ValLen := Length(Value);
    // if there is a trailing \ in dirname, cut it off:
    if ValLen > 0 then
      if Value[ValLen] = '\' then
        SetLength(Value, ValLen - 1);       // shorten the dirname by one
    FDLLDirectory := Value;
  end;
end;

destructor TZipBase.Destroy;
begin
  FreeAndNil(FProgDetails);
  inherited;
end;

constructor TZipBase.Create;//(AnMaster: TComponent);
begin
  inherited Create;
  FMaster  := self;//AnMaster;
  FActive  := False;
  FProgDetails := TProgDetails.Create;
  FMessage := '';
  FErrCode := -1;
  FUnattended := True;                      // during construction
  FCurWaitCount := 0;
  FVerbose := False;
  FTrace   := False;
  FDLLDirectory := '';
  FTempDir := '';
  FNotMainTask := False; 
  FAnswerAll := [];
//  FOnDirUpdate := nil;
  FOnMessage := nil;
  FOnProgress := nil;
  fOnCheckTerminate := nil;
  FOnTick := nil;
  FOnTotalProgress := nil;
  FOnItemProgress := nil;
  FOnProgressDetails := nil;
  FOnZipDialog := nil;
end;

(*? TZipBase.GetMessage
1.73 13 July 2003 RP only return message if error
*)

function TZipBase.GetMessage: String;
begin
  Result := '';
  if FErrCode <> 0 then
  begin
    Result := fMessage;
    if Result = '' then
      Result := ZipLoadStr(FErrCode);       //, 'unknown error ' + IntToStr(FErrCode));
    if Result = '' then
      Result := ZipFmtLoadStr(GE_Unknown, [FErrCode]);
  end;
end;
//? TZipBase.GetMessage

(*? TZipBase.ShowZipMessage
*)

procedure TZipBase.ShowZipMessage(Ident: Integer; const UserStr: String);
var
  Msg: String;
begin
  Msg := ZipLoadStr(Ident);
  if Msg = '' then
    Msg := Format(RESOURCE_ERROR, [Ident]);
  Msg := Msg + UserStr;
  FMessage := Msg;
  ErrCode  := Ident;

  if FUnattended = False then
    ZipMessageDlg(Msg, zmtInformation + DHC_ZipMessage);
//    ShowMessage(Msg);

  if Assigned(OnMessage) then
    OnMessage(Master, FErrCode {0}, Msg);
  // //No ErrCode here else w'll get a msg from the application
end;
//? TZipBase.ShowZipMessage

(*? TZipBase.ShowExceptionError
1.80 strings already formatted
// Somewhat different from ShowZipMessage() because the loading of the resource
// string is already done in the constructor of the exception class.
*)
procedure TZipBase.ShowExceptionError(const ZMExcept: EZipMaster);
begin
  FErrCode := ZMExcept.ResId;
  FMessage := ZMExcept.Message;

  if ZMExcept.FDisplayMsg and not FUnattended then  
    ZipMessageDlg(FMessage, zmtError + DHC_ExMessage);
//    ShowMessage(FMessage);

  if Assigned(OnMessage) then
    OnMessage(Master, FErrCode {0}, FMessage);
end;
//? TZipBase.ShowExceptionError

(*? TZipBase.StartWaitCursor
1.75.0.5 10 March 2004 only set wait if forground task
*)
procedure TZipBase.StartWaitCursor;
begin
  if not fNotMainTask then
  begin
    if FCurWaitCount = 0 then
    begin
      FSaveCursor   := Screen.Cursor;
      Screen.Cursor := crHourglass;
    end;
    Inc(FCurWaitCount);
  end;
end;
//? TZipBase.StartWaitCursor

(*? TZipBase.StopWaitCursor
1.75.0.5 10 March 2004 only set wait if forground task
*)
procedure TZipBase.StopWaitCursor;
begin
  if ( not fNotMainTask) and (FCurWaitCount > 0) then
  begin
    Dec(FCurWaitCount);
    if (FCurWaitCount = 0) then
      Screen.Cursor := FSaveCursor;
  end;
end;
//? TZipBase.StopWaitCursor

(*? TZipBase.Call_Back
  return true if handled
*)
function TZipBase.Call_back(ActionCode: ActionCodes; ErrorCode: Integer;
  Msg: String; FileSize: Cardinal): Boolean;
begin
  Result := False;
end;
//? TZipBase.Call_Back

(*? TZipBase.Report
1.77.2.0 14 September 2004 - RP fix setting ErrCode caused re-entry
1.77.2.0 14 September 2004 - RP alter thread support & OnCheckTerminate
1.77 16 July 2004 - RP preserve last errors message
1.76 24 April 2004 - only handle 'progress' and information
*)

procedure TZipBase.Report(ActionCode: ActionCodes; ErrorCode: Integer;
  Msg: String; FileSize: Int64);
var
  DoStop:  Boolean;
  Details: TProgDetails;
  Erm:     String;
begin
  if fIsDestructing then
    exit;
  if ActionCode <> zacNone then
  begin
    Details := FProgDetails as TProgDetails;
    case ActionCode of
      zacTick: { 'Tick' Just checking / processing messages}
        if assigned(OnTick) then
          OnTick(Master);

      zacItem: { progress type 1 = starting any ZIP operation on a new file }
      begin
        if Assigned(OnProgress) then
{$IFDEF ALLOW_2G}
          OnProgress(Master, NewFile, Msg, FileSize);
{$ELSE}
        OnProgress(Master, NewFile, Msg, Lo64(FileSize));
{$ENDIF}
        Details.SetItem(Msg, FileSize);
{$IFDEF DEBUG_PROGRESS}
        if Verbose then
          with Details do
            Report(zacMessage, 0, Format('#Item - "%s" %d', [ItemName, ItemSize]), 0);
{$ENDIF}
        if Assigned(OnProgressDetails) then
          OnProgressDetails(Master, Details);
        if Assigned(OnItemProgress) then
          OnItemProgress(Master, Details.ItemName, FileSize, 0);
      end;
      zacProgress:                          { progress type 2 = increment bar }
      begin
        if Assigned(OnProgress) then
{$IFDEF ALLOW_2G}
          OnProgress(Master, ProgressUpdate, '', FileSize);
{$ELSE}
        OnProgress(Master, ProgressUpdate, '', Lo64(FileSize));
{$ENDIF}
        Details.Advance(FileSize);
{$IFDEF DEBUG_PROGRESS}
        if Verbose then
          with Details do
            Report(zacMessage, 0,
              Format('#Progress - [inc:%d] ipos:%d isiz:%d, tpos:%d tsiz:%d',
              [FileSize, ItemPosition, ItemSize, TotalPosition, TotalSize]), 0);
{$ENDIF}
        if Assigned(OnProgressDetails) then
          OnProgressDetails(Master, Details);
        if Assigned(OnItemProgress) then
          OnItemProgress(Master, Details.ItemName, Details.ItemPosition,
            Details.ItemPerCent);
        if Assigned(OnTotalProgress) then
          OnTotalProgress(Master, Details.TotalSize, Details.TotalPerCent);
      end;
      zacEndOfBatch:                        { end of a batch of 1 or more files }
      begin
        if Assigned(OnProgress) then
          OnProgress(Master, EndOfBatch, '', 0);
        Details.SetEnd;
{$IFDEF DEBUG_PROGRESS}
        if Verbose then
          Report(zacMessage, 0, '#End Of Batch', 0);
{$ENDIF}
        if Assigned(OnProgressDetails) then
          OnProgressDetails(Master, Details);
        if Assigned(OnItemProgress) then
          OnItemProgress(Master, Details.ItemName, 0, 101);
        if Assigned(OnTotalProgress) then
          OnTotalProgress(Master, 0, 101);
      end;
      zacMessage:                           { a routine status message }
      begin
        Erm := Msg;
        if ErrorCode <> 0 then            // W'll always keep the last ErrorCode
        begin
          FMessage := Msg;
          FErrCode := Integer(ShortInt(ErrorCode and $FF));
          if (FErrCode = 9) and (fEventErr <> '') then // user cancel
          begin
            FMessage := ZipFmtLoadStr(GE_EventEx, [fEventErr]);
            Erm      := FMessage;
          end;
          fFullErrCode := ErrorCode;
        end;
        if Assigned(OnMessage) then
          OnMessage(Master, ErrorCode, Erm);
      end;

      zacCount:                             { total number of files to process }
      begin
        Details.SetCount(FileSize);
{$IFDEF DEBUG_PROGRESS}
        if Verbose then
          Report(zacMessage, 0, Format('#Count - %d', [Details.TotalCount]), 0);
{$ENDIF}
        if Assigned(OnProgressDetails) then
          OnProgressDetails(Master, Details);
        if Assigned(OnProgress) then
{$IFDEF ALLOW_2G}
          OnProgress(Master, TotalFiles2Process, '', FileSize);
{$ELSE}
        OnProgress(Master, TotalFiles2Process, '', Lo64(FileSize));
{$ENDIF}
      end;
      zacSize:                              { total size of all files to be processed }
      begin
        Details.SetSize(FileSize);
{$IFDEF DEBUG_PROGRESS}
        if Verbose then
          Report(zacMessage, 0, Format('#Size - %d', [Details.TotalSize]), 0);
{$ENDIF}
        if Assigned(OnProgressDetails) then
          OnProgressDetails(Master, Details);
        if Assigned(OnProgress) then
{$IFDEF ALLOW_2G}
          OnProgress(Master, TotalSize2Process, '', FileSize);
{$ELSE}
        OnProgress(Master, TotalSize2Process, '', Lo64(FileSize));
{$ENDIF}
      end;

      zacXItem:   { progress type 15 = starting new extra operation }
      begin
        if Assigned(OnProgress) then
{$IFDEF ALLOW_2G}
          OnProgress(Master, NewExtra, Msg, FileSize);
{$ELSE}
        OnProgress(Master, NewExtra, Msg, Lo64(FileSize));
{$ENDIF}
        //          Details.Clear;
        Details.SetItemXtra(ErrorCode, Msg, FileSize);
{$IFDEF DEBUG_PROGRESS}
        if Verbose then
          Report(zacMessage, 0, Format('#XItem - %s size = %d',
            [Details.ItemName, FileSize]), 0);
{$ENDIF}
        if Assigned(OnProgressDetails) then
          OnProgressDetails(Master, Details);
        if Assigned(OnItemProgress) then
          OnItemProgress(Master, Details.ItemName, FileSize, 0);
      end;

      zacXProgress: { progress type 16 = increment bar for extra operation}
      begin
        if Assigned(OnProgress) then
{$IFDEF ALLOW_2G}
          OnProgress(Master, ExtraUpdate, Details.ItemName, FileSize);
{$ELSE}
        OnProgress(Master, ExtraUpdate, Details.ItemName, Lo64(FileSize));
{$ENDIF}
        Details.AdvanceXtra(FileSize);
{$IFDEF DEBUG_PROGRESS}
        if Verbose then
          Report(zacMessage, 0, Format('#XProgress - [inc:%d] pos:%d siz:%d',
            [FileSize, Details.ItemPosition, Details.ItemSize]), 0);
{$ENDIF}
        if Assigned(OnProgressDetails) then
          OnProgressDetails(Master, Details);
        if Assigned(OnItemProgress) then
          OnItemProgress(Master, Details.ItemName, Details.ItemSize,
            Details.ItemPerCent);
      end;

      else                                    {unhandled event}
        Call_Back(ActionCode, ErrorCode, Msg, FileSize);
    end;                                    {end case }
  end;
  if assigned(OnCheckTerminate) then
  begin
    DoStop := Cancel;
    OnCheckTerminate(Master, DoStop);
    if DoStop then
      Cancel := True;
  end
  else
  if not fNotMainTask then
    Application.ProcessMessages;
end;
//? TZipBase.Report

(*? TZipBase.Report
1.76 4 July 2004 - handle written counts
*)
procedure TZipBase.Report(ActionCode: ActionCodes; ErrorCode: Integer;
  Msg: String; FileSize: Int64; written: Cardinal);
begin
  TProgDetails(FProgDetails).Wrote(written);
  Report(ActionCode, ErrorCode, Msg, FileSize);
end;
//? TZipBase.Report

(*? TZipBase.MakeTempFileName
  Make a temporary filename like: C:\...\zipxxxx.zip
  Prefix and extension are default: 'zip' and '.zip'
*)
function TZipBase.MakeTempFileName(Prefix, Extension: String): String;
var
  Buffer: Pchar;
  len:    DWORD;
begin
  Buffer := NIL;
  if Prefix = '' then
    Prefix := 'zip';
  if Extension = '' then
    Extension := '.zip';
  try
    if Length(FTempDir) = 0 then            // Get the system temp dir
    begin
      // 1. The path specified by the TMP environment variable.
      // 2. The path specified by the TEMP environment variable, if TMP is not defined.
      // 3. The current directory, if both TMP and TEMP are not defined.
      len := GetTempPath(0, Buffer);
      GetMem(Buffer, len + 12);
      GetTempPath(len, Buffer);
    end
    else                                    // Use Temp dir provided by ZipMaster
    begin
      FTempDir := DelimitPath(FTempDir, True); //AppendSlash(FTempDir);
      GetMem(Buffer, Length(FTempDir) + 13);
      StrPLCopy(Buffer, FTempDir, Length(FTempDir) + 1);
    end;
    if GetTempFileName(Buffer, PChar(Prefix), 0, Buffer) <> 0 then
    begin
      DeleteFile(Buffer); // Needed because GetTempFileName creates the file also.
      Result := ChangeFileExt(Buffer, Extension); // And finally change the extension.
    end;
  finally
    FreeMem(Buffer);
  end;
end;
//? TZipBase.MakeTempFileName

function TZipBase.ZipMessageDialog(const title: String; var msg: String;
  context: Integer; btns: TMsgDlgButtons): TModalResult;
var
  dlg: TZipDialogBox;
  t, s:   String;
  ctx: Integer;
begin
  t := title;
  if title = '' then
    t := Application.Title;
  if Verbose then
    t := Format('%s   (%d)',[title, context and $FFFF]);
  if assigned(OnZipDialog) then
  begin
    s   := msg;
    ctx := context;
    OnZipDialog(Master, t, s, ctx, btns);
    if (ctx > 0) and (ctx <= Ord(mrYesToAll)) then
    begin
      msg := s;
      Result := TModalResult(ctx);
      exit;
    end;
  end;
  dlg := TZipDialogBox.CreateNew2(Application, context);
  try
    dlg.Build(t, msg, btns);
    dlg.ShowModal();
    Result := dlg.ModalResult;   
//      if Result = mrAll then
//        Result := mrNoToAll;
    if dlg.DlgType = zmtPassword then
    begin
      if (Result = mrOk) then
        Msg := dlg.Pwrd
      else
        Msg := '';
    end;
  finally
    FreeAndNil(dlg);
  end;
end;

function TZipBase.ZipMessageDlg(const title, msg: String; context: Integer;
  btns: TMsgDlgButtons): TModalResult;
var
  m: String;
begin
  m      := msg;
  Result := ZipMessageDialog(title, m, context, btns);
end;

procedure TZipBase.ZipMessageDlg(const msg: String;
  context: Integer);
begin
  ZipMessageDlg('', msg, context, [mbOk]);
end;

end.

