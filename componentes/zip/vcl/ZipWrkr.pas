unit ZipWrkr;

(* TZipWorker VCL by Chris Vleghert and Eric W. Engler
   e-mail: problems@delphizip.net    englere@abraxis.com
   www:    http://www.geocities.com/SiliconValley/Network/2114
   www: http://www.delphizip.net
 v1.78.0.2 by Russell Peters November  3, 2004.

             *)

{$INCLUDE '..\vcl\ZipConfig.inc'}

interface

uses
  Forms, WinTypes, WinProcs, SysUtils, Classes, Messages, Dialogs, Controls,
  Graphics, Buttons, StdCtrls, FileCtrl,
{$IFNDEF NO_SFX}
  ZipSFX,
{$ENDIF}
  ZipStructs, ZipDLL, UnzDLL, ZCallBck, ZipMsg, ZipBase, ZipXcpt, ZipLdr;

const
  ZIPMASTERVERSION: String = '1.78';
  ZIPMASTERBUILD: String = '1.78.0.2';
  ZIPMASTERVER: Integer = 178;
  ZIPVERSION   = 178;
  UNZIPVERSION = 178;

{$IFDEF VERD4+}
type
  LargeInt = Int64;

type
  pLargeInt = ^Int64;
{$ENDIF}

//------------------------------------------------------------------------

type
  TZipStream = class(TMemoryStream)
  public
    constructor Create;
    destructor Destroy; override;
    procedure SetPointer(Ptr: Pointer; Size: Integer); virtual;
  end;

type
  TZipWorker = class(TZipBase)
  private
    FDelaying: TZipDelays;
    // fields of published properties
    FAddCompLevel: Integer;
    fAddOptions: AddOpts;
    FAddStoreSuffixes: AddStoreExts;
    fExtAddStoreSuffixes: String;
    { Private versions of property variables }
    FDirOnlyCount: Integer;
    fHandle: HWND;
    FIsSpanned: Boolean;
    fZipContents: TList;
    fExtrBaseDir: String;
    fZipBusy: Boolean;
    fUnzBusy: Boolean;
    FExtrOptions: ExtrOpts;
    FFSpecArgs: TStrings;
    FFSpecArgsExcl: TStrings;
    FZipFileName: String;
    FSuccessCnt: Integer;
    FPassword: String;
    FEncrypt: Boolean;
    FSFXOffset: Cardinal;
    FSpanOptions: SpanOpts;
    FVer: Integer;
    FVersionInfo: String;

    AutoExeViaAdd: Boolean;
    FVolumeName: String;
    FSizeOfDisk: LargeInt;                  { Int64 or Comp }
    FDiskFree: LargeInt;
    FFreeOnDisk: LargeInt;
    FDrive: String;
    FDriveFixed: Boolean;
    FHowToDelete: DeleteOpts;
    FStoredExtraData: String;               // new 1.73

    FDiskNr: Integer;
    FTotalDisks: Integer;
    FFileSize: Cardinal;
    FRealFileSize: Cardinal;
    FWrongZipStruct: Boolean;
    FInFileName: String;
    FInFileHandle: Integer;
    FOutFileHandle: Integer;
    FVersionMadeBy1: Integer;
    FVersionMadeBy0: Integer;
    FDateStamp: Integer; { DOS formatted date/time - use Delphi's
    FileDateToDateTime function to give you TDateTime format.}
    fFromDate: TDate;
    FShowProgress: TZipShowProgress;  //1.77Boolean;
    FFreeOnDisk1: Cardinal;
    FFreeOnAllDisks: Cardinal;              // new 1.72
    FMaxVolumeSize: Integer;
    FMinFreeVolSize: Integer;
    FCodePage: CodePageOpts;
    FZipEOC: Cardinal;                      // End-Of-Central-Dir location
    FZipSOC: Cardinal;                      // Start-Of-Central-Dir location
    FZipComment: String;
    FEOCComment: String;
    // 1.73.3.2 holds comment read by OpenEOC 
    FZipStream: TZipStream;
    FPasswordReqCount: Longword;
    FUseDirOnlyEntries: Boolean;
    FRootDir: String;
    // Dll related variables
    fZipDll: TZipDll;                       // new 1.73
    fUnzDll: TUnzDll;                       // new 1.73

    ZipParms: pZipParms;
    { declare an instance of ZipParms 1 or 2 }
    UnZipParms: pUnZipParms;
    { declare an instance of UnZipParms 2 }

{$IFNDEF NO_SPAN}
    fConfirmErase: Boolean;
    FDiskWritten: Integer;
    FDriveNr: Integer;
    FInteger: Integer;
    FNewDisk: Boolean;
    FOutFileName: String;
    FZipDiskAction: TZipDiskAction;
    FZipDiskStatus: TZipDiskStatus;
{$ENDIF}
{$IFNDEF NO_SFX}
    FSFX: TCustomZipSFX;                    // 1.72y
{$ENDIF}
    { Property get/set functions }
    procedure SetActive(Value: Boolean);    // new 1.76
    function GetCount: Integer;
    procedure SetFileName(Value: String);
    function GetZipVers: Integer;
    function GetUnzVers: Integer;
    function GetZipComment: String;
    procedure SetZipComment(zComment: String);
    procedure SetExtAddStoreSuffixes(Value: String);
    procedure SetVersionInfo(Value: String);
    procedure SetPasswordReqCount(Value: Longword);
  protected
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
    { Private "helper" functions }
    procedure SetCancel(Value: Boolean); override;
    function IsFixedDrive(drv: String): Boolean;      // new 1.72
    function GetDirEntry(idx: Integer): pZipDirEntry; // changed 1.73
    procedure FreeZipDirEntryRecords;
    procedure SetZipSwitches(var NameOfZipFile: String; zpVersion: Integer);
    procedure SetUnZipSwitches(var NameOfZipFile: String; uzpVersion: Integer);
    function ConvertOEM(const Source: String; Direction: CodePageDirection): String;
    function GetDriveProps: Boolean;
    function OpenEOC(var EOC: ZipEndOfCentral; DoExcept: Boolean): Boolean;
    function CopyBuffer(InFile, OutFile, ReadLen: Integer): Integer;
    procedure WriteJoin(const Buffer; BufferSize, DSErrIdent: Integer);
    procedure ReadJoin(var Buffer; BufferSize, DSErrIdent: Integer);
    // new 1.73
    procedure GetNewDisk(DiskSeq: Integer);
    procedure DllCallback(ZCallBackRec: PZCallBackStruct); // new 1.76

    procedure DiskFreeAndSize(Action: Integer);
    procedure AddSuffix(const SufOption: AddStoreSuffixEnum;
      var sStr: String; sPos: Integer);
    procedure ExtExtract(UseStream: Integer; MemStream: TMemoryStream);
    procedure ExtAdd(UseStream: Integer; StrFileDate, StrFileAttr: DWORD;
      MemStream: TMemoryStream);
    procedure SetDeleteSwitches;
    procedure CreateMVFileName(var FileName: String; StripPartNbr: Boolean);
{$IFNDEF NO_SPAN}
    procedure CheckForDisk(writing: bool);  // 1.70/2 changed
    procedure ClearFloppy(dir: String);     // New 1.70
    function IsRightDisk: Boolean; // 1.72 Changed
    function MakeString(Buffer: Pchar; Size: Integer): String;
    procedure RWJoinData(var Buffer; ReadLen, DSErrIdent: Integer);
    procedure RWSplitData(var Buffer; ReadLen, ZSErrVal: Integer);
    procedure WriteSplit(const Buffer; Len: Integer; MinSize: Integer);
    function ZipFormat: Integer;            // New 1.70
    function GetLastVolume(FileName: String; var EOC: ZipEndOfCentral;
      AllowNotExists: Boolean): Integer;    //173
{$ENDIF}
{$IFNDEF NO_SFX}
    function GetSFXSlave: TCustomZipSFX;    // new 1.73
{$ENDIF}
  public
    constructor Create;//(AMaster: TComponent);  
    destructor Destroy; override;
{$IFDEF VERD4+}
    procedure BeforeDestruction; override;
{$ENDIF}
    procedure Starting; override;
    procedure Done; override;
    { Public Properties (run-time only) }
    property Active: Boolean Read FActive Write SetActive;
    property Handle: HWND Read fHandle Write fHandle;
    //    property ErrCode;
    //: Integer read fErrCode write fErrCode;
    //    property Message;
    //: string read GetMessage; // write fMessage;

    property ZipContents: TList Read FZipContents;
    //    property Cancel;
    //: boolean Read fCancel Write fCancel;
    property ZipBusy: Boolean Read fZipBusy;
    property UnzBusy: Boolean Read fUnzBusy;

    property Count: Integer Read GetCount;
    property SuccessCnt: Integer Read FSuccessCnt;

    property ZipVers: Integer Read GetZipVers;
    property UnzVers: Integer Read GetUnzVers;
    property Ver: Integer Read fVer;

    property SFXOffset: Cardinal Read FSFXOffset;
    property ZipSOC: Cardinal Read FZipSOC;
    property ZipEOC: Cardinal Read FZipEOC;
    property IsSpanned: Boolean Read FIsSpanned;
    property ZipFileSize: Cardinal Read FRealFileSize;
    //    property FullErrCode: Integer Read FFullErrCode;
    property TotalSizeToProcess: Int64 {Cardinal} Read {F}GetTotalSizeToProcess;

    property ZipComment: String Read GetZipComment Write SetZipComment;
    property ZipStream: TZipStream Read FZipStream;
    property DirOnlyCount: Integer Read FDirOnlyCount;
    { Events }
    property OnDirUpdate: TNotifyEvent Read FOnDirUpdate Write FOnDirUpdate;
    property OnSetNewName: TSetNewNameEvent Read FOnSetNewName Write FOnSetNewName;
    property OnNewName: TNewNameEvent Read FOnNewName Write FOnNewName;
    property OnCRC32Error: TCRC32ErrorEvent Read FOnCRC32Error Write FOnCRC32Error;
    property OnPasswordError: TPasswordErrorEvent
      Read FOnPasswordError Write FOnPasswordError;
    property OnExtractOverwrite: TExtractOverwriteEvent
      Read FOnExtractOverwrite Write FOnExtractOverwrite;
    property OnExtractSkipped: TExtractSkippedEvent
      Read FOnExtractSkipped Write FOnExtractSkipped;
    property OnCopyZipOverwrite: TCopyZipOverwriteEvent
      Read FOnCopyZipOverwrite Write FOnCopyZipOverwrite;
    property OnFileComment: TFileCommentEvent Read FOnFileComment Write FOnFileComment;
    property OnFileExtra: TFileExtraEvent Read FOnFileExtra Write FOnFileExtra;
    property OnSetAddName: TSetAddNameEvent Read FOnSetAddName Write FOnSetAddName;
    property OnSetExtName: TSetExtNameEvent Read FOnSetExtName Write FOnSetExtName;
{$IFNDEF NO_SPAN}
    property OnGetNextDisk: TGetNextDiskEvent Read FOnGetNextDisk Write FOnGetNextDisk;
    property OnStatusDisk: TStatusDiskEvent Read FOnStatusDisk Write FOnStatusDisk;
{$ENDIF}
    { Public Methods }
    { NOTE: Test is an sub-option of extract }
    function Add: Integer;
    function Delete: Integer;
    function Extract: Integer;
    function List: Integer;
    // load dll - return version
    function Load_Zip_Dll: Integer;
    function Load_Unz_Dll: Integer;
    procedure Unload_Zip_Dll;
    procedure Unload_Unz_Dll;
    function ZipDllPath: String;
    function UnzDllPath: String;
    procedure AbortDlls;
    function Copy_File(const InFileName, OutFileName: String): Integer;
    //    function EraseFile(const Fname: String; How: DeleteOpts): Integer;
    function GetAddPassword(var Response: TPasswordButton): String;
    function GetExtrPassword(var Response: TPasswordButton): String;
    function AppendSlash(sDir: String): String;
    { New in v1.6 }
    function Rename(RenameList: TList; DateTime: Integer): Integer;
    function ExtractFileToStream(Filename: String): TZipStream;
    function AddStreamToStream(InStream: TMemoryStream): TZipStream;
    function AddStreamToFile(Filename: String; FileDate, FileAttr: Dword): Integer;
    function ExtractStreamToStream(InStream: TMemoryStream;
      OutSize: Longword): TZipStream;
    function GetPassword(DialogCaption, MsgTxt: String; pwb: TPasswordButtons;
      var ResultStr: String): TPasswordButton; overload;
    function GetPassword(DialogCaption, MsgTxt: String; ctx: Integer;
      pwb: TPasswordButtons; var ResultStr: String): TPasswordButton; overload;
    function CopyZippedFiles(DestZipMaster: TZipWorker;
      DeleteFromSource: Boolean; OverwriteDest: OvrOpts): Integer;

    property DirEntry[idx: Integer]: pZipDirEntry Read GetDirEntry; default;
    function FullVersionString: String;
    procedure Clear; override;
    function Find(const fspec: String; var idx: Integer): pZipDirEntry;
    // new 1.73.4
    function IndexOf(const fname: String): Integer;
{$IFNDEF NO_SPAN}
    function ReadSpan(InFileName: String; var OutFilePath: String;
      useXProgress: Boolean): Integer;
    function WriteSpan(InFileName, OutFileName: String;
      useXProgress: Boolean): Integer;
{$ENDIF}
{$IFNDEF NO_SFX}
    function NewSFXFile(const ExeName: String): Integer;
    function ConvertSFX: Integer;
    function ConvertZIP: Integer;
    function IsZipSFX(const SFXExeName: String): Integer;
{$ENDIF}
    //  published
    { Public properties that also show on Object Inspector }
    property AddCompLevel: Integer Read FAddCompLevel Write FAddCompLevel;
    property AddOptions: AddOpts Read FAddOptions Write fAddOptions;
    property AddFrom: TDate Read fFromDate Write fFromDate;
    property ExtrBaseDir: String Read FExtrBaseDir Write FExtrBaseDir;
    property ExtrOptions: ExtrOpts Read FExtrOptions Write FExtrOptions;
    property FSpecArgs: TStrings Read fFSpecArgs Write fFSpecArgs;
    property FSpecArgsExcl: TStrings Read fFSpecArgsExcl Write fFSpecArgsExcl;
    { At runtime: every time the filename is assigned a value,
the ZipDir will automatically be read. }
    property ZipFileName: String Read FZipFileName Write SetFileName;
    property Password: String Read FPassword Write FPassword;
    property AddStoreSuffixes: AddStoreExts Read FAddStoreSuffixes
      Write FAddStoreSuffixes;
    property ExtAddStoreSuffixes: String Read fExtAddStoreSuffixes
      Write SetExtAddStoreSuffixes;
    property CodePage: CodePageOpts Read FCodePage Write FCodePage default cpAuto;
    property HowToDelete: DeleteOpts
      Read FHowToDelete Write FHowToDelete default htdAllowUndo;
    property VersionInfo: String Read FVersionInfo Write SetVersionInfo;
    property PasswordReqCount: Longword Read FPasswordReqCount
      Write SetPasswordReqCount;
    property UseDirOnlyEntries: Boolean Read FUseDirOnlyEntries
      Write FUseDirOnlyEntries default False;
    property RootDir: String Read FRootDir Write fRootDir;
{$IFNDEF NO_SPAN}
    property SpanOptions: SpanOpts Read FSpanOptions Write FSpanOptions;
    property ConfirmErase: Boolean Read fConfirmErase Write fConfirmErase default True;
    property KeepFreeOnDisk1: Cardinal Read FFreeOnDisk1 Write FFreeOnDisk1;
    property KeepFreeOnAllDisks: Cardinal Read FFreeOnAllDisks Write FFreeOnAllDisks;
    property MaxVolumeSize: Integer Read FMaxVolumeSize Write FMaxVolumesize;
    property MinFreeVolumeSize: Integer Read FMinFreeVolSize
      Write FMinFreeVolSize default 65536;
{$ENDIF}
{$IFNDEF NO_SFX}
    property SFXSlave: TCustomZipSFX Read fSFX Write fSFX;
{$ENDIF}
  end;


implementation

uses
{$IFNDEF NO_SFX}
  SFXInterface,
{$ENDIF}
  ZipStrs, ZipUtils, ZipDlg, ZipCtx;

{$R ZipMstr.Res}

const
  BufSize     = 10240;
  //8192;   // Keep under 12K to avoid Winsock problems on Win95.
  // If chunks are too large, the Winsock stack can
  // lose bytes being sent or received.
  FlopBufSize = 65536;
  RESOURCE_ERROR: String =
    'ZipMsgXX.res is probably not linked to the executable' + #10 +
    'Missing String ID is: ';

 { Define the functions that are not part of the TZipWorker class. }
 { The callback function must NOT be a member of a class. }
 { We use the same callback function for ZIP and UNZIP. }

function ZCallback(ZCallBackRec: pZCallBackStruct): LongInt {Longbool};
  stdcall; forward;


{$IFNDEF NO_SFX}
type
  TFriendSFX = class(TCustomZipSFX)
  end;

{$ENDIF}

type
  // 1.75 18 Feb 2004 RP changed for >2G
  MDZipData = record                        // MyDirZipData
    Diskstart: Word; // The disk number where this file begins
    RelOffLocal: Int64;     // offset from the start of the first disk
    FileNameLen: Word;                      // length of current filename
    FileName: array[0..254] of Char;        // Array of current filename
    CRC32: Longword;
    ComprSize: Longword;
    UnComprSize: Longword;
    DateTime: Integer;
  end;
  pMZipData = ^MDZipData;

  TMZipDataList = class(TList)
  private
    function GetItems(Index: Integer): pMZipData;
  public
    constructor Create(TotalEntries: Integer);
    destructor Destroy; override;
    property Items[Index: Integer]: pMZipData Read GetItems;
    function IndexOf(fname: String): Integer;
  end;

// -------------------------- ------------ -------------------------

 { Implementation of TZipWorker class member functions }
 // ================== changed or New functions =============================
(*? TZipWorker.WriteSpan
1.77 1 Oct 2004 test/use YesToAll
1.77 1 Sep 2004 RP Allow Cancel
1.76 6 June 2004 RA initial InFileHandle empty
1.73.2.4 31 August 2003 don't delete last part on floppy
1.73 11 July 2003 RP buffer Central Directory writes
1.73 9 July 2003 RA changed OnMessage and OnProgress to Report calls
1.73 27 June 2003 RP changed Split file handling
// Function to read a Zip source file and write it back to one or more disks.
// Return values:
//  0           All Ok.
// -7           WriteSpan errors. See ZipMsgXX.rc
// -8           Memory allocation error.
// -9           General unknown WriteSpan error.
*)
{$IFNDEF NO_SPAN}
function TZipWorker.WriteSpan(InFileName, OutFileName: String;
  useXProgress: Boolean): Integer;
type
  pZipCentralHeader = ^ZipCentralHeader;
  pZipLocalHeader   = ^ZipLocalHeader;
var
  EOC:    ZipEndOfCentral;
  Res, i, k: Integer;
  LastName, MsgStr: String;
  TotalBytesWrite: Integer;
  StartCentral: Integer;
  CentralOffset: Integer;
  Buffer: array of Char;//[0..BufSize - 1] of Char;
  MDZD:   TMZipDataList;
  MDZDp:  pMZipData;
  EBuf:   String;
  ELen, VLen: Integer;
  Ebufp:  Pchar;
  CEHp:   pZipCentralHeader;
  LOHp:   pZipLocalHeader;
  Fname:  String;
  BatchStarted: Boolean;
begin
  BatchStarted := False;
  SetLength(Buffer, BufSize);
  Result := 0;
  FErrCode := 0;
  FMessage := '';
  fZipBusy := True;
  FDiskNr := 0;
  FFreeOnDisk := 0;
  FNewDisk := True;
  FDiskWritten := 0;
  FTotalDisks := -1;                        // 1.72 don't know number
  FInFileName := InFileName;
  FOutFileName := OutFileName;
  FOutFileHandle := -1;
  FInFileHandle := -1;
  FShowProgress := zspNone;//False;
  CentralOffset := 0;
  MDZD := NIL;

  FDrive      := ExtractFileDrive(OutFileName) + '\';
  FDriveFixed := IsFixedDrive(FDrive);      // 1.72

  StartWaitCursor;
  try
    if not FileExists(InFileName) then
      raise EZipMaster.CreateResDisp(DS_NoInFile, True);
    if ExtractFileName(OutFileName) = '' then
      raise EZipMaster.CreateResDisp(DS_NoOutFile, True);

    // The following function will read the EOC and some other stuff:
    OpenEOC(EOC, True);

    // Get the date-time stamp and save for later.
    FDateStamp := FileGetDate(FInFileHandle);

    // go back to the start the zip archive.
    if (FileSeek64(FInFileHandle, Int64(0), 0) = -1) then
      raise EZipMaster.CreateResDisp(DS_FailedSeek, True);

    MDZD := TMZipDataList.Create(EOC.TotalEntries);

    // Write extended local Sig. needed for a spanned archive.
    FInteger := ExtLocalSig;
    WriteSplit(FInteger, 4, 0);

    // Read for every zipped entry: The local header, variable data, fixed data
    // and, if present, the Data decriptor area.
    //    FShowProgress := True;
    if UseXProgress then
    begin
      Report(zacXItem, zprSplitting, '', FFileSize);//EOC.TotalEntries)
      FShowProgress := zspExtra;
    end
    else begin
      Report(zacCount, zprCompressed, '', EOC.TotalEntries);
      Report(zacSize, zprCompressed, '', FFileSize);
      FShowProgress := zspFull;
      BatchStarted  := True;
    end;

    // 1.73 buffer writes of local header
    SetLength(EBuf, sizeof(ZipLocalHeader) + 70);
    for i := 0 to (EOC.TotalEntries - 1) do
    begin
      if FCancel then   // 1.77 Allow cancel
        raise EZipMaster.CreateResDisp(DS_Canceled, False);
      LOHp := pZipLocalHeader(PChar(EBuf));
      // First the local header.
      ReadJoin(LOHp^, SizeOf(ZipLocalHeader), DS_LOHBadRead);
      if not (LOHp^.HeaderSig = LocalFileHeaderSig) then
        raise EZipMaster.CreateResDisp(DS_LOHWrongSig, True);
      VLen := LOHp^.FileNameLen + LOHp^.ExtraLen;
      ELen := sizeof(ZipLocalHeader) + VLen;
      if ELen > Length(EBuf) then
      begin
        SetLength(EBuf, ELen);
        LOHp := pZipLocalHeader(PChar(EBuf)); // moved
      end;
      EBufp := PChar(EBuf) + sizeof(ZipLocalHeader);
      // Now the variable data
      ReadJoin(EBufp^, VLen, DS_LOHBadRead);
      // Save some information for later. ( on the last disk(s) ).
      MDZDp := MDZD.Items[i];
      MDZDp^.DiskStart := FDiskNr;
      MDZDp^.FileNameLen := LOHp^.FileNameLen;

      StrLCopy(MDZDp^.FileName, EBufp, LOHp^.FileNameLen); // like makestring
      Fname  := SetSlash(MakeString(EBufp, LOHp^.FileNameLen), psdExternal);
      // Give message and progress info on the start of this new file read.
      MsgStr := ZipLoadStr(GE_CopyFile) + Fname;
      Report(zacMessage, 0, MsgStr, 0);

      TotalBytesWrite := ELen + Integer(LOHp^.ComprSize);
      if (LOHp^.Flag and Word($0008)) = 8 then
        Inc(TotalBytesWrite, SizeOf(ZipDataDescriptor));

      if not UseXProgress then
        //        Report(zacXItem, zprJoining, '', TotalBytesWrite)
        //      else
        Report(zacItem, zprCompressed, Fname, TotalBytesWrite);

      // Write the local header to the destination.
      WriteSplit(PChar(EBuf)^, ELen, ELen);

      // Save the offset of the LOH on this disk for later.
      MDZDp^.RelOffLocal := FDiskWritten - ELen;

      // Read Zipped data !!!For now assume we know the size!!!
      RWSplitData(Buffer[0], TotalBytesWrite - ELen, DS_ZipData);
    end;
    // We have written all entries to disk.
    Report(zacMessage, 0, ZipLoadStr(GE_CopyFile) +
      ZipLoadStr(DS_CopyCentral), 0);
    if not UseXProgress then
      Report(zacItem, zprCentral, ZipLoadStr(DS_CopyCentral),
        EOC.CentralSize + sizeof(EOC) + EOC.ZipCommentLen);

    // Now write the central directory with changed offsets.
    SetLength(EBuf, sizeof(ZipCentralHeader) + 30);
    StartCentral := FDiskNr;
    for i := 0 to (EOC.TotalEntries - 1) do
    begin
      if FCancel then   // 1.77 Allow cancel
        raise EZipMaster.CreateResDisp(DS_Canceled, False);
      // Read a central header.
      CEHp := pZipCentralHeader(PChar(EBuf));
      ReadJoin(CEHp^, SizeOf(ZipCentralHeader), DS_CEHBadRead);
      if CEHp^.HeaderSig <> CentralFileHeaderSig then
        raise EZipMaster.CreateResDisp(DS_CEHWrongSig, True);
      // 1.73 RP copy full central record to buffer then write it
      VLen := CEHp^.FileNameLen + CEHp^.ExtraLen + CEHp^.FileComLen;
      ELen := SizeOf(ZipCentralHeader) + VLen;
      if ELen > Length(EBuf) then
      begin
        SetLength(EBuf, ELen);
        CEHp := pZipCentralHeader(PChar(EBuf)); // may have moved
      end;
      EBufp := PChar(CEHp) + sizeof(ZipCentralHeader);
      // Now the variable length fields.
      ReadJoin(EBufp^, VLen, DS_CEHBadRead);

      // Change the central directory with information stored previously in MDZD.
      k     := MDZD.IndexOf(MakeString(EBufp, CEHp^.FileNameLen));
      MDZDp := MDZD[k];
      CEHp^.DiskStart := MDZDp^.DiskStart;
      CEHp^.RelOffLocal := MDZDp^.RelOffLocal;

      // Write this changed central header to disk
      // and make sure it fit's on one and the same disk.
      WriteSplit(PChar(EBuf)^, ELen, ELen);

      // Save the first Central directory offset for use in EOC record.
      if i = 0 then
        CentralOffset := FDiskWritten - ELen;
    end;

    // Write the changed EndOfCentral directory record.
    EOC.CentralDiskNo := StartCentral;
    EOC.ThisDiskNo    := FDiskNr;
    EOC.CentralOffset := CentralOffset;
    WriteSplit(EOC, SizeOf(EOC), SizeOf(EOC) + EOC.ZipCommentLen);

    // Skip past the original EOC to get to the ZipComment if present. v1.52j
    if (FileSeek64(FInFileHandle, Int64(SizeOf(EOC)), 1) = -1) then
      raise EZipMaster.CreateResDisp(DS_FailedSeek, True);

    // And finally the archive comment
    RWSplitData(Buffer[0], EOC.ZipCommentLen, DS_EOArchComLen);
    FShowProgress := zspNone;//False;
  except
    on ews: EZipMaster do                   // All WriteSpan specific errors.
    begin
      ShowExceptionError(ews);
      Result := -7;
    end;
    on EOutOfMemory do                      // All memory allocation errors.
    begin
      ShowZipMessage(GE_NoMem, '');
      Result := -8;
    end;
    on E: Exception do
    begin
      // The remaining errors, should not occur.
      ShowZipMessage(DS_ErrorUnknown, E.Message);
      Result := -9;
    end;
  end;

  StopWaitCursor;
  Buffer := NIL;
  // Give the last progress info on the end of this file read.
  if BatchStarted then
    Report(zacEndOfBatch, 0, '', 0);

  if Assigned(MDZD) then
    FreeAndNil(MDZD);//MDZD.Free;

  FileSetDate(FOutFileHandle, FDateStamp);
  if FOutFileHandle <> -1 then
    FileClose(FOutFileHandle);
  if FInFileHandle <> -1 then
    FileClose(FInFileHandle);
  if (Result = 0) then
  begin
    // change extn of last file
    LastName := FOutFileName;
    CreateMVFileName(LastName, False);
    if FDriveFixed and (spCompatName in FSpanOptions) then
    begin
      if (FileExists(FOutFileName)) then
      begin
        MsgStr := ZipFmtLoadStr(DS_AskDeleteFile, [FOutFileName]);
        FZipDiskStatus := FZipDiskStatus + [zdsSameFileName];
        Res    := idYes;
        if not (zaaYesOvrWrt in FAnswerAll) then
          if assigned(OnStatusDisk) then //1.77
          begin
            FZipDiskAction := zdaOk;          // The default action
            OnStatusDisk(Master, FDiskNr, FOutFileName,
              FZipDiskStatus, FZipDiskAction);
            if FZipDiskAction = zdaYesToAll then
            begin
              FAnswerAll     := FAnswerAll + [zaaYesOvrWrt];
              FZipDiskAction := zdaOk;
            end;
            if FZipDiskAction = zdaOk then
              Res := idYes
            else
              Res := idNo;
          end
          else
            Res := ZipMessageDlg(MsgStr, ZipLoadStr(FM_Confirm),
              zmtWarning + DHC_WrtSpnDel, [mbYes, mbNo]);
        if (Res = 0) then
          ShowZipMessage(DS_NoMem, '');
        if (Res = idNo) then
          Report(zacMessage, DS_NoRenamePart,
            ZipFmtLoadStr(DS_NoRenamePart, [LastName]), 0);
        if (Res = idYes) then
          DeleteFile(FOutFileName);         // if it exists delete old one
      end;
      if FileExists(LastName) then          // should be there but ...
        RenameFile(LastName, FOutFileName);
    end;
  end;
  FTotalDisks := FDiskNr;
  fZipBusy    := False;
