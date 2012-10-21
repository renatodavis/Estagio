unit ZipStrs;

(* Must have default strings plus new strings
        if USE_ALLZIPSTRINGS define all strings will have defaults
 edited 3 October 2004
*)

interface

uses
  ZipMsg;

type
  TZipStrEvent = procedure(Ident: Integer; var DefStr: String) of object;

// Global function to load resource string - new 1.76
function ZipLoadStr(ident: Integer): String; overload;
function ZipLoadStr(ident: Integer; const DefStr: String): String; overload;
function ZipFmtLoadStr(Ident: Integer; const Args: array of const): String; overload;
{function ZipFmtLoadStr(Ident: Integer; const DefStr: string;
                const Args: array of const): string; overload; }
function SetZipStr(handler: TZipStrEvent): TZipStrEvent;


implementation

uses SysUtils;

{$I '..\vcl\ZipConfig.inc'}

type
  TZipResRec = packed record
    i: Word;
    s: pResStringRec;
  end;
  {
const
  RESOURCE_ERROR: string  =
    'ZipMsgXX.res is probably not linked to the executable' + #10 +
    'Missing String ID is: %d ';
   }
resourcestring
  // required strings
  _CF_OverwriteYN  = 'Overwrite file ''%s'' in ''%s'' ?';
  _DS_AskDeleteFile = 'There is already a file %s'#10'Do you want to overwrite this file';
  _DS_AskPrevFile  = 'ATTENTION: This is previous disk no %d!!!'#10 +
    'Are you sure you want to overwrite the contents';
  _DS_CopyCentral  = 'Central directory';
  _DS_InDrive      = #10'in drive: %s';
  _DS_InsertAVolume = 'Please insert disk volume %.1d';
  _DS_InsertDisk   = 'Please insert last disk';
  _DS_InsertVolume = 'Please insert disk volume %.1d of %.1d';
  _DS_NoDiskSpace  = 'This disk has not enough free space available';
  _DS_NoOutFile    = 'Creation of output file failed';
  _DS_NoRenamePart = 'Last part left as : %s';
  _LI_FileTooBig   = 'File larger than 4GB';
  _LI_MethodUnknown = 'Unknown Compression Method';

  _FM_Confirm   = 'Confirm';
  _FM_Erase     = 'Erase %s';
  _GE_CopyFile  = 'Copying: ';
  _GE_RangeError = 'Index (%d) outside range 1..%d';
  _GE_TempZip   = 'Temporary zipfile: %s';
  _GE_WasBusy   = 'Busy + %s';
  _GE_Unknown   = ' Unknown error %d';            // new
  _PR_Loading   = '*Loading Directory';
  _RN_ProcessFile = 'Processing: ';
  _RN_RenameTo  = ' renamed to: ';
  _TM_Erasing   = 'EraseFloppy - Removing %s';    // new
  _TM_Deleting  = 'EraseFloppy - Deleting %s';    // new
  _TM_GetNewDisk = 'Trace : GetNewDisk Opening: %s';
  _PW_Caption   = 'Password';
  _PW_MessageEnter = 'Enter Password ';
  _PW_MessageConfirm = 'Confirm Password ';
  // new strings
  _GE_Except    = 'Exception in Event handler ';
  _GE_Reentered = 'Was busy, Instructions may have been lost!';
  _GE_Busy      = ' Busy, Please wait';
  _GE_Inactive  = 'not Active';
  _GE_EventEx   = 'Exception in Event ';                  // new
  _GE_DLLAbort  = 'DLL Error - Aborting';
  _GE_DLLBusy   = 'DLL Error - Busy';
  _GE_DLLCancel = 'DLL Error - User Cancelled';
  _GE_DLLMem    = 'DLL Error - Not enough memory';
  _GE_DLLStruct = 'DLL Error - Invalid structure';
  _GE_DLLEvent  = 'DLL Error - Exception in handler ';
  _GE_DLLCritical = 'critical DLL Error %d';
  _SF_MsgTooLong = 'SFX Message string exceeds 255 characters!';
  _SF_DefPathTooLong = 'SFX Default path exceeds 255 characters!';
  _SF_DlgTitleTooLong = 'SFX Dialog title exceeds 255 characters!';
  _SF_CmdLineTooLong = 'SFX Command line exceeds 255 characters!';
  _SF_FBkPathTooLong = 'SFX Fallback path exceeds 255 characters!';
  _ZB_Yes = '&Yes';
  _ZB_No = '&No';
  _ZB_OK = '&OK';
  _ZB_Cancel = '&Cancel';
  _ZB_Abort =  '&Abort';
  _ZB_Retry = '&Retry';
  _ZB_Ignore = '&Ignore';
  _ZB_CancelAll = 'CancelAll';
  _ZB_NoToAll = 'NoToAll';
  _ZB_YesToAll = 'YesToAll';
