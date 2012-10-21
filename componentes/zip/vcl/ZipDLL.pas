{ ZIPDLL.PAS   - Delphi translation of file "wizzip.h" by Eric W. Engler }
{ Import Unit for ZIPDLL - put this into the "uses" clause of any
  other unit that wants to access the DLL. }

{ I changed this to use dynamic loading of the DLL in order to allow
  the user program to control when to load and unload the DLLs.
  Thanks to these people for sending me dynamic loading code:
     Ewart Nijburg, Nijsoft@Compuserve.com
     P.A. Gillioz,  pag.aria@rhone.ch
}
{ edited R. Peters
            1.73 7 July 2003
            1.75 13 March 2004
            1.76 11 May 2004
            1.77 11 September 2004
}

unit ZIPDLL;

{ $ INCLUDE ZipConfig.inc}

interface

uses Windows, Dialogs, ZCallBck;//, ZLibLoad, ZipBase;//, ZipXcpt;

 //{$IFDEF VERD2D3}
 //type
 //    LongWord = Cardinal;
 //{$ENDIF}

type
  FileData = packed record
    fFileSpec: pchar;
    fFileComment: pchar;                // NEW z->comment and z->com
    fFileAltName: pchar;                // NEW
    fPassword: pchar;                   // NEW, Override in v1.60L
    fEncrypt: Longword;                 // NEW, Override in v1.60L
    fRecurse: Word;                     // NEW, Override in v1.60L
    fNoRecurseFiles: Word;              // NEW, Override
    fDateUsed: Longbool;                // NEW, Override
    fDate: array[0..7] of Char;         // NEW, Override
    fRootDir: pchar;                    // NEW RootDir support for relative paths in v1.60L.
    fNotUsed: array[0..15] of Cardinal; // NEW
  end;

type
  pFileData = ^FileData;

type
  ExcludedFileSpec = packed record
    fFileSpec: pchar;
  end;

type
  pExcludedFileSpec = ^ExcludedFileSpec;

type
  ZipParms2 = packed record
    Handle: HWND;
    Caller: Pointer;
    Version: Longint;
    ZCallbackFunc: ZFunctionPtrType;
    fTraceEnabled: Longbool;
    pZipPassword: pchar;
    pSuffix: pchar;
    fEncrypt: Longbool;
    fSystem: Longbool;
    fVolume: Longbool;
    fExtra: Longbool;
    fNoDirEntries: Longbool;
    fDate: Longbool;
    fVerboseEnabled: Longbool;
    fQuiet: Longbool;
    fLevel: Longint;
    fComprSpecial: Longbool;
    fCRLF_LF: Longbool;
    fJunkDir: Longbool;
    fRecurse: Wordbool;
    fNoRecurseFiles: Word;
    fGrow: Longbool;
    fForce: Longbool;
    fMove: Longbool;
    fDeleteEntries: Longbool;
    fUpdate: Longbool;
    fFreshen: Longbool;
    fJunkSFX: Longbool;
    fLatestTime: Longbool;
    Date: array[0..7] of Char;
    Argc: Longint;
    pZipFN: pchar;
    // After this point the record is different from ZipParms1 structure.
    fTempPath: pchar;               // NEW TempDir v1.5
    fArchComment: pchar;            // NEW ZipComment v1.6
    fArchiveFilesOnly: Smallint;    // NEW when != 0 only zip when archive bit set
    fResetArchiveBit: Smallint;
    // NEW when != 0 reset the archive bit after a successfull zip
    fFDS: pFileData;                // pointer to Array of FileData
    fForceWin: Longbool;            // NEW
    fTotExFileSpecs: Longint;       // Number of ExcludedFileSpec structures.
    fExFiles: pExcludedFileSpec;    // Array of file specs to exclude from zipping.
    fUseOutStream: Longbool;        // Use memory stream as output.
    fOutStream: Pointer;            // Pointer to the start of the output stream data.
    fOutStreamSize: Longword;       // Size of the Output data.
    fUseInStream: Longbool;         // Use memory stream as input.
    fInStream: Pointer;             // Pointer to the start of the input stream data.
    fInStreamSize: Longword;        // Size of the input data.
    fStrFileAttr: DWORD;            // File attributes of the file stream.
    fStrFileDate: DWORD;            // File date/time to set for the streamed file.
    fHowToMove: Longbool;
    fWantedCodePage: Smallint;
    fWantedOS: Smallint;
    //            fNotUsed0: SmallInt;
    fVCLVer: Cardinal;              // new v1.74
    fGRootDir: pChar;               // new 1.76  global root directory
    fNotUsed: array[0..1 {3}] of Cardinal;
    fSeven: Integer;                // End of record (eg. 7)
  end;

type
  pZipParms = ^ZipParms2;

  ZipOpt = (ZipAdd, ZipDelete);
{ NOTE: Freshen, Update, and Move are only variations of Add }
  {
type
  TZipDll = class(TZipLibLoader)
  public
    constructor Create(owner: TZipBase);
    function Exec(Rec: pZipParms): integer;
  end;
   }
implementation

    {
constructor TZipDll.Create(owner: TZipBase);
begin
  inherited Create(owner, true);
end;

function TZipDll.Exec(Rec: pZipParms): integer;
begin
  Result := DoExec(Rec);
end;
}


end.
