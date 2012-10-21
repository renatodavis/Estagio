unit ZipMsg;

(* 1.77   22 September 2004
*)
interface

const
  GE_FatalZip  = 10101;
  GE_NoZipSpecified = 10102;
  GE_NoMem     = 10103;
  GE_WrongPassword = 10104;
  GE_CopyFile  = 10105;
  GE_Except    = 10106; // new v1.80
  GE_Reentered = 10107; // new v1.80
  GE_Busy      = 10108; // new 1.76
  GE_Inactive  = 10109; // new 1.76
  GE_RangeError = 10110; // new 176
  GE_TempZip   = 10111; // new 176
  GE_WasBusy   = 10112; // new 176
  GE_EventEx   = 10113; // new 176
  //  GE_ExDisp                 = 10114; // new 176
  //  GE_ExDisk                 = 10115; // new 176
  //  GE_ExDrive                = 10116; // new 176
  //  GE_ExFiles                = 10117; // new 176
  GE_DLLAbort  = 10118; // new 176
  GE_DLLBusy   = 10119; // new 176
  GE_DLLCancel = 10120; // new 176
  GE_DLLMem    = 10121; // new 176
  GE_DLLStruct = 10122; // new 176
  GE_DLLEvent  = 10123; // new 176
  GE_DLLCritical = 10124; // new 176
  GE_Unknown   = 10125; // new 176

  RN_ZipSFXData  = 10140;     // new v1.6    Rename
  RN_NoRenOnSpan = 10141;     // new v1.6    Rename
  RN_ProcessFile = 10142;     // new v1.6    Rename
  RN_RenameTo    = 10143;     // new v1.6    Rename
  RN_InvalidDateTime = 10144; // new v1.73

  PW_UnatAddPWMiss = 10150;
  PW_UnatExtPWMiss = 10151;
  PW_Ok      = 10152;      // new v1.6    Password dialog
  PW_Cancel  = 10153;      // new v1.6    Password dialog
  PW_Caption = 10154;      // new v1.6    Password dialog
  PW_MessageEnter = 10155; // new v1.6    Password dialog
  PW_MessageConfirm = 10156; // new v1.6    Password dialog
  PW_CancelAll = 10157;    // new v1.6    Password dialog
  PW_Abort   = 10158;      // new v1.6    Password dialog
  PW_ForFile = 10159;      // new v1.6    Password dialog

  CF_SourceIsDest   = 10180; // new v1.6             CopyZippedFiles
  CF_OverwriteYN    = 10181; // new v1.6             CopyZippedFiles
  CF_CopyFailed     = 10182; // new v1.6             CopyZippedFiles
  CF_SourceNotFound = 10183; // new v1.6             CopyZippedFiles
  CF_SFXCopyError   = 10184; // new v1.6             CopyZippedFiles
  CF_DestFileNoOpen = 10185; // new v1.6             CopyZippedFiles
  CF_NoCopyOnSpan   = 10186; // new v1.7

  LI_ReadZipError   = 10201;
  LI_ErrorUnknown   = 10202;
  LI_WrongZipStruct = 10203;
  LI_GarbageAtEOF   = 10204;
  LI_FileTooBig     = 10205; // v176
  LI_MethodUnknown  = 10206; // v177
  
 // new 1.77 MsgDialogBtns
  ZB_Yes = 10220;
  ZB_No = 10221;
  ZB_OK = 10222;
  ZB_Cancel = 10223;
  ZB_Abort =  10224;
  ZB_Retry = 10225;
  ZB_Ignore = 10226;
  ZB_CancelAll = 10227;
  ZB_NoToAll = 10228;
  ZB_YesToAll = 10229;