//  _ZB_Help = 'Help';

  // strings
{$IFDEF USE_ALLZIPSTRINGS}
  _GE_FatalZip = 'Fatal Error in ZipDLL.DLL: abort exception';
  _GE_NoZipSpecified = 'Error - no zip file specified!';
  _GE_NoMem   = 'Requested memory not available';
  _GE_WrongPassword = 'Error - passwords do NOT match'#10'Password ignored';
  _RN_ZipSFXData = 'Error while copying the SFX header';
  _RN_NoRenOnSpan = 'Rename is not implemented for a spanned zip file';
  _RN_InvalidDateTime = 'Invalid date/time argument for file: ';
  _PW_UnatAddPWMiss = 'Error - no add password given';
  _PW_UnatExtPWMiss = 'Error - no extract password given';
//  _PW_Ok      = '&Ok';
//  _PW_Cancel  = '&Cancel';
//  _PW_CancelAll = 'Cancel all';
//  _PW_Abort   = 'Abort';
  _PW_ForFile = ' for file: ';
  _CF_SourceIsDest = 'Source archive is the same as the destination archive!';
  _CF_CopyFailed = 'Copying a file from ''%s'' to ''%s'' failed';
  _CF_SourceNotFound = 'File ''%s'' is not present in ''%s''!';
  _CF_SFXCopyError = 'Error while copying the SFX data';
  _CF_DestFileNoOpen = 'Destination zip archive could not be opened!';
  _CF_NoCopyOnSpan = 'CopyZippedFiles is not implemented for a spanned zip file';
  _LI_ReadZipError = 'Seek error reading Zip archive!';
  _LI_ErrorUnknown = 'Unknown error in List() function'#10'';
  _LI_WrongZipStruct = 'Warning - Error in zip structure!';
  _LI_GarbageAtEOF = 'Warning - Garbage at the end of the zipfile!';
  _AD_NothingToZip = 'Error - no files to zip!';
  _AD_UnattPassword = 'Unattended action not possible without a password';
  _AD_NoFreshenUpdate = 'AddFreshen or AddUpdate not possible on a spanned archive';
  _AD_AutoSFXWrong = 'Error %.1d occurred during Auto SFX creation.';
  //  _AD_NoStreamDLL = 'Error - your ZipDLL.dll can not use streams,' +
  //    ' please update to version >= 1.60';
  _AD_InIsOutStream = 'Input stream may not be set to the output stream';
  _AD_InvalidName = 'Wildcards are not allowed in Filename or file specification';
  _AD_NoDestDir = 'Destination directory ''%s'' must exist!';
  _DL_NothingToDel = 'Error - no files selected for deletion';
  _DL_NoDelOnSpan = 'Delete Files from archive is not implemented' +
    ' for a spanned zip file';
  _EX_FatalUnZip = 'Fatal Error in UnzDLL.DLL: abort exception';
  _EX_UnAttPassword = 'Warning - Unattended Extract: possible not all files extracted';
  _EX_NoStreamDLL = 'Error - your UnzDLL.dll can not use streams,' +
    ' please update to version >= 1.60';
  _EX_NoExtrDir = 'Extract directory ''%s'' must exist';
  _LD_NoDll   = 'Failed to load %s';
  _LD_BadDll  = 'Unable to load %s - It is old or corrupt';
  _LD_DllLoaded = 'Loaded ';
  _LD_DllUnloaded = 'Unloaded ';
  _SF_NoZipSFXBin = 'Error: SFX stub ''%s'' not found!';
  _SF_InputIsNoZip = 'Error: input file is not a zip file';
  _SF_NoSFXSupport = 'SFX Functions not supported';
  _CZ_NoExeSpecified = 'Error - no .EXE file specified';
  _CZ_InputNotExe = 'Error: input file is not an .EXE file';
  _CZ_SFXTypeUnknown = 'Error determining the type of SFX archive';
  _DS_NoInFile = 'Input file does not exist';
  _DS_FileOpen = 'Zip file could not be opened';
  _DS_NotaDrive = 'Not a valid drive: %s';
  _DS_DriveNoMount = 'Drive %s is NOT defined';
  _DS_NoVolume = 'Volume label could not be set';
  _DS_NoMem   = 'Not enough memory to display MsgBox';
  _DS_Canceled = 'User canceled operation';
  _DS_FailedSeek = 'Seek error in input file';
  _DS_NoWrite = 'Write error in output file';
  _DS_EOCBadRead = 'Error while reading the End Of Central Directory';
  _DS_LOHBadRead = 'Error while reading a local header';
  _DS_CEHBadRead = 'Error while reading a central header';
  _DS_LOHWrongSig = 'A local header signature is wrong';
  _DS_CEHWrongSig = 'A central header signature is wrong';
  _DS_LONameLen = 'Error while reading a local file name';
  _DS_CENameLen = 'Error while reading a central file name';
  _DS_LOExtraLen = 'Error while reading a local extra field';
  _DS_CEExtraLen = 'Error while reading a central extra field';
  _DS_DataDesc = 'Error while reading/writing a data descriptor area';
  _DS_ZipData = 'Error while reading zipped data';
  _DS_CECommentLen = 'Error while reading a file comment';
  _DS_EOArchComLen = 'Error while reading the archive comment';
  _DS_ErrorUnknown = 'UnKnown error in function ReadSpan(), WriteSpan(),' +
    ' ChangeFileDetails() or CopyZippedFiles()'#10'';
  _DS_NoUnattSpan = 'Unattended disk spanning not implemented';
  _DS_EntryLost = 'A local header not found in internal structure';
  _DS_NoTempFile = 'Temporary file could not be created';
  _DS_LOHBadWrite = 'Error while writing a local header';
  _DS_CEHBadWrite = 'Error while writing a central header';
  _DS_EOCBadWrite = 'Error while writing the End Of Central Directory';
  _DS_ExtWrongSig = 'Error while reading a Extended Local signature';
  _DS_NoValidZip = 'This archive is not a valid Zip archive';
  _DS_FirstInSet = 'This is the first disk in a backup set,'#10 +
    'please insert the last disk of this set';
  _DS_NotLastInSet = 'This is the %dth disk in a backup set,'#10 +
    'please insert the last disk of this set';
  _DS_NoSFXSpan = 'Error - Self extracting archives(.exe) can not be spanned';
  _DS_CEHBadCopy = 'Error while copying a filename of a CEH structure';
  _DS_EOCBadSeek = 'Seek error while skipping a EOC structure';
  _DS_EOCBadCopy = 'Error while copying the zip archive comment';
  _DS_FirstFileOnHD = 'This is the first file in a backup set,'#10 +
    'please choose the last file of this set';
  _DS_NoDiskSpan = 'DiskSpanning not supported';
  _DS_UnknownError = 'Unknown Error';
  _ED_SizeTooLarge = 'Size of FileExtraData is larger than available array';
  _CD_NoCDOnSpan = 'ChangeFileDetails is not implemented for a spanned zip file';
  _CD_NoEventHndlr = 'No Event Handler found to Change File Details';
  _CD_LOExtraLen = 'Error while writing a local extra field';
  _CD_CEExtraLen = 'Error while writing a central extra field';
  _CD_CEComLen = 'Error while writing a file comment';
  _CD_FileName = 'No FileName in changed file details';
  _CD_CEHDataSize = 'The combined length of CEH + FileName +' +
    ' FileComment + ExtraData exceeds 65535';
  _CD_Changing = 'Changing details of: ';
  _CD_DuplFileName = 'Duplicate Filename: %s';
  _CD_NoProtected = 'Cannot change details of Excrypted file';
  _CD_InvalidFileName = 'Invalid Filename: ''%s''';
  _CD_NoChangeDir = 'Cannot change path';
  _CD_FileSpecSkip = 'Filespec ''%s'' skipped';
  _PR_Archive = '*Resetting Archive bit';
  _PR_CopyZipFile = '*Copying Zip File';
  _PR_SFX     = '*SFX';
  _PR_Header  = '*??';
  _PR_Finish  = '*Finalising';
  _PR_Copying = '*Copying';
  _PR_CentrlDir = '*Central Directory';
  _PR_Checking = '*Checking';
  _PR_Joining = '*Joining split zip file';
  _PR_Splitting = '*Splitting zip file';
  _WZ_DropDirOnly = 'Dropping %d empty directory entries';
  _WZ_NothingToWrite = 'Nothing to write';
{$ENDIF}

