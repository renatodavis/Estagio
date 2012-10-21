{ UNZDLL.PAS   - Delphi v2 translation of file "wizunzip.h" by Eric W. Engler }
{ Import Unit for UNZDLL - put this into the "uses" clause of any
  other unit that wants to access the UNZDLL. }

{ I changed this to use dynamic loading of the DLL in order to allow
  the user program to control when to load and unload the DLLs.
  Thanks to these people for sending me dynamic loading code:
     Ewart Nijburg, Nijsoft@Compuserve.com
     P.A. Gillioz,  pag.aria@rhone.ch
}

{ edited R. Peters
            1.77 11 Spetember 2004
}
unit UNZDLL;

interface

uses Windows, Dialogs, ZCallBck;//, ZLibLoad, ZipBase;//, ZipXcpt;

{ These records are very critical.  Any changes in the order of items, the
  size of items, or modifying the number of items, may have disasterous
 results.  You have been warned! }

type
  UnzFileData = packed record
    fFileSpec: pchar;
    fFileAltName: pchar;
    fPassword: pchar;
    fNotUsed: array[0..14] of Cardinal;
  end;
  pUnzFileData = ^UnzFileData;

type
  UnzExFileData = packed record
    fFileSpec: pchar;
    fNotUsed: array[0..2] of Cardinal;
  end;
  pUnzExFileData = ^UnzExFileData;

type
  UnZipParms2 = packed record
    Handle: HWND;
    Caller: Pointer;
    Version: Longint;
    ZCallbackFunc: ZFunctionPtrType;
    fTraceEnabled: Longbool;
    fPromptToOverwrite: Longbool;
    pZipPassword: pchar;
    fTest: Longbool;
    fComments: Longbool;
    fConvert: Longbool;
    fQuiet: Longbool;
    fVerboseEnabled: Longbool;
    fUpdate: Longbool;
    fFreshen: Longbool;
    fDirectories: Longbool;
    fOverwrite: Longbool;
    fArgc: Longint;
    pZipFN: pchar;
    { After this point the record is different from UnZipParms1 }
        { Pointer to an Array of UnzFileData records,
          the last pointer MUST be nil! The UnzDll requires this! }
    fUFDS: pUnzFileData;
    { Pointer to an Array of ExUnzFileData records }
    fXUFDS: pUnzExFileData;
    fUseOutStream: Longbool;        // NEW Use Memory stream as output.
    fOutStream: Pointer;            // NEW Pointer to the start of streaam data.
    fOutStreamSize: Longint;        // NEW Size of the output data.
    fUseInStream: Longbool;         // NEW Use memory stream as input.
    fInStream: Pointer;
    // NEW Pointer to the start of the input stream data.
    fInStreamSize: Longint;         // NEW Size of the input data.
    fPwdReqCount: Cardinal;
    // NEW PasswordRequestCount, How many times a password will be asked per file
    fExtractDir: pchar;
    fNotUsed: array[0..7] of Cardinal;
    fSeven: Longint;
  end;
  pUnZipParms = ^UnZipParms2;

implementation (*
type
  TUnzDll = class(TZipLibLoader)
  public
    constructor Create(owner: TZipBase);
    function Exec(Rec: pUnZipParms): integer;
  end;


implementation

constructor TUnzDll.Create(owner: TZipBase);
begin
  inherited Create(owner, false);
end;

function TUnzDll.Exec(Rec: pUnZipParms): integer;
begin
  Result := DoExec(Rec);
end;

  *)

end.