end;

{$ENDIF}
//? TZipWorker.WriteSpan

(*? TZipWorker.ReadSpan
1.77  1 Sep 2004 RP Allow Cancel
1.77 8 Aug 2004 RA handle normal/ eXtended progress
1.75 18 February 2004 RP Allow >2G
1.73 12 July 2003 RA made Report type zacItem for each file + handling Result from GetLastVolume
1.73 11 July 2003 RP changed split file handling
// Function to read a split up Zip source file from multiple disks and write it to one destination file.
// Return values:
// 0            All Ok.
// -7           ReadSpan errors. See ZipMsgXX.rc
// -8           Memory allocation error.
// -9           General unknown ReadSpan error.
 *)
{$IFNDEF NO_SPAN}
function TZipWorker.ReadSpan(InFileName: String; var OutFilePath: String;
  useXProgress: Boolean): Integer;
var
  Buffer: array of Char;//[0..BufSize - 1] of Char;
  //  TotalBytesToRead: Int64;
  FullSize: Int64;
  EOC:    ZipEndOfCentral;
  LOH:    ZipLocalHeader;
  DD:     ZipDataDescriptor;
  CEH:    ZipCentralHeader;
  {DiskNo,}i, k: Integer;
  ExtendedSig: Integer;
  MsgStr: String;
  BytesToWrite: Int64;
  MDZD:   TMZipDataList;
  MDZDp:  pMZipData;
  BatchStarted: Boolean;
begin
  //  TotalBytesToRead := 0;
  BatchStarted := False;

  fErrCode := 0;
  fUnzBusy := True;
  FDrive := ExtractFileDrive(InFileName) + '\';
  FDriveFixed := IsFixedDrive(FDrive);      // 1.72
  FDiskNr := -1;
  FNewDisk := False;
  FShowProgress := zspNone; //False;
  FInFileName := InFileName;
  FInFileHandle := -1;
  FOutFileHandle := -1;
  MDZD := NIL;

  StartWaitCursor;
  try
    SetLength(Buffer, BufSize);
    // If we don't have a filename we make one first.
    if ExtractFileName(OutFilePath) = '' then
    begin
      OutFilePath := MakeTempFileName('', '');
      if OutFilePath = '' then
        raise EZipMaster.CreateResDisp(DS_NoTempFile, True);
    end
    else begin
      EraseFile(OutFilePath, FHowToDelete = htdFinal);
      OutFilePath := ChangeFileExt(OutFilePath, '.zip');
    end;

    // Try to get the last disk from the user if part of Volume numbered set
    Result := GetLastVolume(FInFileName, EOC, False);
    if Result < 0 then
    begin
      StopWaitCursor;
      FUnzBusy := False;
      Result   := -9;
      exit;
    end;
    if Result > 0 then
      raise EZipMaster.CreateResDisp(DS_Canceled, True);

    // Create the output file.
    FOutFileHandle := FileCreate(OutFilePath);
    if FOutFileHandle = -1 then
      raise EZipMaster.CreateResDisp(DS_NoOutFile, True);

    // Get the date-time stamp and save for later.
    FDateStamp := FileGetDate(FInFileHandle);

    // Now we now the number of zipped entries in the zip archive
    // and the starting disk number of the central directory.
    FTotalDisks := EOC.ThisDiskNo;
    if EOC.ThisDiskNo <> EOC.CentralDiskNo then
      GetNewDisk(EOC.CentralDiskNo);        // request a previous disk first
    // We go to the start of the Central directory. v1.52i
    if FileSeek64(FInFileHandle, Int64(EOC.CentralOffset), 0) = -1 then
      raise EZipMaster.CreateResDisp(DS_FailedSeek, True);

    MDZD := TMZipDataList.Create(EOC.TotalEntries);

    FullSize := EOC.CentralSize + EOC.ZipCommentLen + sizeof(ZipEndOfCentral);
    // Read for every entry: The central header and save information for later use.
    for i := 0 to (EOC.TotalEntries - 1) do
    begin
      if FCancel then   // 1.77 Allow cancel
        raise EZipMaster.CreateResDisp(DS_Canceled, False);
      // Read a central header.
      while FileRead(FInFileHandle, CEH, SizeOf(CEH)) <> SizeOf(CEH) do
        //v1.52i
      begin
        // It's possible that we have the central header split up
        if FDiskNr >= EOC.ThisDiskNo then
          raise EZipMaster.CreateResDisp(DS_CEHBadRead, True);
        // We need the next disk with central header info.
        GetNewDisk(FDiskNr + 1);
      end;

      if CEH.HeaderSig <> CentralFileHeaderSig then
        raise EZipMaster.CreateResDisp(DS_CEHWrongSig, True);

      // Now the filename.
      ReadJoin(Buffer[0], CEH.FileNameLen, DS_CENameLen);

      // Save the file name info in the MDZD structure.
      MDZDp := MDZD[i];
      MDZDp^.FileNameLen := CEH.FileNameLen;
      StrLCopy(MDZDp^.FileName, @Buffer[0], CEH.FileNameLen);

      // Save the compressed size, we need this because WinZip sometimes sets this to
      // zero in the local header. New v1.52d
      MDZDp^.ComprSize := CEH.ComprSize;

      // We need the total number of bytes we are going to read for the progress event.
      //      TotalBytesToRead := TotalBytesToRead + Integer(CEH.ComprSize +
      //        CEH.FileNameLen + CEH.ExtraLen + CEH.FileComLen);
      Inc(FullSize, sizeof(ZipLocalHeader) + CEH.FileNameLen +
        CEH.ExtraLen + CEH.ComprSize);
      // plus DataDescriptor if present.
      if (CEH.Flag and Word(8)) = 8 then
        Inc(FullSize, SizeOf(ZipDataDescriptor));

      // Seek past the extra field and the file comment.
      if FileSeek64(FInFileHandle, Int64(CEH.ExtraLen + CEH.FileComLen),
        1) = -1 then
        raise EZipMaster.CreateResDisp(DS_FailedSeek, True);
    end;

    // Now we need the first disk and start reading.
    GetNewDisk(0);

    if UseXProgress then
    begin
      Report(zacXItem, zprJoining, ZipLoadStr(PR_Joining), FullSize);
      FShowProgress := zspExtra;
    end
    else begin
      Report(zacCount, zprCompressed, '', EOC.TotalEntries + 1);
      Report(zacSize, zprCompressed, '', FullSize);
      FShowProgress := zspFull;
      BatchStarted  := True;
    end;
    // Read extended local Sig. first; is only present if it's a spanned archive.
    ReadJoin(ExtendedSig, 4, DS_ExtWrongSig);
    if ExtendedSig <> ExtLocalSig then
      raise EZipMaster.CreateResDisp(DS_ExtWrongSig, True);

    // Read for every zipped entry: The local header, variable data, fixed data
    // and if present the Data decriptor area.
    for i := 0 to (EOC.TotalEntries - 1) do
    begin
      if FCancel then   // 1.77 Allow cancel
        raise EZipMaster.CreateResDisp(DS_Canceled, False);
      // First the local header.
      while FileRead(FInFileHandle, LOH, SizeOf(LOH)) <> SizeOf(LOH) do
      begin
        // Check if we are at the end of a input disk not very likely but...
        if FileSeek64(FInFileHandle, Int64(0), 1) <>
          FileSeek64(FInFileHandle, Int64(0), 2) then
          raise EZipMaster.CreateResDisp(DS_LOHBadRead, True);
        // Well it seems we are at the end, so get a next disk.
        GetNewDisk(FDiskNr + 1);
      end;
      if LOH.HeaderSig <> LocalFileHeaderSig then
        raise EZipMaster.CreateResDisp(DS_LOHWrongSig, True);

      // Now the filename, should be on the same disk as the LOH record.
      ReadJoin(Buffer[0], LOH.FileNameLen, DS_LONameLen);

      // Change some info for later while writing the central dir.
      k     := MDZD.IndexOf(MakeString( @Buffer[0], LOH.FileNameLen));
      MDZDp := MDZD[k];
      MDZDp^.DiskStart := 0;
      MDZDp^.RelOffLocal := FileSeek64(FOutFileHandle, Int64(0), 1);

      // Give message and progress info on the start of this new file read.
      MsgStr := ZipLoadStr(GE_CopyFile) +
        SetSlash(MDZDp^.FileName, psdExternal);
      Report(zacMessage, 0, MsgStr, 0);

      BytesToWrite := SizeOf(LOH) + LOH.FileNameLen + LOH.ExtraLen +
        LOH.ComprSize;
      if (LOH.Flag and Word($0008)) = 8 then
        Inc(BytesToWrite, SizeOf(DD));
      if not UseXProgress then
        Report(zacItem, 0, MDZDp^.FileName, BytesToWrite);

      // Write the local header to the destination.
      WriteJoin(LOH, SizeOf(LOH), DS_LOHBadWrite);

      // Write the filename.
      WriteJoin(Buffer[0], LOH.FileNameLen, DS_LOHBadWrite);

      // And the extra field
      RWJoinData(Buffer[0], LOH.ExtraLen, DS_LOExtraLen);

      // Read Zipped data, if the size is not known use the size from the central header.
      if LOH.ComprSize = 0 then
        LOH.ComprSize := MDZDp^.ComprSize;  // New v1.52d
      RWJoinData(Buffer[0], LOH.ComprSize, DS_ZipData);

      // Read DataDescriptor if present.
      if (LOH.Flag and Word($0008)) = 8 then
        RWJoinData(DD, SizeOf(DD), DS_DataDesc);
    end; // Now we have written all entries to the (hard)disk.
         //    if not UseXProgress then
         //      Report(zacEndOfBatch, zprCompressed, '', 0);      // end of batch

    // Now write the central directory with changed offsets.
    if not UseXProgress then
      Report(zacItem, zprCentral, ZipLoadStr(PR_CentrlDir), EOC.CentralSize);
    for i := 0 to (EOC.TotalEntries - 1) do
    begin
      if FCancel then   // 1.77 Allow cancel
        raise EZipMaster.CreateResDisp(DS_Canceled, False);
      // Read a central header which can be span more than one disk.
      while FileRead(FInFileHandle, CEH, SizeOf(CEH)) <> SizeOf(CEH) do
      begin
        // Check if we are at the end of a input disk.
        if FileSeek64(FInFileHandle, Int64(0), 1) <>
          FileSeek64(FInFileHandle, Int64(0), 2) then
          raise EZipMaster.CreateResDisp(DS_CEHBadRead, True);
        // Well it seems we are at the end, so get a next disk.
        GetNewDisk(FDiskNr + 1);
      end;
      if CEH.HeaderSig <> CentralFileHeaderSig then
        raise EZipMaster.CreateResDisp(DS_CEHWrongSig, True);

      // Now the filename.
      ReadJoin(Buffer[0], CEH.FileNameLen, DS_CENameLen);

      // Save the first Central directory offset for use in EOC record.
      if i = 0 then
        EOC.CentralOffset := FileSeek64(FOutFileHandle, Int64(0), 1);

      // Change the central header info with our saved information.
      k     := MDZD.IndexOf(MakeString( @Buffer[0], CEH.FileNameLen));
      MDZDp := MDZD[k];
      CEH.RelOffLocal := MDZDp^.RelOffLocal;
      CEH.DiskStart := 0;

      // Write this changed central header to disk
      // and make sure it fit's on one and the same disk.
      WriteJoin(CEH, SizeOf(CEH), DS_CEHBadWrite);

      // Write to destination the central filename and the extra field.
      WriteJoin(Buffer[0], CEH.FileNameLen, DS_CEHBadWrite);

      // And the extra field
      RWJoinData(Buffer[0], CEH.ExtraLen, DS_CEExtraLen);

      // And the file comment.
      RWJoinData(Buffer[0], CEH.FileComLen, DS_CECommentLen);
    end;

    // Write the changed EndOfCentral directory record.
    EOC.CentralDiskNo := 0;
    EOC.ThisDiskNo    := 0;
    WriteJoin(EOC, SizeOf(EOC), DS_EOCBadWrite);

    // Skip past the original EOC to get to the ZipComment if present. v1.52M
    if (FileSeek64(FInFileHandle, Int64(SizeOf(EOC)), 1) = -1) then
      raise EZipMaster.CreateResDisp(DS_FailedSeek, True);

    // And finally the archive comment
    RWJoinData(Buffer[0], EOC.ZipCommentLen, DS_EOArchComLen);
  except
    on ers: EZipMaster do                   // All ReadSpan specific errors.
    begin
      ShowExceptionError(ers);
      Result := -7;
    end;
    on EOutOfMemory do                      // All memory allocation errors.
    begin
      ShowZipMessage(GE_NoMem, '');
      Result := -8;
    end;
    on E: Exception do
    begin
      // The remaining errors, should not occur.
      ShowZipMessage(DS_ErrorUnknown, E.Message);
      Result := -9;
    end;
  end;

  Buffer := NIL;
  // Give final progress info at the end.
  if BatchStarted then
    Report(zacEndOfBatch, 0, '', 0);

  if Assigned(MDZD) then
    FreeAndNil(MDZD);//MDZD.Free;

  if FInFileHandle <> -1 then
    FileClose(FInFileHandle);
  if FOutFileHandle > 0 then                //<> -1 Then
  begin
    FileSetDate(FOutFileHandle, FDateStamp);
    FileClose(FOutFileHandle);
    if Result <> 0 then
      // An error somewhere, OutFile is not reliable.
    begin
      DeleteFile(OutFilePath);
      OutFilePath := '';
    end;
  end;

  fUnzBusy := False;
  StopWaitCursor;
end;

{$ENDIF}
//? TZipWorker.ReadSpan

(*? TZipWorker.CheckForDisk
1.77 31 August 2004 RP - allow cancel on hard drive
1.77 18 Aug 2004 RA - allow unattended on hard drive
 // 1.70 changed - no longer check fZipBusy uses writing instead
 // 1.72 changed - now a procedure
 // ask for disk with required part (FDriveNr)
*)
{$IFNDEF NO_SPAN}
procedure TZipWorker.CheckForDisk(writing: bool);
var
  Res, MsgFlag: Integer;
  SizeOfDisk:  LargeInt;     // RCV150199
  MsgStr:      String;
  AbortAction: Boolean;
begin
  FDriveFixed := IsFixedDrive(FDrive);
  if FDriveFixed then
  begin
    // If it is a fixed disk we don't want a new one.
    FNewDisk := False;
    if FCancel then
      raise EZipMaster.CreateResDisp(DS_Canceled, False);
    exit;
  end;
  Report(zacTick, 0, '', 0);              // just ProcessMessages

  Res     := idOk;
  MsgFlag := zmtWarning + DHC_SpanNxtW;   // or error?
  //  MsgBtns := MB_OkCancel;

  // First check if we want a new one or if there is a disk (still) present.
  while (FNewDisk or ((Res = idOk) and not GetDriveProps)) do
  begin
    if Unattended then
      raise EZipMaster.CreateResDisp(DS_NoUnattSpan, True);
    if FDiskNr < 0 then                     // -1=ReadSpan(), 0=WriteSpan()
    begin
      MsgStr  := ZipLoadStr(DS_InsertDisk);
      MsgFlag := zmtError + DHC_SpanNxtR;//MsgFlag or MB_ICONERROR;
    end
    else if writing then
      // Are we from ReadSpan() or WriteSpan()?
    begin
      // This is an estimate, we can't know if every future disk has the same space available and
      // if there is no disk present we can't determine the size unless it's set by MaxVolumeSize.
      SizeOfDisk := FSizeOfDisk - FFreeOnAllDisks;
      if (FMaxVolumeSize <> 0) and (FMaxVolumeSize < FSizeOfDisk) then
        SizeOfDisk := FMaxVolumeSize;

      FTotalDisks := FDiskNr;
      if (SizeOfDisk > 0) and (FTotalDisks < Trunc((FFileSize + 4 +
        FFreeOnDisk1) / SizeOfDisk)) then // RCV150199
        FTotalDisks := Trunc((FFileSize + 4 + FFreeOnDisk1) / SizeOfDisk);
      if SizeOfDisk > 0 then
        MsgStr := ZipFmtLoadStr(DS_InsertVolume,
          [FDiskNr + 1, FTotalDisks + 1])
      else
        MsgStr := ZipFmtLoadStr(DS_InsertAVolume, [FDiskNr + 1]);
    end
    else
      MsgStr := ZipFmtLoadStr(DS_InsertVolume, [FDiskNr + 1, FTotalDisks + 1]);
    MsgStr := MsgStr + ZipFmtLoadStr(DS_InDrive, [FDrive]);

    if not ((FDiskNr = 0) and GetDriveProps and writing) then
      if Assigned(OnGetNextDisk) then      // v1.60L
      begin
        AbortAction := False;
        OnGetNextDisk(Master, FDiskNr + 1,
          FTotalDisks + 1, Copy(FDrive, 1, 1), AbortAction);
        if AbortAction then
          Res := idAbort
        else
          Res := idOk;
      end
      else
        //        Res := MessageBox(FHandle, PChar(MsgStr),
        //          PChar(Application.Title), MsgFlag);
        Res := ZipMessageDlg('', MsgStr, MsgFlag, mbOkCancel);
    FNewDisk := False;
  end;

  // Check if user pressed Cancel or memory is running out.
  if Res <> idOk then
    raise EZipMaster.CreateResDisp(DS_Canceled, False);
  if Res = 0 then
    raise EZipMaster.CreateResDisp(DS_NoMem, True);
end;

{$ENDIF}
//? TZipWorker.CheckForDisk

(*? TZipWorker.CreateMVFileName
1.77 21 Aug 2004 RA allow more than 99 compat parts
*)
procedure TZipWorker.CreateMVFileName(var FileName: String; StripPartNbr: Boolean);
var
  ext:      String;
  StripLen: Integer;
begin         // changes filename into multi volume filename
  if (spCompatName in FSpanOptions) then
  begin
    if (FDiskNr <> FTotalDisks) then
    begin
      if FDiskNr < 9 then
        ext := '.z0'
      else
        ext := '.z';
      ext := ext + IntToStr(succ(FDiskNr));
    end
    else
      ext := '.zip';
    FileName := ChangeFileExt(FileName, ext);
  end
  else begin
    StripLen := 0;
    if StripPartNbr then
      StripLen := 3;
    FileName := Copy(FileName, 1, length(FileName) -
      Length(ExtractFileExt(FileName)) - StripLen) +
      Copy(IntToStr(1001 + FDiskNr), 2, 3) + ExtractFileExt(FileName);
  end;
end;
//? TZipWorker.CreateMVFileName

(*? TZipWorker.OpenEOC    
1.77 19 August 2004 RA Allow >99 parts with compatnames
1.76 30 May 2004 Check file <4G
1.75 18 February 2004 allow >2G
1.73.3.2 11 October 2003 RP changed 'garbage' check and save comment
1.73.2.7 12 September 2003 RP stop Disk number < 0
1.73 13 July 2003 RP changed find EOC
// Function to find the EOC record at the end of the archive (on the last disk.)
// We can get a return value( true::Found, false::Not Found ) or an exception if not found.
 1.73 28 June 2003 RP change handling split files
*)

function TZipWorker.OpenEOC(var EOC: ZipEndOfCentral; DoExcept: Boolean): Boolean;
var
  Size, Sig, i, j: Cardinal;
  DiskNo: Integer;
  ShowGarbageMsg: Boolean;
  First:  Boolean;
  ZipBuf: String;       //pChar;
  ext:    String;
  SizeOfFile: I64Rec;       //int64;    // 176