const
  AllwaysHave = 55;
{$IFDEF USE_ALLZIPSTRINGS}
  RestOfThem  = 130;
{$ELSE}
  RestOfThem  = 0;
{$ENDIF}
  ResTable: array [0..(AllwaysHave + RestOfThem)] of TZipResRec = (
    (i: CF_OverwriteYN; s: @_CF_OverwriteYN),
    (i: DS_AskDeleteFile; s: @_DS_AskDeleteFile),
    (i: DS_AskPrevFile; s: @_DS_AskPrevFile),
    (i: DS_CopyCentral; s: @_DS_CopyCentral),     //?
    (i: DS_InDrive; s: @_DS_InDrive),             //?
    (i: DS_InsertDisk; s: @_DS_InsertDisk),       //?
    (i: DS_InsertVolume; s: @_DS_InsertVolume),   //?
    (i: DS_InsertAVolume; s: @_DS_InsertAVolume), //?
    (i: DS_NoDiskSpace; s: @_DS_NoDiskSpace),  
    (i: DS_FirstInSet; s: @_DS_FirstInSet),
    (i: LI_FileTooBig; s: @_LI_FileTooBig),
    (i: LI_MethodUnknown; s: @_LI_MethodUnknown),
    (i: FM_Confirm; s: @_FM_Confirm),
    (i: FM_Erase; s: @_FM_Erase),
    (i: GE_CopyFile; s: @_GE_CopyFile),
    (i: GE_RangeError; s: @_GE_RangeError),
    (i: GE_TempZip; s: @_GE_TempZip),
    (i: GE_WasBusy; s: @_GE_WasBusy),
    (i: GE_Unknown; s: @_GE_Unknown),
    (i: PR_Loading; s: @_PR_Loading),
    (i: RN_ProcessFile; s: @_RN_ProcessFile),
    (i: RN_RenameTo; s: @_RN_RenameTo),
    (i: TM_Erasing; s: @_TM_Erasing),
    (i: TM_Deleting; s: @_TM_Deleting),
    (i: TM_GetNewDisk; s: @_TM_GetNewDisk),
    (i: GE_Except; s: @_GE_Except),
    (i: GE_Reentered; s: @_GE_Reentered),
    (i: GE_Busy; s: @_GE_Busy),
    (i: GE_Inactive; s: @_GE_Inactive),
    (i: GE_EventEx; s: @_GE_EventEx),
    (i: PW_Caption; s: @_PW_Caption),
    (i: PW_MessageEnter; s: @_PW_MessageEnter),
    (i: PW_MessageConfirm; s: @_PW_MessageConfirm),
    // new strings
    (i: GE_DLLAbort; s: @_GE_DLLAbort),
    (i: GE_DLLBusy; s: @_GE_DLLBusy),
    (i: GE_DLLCancel; s: @_GE_DLLCancel),
    (i: GE_DLLMem; s: @_GE_DLLMem),
    (i: GE_DLLStruct; s: @_GE_DLLStruct),
    (i: GE_DLLEvent; s: @_GE_DLLEvent),
    (i: GE_DLLCritical; s: @_GE_DLLCritical),
    (i: SF_MsgTooLong; s: @_SF_MsgTooLong),
    (i: SF_DefPathTooLong; s: @_SF_DefPathTooLong),
    (i: SF_DlgTitleTooLong; s: @_SF_DlgTitleTooLong),
    (i: SF_CmdLineTooLong; s: @_SF_CmdLineTooLong),
    (i: SF_FBkPathTooLong; s: @_SF_FBkPathTooLong),
    (i: DS_NoRenamePart; s: @_DS_NoRenamePart),
    (i: ZB_Yes; s: @_ZB_Yes),
    (i: ZB_No; s: @_ZB_No),
    (i: ZB_Ok; s: @_ZB_OK),
    (i: ZB_Cancel; s: @_ZB_Cancel),
    (i: ZB_Abort; s: @_ZB_Abort),
    (i: ZB_Retry; s: @_ZB_Retry),
    (i: ZB_Ignore; s: @_ZB_Ignore),
    (i: ZB_CancelAll; s: @_ZB_CancelAll),
    (i: ZB_NoToAll; s: @_ZB_NoToAll),
    (i: ZB_YesToAll; s: @_ZB_YesToAll)
//    (i: ZB_Help; s: @_ZB_Help)
{$IFDEF USE_ALLZIPSTRINGS}
    , (i: GE_FatalZip; s: @_GE_FatalZip),
    (i: GE_NoZipSpecified; s: @_GE_NoZipSpecified),
    (i: GE_NoMem; s: @_GE_NoMem),
    (i: GE_WrongPassword; s: @_GE_WrongPassword),
    (i: GE_CopyFile; s: @_GE_CopyFile),
    (i: GE_Except; s: @_GE_Except),
    (i: GE_Reentered; s: @_GE_Reentered),
    (i: GE_Busy; s: @_GE_Busy),
    (i: GE_Inactive; s: @_GE_Inactive),
    (i: GE_RangeError; s: @_GE_RangeError),
    (i: GE_Tempzip; s: @_GE_TempZip),
    (i: RN_ZipSFXData; s: @_RN_ZipSFXData),
    (i: RN_NoRenOnSpan; s: @_RN_NoRenOnSpan),
    (i: RN_ProcessFile; s: @_RN_ProcessFile),
    (i: RN_RenameTo; s: @_RN_RenameTo),
    (i: RN_InvalidDateTime; s: @_RN_InvalidDateTime),
    (i: PW_UnatAddPWMiss; s: @_PW_UnatAddPWMiss),
    (i: PW_UnatExtPWMiss; s: @_PW_UnatExtPWMiss),
//    (i: PW_Ok; s: @_PW_Ok),
//    (i: PW_Cancel; s: @_PW_Cancel),
//    (i: PW_CancelAll; s: @_PW_CancelAll),
//    (i: PW_Abort; s: @_PW_Abort),
    (i: PW_ForFile; s: @_PW_ForFile),
    (i: CF_SourceIsDest; s: @_CF_SourceIsDest),
    (i: CF_CopyFailed; s: @_CF_CopyFailed),
    (i: CF_SourceNotFound; s: @_CF_SourceNotFound),
    (i: CF_SFXCopyError; s: @_CF_SFXCopyError),
    (i: CF_DestFileNoOpen; s: @_CF_DestFileNoOpen),
    (i: CF_NoCopyOnSpan; s: @_CF_NoCopyOnSpan),
    (i: LI_ReadZipError; s: @_LI_ReadZipError),
    (i: LI_ErrorUnknown; s: @_LI_ErrorUnknown),
    (i: LI_WrongZipStruct; s: @_LI_WrongZipStruct),
    (i: LI_GarbageAtEOF; s: @_LI_GarbageAtEOF),
    (i: AD_NothingToZip; s: @_AD_NothingToZip),
    (i: AD_UnattPassword; s: @_AD_UnattPassword),
    (i: AD_NoFreshenUpdate; s: @_AD_NoFreshenUpdate),
    (i: AD_AutoSFXWrong; s: @_AD_AutoSFXWrong),
    //    (i: AD_NoStreamDLL; s: @_AD_NoStreamDLL),
    (i: AD_InIsOutStream; s: @_AD_InIsOutStream),
    (i: AD_InvalidName; s: @_AD_InvalidName),
    (i: AD_NoDestDir; s: @_AD_NoDestDir),
    (i: DL_NothingToDel; s: @_DL_NothingToDel),
    (i: DL_NoDelOnSpan; s: @_DL_NoDelOnSpan),
    (i: EX_FatalUnZip; s: @_EX_FatalUnZip),
    (i: EX_UnAttPassword; s: @_EX_UnAttPassword),
    (i: EX_NoStreamDLL; s: @_EX_NoStreamDLL),
    (i: EX_NoExtrDir; s: @_EX_NoExtrDir),
    (i: LD_NoDll; s: @_LD_NoDll),
    (i: LD_BadDll; s: @_LD_BadDll),
    (i: LD_DllLoaded; s: @_LD_DllLoaded),
    (i: LD_DllUnloaded; s: @_LD_DllUnloaded),
    (i: SF_NoZipSFXBin; s: @_SF_NoZipSFXBin),
    (i: SF_InputIsNoZip; s: @_SF_InputIsNoZip),
    (i: SF_NoSFXSupport; s: @_SF_NoSFXSupport),
    (i: SF_MsgTooLong; s: @_SF_MsgTooLong),
    (i: SF_DefPathTooLong; s: @_SF_DefPathTooLong),
    (i: SF_DlgTitleTooLong; s: @_SF_DlgTitleTooLong),
    (i: SF_CmdLineTooLong; s: @_SF_CmdLineTooLong),
    (i: SF_FBkPathTooLong; s: @_SF_FBkPathTooLong),
    (i: CZ_NoExeSpecified; s: @_CZ_NoExeSpecified),
    (i: CZ_InputNotExe; s: @_CZ_InputNotExe),
    (i: CZ_SFXTypeUnknown; s: @_CZ_SFXTypeUnknown),
    (i: DS_NoInFile; s: @_DS_NoInFile),
    (i: DS_FileOpen; s: @_DS_FileOpen),
    (i: DS_NotaDrive; s: @_DS_NotaDrive),
    (i: DS_DriveNoMount; s: @_DS_DriveNoMount),
    (i: DS_NoVolume; s: @_DS_NoVolume),
    (i: DS_NoMem; s: @_DS_NoMem),
    (i: DS_Canceled; s: @_DS_Canceled),
    (i: DS_FailedSeek; s: @_DS_FailedSeek),
    (i: DS_NoWrite; s: @_DS_NoWrite),
    (i: DS_EOCBadRead; s: @_DS_EOCBadRead),
    (i: DS_LOHBadRead; s: @_DS_LOHBadRead),
    (i: DS_CEHBadRead; s: @_DS_CEHBadRead),
    (i: DS_LOHWrongSig; s: @_DS_LOHWrongSig),
    (i: DS_CEHWrongSig; s: @_DS_CEHWrongSig),
    (i: DS_LONameLen; s: @_DS_LONameLen),
    (i: DS_CENameLen; s: @_DS_CENameLen),
    (i: DS_LOExtraLen; s: @_DS_LOExtraLen),
    (i: DS_CEExtraLen; s: @_DS_CEExtraLen),
    (i: DS_DataDesc; s: @_DS_DataDesc),
    (i: DS_ZipData; s: @_DS_ZipData),
    (i: DS_CECommentLen; s: @_DS_CECommentLen),
    (i: DS_EOArchComLen; s: @_DS_EOArchComLen),
    (i: DS_ErrorUnknown; s: @_DS_ErrorUnknown),
    (i: DS_NoUnattSpan; s: @_DS_NoUnattSpan),
    (i: DS_EntryLost; s: @_DS_EntryLost),
    (i: DS_NoTempFile; s: @_DS_NoTempFile),
    (i: DS_LOHBadWrite; s: @_DS_LOHBadWrite),
    (i: DS_CEHBadWrite; s: @_DS_CEHBadWrite),
    (i: DS_EOCBadWrite; s: @_DS_EOCBadWrite),
    (i: DS_ExtWrongSig; s: @_DS_ExtWrongSig),
    (i: DS_NoValidZip; s: @_DS_NoValidZip),
    (i: DS_NotLastInSet; s: @_DS_NotLastInSet),  
    (i: DS_NoOutFile; s: @_DS_NoOutFile),
    (i: DS_NoSFXSpan; s: @_DS_NoSFXSpan),
    (i: DS_CEHBadCopy; s: @_DS_CEHBadCopy),
    (i: DS_EOCBadSeek; s: @_DS_EOCBadSeek),
    (i: DS_EOCBadCopy; s: @_DS_EOCBadCopy),
    (i: DS_FirstFileOnHD; s: @_DS_FirstFileOnHD),
    (i: DS_NoDiskSpan; s: @_DS_NoDiskSpan),
    (i: DS_UnknownError; s: @_DS_UnknownError),
    (i: DS_NoRenamePart; s: @_DS_NoRenamePart),
    (i: FM_Erase; s: @_FM_Erase),
    (i: FM_Confirm; s: @_FM_Confirm),
    (i: ED_SizeTooLarge; s: @_ED_SizeTooLarge),
    (i: CD_NoCDOnSpan; s: @_CD_NoCDOnSpan),
    (i: CD_NoEventHndlr; s: @_CD_NoEventHndlr),
    (i: CD_LOExtraLen; s: @_CD_LOExtraLen),
    (i: CD_CEExtraLen; s: @_CD_CEExtraLen),
    (i: CD_CEComLen; s: @_CD_CEComLen),
    (i: CD_FileName; s: @_CD_FileName),
    (i: CD_CEHDataSize; s: @_CD_CEHDataSize),
    (i: CD_Changing; s: @_CD_Changing),
    (i: CD_DuplFileName; s: @_CD_DuplFileName),
    (i: CD_NoProtected; s: @_CD_NoProtected),
    (i: CD_InvalidFileName; s: @_CD_InvalidFileName),
    (i: CD_NoChangeDir; s: @_CD_NoChangeDir),
    (i: CD_FileSpecSkip; s: @_CD_FileSpecSkip),
    (i: PR_Archive; s: @_PR_Archive),
    (i: PR_CopyZipFile; s: @_PR_CopyZipFile),
    (i: PR_SFX; s: @_PR_SFX),
    (i: PR_Header; s: @_PR_Header),
    (i: PR_Finish; s: @_PR_Finish),
    (i: PR_Copying; s: @_PR_Copying),
    (i: PR_CentrlDir; s: @_PR_CentrlDir),
    (i: PR_Checking; s: @_PR_Checking),
    (i: PR_Loading; s: @_PR_Loading),
    (i: PR_Joining; s: @_PR_Joining),
    (i: PR_Splitting; s: @_PR_Splitting),
    (i: WZ_DropDirOnly; s: @_WZ_DropDirOnly),
    (i: WZ_NothingToWrite; s: @_WZ_NothingToWrite),
    (i: TM_Erasing; s: @_TM_Erasing),
    (i: TM_Deleting; s: @_TM_Deleting),
    (i: TM_GetNewDisk; s: @_TM_GetNewDisk)
{$ENDIF}
    );