//  ZB_Help = 10230;

  AD_NothingToZip = 10301;
  AD_UnattPassword = 10302;
  AD_NoFreshenUpdate = 10303;
  AD_AutoSFXWrong = 10304;  // new v1.6    Add AutoSFX
  AD_NoStreamDLL = 10305;   // new v1.6    Add Stream
  AD_InIsOutStream = 10306; // new v1.6    Add Stream
  AD_InvalidName = 10307;   // new v1.6    Add Stream
  AD_NoDestDir = 10308;     // new 1.73

  DL_NothingToDel = 10401;
  DL_NoDelOnSpan  = 10402; // new v1.7

  EX_FatalUnZip    = 10501;
  EX_UnAttPassword = 10502;
  EX_NoStreamDLL   = 10503; // new v1.6    MemoryExtract
  EX_NoExtrDir     = 10504;

  //  LZ_ZipDllLoaded           = 10601;
  //  LZ_NoZipDllExec           = 10602;
  //  LZ_NoZipDllVers           = 10603;
  //  LZ_NoZipDll               = 10604;
  //  LZ_OldZipDll              = 10605; // new v1.7
  //  LZ_ZipDllUnloaded         = 10606;

  LD_NoDll     = 10650;
  LD_BadDll    = 10651;
  LD_DllLoaded = 10652;
  LD_DllUnloaded = 10653;

  //  LU_UnzDllLoaded           = 10701;
  //  LU_NoUnzDllExec           = 10702;
  //  LU_NoUnzDllVers           = 10703;
  //  LU_NoUnzDll               = 10704;
  //  LU_OldUnzDll              = 10705; // new v1.7
  //  LU_UnzDllUnloaded         = 10706;

  //  SF_StringTooLong          = 10801; // Changed v1.6
  SF_StringToLong    = 0;
  SF_NoZipSFXBin     = 10802;
  SF_InputIsNoZip    = 10803;
  SF_NoSFXSupport    = 10804; // new v1.7 (v2.0)
  SF_MsgTooLong      = 10805; // new v1.76
  SF_DefPathTooLong  = 10806; // new v1.76
  SF_DlgTitleTooLong = 10807; // new v1.76
  SF_CmdLineTooLong  = 10808; // new v1.76
  SF_FBkPathTooLong  = 10809; // new v1.76

  CZ_NoExeSpecified = 10901;
  CZ_InputNotExe    = 10902;
  CZ_SFXTypeUnknown = 10903;

  DS_NoInFile   = 11001;
  DS_FileOpen   = 11002;
  DS_NotaDrive  = 11003;   // Changed a bit v1.52c
  DS_DriveNoMount = 11004; // Changed a bit v1.52c
  DS_NoVolume   = 11005;
  DS_NoMem      = 11006;
  DS_Canceled   = 11007;
  DS_FailedSeek = 11008;
  DS_NoOutFile  = 11009;
  DS_NoWrite    = 11010;
  DS_EOCBadRead = 11011;
  DS_LOHBadRead = 11012;
  DS_CEHBadRead = 11013;
  DS_LOHWrongSig = 11014;
  DS_CEHWrongSig = 11015;
  DS_LONameLen  = 11016;
  DS_CENameLen  = 11017;
  DS_LOExtraLen = 11018;
  DS_CEExtraLen = 11019;
  DS_DataDesc   = 11020;
  DS_ZipData    = 11021;
  DS_CECommentLen = 11022;
  DS_EOArchComLen = 11023;
  DS_ErrorUnknown = 11024;
  DS_NoUnattSpan = 11025;
  DS_EntryLost  = 11026;
  DS_NoTempFile = 11027;
  DS_LOHBadWrite = 11028;
  DS_CEHBadWrite = 11029;
  DS_EOCBadWrite = 11030;
  DS_ExtWrongSig = 11031;
  DS_NoDiskSpace = 11032;
  DS_InsertDisk = 11033;
  DS_InsertVolume = 11034;
  DS_InDrive    = 11035;
  DS_NoValidZip = 11036;
  DS_FirstInSet = 11037;
  DS_NotLastInSet = 11038;
  DS_AskDeleteFile = 11039;
  DS_AskPrevFile = 11040;
  DS_NoSFXSpan  = 11041;
  DS_CEHBadCopy = 11042;
  DS_EOCBadSeek = 11043;
  DS_EOCBadCopy = 11044;
  DS_FirstFileOnHD = 11045;
  DS_InsertAVolume = 11046; // new v1.52c  DiskSpan
  DS_CopyCentral = 11047;   // new v1.52i  DiskSpan
  DS_NoDiskSpan = 11048;    // new v1.7 (v2.0)
  DS_UnknownError = 11049;
  DS_NoRenamePart = 11050; // v176

  FM_Erase   = 11101; // 1.72 ?
  FM_Confirm = 11102; // 1.72 ?

  ED_SizeTooLarge = 11201; // 1.73

  CD_NoCDOnSpan   = 11301;
  CD_NoEventHndlr = 11302;
  CD_LOExtraLen   = 11303;
  CD_CEExtraLen   = 11304;
  CD_CEComLen     = 11305;
  CD_FileName     = 11306;
  CD_CEHDataSize  = 11307;
  CD_Changing     = 11308;
  CD_DuplFileName = 11309;
  CD_NoProtected  = 11310;
  CD_InvalidFileName = 11311;
  CD_NoChangeDir  = 11312;
  CD_FileSpecSkip = 11313;

  PR_Progress = 11400;
  PR_Archive  = 11401;
  PR_CopyZipFile = 11402;
  PR_SFX      = 11403;
  PR_Header   = 11404;
  PR_Finish   = 11405;
  PR_Copying  = 11406;
  PR_CentrlDir = 11407;
  PR_Checking = 11408;
  PR_Loading  = 11409;
  PR_Joining  = 11410;
  PR_Splitting = 11411;

  WZ_DropDirOnly    = 11500;
  WZ_NothingToWrite = 11501;

  TM_Erasing    = 11600; // v176
  TM_Deleting   = 11601; // v176
  TM_GetNewDisk = 11602;

implementation

end.