begin
  FZipComment := '';
  First   := False;
  //  ZipBuf := nil;
  FZipEOC := 0;
  FEOCComment := '';

  // Open the input archive, presumably the last disk.
  FInFileHandle := FileOpen(FInFileName, fmShareDenyWrite or fmOpenRead);
  if FInFileHandle = -1 then
  begin
    ShowZipMessage(DS_FileOpen, '');
    Result := False;
    if DoExcept then
      raise EZipMaster.CreateResDisp(DS_NoInFile, True);
    Exit;
  end;

  // First a check for the first disk of a spanned archive,
  // could also be the last so we don't issue a warning yet.
  if (FileRead(FInFileHandle, Sig, 4) = 4) and (Sig = ExtLocalSig) and
    (FileRead(FInFileHandle, Sig, 4) = 4) and (Sig = LocalFileHeaderSig) then
  begin
    First      := True;
    FIsSpanned := True;
  end;

  // Next we do a check at the end of the file to speed things up if
  // there isn't a Zip archive comment.
  SizeOfFile.I := FileSeek64(FInFileHandle, -Int64(SizeOf(ZipEndOfCentral)), 2);
  if SizeOfFile.I >= 0 then
    SizeOfFile.I := SizeOfFile.I + SizeOf(ZipEndOfCentral);
  //  if (SizeOfFile < 0) or (SizeOfFile>HIGH(Cardinal)) then
  if SizeOfFile.Hi <> 0 then
  begin
    Result := False;
    FileClose(FInFileHandle);
    FInFileHandle := -1;
    if Verbose then
      Report(zacMessage, 0, 'Opening EOC seek/size error ' +
        IntToStr(SizeOfFile.I div (1024 * 1024)) + 'Mb', 0);
    if DoExcept then
    begin
      if SizeOfFile.I <> -1 then
        raise EZipMaster.CreateResDisp(LI_FileTooBig, True);
      raise EZipMaster.CreateResDisp(DS_NoValidZip, True);
    end;
    exit;
  end;
  //  FFileSize := Cardinal(FileSeek64(FInFileHandle, -Int64(SizeOf(ZipEndOfCentral)), 2));
  FFileSize := SizeOfFile.Lo;
  if FFileSize >= SizeOf(ZipEndOfCentral) then
    //  if FFileSize <> Cardinal( -1) then
  begin
    //    Inc(FFileSize, SizeOf(EOC));            // Save the archive size as a side effect.
    FRealFileSize := FFileSize;
    // There could follow a correction on FFileSize.
    if (FileRead(FInFileHandle, EOC, SizeOf(ZipEndOfCentral)) =
      SizeOf(ZipEndOfCentral)) and (EOC.HeaderSig = EndCentralDirSig) then
    begin
      FZipEOC := FFileSize - SizeOf(ZipEndOfCentral);
      Result  := True;
      Exit;
    end;
  end;

  // Now we try to find the EOC record within the last 65535 + sizeof( EOC ) bytes
  // of this file because we don't know the Zip archive comment length at this time.
  try
    Size := 65535 + SizeOf(ZipEndOfCentral);
    if FFileSize < Size then
      Size := FFileSize;
    //    GetMem(ZipBuf, Size + 1);
    SetLength(ZipBuf, Size);
    if FileSeek64(FInFileHandle, -Int64(Size), 2) = -1 then
      raise EZipMaster.CreateResDisp(DS_FailedSeek, True);
    ReadJoin(PChar(ZipBuf)^, Size, DS_EOCBadRead);
    for i := Size - SizeOf(ZipEndOfCentral) - 1 downto 0 do
      if pZipEndOfCentral(PChar(ZipBuf) + i)^.HeaderSig = EndCentralDirSig then
      begin
        FZipEOC := FFileSize - Size + i;
        Move((PChar(ZipBuf) + i)^, EOC, SizeOf(ZipEndOfCentral));
        // Copy from our buffer to the EOC record.
        // If we have ZipComment: Save it,No codepage translation yet, wait for CEH read.
        if EOC.ZipCommentLen <> 0 then
          FEOCComment := copy(ZipBuf, i + Sizeof(ZipEndOfCentral) +
            1, EOC.ZipCommentLen);
        // Check if we really are at the end of the file, if not correct the filesize
        // and give a warning. (It should be an error but we are nice.)
        if not (i + SizeOf(ZipEndOfCentral) + EOC.ZipCommentLen -
          Size = 0) then
        begin
          Inc(FFileSize, i + SizeOf(ZipEndOfCentral) +
            Cardinal(EOC.ZipCommentLen) - Size);
          // Now we need a check for WinZip Self Extractor which makes SFX files which
          // allmost always have garbage at the end (Zero filled at 512 byte boundary!)
          // In this special case 'we' don't give a warning.
          ShowGarbageMsg := True;
          if (FRealFileSize - Cardinal(FFileSize) < 512) { and ((FRealFileSize mod
          512) = 0)} then
          begin
            j := i + SizeOf(ZipEndOfCentral) + EOC.ZipCommentLen;
            while (ZipBuf[j] < '/' {= #0}) and (j <= Size) do
              Inc(j);
            if j = Size + 1 then
              ShowGarbageMsg := False;
          end;
          if ShowGarbageMsg then
            ShowZipMessage(LI_GarbageAtEOF, '');
        end;
        { // If we have ZipComment: Save it, must be after Garbage check because a #0 is set!
            if not (EOC.ZipCommentLen = 0) then
            begin
             // No codepage translation yet, wait for CEH read.
             ZipBuf[i + SizeOf(ZipEndOfCentral) + EOC.ZipCommentLen] := #0;
             FZipComment := ZipBuf + i + SizeOf(ZipEndOfCentral);
            end;}
        //      FreeMem(ZipBuf);
        Result := True;
        Exit;
      end;
    //  FreeMem(ZipBuf);
  except
    //  FreeMem(ZipBuf);
    if DoExcept = True then
      raise;
  end;
  if FInFileHandle <> -1 then               // don't leave open
    FileClose(FInFileHandle);
  FInFileHandle := -1;
  if DoExcept = True then
  begin
    // Get the volume number if it's disk from a set. - 1.72 moved
    DiskNo := 0;
    if Pos('PKBACK# ', FVolumeName) = 1 then
      DiskNo := StrToIntDef(Copy(FVolumeName, 9, 3), 0);
    //    else
    if DiskNo <= 0 then
    begin
      ext    := UpperCase(ExtractFileExt(FInFileName));
      DiskNo := 0;
      if copy(ext, 1, 2) = '.Z' then
        DiskNo := StrToIntDef(copy(ext, 2, Length(ext) - 2), 0);
      if (DiskNo <= 0) then
        DiskNo := StrToIntDef(Copy(FInFileName, length(FInFileName) -
          length(ext) - 3 + 1, 3), 0);
    end;
    if ( not First) and (DiskNo {<} > 0) then
      raise EZipMaster.CreateResDisk(DS_NotLastInSet, DiskNo);
    if First = True then
      if DiskNo = 1 then
        raise EZipMaster.CreateResDisp(DS_FirstInSet, True)
      else
        raise EZipMaster.CreateResDisp(DS_FirstFileOnHD, True)
    else
      raise EZipMaster.CreateResDisp(DS_NoValidZip, True);
  end;
  Result := False;
end;
//? TZipWorker.OpenEOC

(*? TZipWorker.GetLastVolume 
1.77 21 August 2004 RP improve orphan file tolerance
1.77 19 August 2004 RA Allow >99 parts with compatnames
1.76 9 June 2004 RA fix finding part of non-split file
1.75 16 March 2004 RA stop exception if unwanted file does not exist
1.73.2.7 13 September 2003 RP avoid neg part numbers
1.73  9 July 2003 RA creation of first part name corrected
1.73 28 June 2003 new fuction
*)
{$IFNDEF NO_SPAN}

function TZipWorker.GetLastVolume(FileName: String; var EOC: ZipEndOfCentral;
  AllowNotExists: Boolean): Integer;
var
  Path, Fname, Ext, sName, s: String;
  PartNbr: Integer;
  Abort, FMVolume, Finding: Boolean;

  function NameOfPart(fn: String; compat: Boolean): String;
  var
    r, n: Integer;
    sRec: TSearchRec;
    fs:   String;
  begin
    Result := '';
    if compat then
      fs := fn + '.z??*'
    else
      fs := fn + '???.zip';
    r := FindFirst(fs, faAnyFile, SRec);
    while r = 0 do
    begin
      if compat then
      begin
        fs := UpperCase(copy(ExtractFileExt(SRec.Name), 3, 20));
        //        fs := UpperCase(copy(SRec.Name, Length(SRec.Name) - 1, 2));
        if fs = 'IP' then
          n := 99999
        else
          n := StrToIntDef(fs, 0);
      end
      else
        n := StrToIntDef(copy(SRec.Name, Length(SRec.Name) - 6, 3), 0);
      if n > 0 then
      begin
        Result := SRec.Name;                // possible name
        break;
      end;
      r := FindNext(SRec);
    end;
    FindClose(SRec);
  end;

begin
  PartNbr  := -1;
  FInFileHandle := -1;
  FMVolume := False;
  FDrive   := ExtractFileDrive(ExpandFileName(FileName)) + '\';
  Path     := ExtractFilePath(FileName);
  Ext      := Uppercase(ExtractFileExt(FileName));
  try
    FDriveFixed := IsFixedDrive(FDrive);
    GetDriveProps;                          // check valid drive
    if not FileExists(FileName) then
    begin
      Fname    := copy(FileName, 1, Length(FileName) - Length(Ext));
      // remove extension
      FMVolume := True;
      // file did not exist maybe it is a multi volume
      if FDriveFixed then
        // if file not exists on harddisk then only Multi volume parts are possible
      begin                                 // filename is of type ArchiveXXX.zip
        // MV files are series with consecutive partnbrs in filename, highest number has EOC
        if Ext = '.ZIP' then
        begin
          Finding := True;
          while Finding do
          begin
            s := Fname + copy(IntToStr(1002 + PartNbr), 2, 3) + '.zip';
            if not FileExists(s) then
            begin
              PartNbr := -1;
              break;
            end;
            Inc(PartNbr);
            FInFileName := s;
            if OpenEOC(EOC, False) then
            begin
              Finding := False;
              if EOC.ThisDiskNo <> PartNbr then
                PartNbr := -1;   // not valid last part
            end;
            if FInfileHandle <> -1 then
              FileClose(FInFileHandle);
            FInFileHandle := -1;
          end;
        end;
        //        While FileExists(Fname + copy(IntToStr(1002 + PartNbr), 2, 3) + '.zip') Do
        //          Inc(PartNbr);
        if PartNbr = -1 then
        begin
          if not AllowNotExists then
            raise EZipMaster.CreateResDisp(DS_FileOpen, True);
          Result := 1;
          exit;                             // non found
        end;
        FileName := Fname + copy(IntToStr(1001 + PartNbr), 2, 3) + '.zip';
        // check if filename.z01 exists then it is part of MV with compat names and cannot be used
        if (FileExists(ChangeFileExt(FileName, '.z01'))) then
          raise EZipMaster.CreateResDisp(DS_FileOpen, True); // cannot be used
      end
      else // if we have an MV archive copied to a removable disk
      begin
        // accept any MV filename on disk
        sName := NameOfPart(Fname, False);
        if sName = '' then
          sName := NameOfPart(Fname, True);
        if sName = '' then                  // none
          //          raise EZipMaster.CreateResDisp(DS_FileOpen, true);
        begin                               // 1.75 RA
          if not AllowNotExists then
            raise EZipMaster.CreateResDisp(DS_FileOpen, True);
          Result := 1;
          exit;
        end;
        FileName := Path + sName;
      end;
    end;                                    // if not exists
    // zip file exists or we got an acceptable part in multivolume or split archive
    FInFileName := FileName;
    // use class variable for other functions
    while not OpenEOC(EOC, False) do
          // does this part contains the central dir
    begin // it is not the disk with central dir so ask for the last disk
      if FInFileHandle <> -1 then
      begin
        FileClose(FInFileHandle);           //each check does FileOpen
        FInFileHandle := -1;                // avoid further closing attempts
      end;
      CheckForDisk(False);                  // does the request for new disk
      if FDriveFixed then
      begin
        if FMVolume then
          raise EZipMaster.CreateResDisp(DS_FileOpen, True);
        // it was not a valable part
        AllowNotExists := False;
        // next error needs to be displayed always
        raise EZipMaster.CreateResDisp(DS_NoValidZip, True);
        // file with EOC is not on fixed disk
      end;
      // for spanned archives on cdrom's or floppies 
      if assigned(OnGetNextDisk) then
      begin                                 // v1.60L
        Abort := False;
        OnGetNextDisk(Master, 0, 0, copy(FDrive, 1, 1), Abort);
        if Abort then                       // we allow abort by the user
        begin
          if FInFileHandle <> -1 then
            FileClose(FInFileHandle);
          Result := 1;
          exit;
        end;
        GetDriveProps;
        // check drive spec and get volume name
      end
      else begin                                 // if no event handler is used
        FNewDisk := True;
        FDiskNr  := -1;                      // read operation
        CheckForDisk(False);                 // ask for new disk
      end;
      if FMVolume then
      begin // we have removable disks with multi volume archives
            //  get the file name on this disk
        sName := NameOfPart(Fname, spCompatName in FSpanOptions);
        if sName = '' then
        begin // no acceptable file on this disk so not a disk of the set
          ShowZipMessage(DS_FileOpen, '');
          Result := -1;                     //error
          exit;
        end;
        FInFileName := Path + sName;
      end;
    end;                                    // while
    if FMVolume then
      // got a multi volume part so we need more checks
    begin                                   // is this first file of a spanned
      if ( not FIsSpanned) and ((EOC.ThisDiskNo = 0) and (PartNbr >= 0)) then
        raise EZipMaster.CreateResDisp(DS_FileOpen, True);
      // part and EOC equal?
      if FDriveFixed and (EOC.ThisDiskNo <> PartNbr) then
        raise EZipMaster.CreateResDisp(DS_NoValidZip, True);
    end;

  except
    on E: EZipMaster do
    begin
      if not AllowNotExists then
        ShowExceptionError(E);
      FInFileName := '';                    // don't use the file
      if FInFileHandle <> -1 then
        FileClose(FInFileHandle);           //close filehandle if open
      Result := -1;
      exit;
    end;
  end;
  Result := 0;
end;

{$ENDIF}
//? TZipWorker.GetLastVolume

(*?  TZipWorker.GetNewDisk
1.77 19 August 2004 RP - improve logic
1.73 12 July 2003 RA clear file handle, change loop
*)

procedure TZipWorker.GetNewDisk(DiskSeq: Integer);
begin
{$IFDEF NO_SPAN}
  raise EZipMaster.CreateResDisp(DS_NODISKSPAN, True);
{$ELSE}
  FileClose(FInFileHandle);
  // Close the file on the old disk first.
  FDiskNr := DiskSeq;
  while True do
  begin
    //  Repeat
    //    If FInFileHandle = -1 Then
    //      If FDriveFixed Then
    //        Raise EZipMaster.CreateResDisp(DS_NoInFile, True)
    //      Else
    //        ShowZipMessage(DS_NoInFile, '');
    repeat
      FNewDisk      := True;
      FInFileHandle := -1;                  // 173 mark closed
      CheckForDisk(False);
    until IsRightDisk;

    if Verbose then
      Report(zacMessage, 0, ZipFmtLoadStr(TM_GetNewDisk, [FInFileName]), 0);
    //      'Trace : GetNewDisk Opening ' + FInFileName, 0);
    // Open the the input archive on this disk.
    FInFileHandle := FileOpen(FInFileName, fmShareDenyWrite or fmOpenRead);
    if FInFileHandle <> -1 then
      break;   // found
    if FDriveFixed then
      raise EZipMaster.CreateResDisp(DS_NoInFile, True)
    else
      ShowZipMessage(DS_NoInFile, '');
    //  Until Not (FInFileHandle = -1);
  end;
{$ENDIF}
end;
//? TZipWorker.GetNewDisk

(*? TZipWorker.WriteSplit
1.77 1 Oct 2004 RP - use YesToAll
1.77 18 Aug 2004 RA - allow unattended on fixed drive
1.77 15 August 2004 RP progress
1.73.3.3 15 October 2003 RP Remove duplicated code
1.73.3.2 11 October 2003 RA set KeepFreeOnDisk1 and KeepFreeOnAlldisk to sector boundaries
1.73.2.7 12 September 2003 RP stoppped disk number<0
1.73 11 July 2003 RP corrected asking disk status
1.73 9 July 2003 RA corrected use of disk status and OnStatusDisk
1.73 7 July 2003 RA changed OnMessage and OnProgress to Report calls
1.73 28 June 2003 changed Split file handling
// This function actually writes the zipped file to the destination while
// taking care of disk changes and disk boundary crossings.
// In case of an write error, or user abort, an exception is raised.
*)
{$IFNDEF NO_SPAN}
procedure TZipWorker.WriteSplit(const Buffer; Len, MinSize: Integer);
var
  Res, MaxLen: Integer;
  Buf:     Pchar; // Used if Buffer doesn't fit on the present disk.
  DiskSeq: Integer;
  DiskFile, MsgQ: String;
  SectorsPCluster, BytesPSector, FreeClusters, TotalClusters: Cardinal;

  function NewSegment: Boolean; // true to 'continue'
  begin
    Result      := False;
    FDriveFixed := IsFixedDrive(FDrive);  // 1.72
    CheckForDisk(True);                   // 1.70 changed
    DiskFile := FOutFileName;

    // If we write on a fixed disk the filename must change.
    // We will get something like: FileNamexxx.zip where xxx is 001,002 etc.
    // if CompatNames are used we get FileName.zxx where xx is 01, 02 etc.. last .zip
    if FDriveFixed or (spNoVolumeName in FSpanOptions) then
      CreateMVFileName(DiskFile, False);
    // Allow clearing of removeable media even if no volume names
    if ( not FDriveFixed) and (spWipeFiles in FSpanOptions) then
      if ( not Assigned(OnGetNextDisk)) or
        (Assigned(OnGetNextDisk) and
        (FZipDiskAction = zdaErase)) then
        // Added v1.60L
      begin
        // Do we want a format first?
        FDriveNr := Ord(UpperCase(FDrive)[1]) - Ord('A');
        if (spNoVolumeName in FSpanOptions) then
          FVolumeName := 'ZipSet_' + IntToStr(succ(FDiskNr))
        // default name
        else
          FVolumeName := 'PKBACK# ' + Copy(IntToStr(1001 + FDiskNr), 2, 3);
        // Ok=6 NoFormat=-3, Cancel=-2, Error=-1
        case ZipFormat of
          // Start formating and wait until finished...
          -1:
            raise EZipMaster.CreateResDisp(DS_Canceled, True);
          -2:
            raise EZipMaster.CreateResDisp(DS_Canceled, False);
        end;
      end;
    if FDriveFixed or (spNoVolumeName in FSpanOptions) then
      DiskSeq := FDiskNr + 1
    else begin
      DiskSeq := StrToIntDef(Copy(FVolumeName, 9, 3), 1);
      if DiskSeq < 0 then
        DiskSeq := 1;
    end;
    FZipDiskStatus := [];                 // v1.60L
    // Do we want to overwrite an existing file?
    if FileExists(DiskFile) then
      if (FileAge(DiskFile) = FDateStamp) and (Pred(DiskSeq) < FDiskNr) then
      begin
        MsgQ := ZipFmtLoadStr(DS_AskPrevFile, [DiskSeq]);
        FZipDiskStatus := FZipDiskStatus + [zdsPreviousDisk]; // v1.60L
      end
      else begin
        MsgQ := ZipFmtLoadStr(DS_AskDeleteFile, [DiskFile]);
        FZipDiskStatus := FZipDiskStatus + [zdsSameFileName]; // v1.60L
      end
    else if not FDriveFixed then
      if (FSizeOfDisk - FFreeOnDisk) <> 0 then // v1.60L
        FZipDiskStatus :=
          FZipDiskStatus + [zdsHasFiles] // But not the same name
      else
        FZipDiskStatus := FZipDiskStatus + [zdsEmpty];
    if Assigned(OnStatusDisk) and not (zaaYesOvrWrt in FAnswerAll) then // 1.77
    begin
      FZipDiskAction := zdaOk;            // The default action
      OnStatusDisk(Master, DiskSeq, DiskFile, FZipDiskStatus,
        FZipDiskAction);
      case FZipDiskAction of
        zdaCancel:
          Res := idCancel;
        zdaReject:
          Res := idNo;
        zdaErase:
          Res := idOk;
        zdaYesToAll:
        begin
          Res := idOk;
          FAnswerAll := FAnswerAll + [zaaYesOvrWrt];
        end;
        zdaOk:
          Res := idOk;
        else
          Res := idOk;
      end;
    end
    else if ((FZipDiskStatus * [zdsPreviousDisk, zdsSameFileName]) <> []) and
      not (zaaYesOvrwrt in FAnswerAll) then
    begin
      Res := ZipMessageDlg(ZipLoadStr(FM_Confirm), MsgQ,
        zmtWarning + DHC_SpanOvr, [mbYes, mbNo, mbCancel, mbYesToAll]);
      if Res = mrYesToAll then
      begin
        FAnswerAll := FAnswerAll + [zaaYesOvrwrt];
        Res := idOk;
      end;
    end
    else
      Res := idOk;
    if (Res = 0) or (Res = idCancel) or (Res = idNo) then
      raise EZipMaster.CreateResDisp(DS_Canceled, False);

    if Res = idNo then
    begin                                 // we will try again...
      FDiskWritten := 0;
      FNewDisk := True;
      Result := True;
      exit;
    end;
    // Create the output file.
    FOutFileHandle := FileCreate(DiskFile);
    if FOutFileHandle = -1 then
      //  raise EZipMaster.CreateResDisp(DS_NoOutFile, True);
    begin                                 //change proposed by Pedro Araujo
      MsgQ := ZipLoadStr(DS_NoOutFile);
      // 'Creation of output file failed');
      Res  := ZipMessageDlg('', MsgQ, zmtError + DHC_SpanNoOut, [mbRetry, mbCancel]);
      //      Res  := MessageBox(FHandle, PChar(MsgQ), PChar(Application.Title),
      //        MB_RETRYCANCEL or MB_ICONERROR);
      if Res = 0 then
        raise EZipMaster.CreateResDisp(DS_NoMem, True);
      if Res <> idRetry then
        raise EZipMaster.CreateResDisp(DS_Canceled, False);
      FDiskWritten := 0;
      FNewDisk := True;
      Result := True;
      exit;
    end;

    // Get the free space on this disk, correct later if neccessary.
    DiskFreeAndSize(1);                   // RCV150199

    // Set the maximum number of bytes that can be written to this disk(file).
    // Reserve space on/in all the disk/file.
    FFreeOnDisk := FFreeOnDisk - FFreeOnAllDisks;

    if (FMaxVolumeSize > 0) and (FMaxVolumeSize < FFreeOnDisk) then
      FFreeOnDisk := FMaxVolumeSize;
    // Reserve space on/in all the disk/file.
    if (FDiskNr = 0) and (FFreeOnDisk1 > 0) or (FFreeOnAllDisks > 0) then
      // only one calculation if needed
      if (GetDiskFreeSpace(PChar(FDrive), SectorsPCluster,
        BytesPSector, FreeClusters,
        TotalClusters)) then
      begin
        if (FFreeOnDisk1 mod BytesPSector) <> 0 then
          FFreeOnDisk1 := succ(FFreeOnDisk1 div BytesPSector) * BytesPSector;
        if (FFreeOnAllDisks mod BytesPSector) <> 0 then
          FFreeOnAllDisks :=
            succ(FFreeOnAllDisks div BytesPSector) * BytesPSector;
      end;
    Dec(FFreeOnDisk, FFreeOnAllDisks);
    // Reserve space on/in the first disk(file).
    if FDiskNr = 0 then
      Dec(FFreeOnDisk, FFreeOnDisk1);

    // Do we still have enough free space on this disk.
    if FFreeOnDisk < FMinFreeVolSize then // No, too bad...
    begin
      FileClose(FOutFileHandle);
      DeleteFile(DiskFile);
      FOutFileHandle := -1;
      if Assigned(OnStatusDisk) then     // v1.60L
      begin
        if spNoVolumeName in FSpanOptions then
          DiskSeq := FDiskNr + 1
        else begin
          DiskSeq := StrToIntDef(Copy(FVolumeName, 9, 3), 1);
          if DiskSeq < 0 then
            DiskSeq := 1;
        end;
        FZipDiskAction := zdaOk;          // The default action
        FZipDiskStatus := [zdsNotEnoughSpace];
        OnStatusDisk(Master, DiskSeq, DiskFile, FZipDiskStatus,
          FZipDiskAction);
        case FZipDiskAction of
          zdaCancel:
            Res := idCancel;
          zdaOk:
            Res := idRetry;
          zdaErase:
            Res := idRetry;
          zdaReject:
            Res := idRetry;
          else
            Res := idRetry;
        end;
      end
      else begin
        MsgQ := ZipLoadStr(DS_NoDiskSpace);
        //            'This disk has not enough free space available');
        //        Res  := MessageBox(FHandle, PChar(MsgQ), PChar(Application.Title),
        //          MB_RETRYCANCEL or MB_ICONERROR);
        Res  := ZipMessageDlg('', MsgQ, zmtError + DHC_SpanSpace, [mbRetry, mbCancel]);
      end;
      if Res = 0 then
        raise EZipMaster.CreateResDisp(DS_NoMem, True);
      if Res <> idRetry then
        raise EZipMaster.CreateResDisp(DS_Canceled, False);
      FDiskWritten := 0;
      FNewDisk := True;
      // If all this was on a HD then this would't be useful but...
      //Continue;
      Result := True;
      exit;
    end;

    // Set the volume label of this disk if it is not a fixed one.
    if not (FDriveFixed or (spNoVolumeName in FSpanOptions)) then
    begin
      FVolumeName := 'PKBACK# ' + Copy(IntToStr(1001 + FDiskNr), 2, 3);
      if not SetVolumeLabel(PChar(FDrive), PChar(FVolumeName)) then
        raise EZipMaster.CreateResDisp(DS_NoVolume, True);
    end;
  end;

begin  {WriteSplit}
  Buf := @Buffer;
  //  if ForegroundTask then
  //    Application.ProcessMessages;
  Report(zacTick, 0, '', 0);
  if Cancel then
    raise EZipMaster.CreateResDisp(DS_Canceled, False);

  while True do
    // Keep writing until error or buffer is empty.
  begin
    // Check if we have an output file already opened, if not: create one,
    // do checks, gather info.
    if FOutFileHandle = -1 then
      if NewSegment then
        continue;  // END OF: if FOutFileHandle = -1

    // Check if we have at least MinSize available on this disk,
    // headers are not allowed to cross disk boundaries. ( if zero than don't care.)
    if (MinSize > 0) and (MinSize > FFreeOnDisk) then
    begin
      FileSetDate(FOutFileHandle, FDateStamp);
      FileClose(FOutFileHandle);
      FOutFileHandle := -1;
      FDiskWritten := 0;
      FNewDisk := True;
      Inc(FDiskNr);                         // RCV270299
      Continue;
    end;

    // Don't try to write more bytes than allowed on this disk.
{$IFDEF VERD4+}
    MaxLen := HIGH(Integer);
    if FFreeOnDisk < MaxLen then
      MaxLen := Integer(FFreeOnDisk);
{$ELSE}
    MaxLen := Trunc(FFreeOnDisk);
{$ENDIF}
    if Len < MaxLen{FFreeOnDisk} then
      MaxLen := Len;
    Res := FileWrite(FOutFileHandle, Buf^, MaxLen);
    if Res = -1 then
      raise EZipMaster.CreateResDisp(DS_NoWrite, True);
    // A write error (disk removed?)

    // Give some progress info while writing
    // While processing the central header we don't want messages.
    if FShowProgress <> zspNone then
      //      Report(zacProgress, 0, '', MaxLen);
      if FShowProgress = zspExtra then
        Report(zacXProgress, 0, '', Res)//MaxLen)
      else
        Report(zacProgress, 0, '', Res);

    Inc(FDiskWritten, Res);
    FFreeOnDisk := FFreeOnDisk - MaxLen;    // RCV150199
    if MaxLen = Len then
      Break;

    // We still have some data left, we need a new disk.
    FileSetDate(FOutFileHandle, FDateStamp);
    FileClose(FOutFileHandle);
    FOutFileHandle := -1;
    FFreeOnDisk    := 0;
    FDiskWritten   := 0;
    Inc(FDiskNr);
    FNewDisk := True;
    Inc(Buf, MaxLen);
    Dec(Len, MaxLen);
  end;
end;

{$ENDIF}
//? TZipWorker.WriteSplit

(*? TZipWorker.WriteJoin
1.77 13 August 2004 RP progress
1.73 15 July 2003 RP progress
*)

procedure TZipWorker.WriteJoin(const Buffer; BufferSize, DSErrIdent: Integer);
begin
  if FileWrite(FOutFileHandle, Buffer, BufferSize) <> BufferSize then
    raise EZipMaster.CreateResDisp(DSErrIdent, True);

  // Give some progress info while writing.
  // While processing the central header we don't want messages.
  //  if FShowProgress <> zspNone then
  //    Report(zacProgress, 0, '', BufferSize);
  if FShowProgress = zspExtra then
    Report(zacXProgress, 0, '', BufferSize)
  else if FShowProgress = zspFull then
    Report(zacProgress, 0, '', BufferSize);
end;
//? TZipWorker.WriteJoin

(*? TZipWorker.AddStreamToFile
1.76 10 June 2004 RA fix access to FSpecArgs
1.73 14 JUly 2003 RA check wildcards & initial FSuccessCnt
// FileAttr are set to 0 as default.
// FileAttr can be one or a logical combination of the following types:
// FILE_ATTRIBUTE_ARCHIVE, FILE_ATTRIBUTE_HIDDEN, FILE_ATTRIBUTE_READONLY, FILE_ATTRIBUTE_SYSTEM.
// FileName is as default an empty string.
// FileDate is default the system date.

// EWE: I think 'Filename' is the name you want to use in the zip file to
// store the contents of the stream under.
*)

function TZipWorker.AddStreamToFile(Filename: String;
  FileDate, FileAttr: DWORD): Integer;
var
  st: TSystemTime;
  ft: TFileTime;
  FatDate, FatTime: Word;
begin
  //    TraceMessage('AddStreamToFile, fname=' + Filename); //  qqq
  if Length(Filename) > 0 then
  begin
    FFSpecArgs.{A}Clear();
    FFSpecArgs.{A}Add(FileName);
  end;
  if FileDate = 0 then
  begin
    GetLocalTime(st);
    SystemTimeToFileTime(st, ft);
    FileTimeToDosDateTime(ft, FatDate, FatTime);
    FileDate := (DWORD(FatDate) shl 16) + FatTime;
  end;
  FSuccessCnt := 0;
  // Check if wildcards are set.
  if FFSpecArgs.Count > 0 then
    if (AnsiPos('*', FFSpecArgs.Strings[0]) > 0) or
      (AnsiPos('?', FFSpecArgs.Strings[0]) > 0) then
      ShowZipMessage(AD_InvalidName, '')
    else
      ExtAdd(1, FileDate, FileAttr, NIL)
  else
    ShowZipMessage(AD_NothingToZip, '');
  Result := fErrCode;
end;
//? TZipWorker.AddStreamToFile

(*? TZipWorker.List
1.76  9 June 2004 stop Range Error >2G
1.76 28 April 2004 test Active
1.76 25 April 2004 use GetLastVolume
1.75 13 March 2004 give progress
1.75 18 February 2004 RP allow file>2G
1.73.3.2 Oct 11 2003 RP convert saved comment
1.73.3.2 Oct 9 2003 RP don't clear ZipComment if file does not exist
1.73 15 July 2003 RP ReadJoin
1.73 13 July 2003 RP change handling part of span
1.73 12 July 2003 RP string Extra Data
1.73 27 June 2003 RP changed Split disk handling
{ New in v1.50: We are now looking at the Central zip Dir, instead of
  the local zip dir.  This change was needed so we could support
  Disk-Spanning, where the dir for the whole disk set is on the last disk.}
{ The List method reads thru all entries in the central Zip directory.
  This is triggered by an assignment to the ZipFilename, or by calling
  this method directly. }
*)

function TZipWorker.List: Integer;
  { all work is local - no DLL calls }
var
  pzd:   pZipDirEntry;
  EOC:   ZipEndOfCentral;
  CEH:   ZipCentralHeader;
  OffsetDiff: Int64;
  Fname: String;
  i, LiE: Integer;
  MadeOS, MadeVer: Byte;
{$IFNDEF NO_SPAN}
  r: integer;
{$ENDIF}
begin
  LiE := 1;                                 // any exceptions will be error
  //  if assigned(Owner) and ((csDesigning in Owner.ComponentState) or
  //    (csLoading in Owner.ComponentState)) then
  //    Exit;                                   { can't do LIST at design time }

  { zero out any previous entries }
  FreeZipDirEntryRecords;

  FRealFileSize := 0;
  FZipSOC     := 0;
  FSFXOffset  := 0;
  // must be before the following "if"
  FZipComment := '';
  OffsetDiff  := 0;
  FIsSpanned  := False;
  FDirOnlyCount := 0;
  fErrCode    := 0;                            // 1.72
  MadeOS      := 0;
  MadeVer     := 20;
  Result      := fErrCode;

  if not Active then
  begin
    FDelaying := FDelaying + [zdiList];
    exit;
  end;

  FInfileName := FZipFileName;
  FDrive      := ExtractFileDrive(ExpandFileName(FInFileName)) + '\';
  FDriveFixed := IsFixedDrive(FDrive);
  GetDriveProps;

{$IFNDEF NO_SPAN}
  // Locate last of multi volume or last disk of split
  r := GetLastVolume(FZipFileName, EOC, True);
  if r < 0 then
    exit;
  // error exception should been thrown when detected
  if r = 1 then // Don't complain - this may intentionally be a new zip file.
{$ELSE}
    if (FZipFileName = '') or not FileExists(FZipFileName) then
{$ENDIF}
    begin
      { let user's program know there's no entries }
      if Assigned(OnDirUpdate) then
        OnDirUpdate(Master);
      Exit;
    end;

{$IFDEF NO_SPAN}
  try
    OpenEOC(EOC, True);                     // exception if not
  except
    on E: EZipMaster do
      ShowExceptionError(E);
  end;
  { let user's program know there's no entries }
{$ENDIF}
  if FInFileHandle = -1 then                // was problem
  begin
    if Assigned(OnDirUpdate) then
      OnDirUpdate(Master);
    Exit;
  end;

  try
    StartWaitCursor;
    try
      FTotalDisks := EOC.ThisDiskNo;
      // Needed in case GetNewDisk is called.

      // This could also be set to True if it's the first and only disk.
      if EOC.ThisDiskNo > 0 then
        FIsSpanned := True;

      // Do we have to request for a previous disk first?
      if EOC.ThisDiskNo <> EOC.CentralDiskNo then
      begin
        GetNewDisk(EOC.CentralDiskNo);
        FFileSize  := Cardinal(FileSeek64(FInFileHandle, Int64(0), 2)); //v1.52i
        OffsetDiff := EOC.CentralOffset;    //v1.52i
      end
      else                                  //v1.52i
        // Due to the fact that v1.3 and v1.4x programs do not change the archives
        // EOC and CEH records in case of a SFX conversion (and back) we have to
        // make this extra check.
        OffsetDiff := Longword(FFileSize) - EOC.CentralSize - SizeOf(EOC) -
          EOC.ZipCommentLen;
      FZipSOC := OffsetDiff;
      // save the location of the Start Of Central dir
      FSFXOffset := FFileSize;
      // initialize this - we will reduce it later
      if FFileSize = 22 then
        FSFXOffset := 0;

      FWrongZipStruct := False;
      if EOC.CentralOffset <> Longword(OffsetDiff) then
      begin
        FWrongZipStruct := True;
        // We need this in the ConvertXxx functions.
        ShowZipMessage(LI_WrongZipStruct, '');
      end;

      // Now we can go to the start of the Central directory.
      if FileSeek64(FInFileHandle, OffsetDiff, 0) = -1 then
        raise EZipMaster.CreateResDisp(LI_ReadZipError, True);

      Report(zacXItem, zprLoading, ZipLoadStr(PR_Loading), EOC.TotalEntries);
      //      Report(zacXItem, zprLoading, _PR_Loading{'*Loading Directory'}, EOC.TotalEntries);
      // Read every entry: The central header and save the information.
{$IFDEF DEBUG}
      if Trace then
        Report(zacMessage, 0,
          Format('List - expecting %d files', [EOC.TotalEntries]), 0);
{$ENDIF}
      ZipContents.Capacity := EOC.TotalEntries;
      for i := 0 to (EOC.TotalEntries - 1) do
      begin
        // Read a central header entry for 1 file
        while FileRead(FInFileHandle, CEH, SizeOf(CEH)) <> SizeOf(CEH) do
          //v1.52i
        begin
          // It's possible that we have the central header split up.
          if FDiskNr >= EOC.ThisDiskNo then
            raise EZipMaster.CreateResDisp(DS_CEHBadRead, True);
          // We need the next disk with central header info.
          GetNewDisk(FDiskNr + 1);
        end;

        //validate the signature of the central header entry
        if CEH.HeaderSig <> CentralFileHeaderSig then
          raise EZipMaster.CreateResDisp(DS_CEHWrongSig, True);

        // Now the filename
        SetLength(Fname, CEH.FileNameLen);
        ReadJoin(Fname[1], CEH.FileNameLen, DS_CENameLen);

        // Save version info globally for use by codepage translation routine
        FVersionMadeBy0 := CEH.VersionMadeBy0;
        FVersionMadeBy1 := CEH.VersionMadeBy1;
        if FVersionMadeBy1 > 0 then         // not msdos
        begin
          MadeOs  := FVersionMadeBy1;
          MadeVer := FVersionMadeBy0;
        end;
        Fname := ConvertOEM(Fname, cpdOEM2ISO);
{$IFDEF DEBUG}
        if Trace then
          Report(zacMessage, 0, Format('List - [%d] "%s"', [i, Fname]), 0);
{$ENDIF}
        // Create a new ZipDirEntry pointer.
        New(pzd); // These will be deleted in: FreeZipDirEntryRecords.

        // Copy the needed file info from the central header.
        CopyMemory(pzd, @CEH.VersionMadeBy0, 42);
        pzd^.FileName  := SetSlash(Fname, psdExternal);
        pzd^.Encrypted := (pzd^.Flag and 1) > 0;

        pzd^.ExtraData := '';
        // Read the extra data if present new v1.6
        if pzd^.ExtraFieldLength > 0 then
        begin
          SetLength(pzd^.ExtraData, pzd^.ExtraFieldLength);
          ReadJoin(pzd^.ExtraData[1], CEH.ExtraLen, LI_ReadZipError);
        end;

        // Read the FileComment, if present, and save.
        if CEH.FileComLen > 0 then
        begin
          // get the file comment
          SetLength(pzd^.FileComment, CEH.FileComLen);
          ReadJoin(pzd^.FileComment[1], CEH.FileComLen, DS_CECommentLen);
          pzd^.FileComment := ConvertOEM(pzd^.FileComment, cpdOEM2ISO);
        end;

        if FUseDirOnlyEntries or (ExtractFileName(pzd^.FileName) <> '') then
        begin                               // Add it to our contents tabel.
{$IFDEF DEBUG}
          if Trace then
            Report(zacMessage, 0,
              Format('List - adding "%s" [%s]',
              [pzd.FileName, pzd.FileComment]), 0);
{$ENDIF}
          ZipContents.Add(pzd);
          // Notify user, when needed, of the next entry in the ZipDir. 
          if Assigned(OnNewName) then
            OnNewName(Master, i + 1, pzd^);
        end
        else begin
          Inc(FDirOnlyCount);
{$IFDEF DEBUG}
          if Trace then
            Report(zacMessage, 0,
              Format('List - dropped dir [%d]', [FDirOnlyCount]), 0);
{$ENDIF}
          pzd^.ExtraData  := '';
          pzd.FileName    := '';
          pzd.FileComment := '';
          Dispose(pzd);
        end;

        // Calculate the earliest Local Header start
        if {Longword(}FSFXOffset{)} > CEH.RelOffLocal then
          FSFXOffset := CEH.RelOffLocal;
        Report(zacXProgress, zprLoading, ZipLoadStr(PR_Loading), 1);
        if Cancel then
          raise EZipMaster.CreateResDisp(DS_Canceled, True);
      end;
      FTotalDisks := EOC.ThisDiskNo;
      // We need this when we are going to extract.
      LiE := 0;                             // finished ok
    except
      on ezl: EZipMaster do
        // Catch all Zip List specific errors.
      begin
        ShowExceptionError(ezl);
      end;
      on EOutOfMemory do
      begin
        ShowZipMessage(GE_NoMem, '');
      end;
      on E: Exception do
      begin
        // the error message of an unknown error is displayed ...
        ShowZipMessage(LI_ErrorUnknown, E.Message);
      end;
    end;
  finally
    Report(zacEndOfBatch, zprLoading, '', 0);
    StopWaitCursor;
    if FInFileHandle <> -1 then
      FileClose(FInFileHandle);
    FInFileHandle := -1;
    if LiE = 1 then
    begin
      FZipFileName := '';
      FSFXOffset   := 0;
    end
    else begin
      // Correct the offset for v1.3 and 1.4x
      FSFXOffset      := FSFXOffset + Cardinal(OffsetDiff -
        Int64(EOC.CentralOffset));
      FVersionMadeBy1 := MadeOS;
      // if any not dos assume comment not oem
      FVersionMadeBy0 := MadeVer;
      FZipComment     := ConvertOEM(FEOCComment, cpdOEM2ISO);
    end;

    // Let the user's program know we just refreshed the zip dir contents. 
    if Assigned(OnDirUpdate) then
      OnDirUpdate(Master);
  end;
  Result := fErrCode;
end;
//? TZipWorker.List

(*? TZipWorker.CopyZippedFiles
1.76 9 June 2004 RA properly assign not done files to FSpecArgs
1.76 24 April 2004 RA fix FInFileHandle not closed
1.75 18 February 2004 allow >2G
1.73.2.8 2 Oct 2003 RA fix slash
1.73  1 August 2003 RA close file or error
1.73 24 July 2003 RA init OutFileHandle
1.73 13 July 2003 RA removed second OpenEOC
1.73 12 July 2003 RP string extra data
// Function to copy one or more zipped files from the zip archive to another zip archive
// FSpecArgs in source is used to hold the filename(s) to be copied.
// When this function is ready FSpecArgs contains the file(s) that where not copied.
// Return values:
// 0            All Ok.
// -6           CopyZippedFiles Busy
// -7           CopyZippedFiles errors. See ZipMsgXX.rc
// -8           Memory allocation error.
// -9           General unknown CopyZippedFiles error.
*)

function TZipWorker.CopyZippedFiles(DestZipMaster: TZipWorker;
  DeleteFromSource: Boolean; OverwriteDest: OvrOpts): Integer;
var
  EOC:      ZipEndOfCentral;
  CEH:      ZipCentralHeader;
  OutFilePath: String;
  In2FileHandle: Integer;
  Found, Overwrite: Boolean;
  DestMemCount: Integer;
  NotCopiedFiles: TStringList;
  pzd, zde: pZipDirEntry;
  s, d:     Integer;
  MDZD:     TMZipDataList;
  MDZDp:    pMZipData;
begin
  fZipBusy := True;
  FShowProgress := zspNone;//False;
  NotCopiedFiles := NIL;
  Result := 0;
  In2FileHandle := -1;
  FOutFileHandle := -1;
  MDZD   := NIL;

  StartWaitCursor;
  try
    // Are source and destination different?
    if (DestZipMaster = Self) or (AnsiStrIComp(PChar(ZipFileName),
      PChar(DestZipMaster.ZipFileName)) = 0) then
      raise EZipMaster.CreateResDisp(CF_SourceIsDest, True);
    // The following function a.o. open the input file no. 1.
    // new 1.7 - stop attempt to copy spanned file
    OpenEOC(EOC, True);
    if (DestZipMaster.IsSpanned or IsSpanned) then
    begin
      if FInFileHandle <> -1 then
        FileClose(FInFileHandle);
      FInFileHandle := -1;
      raise EZipMaster.CreateResDisp(CF_NoCopyOnSpan, True);
    end;
    // Now check for every source file if it is in the destination archive and determine what to do.
    // we use the three most significant bits from the Flag field from ZipDirEntry to specify the action
    // None           = 000xxxxx, Destination no change. Action: Copy old Dest to New Dest
    // Add            = 001xxxxx (New).                  Action: Copy Source to New Dest
    // Overwrite      = 010xxxxx (OvrAlways)             Action: Copy Source to New Dest
    // AskToOverwrite = 011xxxxx (OvrConfirm)            Action to perform: Overwrite or NeverOverwrite
    // NeverOverwrite = 100xxxxx (OvrNever)                                                  Action: Copy old Dest to New Dest
    for s := 0 to FSpecArgs.Count - 1 do
    begin
      Found := False;
      for d := 0 to DestZipMaster.Count - 1 do
      begin
        zde := pZipDirEntry(DestZipMaster.ZipContents.Items[d]);
        if AnsiStrIComp(PChar(FSpecArgs.Strings[s]),
          PChar(zde^.FileName)) = 0 then
        begin
          Found     := True;
          zde^.Flag := zde^.Flag and $1FFF; // Clear the three upper bits.
          if OverwriteDest = OvrAlways then
            zde^.Flag := zde^.Flag or $4000
          else if OverwriteDest = OvrNever then
            zde^.Flag := zde^.Flag or $8000
          else
            zde^.Flag := zde^.Flag or $6000;
          Break;
        end;
      end;
      if not Found then
      begin                                 // Add the Filename to the list and set flag
        New(zde);
        DestZipMaster.ZipContents.Add(zde);
        zde^.FileName  := FSpecArgs.Strings[s];
        zde^.FileNameLength := Length(FSpecArgs.Strings[s]);
        zde^.Flag      := zde^.Flag or $2000;    // (a new entry)
        zde^.ExtraData := '';                    // Needed when deleting zde
      end;
    end;
    // Make a temporary filename like: C:\...\zipxxxx.zip for the new destination
    OutFilePath := MakeTempFileName('', '');
    if OutFilePath = '' then
      raise EZipMaster.CreateResDisp(DS_NoTempFile, True);

    // Create the output file.
    FOutFileHandle := FileCreate(OutFilePath);
    if FOutFileHandle = -1 then
      raise EZipMaster.CreateResDisp(DS_NoOutFile, True);

    // Open the second input archive, i.e. the original destination.
    In2FileHandle := FileOpen(DestZipMaster.ZipFileName, fmShareDenyWrite or
      fmOpenRead);
    if In2FileHAndle = -1 then
      raise EZipMaster.CreateResDisp(CF_DestFileNoOpen, True);

    // Get the date-time stamp and save for later.
    FDateStamp := FileGetDate(In2FileHandle);

    // Write the SFX header if present.
    if CopyBuffer(In2FileHandle, FOutFileHandle,
      DestZipMaster.SFXOffset) <> 0 then
      raise EZipMaster.CreateResDisp(CF_SFXCopyError, True);

    NotCopiedFiles := TStringList.Create();
    // Now walk trough the destination, copying and replacing
    DestMemCount   := DestZipMaster.ZipContents.Count;

    MDZD := TMZipDataList.Create(DestMemCount);

    // Copy the local data and save central header info for later use.
    for d := 0 to DestMemCount - 1 do
    begin
      zde := pZipDirEntry(DestZipMaster.ZipContents.Items[d]);
      if (zde^.Flag and $E000) = $6000 then // Ask first if we may overwrite.
      begin
        Overwrite := False;
        // Do we have a event assigned for this then don't ask. 
        if Assigned(OnCopyZipOverwrite) then
          OnCopyZipOverwrite(DestZipMaster, zde^.FileName, Overwrite)
        else if ZipMessageDlg('', Format(ZipLoadStr(CF_OverwriteYN),
          [zde^.FileName, DestZipMaster.ZipFileName]),
          zmtConfirmation + DHC_CpyZipOvr, [mbYes, mbNo]) = idYes then
          //        else if MessageBox(FHandle, PChar(Format(ZipLoadStr(CF_OverwriteYN
          //          {'Overwrite %s in %s ?'}), [zde^.FileName,
          //          DestZipMaster.ZipFileName])),
          //          PChar(Application.Title), MB_YESNO or MB_ICONQUESTION or
          //          MB_DEFBUTTON2) = idYes then
          Overwrite := True;
        zde^.Flag := zde^.Flag and $1FFF;   // Clear the three upper bits.
        if Overwrite then
          zde^.Flag := zde^.Flag or $4000
        else
          zde^.Flag := zde^.Flag or $8000;
      end;
      // Change info for later while writing the central dir in new Dest.
      MDZDp := MDZD[d];
      MDZDp^.RelOffLocal := FileSeek64(FOutFileHandle, Int64(0), 1);

      if (zde^.Flag and $6000) = $0000 then
        // Copy from original dest to new dest.
      begin
        // Set the file pointer to the start of the local header.
        FileSeek64(In2FileHandle, Int64(zde^.RelOffLocalHdr), 0);
        if CopyBuffer(In2FileHandle, FOutFileHandle, SizeOf(ZipLocalHeader) +
          zde^.FileNameLength + zde^.ExtraFieldLength +
          zde^.CompressedSize) <> 0 then
          raise EZipMaster.CreateResFile(CF_CopyFailed,
            DestZipMaster.ZipFileName, DestZipMaster.ZipFileName);
        if zde^.Flag and $8000 <> 0 then
        begin
          NotCopiedFiles.Add(zde^.FileName);
          // Delete also from FSpecArgs, should not be deleted from source later.
          FSpecArgs.{A}Delete(FSpecArgs.IndexOf(zde^.FileName));
        end;
      end
      else
        for s := 0 to Count - 1 do
        begin
          pzd := pZipDirEntry(ZipContents.Items[s]);
          if AnsiStrIComp(PChar(pzd^.FileName), PChar(zde^.FileName)) = 0 then
          begin
            FileSeek64(FInFileHandle, Int64(pzd^.RelOffLocalHdr), 0);
            if CopyBuffer(FInFileHandle, FOutFileHandle,
              SizeOf(ZipLocalHeader) + pzd^.FileNameLength +
              pzd^.ExtraFieldLength + pzd^.CompressedSize) <> 0 then
              raise EZipMaster.CreateResFile(CF_CopyFailed, ZipFileName,
                DestZipMaster.ZipFileName);
            Break;
          end;
        end;
      // Save the file name info in the MDZD structure.
      MDZDp^.FileNameLen := zde^.FileNameLength;
      StrPLCopy(MDZDp^.FileName, zde^.FileName, zde^.FileNameLength);
    end;                                    // Now we have written al entries.

    // Now write the central directory with possibly changed offsets.
    // Remember the EOC we are going to use is from the wrong input file!
    EOC.CentralSize := 0;
    for d := 0 to DestMemCount - 1 do
    begin
      zde   := pZipDirEntry(DestZipMaster.ZipContents.Items[d]);
      pzd   := NIL;
      Found := False;
      // Rebuild the CEH structure.
      if (zde^.Flag and $6000) = $0000 then
        // Copy from original dest to new dest.
      begin
        pzd   := pZipDirEntry(DestZipMaster.ZipContents.Items[d]);
        Found := True;
      end
      else                                  // Copy from source to new dest.
        for s := 0 to Count - 1 do
        begin
          pzd := pZipDirEntry(ZipContents.Items[s]);
          if AnsiStrIComp(PChar(pzd^.FileName), PChar(zde^.FileName)) = 0 then
          begin
            Found := True;
            Break;
          end;
        end;
      if not Found then
        raise EZipMaster.CreateResFile(CF_SourceNotFound, zde^.FileName,
          ZipFileName);
      CopyMemory( @CEH.VersionMadeBy0, pzd, SizeOf(ZipCentralHeader) - 4);
      CEH.HeaderSig := CentralFileHeaderSig;
      CEH.Flag := CEH.Flag and $1FFF;
      MDZDp := MDZD[d];
      CEH.RelOffLocal := MDZDp^.RelOffLocal;
      // Save the first Central directory offset for use in EOC record.
      if d = 0 then
        EOC.CentralOffset := FileSeek64(FOutFileHandle, Int64(0), 1);
      EOC.CentralSize := EOC.CentralSize + SizeOf(CEH) + CEH.FileNameLen +
        CEH.ExtraLen + CEH.FileComLen;

      // Write this changed central header to disk
      WriteJoin(CEH, SizeOf(CEH), DS_CEHBadWrite);
      //if filename was converted OEM2ISO then we have to reconvert before copying
      FVersionMadeBy1 := CEH.VersionMadeBy1;
      FVersionMadeBy0 := CEH.VersionMadeBy0;
      StrCopy(MDZDp^.FileName,
        PChar(SetSlash(ConvertOEM(MDZDp^.FileName, cpdISO2OEM),
        psdInternal)));

      // Write to destination the central filename.
      WriteJoin(MDZDp^.FileName, CEH.FileNameLen, DS_CEHBadWrite);

      // And the extra field from zde or pzd.
      if CEH.ExtraLen <> 0 then
        WriteJoin(PChar(pzd^.ExtraData)^, CEH.ExtraLen, DS_CEExtraLen);

      // And the file comment.
      if CEH.FileComLen <> 0 then
        WriteJoin(PChar(pzd^.FileComment)^, CEH.FileComLen, DS_CECommentLen);
    end;
    EOC.CentralEntries := DestMemCount;
    EOC.TotalEntries   := EOC.CentralEntries;
    EOC.ZipCommentLen  := Length(DestZipMaster.ZipComment);

    // Write the changed EndOfCentral directory record.
    WriteJoin(EOC, SizeOf(EOC), DS_EOCBadWrite);

    // And finally the archive comment
    FileSeek64(In2FileHandle, Int64(DestZipMaster.ZipEOC + SizeOf(EOC)), 0);
    if CopyBuffer(In2FileHandle, FOutFileHandle,
      Length(DestZipMaster.ZipComment)) <> 0 then
      raise EZipMaster.CreateResDisp(DS_EOArchComLen, True);

    if FInFileHandle <> -1 then
      FileClose(FInFileHandle);
    FInFileHandle := -1;
    // Now delete all copied files from the source when deletion is wanted.
    if DeleteFromSource and (FSpecArgs.Count > 0) then
    begin
      fZipBusy := False;
      Delete(); // Delete files specified in FSpecArgs and update the contents.
    end;
    FSpecArgs.Assign(NotCopiedFiles);       // Info for the caller.
  except
    on ers: EZipMaster do
      // All CopyZippedFiles specific errors..
    begin
      ShowExceptionError(ers);
      Result := -7;
    end;
    on EOutOfMemory do                      // All memory allocation errors.
    begin
      ShowZipMessage(GE_NoMem, '');
      Result := -8;
    end;
    on E: Exception do
    begin
      ShowZipMessage(DS_ErrorUnknown, E.Message);
      Result := -9;
    end;
  end;

  if Assigned(MDZD) then
    FreeAndNil(MDZD);//MDZD.Free;
  FreeAndNil(NotCopiedFiles);//NotCopiedFiles.Free;

  if FInFileHandle <> -1 then
    FileClose(FInFileHandle);
  if In2FileHandle <> -1 then
    FileClose(In2FileHandle);
  if FOutFileHandle <> -1 then
  begin
    FileSetDate(FOutFileHandle, FDateStamp);
    FileClose(FOutFileHandle);
    if Result <> 0 then
      // An error somewhere, OutFile is not reliable.
      DeleteFile(OutFilePath)
    else begin
      EraseFile(DestZipMaster.FZipFileName,
        DestZipMaster.HowToDelete = htdFinal);
      if not RenameFile(OutFilePath, DestZipMaster.FZipFileName) then
        EraseFile(OutFilePath, DestZipMaster.HowToDelete = htdFinal);
    end;
  end;
  DestZipMaster.List;
  // Update the old(possibly some entries were added temporarily) or new destination.
  StopWaitCursor;
  fZipBusy := False;
end;
//? TZipWorker.CopyZippedFiles

procedure TZipWorker.Starting; 
begin
  inherited;
end;

procedure TZipWorker.Done;
begin
  inherited;
end;

(*? TZipWorker.GetAddPassword
1.76 25 May 2004 changed
1.76 10 May 2004 change loading strings
*)
function TZipWorker.GetAddPassword(var Response: TPasswordButton): String;
var
  p1, p2: String;
begin
  p2 := '';
  if Unattended then
    ShowZipMessage(PW_UnatAddPWMiss, '')
  else begin
    Response := GetPassword(ZipLoadStr(PW_Caption),
      ZipLoadStr(PW_MessageEnter), DHC_AddPwrd1,
      mbOkCancel{[pwbCancel]}, p1);
    if (Response = mbOK{pwbOk}) and (p1 <> '') then
    begin
      Response := GetPassword(ZipLoadStr(PW_Caption),
        ZipLoadStr(PW_MessageConfirm), DHC_AddPWrd2,
        mbOkCancel{[pwbCancel]}, p2);
      if (Response = mbOK{pwbOk}) and (p2 <> '') then
        if AnsiCompareStr(p1, p2) <> 0 then
        begin
          ShowZipMessage(GE_WrongPassword, '');
          p2 := '';
        end;
    end;
  end;
  Result := p2;
end;
//? TZipWorker.GetAddPassword

(*? TZipWorker.GetExtrPassword
1.76 25 May 2004 changed
1.76 10 May 2004 change loading strings
  Same as GetAddPassword, but does NOT verify
*)
function TZipWorker.GetExtrPassword(var Response: TPasswordButton): String;
begin
  Result := '';
  if Unattended then
    ShowZipMessage(PW_UnatExtPWMiss, '')
  else
    Response := GetPassword(ZipLoadStr(PW_Caption),
      ZipLoadStr(PW_MessageEnter), DHC_ExtrPwrd,
      [mbOK, mbCancel, mbAll{pwbCancelAll}], Result);
end;
//? TZipWorker.GetExtrPassword

(*? TZipWorker.GetPassword
1.76 25 May 2004 no external GlobalResult
*)
function TZipWorker.GetPassword(DialogCaption, MsgTxt: String;
  ctx: Integer; pwb: TPasswordButtons; var ResultStr: String): TPasswordButton;
var
  GModalResult: TModalResult;
  msg: String;
begin
  msg := MsgTxt;
  ResultStr := '';
  GModalResult := ZipMessageDialog(DialogCaption, msg,
    zmtPassword + (ctx and $FFFF), pwb);
  case GModalResult of
    mrOk:
    begin
      ResultStr := msg;
      Result    := mbOK;
    end;
    mrCancel:
      Result := mbCancel;
    mrAll:
      Result := mbNoToAll;
//    mrNoToAll:
//      Result := mbAll;//CancelAll;
    else
      Result := mbAbort;
  end;
end;
//? TZipWorker.GetPassword

(*? TZipWorker.GetPassword
1.76 25 May 2004 no external GlobalResult
*)
function TZipWorker.GetPassword(DialogCaption, MsgTxt: String;
  pwb: TPasswordButtons; var ResultStr: String): TPasswordButton;
begin
  Result := GetPassword(DialogCaption, MsgTxt, DHC_Password, pwb, ResultStr);
end;
//? TZipWorker.GetPassword

(*? TZipWorker.DllCallback
1.77 15 July 2004 altered callbackStruct + message format
1.77 4 July 2004 changed callbackStruct + bytes written
1.76 25 April 2004 changes to GetXXXPassword
1.76 24 April 2004
*)
procedure TZipWorker.DllCallback(ZCallBackRec: PZCallBackStruct);
var
  OldFileName, pwd, FileComment: String;
  OrigName:  String;
  IsChanged, DoExtract, DoOverwrite: Boolean;
  RptCount:  Longword;
  Response:  TPasswordButton;
  xlen:      Integer;
  ActionCode: ActionCodes;
  XIdent:    Cardinal;
  XPreamble: Integer;
  ErrorCode: Integer;
  CMsg, M:   String;
  FileSize:  Int64;
  wrote:     Cardinal;

  function IsPathOnly(const f: String): Boolean;
  var
    c: Char;
  begin
    Result := False;
    if f <> '' then
    begin
      c := f[length(f)];
      if (c = '\') or (c = '/') then
        Result := True;
    end;
  end;

  function Msg: String;
  var
    xm: String;
  begin
    Result := CMsg;
    if Result = '' then
    begin
      if ZCallBackRec^.Zero = 0 then
        CMsg := ZCallBackRec^.FName
      else
        CMsg := String(ZCallBackRec^.FileNameOrMsg);
      CMsg := SetSlash({TrimRight(}CMsg{)}, psdExternal);
      if XIdent <> 0 then
      begin
        xm := ZipLoadStr(XIdent);
        if xm <> '' then
          CMsg := xm + ' ' + copy(CMsg, XPreamble, Length(CMsg) - XPreamble);
      end;
      Result := CMsg;
    end;
  end;

begin
  if fIsDestructing then                    // in destructor return
    exit;
  CMsg      := '';
  XIdent    := ZCallBackRec^.ActionCode;
  ActionCode := ActionCodes(XIdent and 63);
  XIdent    := XIdent and $FFFFFF00;
  XPreamble := 0;
  if XIdent <> 0 then
  begin
    XIdent    := XIdent shr 8;
    XPreamble := XIdent and 255;     // offset of filename
    XIdent    := XIdent shr 8;       // ident of message
  end;
  //  ActionCode := ActionCodes(ZCallBackRec^.ActionCode);
  ErrorCode := ZCallBackRec^.ErrorCode;
  FileSize  := ZCallBackRec^.FileSize;
  try
    //    Msg := SetSlash(TrimRight(string(ZCallBackRec^.FileNameOrMsg)), psdExternal);
    if (ActionCode <= zacSize) or (ActionCode = zacXItem) or
      (ActionCode = zacXProgress) then
    begin
      wrote := 0;
      if ActionCode = zacTick then
        m := ''
      else
        m := Msg;
      case ActionCode of
        zacItem..zacEndOfBatch:
          wrote := ZCallBackRec^.Data;
        zacSize:
        begin
          FileSize  := (Int64(ErrorCode) shl 32) + FileSize;
          ErrorCode := 0;
        end;
      end;
      Report(ActionCode, ErrorCode, Msg, FileSize, wrote);
    end
    else begin
      case ActionCode of
        zacNewName:
          { request for a new path+name just before zipping or extracting }
        begin
          if Assigned(OnSetNewName) then
          begin
            OldFileName := Msg;
            IsChanged   := False;

            OnSetNewName(Master, OldFileName, IsChanged);
            if IsChanged then
            begin
              StrPLCopy(ZCallBackRec^.FileNameOrMsg, OldFileName, 512);
              ZCallBackRec^.ErrorCode := 1;
            end
            else
              ZCallBackRec^.ErrorCode := 0;
          end;
          if (FileSize = 0) and Assigned(OnSetAddName) then
          begin
            OrigName    := SetSlash(PChar(ZCallBackRec^{.X}.Data),
              psdExternal);
            OldFileName := Msg;
            IsChanged   := False;

            OnSetAddName(Master, OldFileName, OrigName, IsChanged);
            if IsChanged then
            begin
              StrPLCopy(ZCallBackRec^.FileNameOrMsg, OldFileName, 512);
              ZCallBackRec^.ErrorCode := 1;
            end
            else
              ZCallBackRec^.ErrorCode := 0;
          end;
        end;

        zacPassword:
          { New or other password needed during Extract() }
        begin
          pwd      := '';
          RptCount := FileSize;
          Response := mbOK;//pwbOk;

          if Assigned(OnPasswordError) then
          begin
            OnPasswordError(Master, ZCallBackRec^.IsOperationZip,
              pwd, Msg, RptCount,
              Response);
            if Response <> mbOK then
              pwd := '';
          end
          else if (ErrorCode and $01) <> 0 then
            pwd := GetAddPassword(Response)
          else
            pwd := GetExtrPassword(Response);

          if pwd <> '' then
          begin
            StrPLCopy(ZCallBackRec^.FileNameOrMsg, pwd, PWLEN);
            ZCallBackRec^.ErrorCode := 1;
          end
          else begin
            RptCount := 0;
            ZCallBackRec^.ErrorCode := 0;
          end;
          if RptCount > 15 then
            RptCount := 15;
          ZCallBackRec^.FileSize := RptCount;
          if Response = mbNoToAll{pwbCancelAll} then // Cancel all
            ZCallBackRec^.ActionCode := 0;
          if Response = mbAbort then     // Abort
            Cancel := True;
        end;

        zacCRCError: { CRC32 error, (default action is extract/test the file) }
        begin
          DoExtract := True;
          // This was default for versions <1.6
          if Assigned(OnCRC32Error) then
            OnCRC32Error(Master, Msg, ErrorCode, FileSize, DoExtract);
          ZCallBackRec^.ErrorCode := Integer(DoExtract);
          { This will let the Dll know it should send some warnings }
          if not Assigned(OnCRC32Error) then
            ZCallBackRec^.ErrorCode := 2;
        end;

        zacOverwrite:                       { Extract(UnZip) Overwrite ask }
          if Assigned(OnExtractOverwrite) then
          begin
            DoOverwrite := Boolean(FileSize);
            OnExtractOverwrite(Master, Msg,
              (ErrorCode and $10000) = $10000,
              DoOverwrite, ErrorCode and $FFFF);
            ZCallBackRec^.FileSize := Integer(DoOverwrite);
          end;

        zacSkipped:                         { Extract(UnZip) and Skipped }
        begin
          if ErrorCode <> 0 then
          begin
            ErrCode      := Integer(Char(ErrorCode and $FF));
            FFullErrCode := ErrorCode;
          end;
          if Assigned(OnExtractSkipped) then
            OnExtractSkipped(Master, Msg, UnZipSkipTypes(
              (FileSize and $FF) - 1),
              ZCallBackRec^.ErrorCode)//;
          else if Assigned(OnMessage) then
            OnMessage(Master, GE_Unknown, 'Skipped ' +
              Msg + ' ' + IntToStr((FileSize and $FF) - 1));
        end;

        zacComment:                         { Add(Zip) FileComments. v1.60L }
          if Assigned(OnFileComment) then
          begin
            //            FileComment := ZCallBackRec^.FileNameOrMsg + 256;
            FileComment := ZCallBackRec^.FileComment;
            IsChanged   := False;
            OnFileComment(Master, Msg, FileComment, IsChanged);
            if IsChanged then
              if (FileComment <> '') then
                StrPLCopy(ZCallBackRec^.FileNameOrMsg, FileComment, 511)
              else
                ZCallBackRec^.FileNameOrMsg[0] := #0;
            ZCallBackRec^.ErrorCode := Integer(IsChanged);
            FileSize := Length(FileComment);
            if FileSize > 511 then
              FileSize := 511;
            ZCallBackRec^.FileSize := FileSize;
          end;

        zacStream:                          { Stream2Stream extract. v1.60M }
        begin
          try
            FZipStream.SetSize(FileSize);
          except
            ZCallBackRec^.ErrorCode := 1;
            ZCallBackRec^.FileSize  := 0;
          end;
          if ZCallBackRec^.ErrorCode <> 1 then
            ZCallBackRec^.FileSize := Integer(FZipStream.Memory);
        end;

        zacData:                            { Set Extra Data v1.72 }
          if Assigned(OnFileExtra) then
          begin
            SetLength(FStoredExtraData, FileSize);
            if FileSize > 0 then
              move(PChar(ZCallBackRec^.Data)^,
                PChar(FStoredExtraData)^, FileSize);
            //   FStoredExtraData := XData;    // hold copy
            IsChanged := False;
            OnFileExtra(Master, Msg, FStoredExtraData, IsChanged);
            if IsChanged then
            begin
              xlen := Length(FStoredExtraData);
              if (xlen > 0) then
                if (xlen < 512) then
                  move(PChar(FStoredExtraData)^,
                    ZCallBackRec^.FileNameOrMsg, xlen)
                else
                  ZCallBackRec^.Data := Cardinal(PChar(FStoredExtraData));
              ZCallBackRec^.FileSize := xlen;
              ZCallBackRec^.ErrorCode := -1;
            end;
          end;

        zacExtName:
          { request for a new path+name just before zipping or extracting }
          if Assigned(OnSetExtName) then
          begin
            OldFileName := Msg;
            IsChanged   := False;
            OnSetExtName(Master, OldFileName, IsChanged);
            if IsChanged and (OldFileName <> Msg) and
              (IsPathOnly(OldFileName) = IsPathOnly(Msg)) then
            begin
              StrPLCopy(ZCallBackRec^.FileNameOrMsg, OldFileName, 512);
              ZCallBackRec^.ErrorCode := 1;
            end
            else
              ZCallBackRec^.ErrorCode := 0;
          end;
      end;                                  {end case }
      Report(zacNone, 0, '', 0);            // process messages
    end;
  except
    on E: Exception do
    begin
      if fEventErr = '' then                // catch first exception only
        fEventErr := ' #' + IntToStr(Ord(ActionCode)) + ' "' + E.Message + '"';
      Cancel := True;
    end;
  end;
end;
//? TZipWorker.DllCallback

(*? TZipWorker.ExtAdd
1.78 4 Oct 2004 RA no_sfx error message
1.76 26 May 2004 RP use shielded FSpecArgs
1.76 13 May 2004 RP change RootDir support and allow Freshen/Update with no args
1.76 24 April 2004 RP change checking no files
1.76 17 April 2004 RP change exception reporting
1.75 16 March 2004 RA only forceDir on hard drive
1.73.2.6 7 September 2003 RP allow Freshen/Update with no args
1.73  4 August 2003 RA fix removal of '< '
1.73 17 July 2003 RP reject '< ' as password ' '
1.73 16 July 2003 RA load Dll in try except
1.73 16 July 2003 RP trim filenames
1.73 15 July 2003 RA remove '<' from filename
1.73 12 July 2003 RP release held File Data  + test destination drive
1.73 27 June 2003 RP changed slplit file support
// UseStream = 0 ==> Add file to zip archive file.
// UseStream = 1 ==> Add stream to zip archive file.
// UseStream = 2 ==> Add stream to another (zipped) stream.
*)

procedure TZipWorker.ExtAdd(UseStream: Integer; StrFileDate, StrFileAttr: DWORD;
  MemStream: TMemoryStream);
var
  i, DLLVers: Integer;
{$IFNDEF NO_SFX}
  SFXResult: Integer;
{$ENDIF}
  Tmp, TmpZipName: String;
  pFDS:     pFileData;
  pExFiles: pExcludedFileSpec;
  len, b, p, RootLen: Integer;
  FDSSpec:  String;       // 1.76
  rdir:     String;
begin
  FSuccessCnt := 0;
  if (UseStream = 0) and (fFSpecArgs.Count = 0) then
  begin
    if not ((AddFreshen in FAddOptions) or (AddUpdate in FAddOptions)) then
    begin
      ShowZipMessage(AD_NothingToZip, '');
      Exit;
    end;
    FAddOptions := (FAddOptions - [AddUpdate]) + [AddFreshen];
    FFSpecArgs.{A}Add('*.*');                 // do freshen all
  end;
  if (AddDiskSpanErase in FAddOptions) then
  begin
    FAddOptions  := FAddOptions + [AddDiskSpan]; // make certain set
    FSpanOptions := FSpanOptions + [spWipeFiles];
  end;
{$IFDEF NO_SPAN}
  if (AddDiskSpan in FAddOptions) then
  begin
    ShowZipMessage(DS_NODISKSPAN, '');
    Exit;
  end;
{$ENDIF}
  { We must allow a zipfile to be specified that doesn't already exist,
    so don't check here for existance. }
  if (UseStream < 2) and (FZipFileName = '') then
    { make sure we have a zip filename }
  begin
    ShowZipMessage(GE_NoZipSpecified, '');
    Exit;
  end;
  // We can not do an Unattended Add if we don't have a password.
  if FUnattended and (AddEncrypt in FAddOptions) and (FPassword = '') then
  begin
    ShowZipMessage(AD_UnattPassword, '');
    Exit;
  end;

  // If we are using disk spanning, first create a temporary file
  if (UseStream < 2) and (AddDiskSpan in FAddOptions) then
  begin
{$IFDEF NO_SPAN}
    ShowZipMessage(DS_NoDiskSpan, '');
    exit;
{$ELSE}
    // We can't do this type of Add() on a spanned archive.
    if (AddFreshen in FAddOptions) or (AddUpdate in FAddOptions) then
    begin
      ShowZipMessage(AD_NoFreshenUpdate, '');
      Exit;
    end;
    // We can't make a spanned SFX archive
    if (UpperCase(ExtractFileExt(FZipFileName)) = '.EXE') then
    begin
      ShowZipMessage(DS_NoSFXSpan, '');
      Exit;
    end;
    TmpZipName := MakeTempFileName('', '');

    if Verbose and Assigned(OnMessage) then
      OnMessage(Master, 0, ZipFmtLoadStr(GE_TempZip, [TmpZipName]));
{$ENDIF}
  end
  else
    TmpZipName := FZipFileName;
  // not split - create the outfile directly

  { Make sure we can't get back in here while work is going on }
  if fZipBusy then
    Exit;

  if (UseStream < 2) and (Uppercase(ExtractFileExt(FZipFileName)) = '.EXE') and
    (FSFXOffset = 0) and not FileExists(FZipFileName) then
{$IFNDEF NO_SFX}
    try
      { This is the first "add" operation following creation of a new
        .EXE archive.  We need to add the SFX code now, before we add
        the files. }
      AutoExeViaAdd := True;
      SFXResult     := NewSFXFile(FZipFileName); //1.72x ConvertSFX;
      AutoExeViaAdd := False;
      if SFXResult <> 0 then
        raise EZipMaster.CreateResDisk(AD_AutoSFXWrong, SFXResult);
    except
      on ews: EZipMaster do
        // All SFX creation errors will be caught and returned in this one message.
      begin
        ShowExceptionError(ews);
        Exit;
      end;
    end;
{$ELSE}
//  raise EZipMaster.CreateResDisp(SF_NoSFXSupport, True);
    begin
      ShowZipMessage(SF_NoSFXSupport, '');
      exit;
    end;
{$ENDIF}
  try
    DLLVers := FZipDll.LoadDll(ZIPVERSION {Min_ZipDll_Vers}, False);
  except
    on ews: EZipMaster do
    begin
      ShowExceptionError(ews);
      exit;
    end;
  end;
  if DLLVers = 0 then
    exit;                                   // could not load valid dll

  fZipBusy := True;
  Cancel   := False;

  StartWaitCursor;
  try
    try
      ZipParms := AllocMem(SizeOf(ZipParms2));
      SetZipSwitches(TmpZipName, DLLVers);

      // make certain destination can exist
      //      if (UseStream < 2) then
      if (UseStream < 2) and (FDriveFixed or not
        (AddDiskSpan in FAddOptions)) then
        // 1.75 RA
      begin
        if AddForceDest in FAddOptions then
          ForceDirectory(ExtractFilePath(FZipFileName));
        if not DirExists(ExtractFilePath(FZipFileName)) then
          raise EZipMaster.CreateResDrive(AD_NoDestDir,
            ExtractFilePath(FZipFileName));
      end;

      with ZipParms^ do
      begin
        if UseStream = 1 then
        begin
          fUseInStream  := True;
          fInStream     := FZipStream.Memory;
          fInStreamSize := FZipStream.Size;
          fStrFileAttr  := StrFileAttr;
          fStrFileDate  := StrFileDate;
        end;
        if UseStream = 2 then
        begin
          fUseOutStream  := True;
          fOutStream     := FZipStream.Memory;
          fOutStreamSize := MemStream.Size + 6;
          fUseInStream   := True;
          fInStream      := MemStream.Memory;
          fInStreamSize  := MemStream.Size;
        end;
        // 1.76 set global RootDir
        if FRootDir <> '' then
        begin
          rdir      := ExpandFileName(fRootDir); // allow relative root
          RootLen   := Length(rdir);
          fGRootDir := StrAlloc(RootLen + 1);
          StrPLCopy(fGRootDir, rdir, RootLen + 1);
        end;
        argc := fSpecArgs.Count;
        fFDS := AllocMem(SizeOf(FileData) * FFSpecArgs.Count);
        for i := 0 to pred(FFSpecArgs.Count) do
        begin
          pFDS := fFDS;
          Inc(pFDS, i);
          FDSSpec := FFSpecArgs.Strings[i];
          len := Length(FDSSpec);
          p := 1;

          // Added to version 1.60L to support recursion and encryption on a FFileSpec basis.
          // Regardless of what AddRecurseDirs is set to, a '>' will force recursion, and a '|' will stop recursion.
          pFDS.fRecurse := Word(fRecurse);  // Set default
          if Copy(FDSSpec, 1, 1) = '>' then
          begin
            pFDS.fRecurse := $FFFF;
            Inc(p);
          end;
          if Copy(FDSSpec, 1, 1) = '|' then
          begin
            pFDS.fRecurse := 0;
            Inc(p);
          end;

          // Also it is possible to specify a password after the FFileSpec, separated by a '<'
          // If there is no other text after the '<' then, an existing password, is temporarily canceled.
          pFDS.fEncrypt := Longword(fEncrypt); // Set default
          if Length(pZipPassword) > 0 then  // v1.60L
          begin
            pFDS.fPassword := StrAlloc(Length(pZipPassword) + 1);
            StrLCopy(pFDS.fPassword, pZipPassword, Length(pZipPassword));
          end;
          b := AnsiPos('<', FDSSpec);
          if b <> 0 then
          begin                             // Found...
            pFDS.fEncrypt := $FFFF;         // the new default, but...
            StrDispose(pFDS.fPassword);
            pFDS.fPassword := NIL;
            tmp := Copy(FDSSpec, b + 1, 1);
            if (tmp = '') or (tmp = ' ') then
            begin
              pFDS.fEncrypt := 0;
              // No password, so cancel for this FFspecArg
              Dec(len, Length(tmp) + 1);
            end
            else begin
              pFDS.fPassword := StrAlloc(len - b + 1);
              StrPLCopy(pFDS.fPassword, Copy(FDSSpec, b + 1, len - b),
                len - b + 1);
              len := b - 1;
            end;
          end;

          // And to set the RootDir, possibly later with override per FSpecArg v1.70
          //          if RootDir <> '' then
          //          begin
          //            rdir    := ExpandFileName(fRootDir); // allow relative root
          //            RootLen := Length(rdir);
          //            pFDS.fRootDir := StrAlloc(RootLen + 1);
          //            StrPLCopy(pFDS.fRootDir, rdir, RootLen + 1);
          //          end;
          // 1.76 only set if different to global
          pFDS.fRootDir := NIL;
          tmp := Trim(Copy(FDSSpec, p, len - p + 1));
          if tmp <> '' then
          begin
            pFDS.fFileSpec := StrAlloc(Length(tmp) + 1);
            StrPLCopy(pFDS.fFileSpec, tmp, Length(tmp) + 1);
          end
          else
            pFDS.fFileSpec := NIL;
        end;
        fSeven := 7;
      end;                                  { end with }

      //      ZipParms.argc := fSpecArgs.Count;
      FEventErr   := '';                      // added
      { pass in a ptr to parms }
      fSuccessCnt := FZipDLL.Exec(ZipParms);
      (*      if fSuccessCnt < 0 then
            begin
              if FEventErr<>'' then
              ShowZipMessage(GE_FatalZip, ' VCL event: '+FEventErr)
              else
              ShowZipMessage(GE_FatalZip, {' fatal Dll'}' error: '+IntToStr(FSuccessCnt));
              fSuccessCnt := 0;
            end;   *)
      // If Add was successful and we want spanning, copy the
      // temporary file to the destination.
      if (UseStream < 2) and (fSuccessCnt > 0) and
        (AddDiskSpan in FAddOptions) then
{$IFDEF NO_SPAN}
        raise EZipMaster.CreateResDisp(DS_NODISKSPAN, True);
{$ELSE}
      begin
        // write the temp zipfile to the right target:
        if WriteSpan(TmpZipName, FZipFileName, True) <> 0 then
          fSuccessCnt := 0;                 // error occurred during write span
        DeleteFile(TmpZipName);
      end;
{$ENDIF}
      if (UseStream = 2) and (FSuccessCnt = 1) then
        FZipStream.SetSize(ZipParms.fOutStreamSize);
    except
      on ews: EZipMaster do
      begin
        if FEventErr <> '' then
          ews.Message := ews.Message + FEventErr;
        ShowExceptionError(ews);
      end
      else
        ShowZipMessage(GE_FatalZip, '');
    end;
  finally
    fFSpecArgs.Clear;
    fFSpecArgsExcl.Clear;
    with ZipParms^ do
    begin
      { Free the memory for the zipfilename and parameters }
      { we know we had a filename, so we'll dispose it's space }
      StrDispose(pZipFN);
      StrDispose(pZipPassword);
      StrDispose(pSuffix);
      pZipPassword := NIL;                  // v1.60L

      StrDispose(fTempPath);
      StrDispose(fArchComment);
      StrDispose(fGRootDir);                // 1.76
      for i := (Argc - 1) downto 0 do
      begin
        pFDS := fFDS;
        Inc(pFDS, i);
        StrDispose(pFDS.fFileSpec);
        StrDispose(pFDS.fPassword);         // v1.60L
        StrDispose(pFDS.fRootDir);          // v1.60L
      end;
      FreeMem(fFDS);
      for i := (fTotExFileSpecs - 1) downto 0 do
      begin
        pExFiles := fExFiles;
        Inc(pExFiles, i);
        StrDispose(pExFiles.fFileSpec);
      end;
      FreeMem(fExFiles);
    end;
    FreeMem(ZipParms);
    ZipParms := NIL;
    StopWaitCursor;
  end;                                      {end try finally }

  FZipDll.Unload(False);

  FStoredExtraData := '';                   // release held data
  Cancel   := False;
  fZipBusy := False;
  if fSuccessCnt > 0 then
    List;
  // Update the Zip Directory by calling List method
end;
//? TZipWorker.ExtAdd

(*? ZCallback
1.76 01 May 2004 RP change return type and value to return flag for exception
1.76 24 April 2004 RP use DllCallback
1.73 ( 1 June 2003) changed for new callback
{ Dennis Passmore (Compuserve: 71640,2464) contributed the idea of passing an
 instance handle to the DLL, and, in turn, getting it back from the callback.
 This lets us referance variables in the TZipWorker class from within the
 callback function.  Way to go Dennis!
 Modified by Russell Peters }
*)

function ZCallback(ZCallBackRec: PZCallBackStruct): LongInt; stdcall;
begin
  with TObject(ZCallBackRec^.Caller) as TZipWorker do
  begin
    DllCallback(ZCallBackRec);
    if fEventErr <> '' then
      Result := 10106                       // handled exception
    else
      Result := Ord(Cancel);
  end;
end;
//? ZCallback

(*? TZipWorker.SetCancel
1.76 10 May 2004 remove AbortDlls
1.76 28 April 2004 add side effect of aborting dll when setting true
*)
procedure TZipWorker.SetCancel(Value: Boolean);
begin
  if Cancel <> Value then
    inherited;
end;
//? TZipWorker.SetCancel

(*? TZipWorker.AbortDlls
1.76 28 April 2004 abort both dlls (only if loaded)
*)
procedure TZipWorker.AbortDlls;
begin
  if assigned(FZipDll) then
    FZipDll.Abort;
  if assigned(FUnzDll) then
    FUnzDll.Abort;
  Cancel := True;
end;
//? TZipWorker.AbortDlls

(*? TZipWorker.ExtExtract
1.76 19 May 2004 show exception information
1.76  5 May 2004 fix 'No Input File' on multipart extract
1.76 28 April 2004 do not check destination when testing (ExtrTest is active)
1.73.2.6 17 September 2003 RA stop duplicate 'cannot open file' messages
1.73 22 July 2003 RA exception handling for EZipMaster + fUnzBusy := False when dll load error
1.73 16 July 2003 RA catch and display dll load errors
1.73 12 July 2003 RP allow ForceDirectories
// UseStream = 0 ==> Extract file from zip archive file.
// UseStream = 1 ==> Extract stream from zip archive file.
// UseStream = 2 ==> Extract (zipped) stream from another stream.
*)

procedure TZipWorker.ExtExtract(UseStream: Integer; MemStream: TMemoryStream);
var
  i, UnzDLLVers: Integer;
  OldPRC:     Integer;
  TmpZipName: String;
  pUFDS:      pUnzFileData;
{$IFNDEF NO_SPAN}
  NewName:    array[0..512] of Char;
{$ENDIF}
begin
  FSuccessCnt := 0;
  FErrCode    := 0;
  FMessage    := '';
  OldPRC      := FPasswordReqCount;

  if (UseStream < 2) then
  begin
    if (FZipFileName = '') then
    begin
      ShowZipMessage(GE_NoZipSpecified, '');
      Exit;
    end; {
    if ( not FileExists(FZipFileName)) then
    begin
      ShowZipMessage(DS_NoInFile, '');
      Exit;
    end;       }
    if Count = 0 then
      List;                                 // try again
    if Count = 0 then
    begin
      if FErrCode = 0 then                  // only show once
        ShowZipMessage(DS_FileOpen, '');
      exit;
    end;
  end;

  { Make sure we can't get back in here while work is going on }
  if fUnzBusy then
    Exit;

  // We have to be carefull doing an unattended Extract when a password is needed
  // for some file in the archive.
  if FUnattended and (FPassword = '') and not
    Assigned({TZipMaster(Master).}OnPasswordError) then
  begin
    FPasswordReqCount := 0;
    ShowZipMessage(EX_UnAttPassword, '');
  end;

  Cancel   := False;
  fUnzBusy := True;

  // We do a check if we need UnSpanning first, this depends on
  // The number of the disk the EOC record was found on. ( provided by List() )
  // If we have a spanned set consisting of only one disk we don't use ReadSpan().
  if FTotalDisks <> 0 then
  begin
{$IFDEF NO_SPAN}
    fUnzBusy := False;
    ShowZipMessage(DS_NODISKSPAN, '');
    exit;
{$ELSE}
    if FTempDir = '' then
    begin
      GetTempPath(MAX_PATH, NewName);
      TmpZipName := NewName;
    end
    else
      TmpZipName := AppendSlash(FTempDir);
    if ReadSpan(FZipFileName, TmpZipName, True) <> 0 then
    begin
      fUnzBusy := False;
      Exit;
    end;
    // We returned without an error, now  TmpZipName contains a real name.
{$ENDIF}
  end
  else
    TmpZipName := FZipFileName;
  try
    UnzDLLVers := FUnzDll.LoadDll(UNZIPVERSION {Min_UnzDll_Vers}, False);
  except
    on ews: EZipMaster do
    begin
      ShowExceptionError(ews);
      UnzDLLVers := 0;
    end;
  end;
  if UnzDllVers = 0 then
  begin
    FUnzBusy := False;
    exit;                                   // could not load valid DLL
  end;
  try
    try
      UnZipParms := AllocMem(SizeOf(UnZipParms2));
      SetUnZipSwitches(TmpZipName, UnzDLLVers);

      with UnzipParms^ do
      begin
        if (FExtrBaseDir <> '') and not (ExtrTest in FExtrOptions) then
        begin
          if ExtrForceDirs in FExtrOptions then
            ForceDirectory(FExtrBaseDir);
          if not DirExists(FExtrBaseDir) then
            raise EZipMaster.CreateResDrive(EX_NoExtrDir, FExtrBaseDir);
          fExtractDir := StrAlloc(Length(fExtrBaseDir) + 1);
          StrPLCopy(fExtractDir, fExtrBaseDir, Length(fExtrBaseDir));
        end
        else
          fExtractDir := NIL;

        fUFDS := AllocMem(SizeOf(UnzFileData) * FFSpecArgs.Count);
        // 1.70 added test - speeds up extract all
        if (fFSpecArgs.Count <> 0) and (fFSpecArgs[0] <> '*.*') then
        begin
          for i := 0 to (fFSpecArgs.Count - 1) do
          begin
            pUFDS := fUFDS;
            Inc(pUFDS, i);
            pUFDS.fFileSpec := StrAlloc(Length(fFSpecArgs[i]) + 1);
            StrPLCopy(pUFDS.fFileSpec, fFSpecArgs[i],
              Length(fFSpecArgs[i]) + 1);
          end;
          fArgc := FFSpecArgs.Count;
        end
        else
          fArgc := 0;
        if UseStream = 1 then
          for i := 0 to Count - 1 do
            // Find the wanted file in the ZipDirEntry list.
            with ZipDirEntry(ZipContents[i]^) do
              if AnsiStrIComp(PChar(FFSpecArgs.Strings[0]),
                PChar(FileName)) = 0 then
              begin                         // Found?
                FZipStream.SetSize(UncompressedSize);
                fUseOutStream := True;
                fOutStream := FZipStream.Memory;
                fOutStreamSize := UncompressedSize;
                fArgc := 1;
                Break;
              end;
        if UseStream = 2 then
        begin
          fUseInStream   := True;
          fInStream      := MemStream.Memory;
          fInStreamSize  := MemStream.Size;
          fUseOutStream  := True;
          fOutStream     := FZipStream.Memory;
          fOutStreamSize := FZipStream.Size;
        end;
        fSeven := 7;
      end;
      FEventErr := '';                      // added
      { Argc is now the no. of filespecs we want extracted }
      if (UseStream = 0) or ((UseStream > 0) and UnZipParms.fUseOutStream) then
        fSuccessCnt := fUnzDLL.Exec({Pointer(}UnZipParms {)});
      { Remove from memory if stream is not Ok. }
(*      if (UseStream > 0) and (FSuccessCnt <> 1) then
        FZipStream.Clear();
      { If UnSpanned we still have this temporary file hanging around. }
      if FTotalDisks > 0 then
        DeleteFile(TmpZipName); *)
    except
      {  on ezl: EZipMaster do
          ShowExceptionError(ezl)
        else
          ShowZipMessage(EX_FatalUnZip, '');}
      on ews: EZipMaster do
      begin
        if FEventErr <> '' then
          ews.Message := ews.Message + FEventErr;
        ShowExceptionError(ews);
        FSuccessCnt := 0;
      end;
      else begin
        ShowZipMessage(EX_FatalUnZip, '');
        FSuccessCnt := 0;
      end;
    end;
  finally
    fFSpecArgs.{A}Clear;
    { Remove from memory if stream is not Ok. }
    if (UseStream > 0) and (FSuccessCnt <> 1) then
      FZipStream.Clear();
    { If UnSpanned we still have this temporary file hanging around. }
    if FTotalDisks > 0 then
      DeleteFile(TmpZipName);
    with UnZipParms^ do
    begin
      StrDispose(pZipFN);
      StrDispose(pZipPassword);
      if (fExtractDir <> NIL) then
        StrDispose(fExtractDir);

      for i := (fArgc - 1) downto 0 do
      begin
        pUFDS := fUFDS;
        Inc(pUFDS, i);
        StrDispose(pUFDS.fFileSpec);
      end;
      FreeMem(fUFDS);
    end;
    FreeMem(UnZipParms);

    UnZipParms := NIL;
  end;

  if FUnattended and (FPassword = '') and not
    Assigned(OnPasswordError) then
    FPasswordReqCount := OldPRC;

  FUnzDll.Unload(False);
  Cancel   := False;
  fUnzBusy := False;
  { no need to call the List method; contents unchanged }
end;
//? TZipWorker.ExtExtract

(*? TZipWorker.SetActive
1.76
*)
procedure TZipWorker.SetActive(Value: Boolean);
begin
  if Active <> Value then
  begin
    FActive := Value;
    if FActive then
    begin                                   // do delayed action
      if zdiList in FDelaying then
        List;
      if zdiComment in FDelaying then
        SetZipComment(FZipComment);
    end;
    FDelaying := [];
  end;
end;
//? TZipWorker.SetActive

(*? TZipWorker.SetFilename
1.76 27 April 2004 _List controlled by 'Inactive'
*)
procedure TZipWorker.SetFilename(Value: String);
begin
  FZipFileName := Value;
  //  if not (assigned(Master) and (csDesigning in Master.ComponentState)) then
  List; { automatically build a new TLIST of contents in "ZipContents" }
end;
//? TZipWorker.SetFilename

(*? TZipWorker.Create
1.76 27 April 2004 - clear Active and Delaying
1.75.0.2 3 March 2004 - new event
1.75 21 February 2004 new event
// 1.73 ( 5 June 2003) - updated constructor/destructor
*)
constructor TZipWorker.Create;//(AMaster: TComponent);
begin
  inherited Create;//(AMaster);
  fIsDestructing := False;                  // new 1.73
  FActive   := False;
  fZipContents := TList.Create;
  FFSpecArgs := TStringList.Create;
  FFSpecArgsExcl := TStringList.Create;
  fHandle   := Application.Handle;
  fZipDll   := TZipDll.Create(self);
  fUnzDll   := TUnzDll.Create(self);
  FDelaying := [];
  FZipBusy  := False;
  FUnzBusy  := False;
  //  FOnCheckTerminate := NIL;
  //  FOnTick      := NIL;
  FOnFileExtra := NIL;
  FOnDirUpdate := NIL;
  //  FOnProgress  := NIL;
  //  FOnTotalProgress := NIL;
  //  FOnItemProgress := NIL;
  //  FOnMessage   := NIL;
  FOnSetNewName := NIL;
  FOnNewName := NIL;
  FOnPasswordError := NIL;
  FOnCRC32Error := NIL;
  FOnExtractOverwrite := NIL;
  FOnExtractSkipped := NIL;
  FOnCopyZipOverwrite := NIL;
  FOnFileComment := NIL;
  FOnFileExtra := NIL;
  FOnSetAddName := NIL;
  FOnSetExtName := NIL;
{$IFNDEF NO_SPAN}
  FOnGetNextDisk := NIL;
  FOnStatusDisk := NIL;
  fConfirmErase := True;
{$ENDIF}
  ZipParms  := NIL;
  UnZipParms := NIL;
  FZipFileName := '';
  FPassword := '';
  FPasswordReqCount := 1;                   { New in v1.6 }
  FEncrypt  := False;
  FSuccessCnt := 0;
  FAddCompLevel := 9;                       { dflt to tightest compression }
  AutoExeViaAdd := False;
  FUnattended := False;
  FVersionInfo := ZIPMASTERVERSION;
  FVer      := ZIPMASTERVER;
  FRealFileSize := 0;
  FSFXOffset := 0;
  FZipSOC   := 0;
  FFreeOnDisk1 := 0;
  { Don't leave any freespace on disk 1. }
  FFreeOnAllDisks := 0;                     // 1.72 { use all space }
  FMaxVolumeSize := 0;                      { Use the maximum disk size. }
  FMinFreeVolSize := 65536;
  { Reject disks with less free bytes than... }
  FCodePage := cpAuto;
  FIsSpanned := False;
  FZipComment := '';
  FHowToDelete := htdAllowUndo;
  FAddStoreSuffixes := [assGIF, assPNG, assZ, assZIP, assZOO, assARC, assLZH,
    assARJ, assTAZ, assTGZ, assLHA, assRAR, assACE, assCAB,
    assGZ, assGZIP, assJAR];
  FZipStream := TZipStream.Create;
  FUseDirOnlyEntries := False;
  FDirOnlyCount := 0;
  FSpanOptions := [];                       // new 1.72
{$IFNDEF NO_SPAN}
  fConfirmErase := True;
{$ENDIF}
{$IFNDEF NO_SFX}
  FSFX      := NIL;                              // 1.72
{$ENDIF}
end;
//? TZipWorker.Create

(*? TZipWorker.SetZipComment
1.77 4 Oct 2004 RA don't open if no file exists
1.76 27 April 2004 test Active
1.75 18 February 2004 allow >2G
1.73.3.2 11 Oct 2003 RP allow preset comment
1.73 ( 21 July 2003) RA user Get Lastvolume to add ZipComment to split archive
*)
procedure TZipWorker.SetZipComment(zComment: String);
var
  EOC:     ZipEndOfCentral;
  len:     Integer;
  CommentBuf: String;
  Fatal:   Boolean;
  FileOfs: Int64;
begin
  FInFileHandle := -1;
  Fatal := False;
  if not Active then
  begin
    FDelaying   := FDelaying + [zdiComment];
    FZipComment := zComment;
    exit;
  end;
  try
    if Length(ZipFileName) <> 0 then        // RP 1.73
{$IFNDEF NO_SPAN}
      GetLastVolume(ZipFileName, EOC, True); // will read existing comment
{$ELSE}
    if FileExists(ZipFileName) then
    OpenEOC(EOC, True);
{$ENDIF}
    FZipComment := zComment;
    // FInFileName opened by OpenEOC() only for Read
    if (FInFileHandle <> -1) then           // file exists
    begin
      FileClose(FInFileHandle);             // must reopen for read/write
      CommentBuf := ConvertOEM(zComment, cpdISO2OEM);
      if CommentBuf = FEOCComment then
        exit;                               // same - nothing to do
      len := Length(CommentBuf);
      FInFileHandle := FileOpen(FInFileName, fmShareDenyWrite or
        fmOpenReadWrite);
      if FInFileHandle = -1 then            // RP 1.60
        raise EZipMaster.CreateResDisp(DS_FileOpen, True);
      FileOfs := FZipEOC;                   // convert 64 bit
      if FileSeek64(FInFileHandle, FileOfs, 0) = -1 then
        raise EZipMaster.CreateResDisp(DS_FailedSeek, True);
      if (FileRead(FInFileHandle, EOC, SizeOf(EOC)) <> SizeOf(EOC)) or
        (EOC.HeaderSig <> EndCentralDirSig) then
        raise EZipMaster.CreateResDisp(DS_EOCBadRead, True);
      EOC.ZipCommentLen := len;
      FileOfs := -SizeOf(EOC);
      if FileSeek64(FInFileHandle, FileOfs, 1) = -1 then
        raise EZipMaster.CreateResDisp(DS_FailedSeek, True);
      Fatal := True;
      if FileWrite(FInFileHandle, EOC, SizeOf(EOC)) <> SizeOf(EOC) then
        raise EZipMaster.CreateResDisp(DS_EOCBadWrite, True);
      if FileWrite(FInFileHandle, PChar(CommentBuf)^, len) <> len then
        raise EZipMaster.CreateResDisp(DS_NoWrite, True);
      Fatal := False;
      // if SetEOF fails we get garbage at the end of the file, not nice but
      // also not important.
      SetEndOfFile(FInFileHandle);
    end;
  except
    on ews: EZipMaster do
    begin
      ShowExceptionError(ews);
      FZipComment := '';
    end;
    on EOutOfMemory do
    begin
      ShowZipMessage(GE_NoMem, '');
      FZipComment := '';
    end;
  end;
  //  FreeMem(CommentBuf);
  if FInFileHandle <> -1 then
    FileClose(FInFileHandle);
  if Fatal then
    // Try to read the zipfile, maybe it still works.
    List;
end;
//? TZipWorker.SetZipComment

(*? TZipWorker.IndexOf
1.80
 Find specified filespec  returns index of Directory entry (-1 - not found)
*)
function TZipWorker.IndexOf(const fname: String): Integer;
begin
  for Result := 0 to pred(Count) do
    if FileNameMatch(fname, DirEntry[Result].FileName) then
      exit;
  Result := -1;
end;
//? TZipWorker.IndexOf

(*? TZipWorker.Find
1.73.4
 Find specified filespec after idx (<0 - from beginning)
 returns pointer to Directory entry (nil - not found)
 sets idx to index of found entry (-1 not found)
*)
function TZipWorker.Find(const fspec: String; var idx: Integer): pZipDirEntry;
var
  c: Integer;
begin
  if idx < 0 then
    idx := -1;
  c := pred(Count);
  while idx < c do
  begin
    Inc(idx);
    Result := DirEntry[idx];
    if FileNameMatch(fspec, Result.FileName) then
      exit;
  end;
  idx    := -1;
  Result := NIL;
end;
//? TZipWorker.Find

(*? TZipWorker.Clear
1.76 26 May 2004 expanded
1.73.3.4 14 January 2004 RP added
 Clears lists and strings
*)
procedure TZipWorker.Clear;
begin
  fIsDestructing := True;                   // stop callbacks
  AbortDlls;
  FCancel := True;
  FreeZipDirEntryRecords;
  fReenter := False;

  FDelaying     := [];
  FRealFileSize := 0;
  FIsSpanned    := False;
  //  fErrCode := 0;
  FFSpecArgs.{A}Clear;
  FFSpecArgsExcl.{A}Clear;
  FZipFileName := '';
  FDelaying    := [];
  FZipBusy     := False;
  FUnzBusy     := False;
  FZipFileName := '';
  FPassword    := '';
  FPasswordReqCount := 1;                   { New in v1.6 }
  FEncrypt     := False;
  FSuccessCnt  := 0;
  FAddCompLevel := 9;                       { dflt to tightest compression }
  AutoExeViaAdd := False;
  FUnattended  := False;
  FRealFileSize := 0;
  FSFXOffset   := 0;
  FZipSOC      := 0;
  FFreeOnDisk1 := 0;
  { Don't leave any freespace on disk 1. }
  FFreeOnAllDisks := 0;                     // 1.72 { use all space }
  FMaxVolumeSize := 0;                      { Use the maximum disk size. }
  FMinFreeVolSize := 65536;
  { Reject disks with less free bytes than... }
  FCodePage    := cpAuto;
  FIsSpanned   := False;
  FZipComment  := '';
  FHowToDelete := htdAllowUndo;
  FAddStoreSuffixes := [assGIF, assPNG, assZ, assZIP, assZOO, assARC, assLZH,
    assARJ, assTAZ, assTGZ, assLHA, assRAR, assACE, assCAB,
    assGZ, assGZIP, assJAR];
  FUseDirOnlyEntries := False;
  FDirOnlyCount := 0;
  FSpanOptions := [];                       // new 1.72
{$IFNDEF NO_SPAN}
  fConfirmErase := True;
{$ENDIF}
  //  FCancel := FALSE;
  //  fIsDestructing := FALSE;                  // new 1.73
  inherited;
end;
//? TZipWorker.Clear

(*? TZipWorker.SetZipSwitches
1.75 13 March 2004 RP - supply app window handle
1.73  1 August 2003 RP - set required dll interface version
*)
procedure TZipWorker.SetZipSwitches(var NameOfZipFile: String; zpVersion: Integer);
var
  i: Integer;
  SufStr, Dts: String;
  pExFiles: pExcludedFileSpec;
begin
  with ZipParms^ do
  begin
    if Length(FZipComment) <> 0 then
    begin
      fArchComment := StrAlloc(Length(FZipComment) + 1);
      StrPLCopy(fArchComment, FZipComment, Length(FZipComment) + 1);
    end;
    if AddArchiveOnly in fAddOptions then
      fArchiveFilesOnly := 1;
    if AddResetArchive in fAddOptions then
      fResetArchiveBit := 1;

    if (FFSpecArgsExcl.Count <> 0) then
    begin
      fTotExFileSpecs := FFSpecArgsExcl.Count;
      fExFiles := AllocMem(SizeOf(ExcludedFileSpec) *
        FFSpecArgsExcl.Count);
      for i := 0 to (fFSpecArgsExcl.Count - 1) do
      begin
        pExFiles := fExFiles;
        Inc(pExFiles, i);
        pExFiles.fFileSpec := StrAlloc(Length(fFSpecArgsExcl[i]) + 1);
        StrPLCopy(pExFiles.fFileSpec, fFSpecArgsExcl[i],
          Length(fFSpecArgsExcl[i]) + 1);
      end;
    end;
    // New in v 1.6M Dll 1.6017, used when Add Move is choosen.
    if FHowToDelete = htdAllowUndo then
      fHowToMove := True;
    if FCodePage = cpOEM then
      fWantedCodePage := 2;
  end;                                      { end with }

  if (Length(FTempDir) <> 0) then
  begin
    ZipParms.fTempPath := StrAlloc(Length(FTempDir) + 1);
    StrPLCopy(ZipParms.fTempPath, FTempDir, Length(FTempDir) + 1);
  end;

  with ZipParms^ do
  begin
    Version := ZIPVERSION;                  // version we expect the DLL to be
    Caller  := Self;
    // point to our VCL instance; returned in callback
    Handle  := fHandle;                      // 1.75
    fVCLVer := ZIPVERSION;                  // 1.74 - verify not 1.72

    fQuiet := True; { we'll report errors upon notification in our callback }
    { So, we don't want the DLL to issue error dialogs }

    ZCallbackFunc := ZCallback;
    // pass addr of function to be called from DLL
    fJunkSFX      := False;
    // if True, convert input .EXE file to .ZIP

    SufStr := '';
    for i := 0 to Integer(assEXE) do
      AddSuffix(AddStoreSuffixEnum(i), SufStr, i);
    if assEXT in fAddStoreSuffixes then     // new 1.71
      SufStr := SufStr + fExtAddStoreSuffixes;
    if Length(SufStr) <> 0 then
    begin
      System.Delete(SufStr, Length(SufStr), 1);
      pSuffix := StrAlloc(Length(SufStr) + 1);
      StrPLCopy(pSuffix, SufStr, Length(SufStr) + 1);
    end;
    // fComprSpecial := False;     { if True, try to compr already compressed files }

    fSystem := False;
    { if True, include system and hidden files }

    if AddVolume in fAddOptions then
      fVolume := True
    { if True, include volume label from root dir }
    else
      fVolume := False;

    fExtra := False; { if True, include extended file attributes-NOT SUPTED }

    fDate := AddFromDate in fAddOptions;
    { if True, exclude files earlier than specified date }
    { Date := '100592'; }{ Date to include files after; only used if fDate=TRUE }
    dts   := FormatDateTime('mm dd yy', fFromDate);
    for i := 0 to 7 do
      Date[i] := dts[i + 1];

    fLevel   := FAddCompLevel;
    { Compression level (0 - 9, 0=none and 9=best) }
    fCRLF_LF := False;
    { if True, translate text file CRLF to LF (if dest Unix)}
    if AddSafe in FAddOptions then
      fGrow := False
    else
      fGrow := True;
    { if True, Allow appending to a zip file (-g)}

    fDeleteEntries := False;                { distinguish bet. Add and Delete }

    if Trace then
      fTraceEnabled := True
    else
      fTraceEnabled := False;
    if Verbose then
      fVerboseEnabled := True
    else
      fVerboseEnabled := False;
    if (fTraceEnabled and not Verbose) then
      fVerboseEnabled := True;
    { if tracing, we want verbose also }

    if AddForceDOS in fAddOptions then
      fForce := True
    { convert all filenames to 8x3 format }
    else
      fForce := False;
    if AddZipTime in fAddOptions then
      fLatestTime := True
    // make zipfile's timestamp same as newest file
    else
      fLatestTime := False;
    if AddMove in fAddOptions then
      fMove := True                         { dangerous, beware! }
    else
      fMove := False;
    if AddFreshen in fAddOptions then
      fFreshen := True
    else
      fFreshen := False;
    if AddUpdate in fAddOptions then
      fUpdate := True
    else
      fUpdate := False;
    if (fFreshen and fUpdate) then
      fFreshen := False;
    { Update has precedence over freshen }

    if AddEncrypt in fAddOptions then
      fEncrypt := True                      { DLL will prompt for password }
    else
      fEncrypt := False;

    { NOTE: if user wants recursion, then he probably also wants
        AddDirNames, but we won't demand it. }
    if AddRecurseDirs in fAddOptions then
      fRecurse := True
    else
      fRecurse := False;

    if AddHiddenFiles in fAddOptions then
      fSystem := True
    else
      fSystem := False;

    if AddSeparateDirs in fAddOptions then
      fNoDirEntries := False { do make separate dirname entries - and also
      include dirnames with filenames }
    else
      fNoDirEntries := True; { normal zip file - dirnames only stored
    with filenames }

    if AddDirNames in fAddOptions then
      fJunkDir := False                     { we want dirnames with filenames }
    else
      fJunkDir := True;
    { don't store dirnames with filenames }

    pZipFN := StrAlloc(Length(NameOfZipFile) + 1);
    // allocate room for null terminated string
    StrPLCopy(pZipFN, NameOfZipFile, Length(NameOfZipFile) + 1);
    { name of zip file }
    if Length(FPassword) > 0 then
    begin
      pZipPassword := StrAlloc(Length(FPassword) + 1);
      { allocate room for null terminated string }
      StrPLCopy(pZipPassword, FPassword, PWLEN + 1);
      { password for encryption/decryption }
    end;
  end;                                      {end else with do }
end;
//? TZipWorker.SetZipSwitches

(*? TZipWorker.GetZipComment
1.73.3.2 11 Oct 2003 RP comment now converted when read
*)
function TZipWorker.GetZipComment: String;
begin
  Result := FZipComment;
end;
//? TZipWorker.GetZipComment

(*? TZipWorker.Rename
1.77 18 Aug 2004 RP use dynamic buffer
1.75 18 February 2004 RP allow >2G
1.73.3.2 11 October 2003 RP changed comment variable
1.73.2.1 23 August 2003 RP remove use of undefined variable 'name'
1.73  8 August 2003 RA clear outFileHandle
1.73 16 July 2003 RP use SetSlash + ConvertOEM
1.73 14 July 2003 RA convertion/re-convertion of filenames with OEM chars
1.73 13 July 2003 RA test on date/time in RenRec + test for wildcards
// Function to read a Zip archive and change one or more file specifications.
// Source and Destination should be of the same type. (path or file)
// If NewDateTime is 0 then no change is made in the date/time fields.
// Return values:
// 0            All Ok.
// -7           Rename errors. See ZipMsgXX.rc
// -8           Memory allocation error.
// -9           General unknown Rename error.
// -10          Dest should also be a filename.
*)
function TZipWorker.Rename(RenameList: TList; DateTime: Integer): Integer;
var
  EOC:     ZipEndOfCentral;
  CEH:     ZipCentralHeader;
  LOH:     ZipLocalHeader;
  OrigFileName: String;
  MsgStr:  String;
  OutFilePath: String;
  Fname:   String;
  Buffer:  array of Char;//[0..BufSize - 1] of Char;
  i, k, m: Integer;
  TotalBytesToRead: Integer;
  TotalBytesWrite: Integer;
  RenRec:  pZipRenameRec;
  MDZD:    TMZipDataList;
  MDZDp:   pMZipData;
begin
  Result   := 0;
  TotalBytesToRead := 0;
  fZipBusy := True;
  FShowProgress := zspNone;//False;

  SetLength(Buffer, BufSize);
  FInFileName := FZipFileName;
  FInFileHandle := -1;
  FOutFileHandle := -1;
  MDZD := NIL;

  StartWaitCursor;

  // If we only have a source path make sure the destination is also a path.
  for i := 0 to RenameList.Count - 1 do
  begin
    RenRec := RenameList.Items[i];
    RenRec^.Source := SetSlash(RenRec^.Source, psdExternal);
    RenRec^.Dest := SetSlash(RenRec^.Dest, psdExternal);
    if (AnsiPos('*', RenRec^.Source) > 0) or
      (AnsiPos('?', RenRec^.Source) > 0) or
      (AnsiPos('*', RenRec^.Dest) > 0) or
      (AnsiPos('?', RenRec^.Dest) > 0) then
    begin
      ShowZipMessage(AD_InvalidName, '');   // no wildcards allowed
      StopWaitCursor;
      fZipBusy := False;
      Result   := -7;                         // Rename error
      exit;
    end;
    if Length(ExtractFileName(RenRec^.Source)) = 0 then // Assume it's a path.
    begin                                   // Make sure destination is a path also.
      RenRec^.Dest   := AppendSlash(ExtractFilePath(RenRec^.Dest));
      RenRec^.Source := AppendSlash(RenRec^.Source);
    end
    else if Length(ExtractFileName(RenRec^.Dest)) = 0 then
    begin
      StopWaitCursor;
      fZipBusy := False;
      Result   := -10;
      // Dest should also be a filename.
      Exit;
    end;
  end;
  try
    // Check the input file.
    if not FileExists(FZipFileName) then
      raise EZipMaster.CreateResDisp(GE_NoZipSpecified {DS_NoInFile}, True);
    // Make a temporary filename like: C:\...\zipxxxx.zip
    OutFilePath := MakeTempFileName('', '');
    if OutFilePath = '' then
      raise EZipMaster.CreateResDisp(DS_NoTempFile, True);

    // Create the output file.
    FOutFileHandle := FileCreate(OutFilePath);
    if FOutFileHandle = -1 then
      raise EZipMaster.CreateResDisp(DS_NoOutFile, True);

    // The following function will read the EOC and some other stuff:
    OpenEOC(EOC, True);

    // Get the date-time stamp and save for later.
    FDateStamp := FileGetDate(FInFileHandle);

    // Now we now the number of zipped entries in the zip archive
    FTotalDisks := EOC.ThisDiskNo;
    if EOC.ThisDiskNo <> 0 then
      raise EZipMaster.CreateResDisp(RN_NoRenOnSpan, True);

    // Go to the start of the input file.
    //            fileOfs := 0;
    if FileSeek64(FInFileHandle, Int64(0), 0) = -1 then
      raise EZipMaster.CreateResDisp(DS_FailedSeek, True);

    // Write the SFX header if present.
    if CopyBuffer(FInFileHandle, FOutFileHandle, FSFXOffset) <> 0 then
      raise EZipMaster.CreateResDisp(RN_ZipSFXData, True);

    // Go to the start of the Central directory.
    //  FileOfs := EOC.CentralOffset;  // force 64 bit
    if FileSeek64(FInFileHandle, Int64(EOC.CentralOffset), 0) = -1 then
      raise EZipMaster.CreateResDisp(DS_FailedSeek, True);

    MDZD := TMZipDataList.Create(EOC.TotalEntries);

    // Read for every entry: The central header and save information for later use.
    for i := 0 to (EOC.TotalEntries - 1) do
    begin
      // Read a central header.
      ReadJoin(CEH, SizeOf(CEH), DS_CEHBadRead);

      if CEH.HeaderSig <> CentralFileHeaderSig then
        raise EZipMaster.CreateResDisp(DS_CEHWrongSig, True);

      // Now the filename.
      SetLength(FName, CEH.FileNameLen);
      ReadJoin(FName[1], CEH.FileNameLen, DS_CENameLen);
      //      ReadJoin(Buffer, CEH.FileNameLen, DS_CENameLen);
      //      Buffer[CEH.FileNameLen] := #0;
      //      Fname := Buffer;

      // Save the file name info in the MDZD structure.
      MDZDp := MDZD[i];
      MDZDp^.FileNameLen := CEH.FileNameLen;
      // convert OEM char set in original file else we don't find the file
      FVersionMadeBy1 := CEH.VersionMadeBy1;
      FVersionMadeBy0 := CEH.VersionMadeBy0;
      Fname := ConvertOEM(Fname, cpdOEM2ISO);
      StrLCopy(MDZDp^.FileName, PChar(Fname), 253);
      //DiskStart is not used in this function and we need FHostNum later
      MDZDp^.DiskStart   := (FVersionMadeBy1 shl 8) or FVersionMadeBy0;
      MDZDp^.RelOffLocal := CEH.RelOffLocal;
      MDZDp^.DateTime    := DateTime;

      // We need the total number of bytes we are going to read for the progress event.
      TotalBytesToRead := TotalBytesToRead + Integer(CEH.ComprSize +
        CEH.FileNameLen + CEH.ExtraLen);

      // Seek past the extra field and the file comment.
      //              FileOfs := CEH.ExtraLen + CEH.FileComLen;
      if FileSeek64(FInFileHandle, Int64(CEH.ExtraLen + CEH.FileComLen),
        1) = -1 then
        raise EZipMaster.CreateResDisp(DS_FailedSeek, True);
    end;

    FShowProgress := zspFull;//True;
    Report(zacCount, 0, '', EOC.TotalEntries);
    Report(zacSize, 0, '', TotalBytesToRead);

    // Read for every zipped entry: The local header, variable data, fixed data
    // and if present the Data descriptor area.
    for i := 0 to (EOC.TotalEntries - 1) do
    begin
      // Seek to the first entry.
      MDZDp := MDZD[i];
      //              FileOfs := MDZDp^.RelOffLocal;
      FileSeek64(FInFileHandle, MDZDp^.RelOffLocal, 0);

      // First the local header.
      ReadJoin(LOH, SizeOf(LOH), DS_LOHBadRead);
      if LOH.HeaderSig <> LocalFileHeaderSig then
        raise EZipMaster.CreateResDisp(DS_LOHWrongSig, True);

      // Now the filename.
      ReadJoin(Buffer[0], LOH.FileNameLen, DS_LONameLen);

      // Set message info on the start of this new fileread because we still have the old filename.
      MsgStr := ZipLoadStr(RN_ProcessFile) + MDZDp^.FileName;

      // Calculate the bytes we are going to write; we 'forget' the difference
      // between the old and new filespecification.
      TotalBytesWrite := LOH.FileNameLen + LOH.ExtraLen + LOH.ComprSize;

      // Check if the original path and/or filename needs to be changed.
      OrigFileName := SetSlash(MDZDp^.FileName, psdExternal);
      for m := 0 to RenameList.Count - 1 do
      begin
        RenRec := RenameList.Items[m];
        k      := Pos(UpperCase(RenRec^.Source), UpperCase(OrigFileName));
        if k <> 0 then
        begin
          System.Delete(OrigFileName, k, Length(RenRec^.Source));
          Insert(RenRec^.Dest, OrigFileName, k);
          LOH.FileNameLen := Length(OrigFileName);
          for k := 1 to Length(OrigFileName) do
            if OrigFileName[k] = '\' then
              OrigFileName[k] := '/';
          MsgStr := MsgStr + ZipLoadStr(RN_RenameTo) + OrigFileName;
          //          ' renamed to: ') + OrigFileName;
          //allow OEM char sets in Rename
          //we replaced the filename look if we need to reconvert it
          FVersionMadeBy1 := (MDZDp^.DiskStart and $FF00) shl 8;
          FVersionMadeBy0 := (MDZDp^.DiskStart and $FF);
          OrigFileName    := ConvertOEM(OrigFileName, cpdISO2OEM);
          StrPLCopy(MDZDp^.FileName, OrigFileName, Length(OrigFileName) + 1);
          MDZDp^.FileNameLen := Length(OrigFileName);

          // Change Date and Time if needed.
          if RenRec^.DateTime <> 0 then
            try
              // test if valid date/time will throw error if not
              FileDateToDateTime(RenRec^.DateTime);
              MDZDp^.DateTime := RenRec^.DateTime;
            except
              ShowZipMessage(RN_InvalidDateTime, MDZDp^.FileName);
            end;
        end;
      end;
      Report(zacMessage, 0, MsgStr, 0);

      // Change Date and/or Time if needed.
      if MDZDp^.DateTime <> 0 then
      begin
        LOH.ModifDate := HIWORD(MDZDp^.DateTime);
        LOH.ModifTime := LOWORD(MDZDp^.DateTime);
      end;
      // Change info for later while writing the central dir.
      //   FileOfs := 0;
      MDZDp^.RelOffLocal := FileSeek64(FOutFileHandle, Int64(0), 1);

      Report(zacItem, 0, SetSlash(MDZDp^.FileName, psdExternal),
        TotalBytesWrite);

      // Write the local header to the destination.
      WriteJoin(LOH, SizeOf(LOH), DS_LOHBadWrite);

      // Write the filename.
      WriteJoin(MDZDp^.FileName, LOH.FileNameLen, DS_LOHBadWrite);

      // And the extra field
      if CopyBuffer(FInFileHandle, FOutFileHandle, LOH.ExtraLen) <> 0 then
        raise EZipMaster.CreateResDisp(DS_LOExtraLen, True);

      // Read and write Zipped data
      if CopyBuffer(FInFileHandle, FOutFileHandle, LOH.ComprSize) <> 0 then
        raise EZipMaster.CreateResDisp(DS_ZipData, True);

      // Read DataDescriptor if present.
      if (LOH.Flag and Word($0008)) = 8 then
        if CopyBuffer(FInFileHandle, FOutFileHandle,
          SizeOf(ZipDataDescriptor)) <> 0 then
          raise EZipMaster.CreateResDisp(DS_DataDesc, True);
    end;                                    // Now we have written all entries.

    // Now write the central directory with possibly changed offsets and filename(s).
    FShowProgress := zspNone;//False;
    for i := 0 to (EOC.TotalEntries - 1) do
    begin
      MDZDp := MDZD[i];
      // Read a central header which can be span more than one disk.
      ReadJoin(CEH, SizeOf(CEH), DS_CEHBadRead);
      if CEH.HeaderSig <> CentralFileHeaderSig then
        raise EZipMaster.CreateResDisp(DS_CEHWrongSig, True);

      // Change Date and/or Time if needed.
      if MDZDp^.DateTime <> 0 then
      begin
        CEH.ModifDate := HIWORD(MDZDp^.DateTime);
        CEH.ModifTime := LOWORD(MDZDp^.DateTime);
      end;

      // Now the filename.
      ReadJoin(Buffer[0], CEH.FileNameLen, DS_CENameLen);

      // Save the first Central directory offset for use in EOC record.
      if i = 0 then
        EOC.CentralOffset := Cardinal(FileSeek64(FOutFileHandle, Int64(0), 1));

      // Change the central header info with our saved information.
      CEH.RelOffLocal := MDZDp^.RelOffLocal;
      CEH.DiskStart   := 0;
      EOC.CentralSize := EOC.CentralSize - CEH.FileNameLen +
        MDZDp^.FileNameLen;
      CEH.FileNameLen := MDZDp^.FileNameLen;

      // Write this changed central header to disk
      WriteJoin(CEH, SizeOf(CEH), DS_CEHBadWrite);

      // Write to destination the central filename and the extra field.
      WriteJoin(MDZDp^.FileName{[1]}, CEH.FileNameLen, DS_CEHBadWrite);

      // And the extra field
      if CopyBuffer(FInFileHandle, FOutFileHandle, CEH.ExtraLen) <> 0 then
        raise EZipMaster.CreateResDisp(DS_CEExtraLen, True);

      // And the file comment.
      if CopyBuffer(FInFileHandle, FOutFileHandle, CEH.FileComLen) <> 0 then
        raise EZipMaster.CreateResDisp(DS_CECommentLen, True);
    end;
    // Write the changed EndOfCentral directory record.
    EOC.CentralDiskNo := 0;
    EOC.ThisDiskNo    := 0;
    WriteJoin(EOC, SizeOf(EOC), DS_EOCBadWrite);

    // And finally the archive comment
    { ==================== Changed by Jin Turner ===================}
    if (FEOCComment <> '') and
      (FileWrite(FOutFileHandle, PChar(FEOCComment)^,
      Length(FEOCComment)) < 0) then
      raise EZipMaster.CreateResDisp(DS_EOArchComLen, True);
  except
    on ers: EZipMaster do                   // All Rename specific errors.
    begin
      ShowExceptionError(ers);
      Result := -7;
    end;
    on EOutOfMemory do                      // All memory allocation errors.
    begin
      ShowZipMessage(GE_NoMem, '');
      Result := -8;
    end;
    on E: Exception do
    begin
      // the error message of an unknown error is displayed ...
      ShowZipMessage(DS_ErrorUnknown, E.Message);
      Result := -9;
    end;
  end;
  if Assigned(MDZD) then
    FreeAndNil(MDZD);//MDZD.Free;

  // Give final progress info at the end.
  Report(zacEndOfBatch, 0, '', 0);
  Buffer := NIL;

  if FInFileHandle <> -1 then
    FileClose(FInFileHandle);
  if FOutFileHandle <> -1 then
  begin
    FileSetDate(FOutFileHandle, FDateStamp);
    FileClose(FOutFileHandle);
    if Result <> 0 then
      // An error somewhere, OutFile is not reliable.
      DeleteFile(OutFilePath)
    else begin
      EraseFile(FZipFileName, FHowToDelete = htdFinal);
      RenameFile(OutFilePath, FZipFileName);
      List;
    end;
  end;

  fZipBusy := False;
  StopWaitCursor;
end;
//? TZipWorker.Rename


(*? TZipWorker.ConvertOEM
1.73 24 July 2003 RA adjust result string length
1.73 ( 2 June 2003) RP replacement function that should be able to handle MBCS
//---------------------------------------------------------------------------
( * Convert filename (and file comment string) into 'internal' charset (ISO).
 * This function assumes that Zip entry filenames are coded in OEM (IBM DOS)
 * codepage when made on:
 *  -> DOS (this includes 16-bit Windows 3.1)  (FS_FAT_  {0} )
 *  -> OS/2                                    (FS_HPFS_ {6} )
 *  -> Win95/WinNT with Nico Mak''s WinZip      (FS_NTFS_ {11} && hostver == '5.0' {50} )
 *
 * All other ports are assumed to code zip entry filenames in ISO 8859-1.
 * But norton Zip v1.0 sets the host byte as OEM(0) but does use the ISO set,
 * thus archives made by NortonZip are not recognized as being ISO.
 * (In this case you need to set the CodePage property manualy to cpNone.)
 * When ISO is used in the zip archive there is no need for translation
 * and so we call this cpNone.
 *)
function TZipWorker.ConvertOEM(const Source: String;
  Direction: CodePageDirection): String;
const
  FS_FAT: Integer  = 0;
  FS_HPFS: Integer = 6;
  FS_NTFS: Integer = 11;
var
  buf: String;
begin
  Result := Source;
  if ((FCodePage = cpAuto) and (FVersionMadeBy1 = FS_FAT) or (FVersionMadeBy1 =
    FS_HPFS) or ((FVersionMadeBy1 = FS_NTFS) and (FVersionMadeBy0 = 50))) or
    (FCodePage =
    cpOEM) then
  begin
    SetLength(buf, 2 * Length(Source) + 1); // allow worst case - all double
    if (Direction = cpdOEM2ISO) then
      OemToChar(PChar(Source), PChar(buf))
    else
      CharToOem(PChar(Source), PChar(buf));
    Result := PChar(buf);
  end;
end;
//? TZipWorker.ConvertOEM

//---------------------------------------------------------------------------
(*? TZipWorker.ReadJoin
1.73 15 July 2003 new function
*)
procedure TZipWorker.ReadJoin(var Buffer; BufferSize, DSErrIdent: Integer);
begin
  if FileRead(FInFileHandle, Buffer, BufferSize) <> BufferSize then
    raise EZipMaster.CreateResDisp(DSErrIdent, True);
end;
//? TZipWorker.ReadJoin

procedure TZipWorker.SetVersionInfo(Value: String);
begin
  // We do not want that this can be changed, but we do want to see it in the OI.
end;

procedure TZipWorker.SetPasswordReqCount(Value: Longword);
begin
  if Value <> FPasswordReqCount then
  begin
    if Value > 15 then
      Value := 15;
    FPasswordReqCount := Value;
  end;
end;

(*? TZipWorker.FreeZipDirEntryRecords
1.73 12 July 2003 RP string ExtraData
{ Empty fZipContents and free the storage used for dir entries }
*)
procedure TZipWorker.FreeZipDirEntryRecords;
var
  i: Integer;
begin
  if ZipContents.Count = 0 then
    Exit;
  for i := (ZipContents.Count - 1) downto 0 do
  begin
    if Assigned(ZipContents[i]) then
    begin
      pZipDirEntry(ZipContents[i]).ExtraData := '';
      // dispose of the memory pointed-to by this entry
      Dispose(pZipDirEntry(ZipContents[i]));
    end;
    ZipContents.Delete(i);                  // delete the TList pointer itself
  end;                                      { end for }
  // The caller will free the FZipContents TList itself, if needed
end;
//? TZipWorker.FreeZipDirEntryRecords

(*? TZipWorker.GetSFXSlave
1.73 15 Juli 2003 RA added passing message type in MessageFlags to slave
1.73 4 July 2003
*)
{$IFNDEF NO_SFX}
function TZipWorker.GetSFXSlave: TCustomZipSFX;
begin
{$IFNDEF NO_SFX}
  Result := FSFX;
  if not assigned(Result) then
{$ENDIF}
    raise EZipMaster.CreateResDisp(SF_NoSFXSupport, True);
end;

{$ENDIF}
//? TZipWorker.GetSFXSlave

//-------------------
{$IFDEF VERD4+}
(*? TZipWorker.BeforeDestruction
1.73 3 July 2003 RP stop callbacks
*)
procedure TZipWorker.BeforeDestruction;
begin
  fIsDestructing := True;                   // stop callbacks
  inherited;
end;
//? TZipWorker.BeforeDestruction
{$ENDIF}

(*? TZipWorker.Destroy
1.77.4.0 23 Sep 2004 use FreeAndNil
1.73  1 June 2003 RP destructing flag to stop callbacks
*)
destructor TZipWorker.Destroy;
begin
  fIsDestructing := True;                   // 1.73 - stop callbacks
  AbortDlls;
  FreeAndNil(FZipStream);//FZipStream.Free;
  FreeZipDirEntryRecords;
  FreeAndNil(FZipContents);//fZipContents.Free;
  FreeAndNil(FFSpecArgsExcl);//FFSpecArgsExcl.Free;
  FreeAndNil(FFSpecArgs);//FFSpecArgs.Free;
  FreeAndNil(FUnzDll);//fUnzDll.Free;       // new 1.73
  FreeAndNil(FZipDll);//fZipDll.Free;       // new 1.73
  inherited Destroy;
end;
//? TZipWorker.Destroy

//---------------------------------------------------------------------------
(*? TZipWorker.IsRightDisk
1.73 29 June 2003 RP amended
*)
{$IFNDEF NO_SPAN}
function TZipWorker.IsRightDisk: Boolean;
begin
  Result := True;
  if ( not FDriveFixed) and (FVolumeName = 'PKBACK# ' +
    copy(IntToStr(1001 + FDiskNr), 2, 3)) and (FileExists(FInfileName)) then
    exit;
  CreateMVFileName(FInFileName, True);
  if not FDriveFixed then
    // allways right only needed new filename
    Result := FileExists(FInFileName);      // must exist
end;

{$ENDIF}
//? TZipWorker.IsRightDisk


(*? TZipWorker.ZipFormat ------------------------------------------------------
1.73 10 July 2003 RP changed trace messages
1.73 9 July 2003 RA use of property ConfirmErase + confirmation messages translatable
1.73 27 June 2003 RP change handling of 'No'
//  Format floppy disk
*)
{$IFNDEF NO_SPAN}
procedure TZipWorker.ClearFloppy(dir: String);
var
  SRec:  TSearchRec;
  Fname: String;
begin
  if FindFirst(Dir + '*.*', faAnyFile, SRec) = 0 then
    repeat
      Fname := Dir + SRec.Name;
      if ((SRec.Attr and faDirectory) <> 0) and (SRec.Name <> '.') and
        (SRec.Name <> '..') then
      begin
        Fname := Fname + '\';
        ClearFloppy(Fname);
        if (Trace) then
          Report(zacMessage, 0, ZipFmtLoadStr(TM_Erasing, [Fname]), 0)
        //          Report(zacMessage, 0, 'EraseFloppy - Removing ' + Fname, 0)
        else
          Report(zacTick, 0, '', 0);
        //allow time for OS to delete last file
        RemoveDir(Fname);
      end
      else begin
        if (Trace) then
          Report(zacMessage, 0, ZipFmtLoadStr(TM_Deleting, [Fname]), 0);
        //          Report(zacMessage, 0, 'EraseFloppy - Deleting ' + Fname, 0);
        DeleteFile(Fname);
      end;
    until FindNext(SRec) <> 0;
  FindClose(SRec);
end;

function FormatFloppy(WND: HWND; Drive: String): Integer;
const
  SHFMT_ID_DEFAULT = $FFFF;
  {options}
  SHFMT_OPT_FULL = $0001;
  SHFMT_OPT_SYSONLY = $0002;
  {return values}
  SHFMT_ERROR    = $FFFFFFFF;
  // -1 Error on last format, drive may be formatable
  SHFMT_CANCEL   = $FFFFFFFE;    // -2 last format cancelled
  SHFMT_NOFORMAT = $FFFFFFFD;    // -3 drive is not formatable
type
  TSHFormatDrive = function(WND: HWND; Drive, fmtID, Options: DWORD): DWORD;
    stdcall;
const
  SHFormatDrive: TSHFormatDrive = NIL;
var
  drv:  Integer;
  hLib: THandle;
  OldErrMode: Integer;
begin
  Result := -3;                             // error
  if not ((Length(Drive) > 1) and (Drive[2] = ':') and (Upcase(Drive[1]) in
    ['A'..'Z'])) then
    exit;
  if GetDriveType(PChar(Drive)) <> DRIVE_REMOVABLE then
    exit;
  drv  := Ord(Upcase(Drive[1])) - Ord('A');
  OldErrMode := SetErrorMode(SEM_FAILCRITICALERRORS or SEM_NOGPFAULTERRORBOX);
  hLib := LoadLibrary('Shell32');
  if hLib <> 0 then
  begin
    @SHFormatDrive := GetProcAddress(hLib, 'SHFormatDrive');
    if @SHFormatDrive <> NIL then
      try
        Result := SHFormatDrive(WND, drv, SHFMT_ID_DEFAULT, SHFMT_OPT_FULL);
      finally
        FreeLibrary(hLib);
      end;
    SetErrorMode(OldErrMode);
  end;
end;

(*? TZipWorker.ZipFormat
1.76 14 May 2004 check ConfirmErase
*)
function TZipWorker.ZipFormat: Integer;
var
  Msg, Vol:    String;
  Res {, drt}: Integer;
begin
  Result := -3;
  if (spTryFormat in FSpanOptions) and not FDriveFixed then
    Result := FormatFloppy(Application.Handle, FDrive);
  if Result = -3 then
  begin
    if FConfirmErase then
    begin
      Msg := ZipFmtLoadStr(FM_Erase, [FDrive]);
      //      Res := MessageBox(FHandle, PChar(Msg), PChar(ZipLoadStr(FM_Confirm))
      //        , MB_YESNO or MB_DEFBUTTON2 or MB_ICONWARNING);
      Res := ZipMessageDlg(ZipLoadStr(FM_Confirm), Msg,
        zmtWarning + DHC_FormErase, [mbYes, mbNo]);
      if Res <> idYes then
      begin
        Result := -3;                       // no  was -2; // cancel
        Exit;
      end;
    end;
    ClearFloppy(FDrive);
    Result := 0;
  end;
  if Length(FVolumeName) > 11 then
    Vol := Copy(FVolumeName, 1, 11)
  else
    Vol := FVolumeName;
  if (Result = 0) and not (spNoVolumeName in FSpanOptions) then // did it
    SetVolumeLabel(PChar(FDrive), PChar(Vol));
end;

{$ENDIF}
//? TZipWorker.ZipFormat

// ---------------------------- ZipDataList --------------------------------

function TMZipDataList.GetItems(Index: Integer): pMZipData;
begin
  if Index >= Count then
    raise EZipMaster.CreateResFmt(GE_RangeError, [Index, Count - 1]);
  Result := inherited Items[Index];
end;

constructor TMZipDataList.Create(TotalEntries: Integer);
var
  i:     Integer;
  MDZDp: pMZipData;
begin
  inherited Create;
  Capacity := TotalEntries;
  for i := 1 to TotalEntries do
  begin
    New(MDZDp);
//    MDZDp^.FileName := '';
    MDZDp^.FileName[0] := #0;
    Add(MDZDp);
  end;
end;

destructor TMZipDataList.Destroy;
var
  i:     Integer;
  MDZDp: pMZipData;
begin
  if Count > 0 then
    for i := (Count - 1) downto 0 do
    begin
      MDZDp := Items[i];
      if Assigned(MDZDp) then
        // dispose of the memory pointed-to by this entry
        Dispose(MDZDp);

      Delete(i);                            // delete the TList pointer itself
    end;
  inherited Destroy;
end;

function TMZipDataList.IndexOf(fname: String): Integer;
var
  MDZDp: pMZipData;
begin
  for Result := 0 to (Count - 1) do
  begin
    MDZDp := Items[Result];
    if CompareText(fname, MDZDp^.FileName) = 0 then // case insensitive compare
      break;
  end;

  // Should not happen, but maybe in a bad archive...
  if Result = Count then
    raise EZipMaster.CreateResDisp(DS_EntryLost, True);
end;


function TZipWorker.GetCount: Integer;
begin
  if ZipFileName <> '' then
    Result := ZipContents.Count
  else
    Result := 0;
end;

               (*
procedure TZipWorker.SetPasswordReqCount(Value: Longword);
begin
  if Value <> FPasswordReqCount then
  begin
    if Value > 15 then
      Value := 15;
    FPasswordReqCount := Value;
  end;
end;             *)

// new 1.72 tests for 'fixed' drives

function TZipWorker.IsFixedDrive(drv: String): Boolean;
var
  drt: Integer;
begin
  drt    := GetDriveType(PChar(drv));
  Result := (drt = DRIVE_FIXED) or (drt = DRIVE_REMOTE) or (drt =
    DRIVE_RAMDISK);
end;

procedure TZipWorker.SetExtAddStoreSuffixes(Value: String);
var
  str: String;
  i:   Integer;
  c:   Char;
begin
  if Value <> '' then
  begin
    c := ':';
    i := 1;
    while i <= length(Value) do
    begin
      c := Value[i];
      if c <> '.' then
        str := str + '.';
      while (c <> ':') and (i <= length(Value)) do
      begin
        c := Value[i];
        if (c = ';') or (c = ':') or (c = ',') then
          c := ':';
        str := str + c;
        Inc(i);
      end;
    end;
    if c <> ':' then
      str := str + ':';
    fAddStoreSuffixes := fAddStoreSuffixes + [assEXT];
    fExtAddStoreSuffixes := Lowercase(str);
  end
  else begin
    fAddStoreSuffixes    := fAddStoreSuffixes - [assEXT];
    fExtAddStoreSuffixes := '';
  end;
end;
 // Add a new suffix to the suffix string if contained in the set 'FAddStoreSuffixes'
 // changed 1.71

procedure TZipWorker.AddSuffix(const SufOption: AddStoreSuffixEnum;
  var sStr: String; sPos: Integer);
const
  SuffixStrings: array[0..17, 0..3] of Char =
    ('gif', 'png', 'z', 'zip', 'zoo',  'arc', 'lzh', 'arj',
     'taz', 'tgz', 'lha', 'rar', 'ace', 'cab', 'gz', 'gzip',
    'jar', 'exe');
begin
  if SufOption = assEXT then
    sStr := sStr + fExtAddStoreSuffixes
  else if SufOption in fAddStoreSuffixes then
    sStr := sStr + '.' + String(SuffixStrings[sPos]) + ':';
end;

procedure TZipWorker.SetDeleteSwitches;
{ override "add" behavior assumed by SetZipSwitches: }
begin
  with ZipParms^ do
  begin
    fDeleteEntries := True;
    fGrow    := False;
    fJunkDir := False;
    fMove    := False;
    fFreshen := False;
    fUpdate  := False;
    fRecurse := False;                      // bug fix per Angus Johnson
    fEncrypt := False;
    // you don't need the pwd to delete a file
  end;
end;

procedure TZipWorker.SetUnZipSwitches(var NameOfZipFile: String; uzpVersion: Integer);
begin
  with UnZipParms^ do
  begin
    Version := uzpVersion;
    //UNZIPVERSION;  // version we expect the DLL to be
    Caller  := Self;
    // point to our VCL instance; returned in Report

    fQuiet := True; { we'll report errors upon notification in our Report }
    { So, we don't want the DLL to issue error dialogs }

    ZCallbackFunc := ZCallback;
    // pass addr of function to be called from DLL

    if Trace then
      fTraceEnabled := True
    else
      fTraceEnabled := False;
    if Verbose then
      fVerboseEnabled := True
    else
      fVerboseEnabled := False;
    if (fTraceEnabled and not fVerboseEnabled) then
      fVerboseEnabled := True;
    { if tracing, we want verbose also }

    if FUnattended then
      Handle := 0
    else
      Handle := fHandle;
    // used for dialogs (like the pwd dialogs)

    fQuiet    := True;                         { no DLL error reporting }
    fComments := False;
    { zipfile comments - not supported }
    fConvert  := False;
    { ascii/EBCDIC conversion - not supported }

    if ExtrDirNames in fExtrOptions then
      fDirectories := True
    else
      fDirectories := False;
    if ExtrOverWrite in fExtrOptions then
      fOverwrite := True
    else
      fOverwrite := False;

    if ExtrFreshen in fExtrOptions then
      fFreshen := True
    else
      fFreshen := False;
    if ExtrUpdate in fExtrOptions then
      fUpdate := True
    else
      fUpdate := False;
    if fFreshen and fUpdate then
      fFreshen := False;
    { Update has precedence over freshen }

    if ExtrTest in fExtrOptions then
      fTest := True
    else
      fTest := False;

    { allocate room for null terminated string }
    pZipFN := StrAlloc(Length(NameOfZipFile) + 1);
    StrPLCopy(pZipFN, NameOfZipFile, Length(NameOfZipFile) + 1);
    { name of zip file }

    UnZipParms.fPwdReqCount := FPasswordReqCount;
    { We have to be carefull doing an unattended Extract when a password is needed
           for some file in the archive. We set it to an unlikely password, this way
     encrypted files won't be extracted.
             From verion 1.60 and up the event OnPasswordError is called in this case. }

    pZipPassword := StrAlloc(Length(FPassword) + 1);
    // Allocate room for null terminated string.
    StrPLCopy(pZipPassword, FPassword, Length(FPassword) + 1);
    // Password for encryption/decryption.
  end;                                      { end with }
end;

function TZipWorker.Add: Integer;
begin
  ExtAdd(0, 0, 0, NIL);
  Result := fErrCode;
end;

(*? TZipWorker.AddStreamToStream ---------------------------------------------
1.73 14 July 2003 RA Initial FSuccesCnt
*)

function TZipWorker.AddStreamToStream(InStream: TMemoryStream): TZipStream;
begin
  Result      := NIL;
  FSuccessCnt := 0;
  if InStream = FZipStream then
  begin
    ShowZipMessage(AD_InIsOutStream, '');
    Exit;
  end;
  if InStream.Size > 0 then
  begin
    FZipStream.SetSize(InStream.Size + 6);
    // Call the extended Add procedure:
    ExtAdd(2, 0, 0, InStream);
    { The size of the output stream is reset by the dll in ZipParms2 in fOutStreamSize.
     Also the size is 6 bytes more than the actual output size because:
     - the first two bytes are used as flag, STORED=0 or DEFLATED=8.
     - the next four bytes are set to the calculated CRC value.
     The size is reset from Inputsize +6 to the actual data size +6.
     (you do not have to set the size yourself, in fact it won't be taken into account.
     The start of the stream is set to the actual data start. }
    if FSuccessCnt = 1 then
      FZipStream.Position := 6
    else
      FZipStream.SetSize(0);
  end
  else
    ShowZipMessage(AD_NothingToZip, '');
  Result := FZipStream;
end;
//? TZipMster.AddStreamToStream

(*? TZipWorker.Delete
1.73 16 July 2003 RA catch and display dll load errors
1.73 13 July 2003 RA for spanned archive no exception but show mesage
*)
function TZipWorker.Delete: Integer;
var
  i, DLLVers: Integer;
  pFDS:     pFileData;
  EOC:      ZipEndOfCentral;
  pExFiles: pExcludedFileSpec;
begin
  FErrCode    := 0;
  Result      := 0;
  FSuccessCnt := 0;
  if fFSpecArgs.Count = 0 then
  begin
    ShowZipMessage(DL_NothingToDel, '');
    Exit;
  end;
  if not FileExists(FZipFileName) then
  begin
    ShowZipMessage(GE_NoZipSpecified, '');
    Result := FErrCode;
    Exit;
  end;
  // new 1.7 - stop delete from spanned
  OpenEOC(EOC, False);                      //1.72 true);
  FileClose(fInFileHandle);                 // only needed to test it
  if (IsSpanned) then
    //    raise EZipMaster.CreateResDisp(DL_NoDelOnSpan, true);
  begin
    ShowZipMessage(DL_NoDelOnSpan, '');
    Result := FErrCode;
    exit;
  end;

  { Make sure we can't get back in here while work is going on }
  if fZipBusy then
    Exit;
  fZipBusy := True; { delete uses the ZIPDLL, so it shares the FZipBusy flag }
  Cancel   := False;

  try
    DLLVers := FZipDll.LoadDll(ZIPVERSION {Min_ZipDll_Vers}, False);
    //Load_ZipDll(AutoLoad);
  except
    on ews: EZipMaster do
    begin
      ShowExceptionError(ews);
      Result := FErrCode;
      exit;
    end;
  end;
  try
    try
      ZipParms := AllocMem(SizeOf(ZipParms2));
      SetZipSwitches(fZipFileName, DLLVers);
      SetDeleteSwitches;

      with ZipParms^ do
      begin
        fFDS := AllocMem(SizeOf(FileData) * FFSpecArgs.Count);
        for i := 0 to (fFSpecArgs.Count - 1) do
        begin
          pFDS := fFDS;
          Inc(pFDS, i);
          pFDS.fFileSpec := StrAlloc(Length(fFSpecArgs[i]) + 1);
          StrPLCopy(pFDS.fFileSpec, fFSpecArgs[i], Length(fFSpecArgs[i]) + 1);
        end;
        Argc   := fSpecArgs.Count;
        fSeven := 7;
      end;                                  { end with }
      { pass in a ptr to parms }
      FEventErr   := '';                      // added
      fSuccessCnt := fZipDLL.Exec(ZipParms); 
    except
      on ews: EZipMaster do
      begin
        if FEventErr <> '' then
          ews.Message := ews.Message + FEventErr;
        ShowExceptionError(ews);
      end
      else
        ShowZipMessage(GE_FatalZip, '');
    end;
  finally
    fFSpecArgs.{A}Clear;
    fFSpecArgsExcl.{A}Clear;

    with ZipParms^ do
    begin
      StrDispose(pZipFN);
      StrDispose(pZipPassword);
      StrDispose(pSuffix);
      StrDispose(fTempPath);
      StrDispose(fArchComment);
      for i := (Argc - 1) downto 0 do
      begin
        pFDS := fFDS;
        Inc(pFDS, i);
        StrDispose(pFDS.fFileSpec);
      end;
      FreeMem(fFDS);
      for i := (fTotExFileSpecs - 1) downto 0 do
      begin
        pExFiles := fExFiles;
        Inc(pExFiles, i);
        StrDispose(pExFiles.fFileSpec);
      end;
      FreeMem(fExFiles);
    end;
    FreeMem(ZipParms);
    ZipParms := NIL;
  end;

  FZipDll.Unload(False);
  fZipBusy := False;

  Cancel := False;
  if fSuccessCnt > 0 then
    List;
  Result := FErrCode;
  { Update the Zip Directory by calling List method }
end;
//? TZipWorker.Delete

constructor TZipStream.Create;
begin
  inherited Create;
  Clear();
end;

destructor TZipStream.Destroy;
begin
  inherited Destroy;
end;

procedure TZipStream.SetPointer(Ptr: Pointer; Size: Integer);
begin
  inherited SetPointer(Ptr, Size);
end;

(*? TZipWorker.ExtractFileToStream ------------------------------------------
1.73 15 July 2003 RA add check on filename in FSpecArgs + return on busy
*)

function TZipWorker.ExtractFileToStream(FileName: String): TZipStream;
begin
  FSuccessCnt := 0;
  if FileName <> '' then
  begin
    FFSpecArgs.{A}Clear();
    FFSpecArgs.{A}Add(FileName);
  end;
  if (FFSpecArgs.Count <> 0) then
  begin
    FZipStream.Clear();
    ExtExtract(1, NIL);
    if FSuccessCnt <> 1 then
      Result := NIL
    else
      Result := FZipStream;
  end
  else begin
    ShowZipMessage(AD_NothingToZip, '');
    Result := NIL;
  end;
end;
//? TZipWorker.ExtractFileToStream

(*? TZipWorker.ExtractStreamToStream
1.73 14 July 2003 RA initial FSuccessCnt
*)

function TZipWorker.ExtractStreamToStream(InStream: TMemoryStream;
  OutSize: Longword): TZipStream;
begin
  FSuccessCnt := 0;
  if InStream = FZipStream then
  begin
    ShowZipMessage(AD_InIsOutStream, '');
    Result := NIL;
    Exit;
  end;
  FZipStream.Clear();
  FZipStream.SetSize(OutSize);
  ExtExtract(2, InStream);
  if FSuccessCnt <> 1 then
    Result := NIL
  else
    Result := FZipStream;
end;
//? TZipWorker.ExtractStreamToStream

function TZipWorker.Extract: Integer;
begin
  ExtExtract(0, NIL);
  Result := fErrCode;
end;

//---------------------------------------------------------------------------
(*? TZipWorker.Copy_File
1.75 18 February 2004 Allow >2G
// Returns 0 if good copy, or a negative error code.
*)
function TZipWorker.Copy_File(const InFileName, OutFileName: String): Integer;
const
  SE_CreateError   = -1;           { Error in open or creation of OutFile. }
  SE_OpenReadError = -3;           { Error in open or Seek of InFile.      }
  SE_SetDateError  = -4;           { Error setting date/time of OutFile.   }
  SE_GeneralError  = -9;
var
  InFile, OutFile: Integer;
  InSize, OutSize: Int64;
begin
  InSize  := -1;
  OutSize := -1;
  Result  := SE_OpenReadError;
  FShowProgress := zspNone;//False;

  if not FileExists(InFileName) then
    Exit;
  StartWaitCursor;
  InFile := FileOpen(InFileName, fmOpenRead or fmShareDenyWrite);
  if InFile <> -1 then
  begin
    if FileExists(OutFileName) then
      EraseFile(OutFileName, FHowToDelete = htdFinal);
    OutFile := FileCreate(OutFileName);
    if OutFile <> -1 then
    begin
      Result := CopyBuffer(InFile, OutFile, -1);
      if (Result = 0) and (FileSetDate(OutFile, FileGetDate(InFile)) <> 0) then
        Result := SE_SetDateError;
      OutSize := FileSeek64(OutFile, Int64(0), 2);
      FileClose(OutFile);
    end
    else
      Result := SE_CreateError;
    InSize := FileSeek64(InFile, Int64(0), 2);
    FileClose(InFile);
  end;
  // An extra check if the filesizes are the same.
  if (Result = 0) and ((InSize = -1) or (OutSize = -1) or
    (InSize <> OutSize)) then
    Result := SE_GeneralError;
  // Don't leave a corrupted outfile lying around. (SetDateError is not fatal!)
  if (Result <> 0) and (Result <> SE_SetDateError) then
    DeleteFile(OutFileName);

  StopWaitCursor;
end;
//? TZipWorker.Copy_File

(*? TZipWorker.CopyBuffer
1.73 15 July 2003 RP progress
1.73 10 Jul 2003 RP use String as buffer
*)

function TZipWorker.CopyBuffer(InFile, OutFile, ReadLen: Integer): Integer;
const
  SE_CopyError = -2;           // Write error or no memory during copy.
var
  SizeR, ToRead: Integer;
  Buffer: array of Char;
begin
  // both files are already open
  Result := 0;
  ToRead := BufSize;
  try
    SetLength(Buffer, BufSize);
    repeat
      if ReadLen >= 0 then
      begin
        ToRead := ReadLen;
        if BufSize < ReadLen then
          ToRead := BufSize;
      end;
      SizeR := FileRead(InFile, Buffer[0], ToRead);
      if FileWrite(OutFile, Buffer[0], SizeR) <> SizeR then
      begin
        Result := SE_CopyError;
        Break;
      end;
      if ReadLen > 0 then
        Dec(ReadLen, SizeR);
      case FShowProgress of
        zspFull:
          Report(zacProgress, 0, '', SizeR);
        zspExtra:
          Report(zacXProgress, 0, '', SizeR);
        else
          Report(zacTick, 0, '', 0);        // Mostly for winsock.
      end;
    until ((ReadLen = 0) or (SizeR <> ToRead));
  except
    Result := SE_CopyError;
  end;
  // leave both files open
end;
//? TZipWorker.CopyBuffer

//---------------------------------------------------------------------------
(*? TZipWorker.Load_Zip_Dll
1.73 16 July 2003 RA catch and diplay dll load errors
*)

function TZipWorker.Load_Zip_Dll: Integer;    // CHANGED 1.70
begin
  try
    Result := FZipDll.LoadDll(ZIPVERSION {Min_ZipDll_Vers}, True);
  except
    on ews: EZipMaster do
    begin
      ShowExceptionError(ews);
      Result := 0;
    end;
  end;
end;
 //? TZipWorker.Load_Zip_Dll
 // CHANGED 1.70 - return version if loaded

(*? TZipWorker.Load_Unz_Dll
1.73 16 July 2003 RA catch and display dll load errors
*)

function TZipWorker.Load_Unz_Dll: Integer;
begin
  try
    Result := fUnzDll.LoadDll(UNZIPVERSION, True);
  except
    on ews: EZipMaster do
    begin
      ShowExceptionError(ews);
      Result := 0;
    end;
  end;
end;
//? TZipWorker.Load_Unz_Dll

procedure TZipWorker.Unload_Zip_Dll;
begin
  FZipDll.Unload(True);
end;

procedure TZipWorker.Unload_Unz_Dll;
begin
  FUnzDll.Unload(True);
end;

// new 1.72
(*? TZipWorker.ZipDllPath
*)
function TZipWorker.ZipDllPath: String;
begin
  Result := FZipDll.Path;
end;
//? TZipWorker.ZipDllPath

(*? TZipWorker.UnzDllPath
*)
function TZipWorker.UnzDllPath: String;
begin
  Result := FUnzDll.Path;
end;
//? TZipWorker.UnzDllPath

(*? TZipWorker.GetZipVers
*)
function TZipWorker.GetZipVers: Integer;
begin
  Result := FZipDll.Version;
end;
//? TZipWorker.GetZipVers

(*? TZipWorker.GetUnzVers
*)
function TZipWorker.GetUnzVers: Integer;
begin
  Result := FUnzDll.Version;
end;
//? TZipWorker.GetUnzVers

 { Replacement for the functions DiskFree and DiskSize. }
 { This should solve problems with drives > 2Gb and UNC filenames. }
 { Path FDrive ends with a backslash. }
 { Action=1 FreeOnDisk, 2=SizeOfDisk, 3=Both }

procedure TZipWorker.DiskFreeAndSize(Action: Integer); // RCV150199
var
  GetDiskFreeSpaceEx:

  function(RootName: Pchar; var FreeForCaller, TotNoOfBytes: LargeInt;
    TotNoOfFreeBytes: pLargeInt): BOOL; stdcall;
  SectorsPCluster, BytesPSector, FreeClusters, TotalClusters: DWORD;
  LDiskFree, LSizeOfDisk: LargeInt;
  Lib: THandle;
begin
  LDiskFree := -1;
  LSizeOfDisk := -1;
  Lib := GetModuleHandle('Kernel32');
  if Lib <> 0 then
  begin
    @GetDiskFreeSpaceEx := GetProcAddress(Lib, 'GetDiskFreeSpaceExA');
    if ( @GetDiskFreeSpaceEx <> NIL) then
      // We probably have W95+OSR2 or better.
      if not GetDiskFreeSpaceEx(PChar(FDrive), LDiskFree,
        LSizeOfDisk, NIL) then
      begin
        LDiskFree   := -1;
        LSizeOfDisk := -1;
      end;
    FreeLibrary(Lib);                       //v1.52i
  end;
  if (LDiskFree = -1) then
    // We have W95 original or W95+OSR1 or an error.
    if GetDiskFreeSpace(PChar(FDrive), SectorsPCluster, BytesPSector,
      FreeClusters, TotalClusters) then
    begin
{$IFDEF VERD2D3}
      LDiskFree   := (1.0 * BytesPSector) * SectorsPCluster * FreeClusters;
      LSizeOfDisk := (1.0 * BytesPSector) * SectorsPCluster * TotalClusters;
{$ELSE}
      LDiskFree   := LargeInt(BytesPSector) * SectorsPCluster * FreeClusters;
      LSizeOfDisk := LargeInt(BytesPSector) * SectorsPCluster * TotalClusters;
{$ENDIF}
    end;
  if (Action and 1) <> 0 then
    FFreeOnDisk := LDiskFree;
  if (Action and 2) <> 0 then
    FSizeOfDisk := LSizeOfDisk;
end;

 // Check to see if drive in FDrive is a valid drive.
 // If so, put it's volume label in FVolumeName,
 //        put it's size in FSizeOfDisk,
 //        put it's free space in FDiskFree,
 //        and return true.
 // was IsDiskPresent
 // If not valid, return false.
 // Called by _List() and CheckForDisk().

function TZipWorker.GetDriveProps: Boolean;
var
  SysFlags, OldErrMode: DWord;
  NamLen: Cardinal;
{$IFDEF VERD2D3}
  SysLen: Cardinal;
{$ELSE}
  SysLen: DWord;
{$ENDIF}
  VolNameAry: array[0..255] of Char;
  Num:  Integer;
  Bits: set of 0..25;
  DriveLetter: Char;
  DiskSerial: Integer;
begin
  NamLen      := 255;
  SysLen      := 255;
  FSizeOfDisk := 0;
  FDiskFree   := 0;
  FVolumeName := '';
  VolNameAry[0] := #0;
  Result      := False;
  DriveLetter := UpperCase(FDrive)[1];

  if DriveLetter <> '\' then                // Only for local drives
  begin
    if (DriveLetter < 'A') or (DriveLetter > 'Z') then
      raise EZipMaster.CreateResDrive(DS_NotaDrive, FDrive);

    Integer(Bits) := GetLogicalDrives();
    Num := Ord(DriveLetter) - Ord('A');
    if not (Num in Bits) then
      raise EZipMaster.CreateResDrive(DS_DriveNoMount, FDrive);
  end;

  OldErrMode := SetErrorMode(SEM_FAILCRITICALERRORS);
  // Turn off critical errors:

  // Since v1.52c no exception will be raised here; moved to List() itself.
  if ( not FDriveFixed) and
    // 1.72 only get Volume label for removable drives
    {If}( not GetVolumeInformation(PChar(FDrive), VolNameAry,
    NamLen, @DiskSerial,
    SysLen, SysFlags, NIL, 0)) then
  begin
    // W'll get this if there is a disk but it is not or wrong formatted
    // so this disk can only be used when we also want formatting.
    if (GetLastError() = 31) and (AddDiskSpanErase in FAddOptions) then
      Result := True;
    SetErrorMode(OldErrMode);               //v1.52i
    Exit;
  end;

  FVolumeName := VolNameAry;
  { get free disk space and size. }
  DiskFreeAndSize(3);                       // RCV150199

  SetErrorMode(OldErrMode);                 // Restore critical errors:

  // -1 is not very likely to happen since GetVolumeInformation catches errors.
  // But on W95(+OSR1) and a UNC filename w'll get also -1, this would prevent
  // opening the file. !!!Potential error while using spanning with a UNC filename!!!
  if (DriveLetter = '\') or ((DriveLetter <> '\') and (FSizeOfDisk <> -1)) then
    Result := True;
end;

function TZipWorker.AppendSlash(sDir: String): String;
begin
  if (sDir <> '') and (sDir[Length(sDir)] <> '\') then
    Result := sDir + '\'
  else
    Result := sDir;
end;

 //---------------------------------------------------------------------------
 //---------------------------------------------------------------------------

function TZipWorker.GetDirEntry(idx: Integer): pZipDirEntry;
begin
  Result := pZipDirEntry(ZipContents.Items[idx]);
end;

function FileVersion(fname: String): String;
var
  siz:  Integer;
  buf, Value: Pchar;
  hndl: DWORD;
begin
  Result := '?.?.?.?';
  siz    := GetFileVersionInfoSize(PChar(fname), hndl);
  if siz > 0 then
  begin
    buf := AllocMem(siz);
    try
      GetFileVersionInfo(PChar(fname), 0, siz, buf);
      if VerQueryValue(buf, PChar('StringFileInfo\040904E4\FileVersion')
        , pointer(Value), hndl) then
        Result := Value
      else if VerQueryValue(buf, PChar('StringFileInfo\040904B0\FileVersion')
        , pointer(Value), hndl) then
        Result := Value;
    finally
      FreeMem(buf);
    end;
  end;
end;

(*? TZipWorker.FullVersionString
1.76 5 May 2004 RA fix cast to TZipSFX
*)
function TZipWorker.FullVersionString: String;
begin
{$IFDEF NO_SPAN}
  Result := 'ZipMaster ' + ZIPMASTERBUILD + ' -SPAN ';
{$ELSE}
  Result := 'ZipMaster ' + ZIPMASTERBUILD + ' ';
{$ENDIF}
{$IFDEF NO_SFX}
  Result := Result + ' ,no sfx ';
{$ELSE}
  Result := Result + ' ,SFX = ';
  if assigned(fSFX) then
    Result := Result + TZipSFX(fSFX).Version
  else
    Result := Result + 'none';
{$ENDIF}
  //            if ZipDllHandle <> 0 then
  Result := Result + ', ZipDll ' + FileVersion(FZipDll.Path);
  //            if UnzDllHandle <> 0 then
  Result := Result + ', UnzDll ' + FileVersion(FUnzDll.Path);
end;
//? TZipWorker.FullVersionString

 //---------------------------------------------------------------------------
 // Read data from the input file with a maximum of 8192(BufSize) bytes per read
 // and write this to the output file.
 // In case of an error an Exception is raised and this will
 // be caught in WriteSpan.

{$IFNDEF NO_SPAN}
procedure TZipWorker.RWSplitData(var Buffer; ReadLen, ZSErrVal: Integer);
var
  SizeR, ToRead: Integer;
begin
  while ReadLen > 0 do
  begin
    ToRead := BufSize;
    if ReadLen < BufSize then
      ToRead := ReadLen;
    SizeR := FileRead(FInFileHandle, Buffer, ToRead);
    if SizeR <> ToRead then
      raise EZipMaster.CreateResDisp(ZSErrVal, True);
    WriteSplit(Buffer, SizeR, 0);
    Dec(ReadLen, SizeR);
  end;
end;

//---------------------------------------------------------------------------
(*? TZipWorker.RWJoinData
*)
procedure TZipWorker.RWJoinData(var Buffer; ReadLen, DSErrIdent: Integer);
var
  ToRead, SizeR: Integer;
begin
  while ReadLen > 0 do
  begin
    ToRead := BufSize;
    if ReadLen < BufSize then
      ToRead := ReadLen;
    SizeR := FileRead(FInFileHandle, Buffer, ToRead);
    if SizeR <> ToRead then
    begin
      // Check if we are at the end of a input disk.
      if FileSeek64(FInFileHandle, 0, 1) <> FileSeek64(FInFileHandle, 0, 2) then
        raise EZipMaster.CreateResDisp(DSErrIdent, True);
      // It seems we are at the end, so get a next disk.
      GetNewDisk(FDiskNr + 1);
    end;
    if SizeR > 0 then                       // Fix by Scott Schmidt v1.52n
    begin
      WriteJoin(Buffer, SizeR, DSErrIdent);
      Dec(ReadLen, SizeR);
    end;
  end;
end;
//? TZipWorker.RWJoinData

//---------------------------------------------------------------------------

function TZipWorker.MakeString(Buffer: Pchar; Size: Integer): String;
begin
  SetLength(Result, Size);
  StrLCopy(PChar(Result), Buffer, Size);
end;

{$ENDIF}
{$IFNDEF NO_SFX}
// SFX support
(*? TZipWorker.ConvertSFX
1.76 10 May 2004 check file type
1.73 15 July 2003 RA handling of exceptions
*)

function TZipWorker.ConvertSFX: Integer;
var
  slave: TCustomZipSFX;
begin
  slave   := GetSFXSlave;
  ErrCode := 0;
  FSuccessCnt := 1;

  Result := 0;
  with TFriendSFX(slave) do
  begin
    SourceFile := FZipFileName;
    TargetFile := ChangeFileExt(FZipFileName, '.exe');
  end;
  try
    Slave.Convert;
  except
    on E: Exception do
    begin
      if FUnattended = False then
        {ShowMessage}ZipMessageDlg(E.Message, DHC_ExSFX2EXE);
      if Assigned(OnMessage) then
        OnMessage(Master, 0, E.Message);
      Result      := 1;
      FSuccessCnt := 0;
    end;
  end;
end;
//? TZipWorker.ConvertSFX

function TZipWorker.NewSFXFile(const ExeName: String): Integer;
var
  slave: TCustomZipSFX;
begin
  slave  := GetSFXSlave;
  Result := 0;
  with TFriendSFX(slave) do
  begin
    SourceFile := FZipFileName;
    TargetFile := ExeName;
  end;
  Slave.CreateNewSFX;
end;

(*? TZipWorker.ConvertZIP
1.76 10 May 2004 check file type
1.73 15 July 2003 RA handling of exceptions
{ Convert an .EXE archive to a .ZIP archive. }
{ returns 0 if good, or else a negative error code }
*)

function TZipWorker.ConvertZIP: Integer;
var
  slave: TCustomZipSFX;
begin
  slave   := GetSFXSlave;
  Result  := 0;
  ErrCode := 0;
  FSuccessCnt := 1;
  with TFriendSFX(slave) do
  begin
    SourceFile := FZipFileName;
    TargetFile := ChangeFileExt(FZipFileName, '.zip');
  end;
  try
    Slave.Convert;
  except
    on E: Exception do
    begin
      if FUnattended = False then
        ZipMessageDlg(E.Message, DHC_ExSFX2Zip);
      //        ShowMessage(E.Message);
      if Assigned(OnMessage) then
        OnMessage(Master, 0, E.Message);
      Result      := 1;
      FSuccessCnt := 0;
    end;
  end;
end;
//? TZipWorker.ConvertZIP

{* Return value:
 0 = The specified file is not a SFX
 1 = It is one
 -7  = Open, read or seek error
 -8  = memory error
 -9  = exception error
 -10 = all other exceptions
*}

function TZipWorker.IsZipSFX(const SFXExeName: String): Integer;
var
  r: Integer;
begin
  r      := QueryZip(SFXExeName);                // SFX = 1 + 128 + 64
  Result := 0;
  if (r and (1 or 128 or 64)) = (1 or 128 or 64) then
    Result := 1;
end;

{$ENDIF}

end.