var
  GOnZipStr: TZipStrEvent;

type
  RenIds = packed record
    new, old: word;
  end;

const
  SubstIDs: array [0..3] of RenIds = (
    (new: ZB_Ok; old: PW_Ok), (new: ZB_Cancel; old: PW_Cancel),
    (new: ZB_CancelAll; old: PW_CancelAll), (new: ZB_Abort; old: PW_Abort));

function Find(id: Integer): pResStringRec;
var
  wi: word;
  i: integer;
begin      
  Result := NIL;
  wi := word(id);
  for i := 0 to high(ResTable) do
    if ResTable[i].i = wi then
    begin
      Result := ResTable[i].s;
      break;
    end;
end;

function FindOld(id: Integer): String;
var i: integer;
begin
  Result := '';
  for i := low(SubstIDs) to high(SubstIDs) do
  begin
    if word(id) = SubstIDs[i].new then
    begin
      Result := ZipLoadStr(SubstIDs[i].old);
      break;
    end;
  end;
end;

function ZipLookup(ident: Integer): String;
var
  p:  pResStringRec;
begin
  Result := '';
  if ident < 10000 then
    exit;
  p := find(ident);
  if p = NIL then
    Result := FindOld(ident)
  else
    Result := LoadResString(p);
end;

function ZipLoadStr(ident: Integer; const DefStr: String): String;
begin
  Result := ZipLoadStr(Ident);

  if Result = '' then
    Result := DefStr;
end;

(*? ZipLoadStr
1.76 8 June 2004 RA initial empty result
*)
function ZipLoadStr(ident: Integer): String;
begin
  Result := '';
  if assigned(GOnZipStr) then
    GOnZipStr(ident, Result);
  if Result = '' then
    Result := SysUtils.LoadStr(Ident);
  if Result = '' then
    Result := ZipLookup(ident);
end;
//? ZipLoadStr

function ZipFmtLoadStr(Ident: Integer; const Args: array of const): String;
begin
  Result := ZipLoadStr(Ident);

  if Result <> '' then
    Result := Format(Result, Args);
end;


function SetZipStr(handler: TZipStrEvent): TZipStrEvent;
begin
  Result := GOnZipStr;
  if Integer( @handler) <> -1 then
    GOnZipStr := handler;
end;

initialization
  GOnZipStr := NIL;

end.
