unit ZCallBck;

interface

uses Windows, SysUtils;

{ Maximum no. of files in a single ZIP file }
const
  FilesMax = 4096;
  { Maximum no. of characters in a password; Do not change! }
  PWLEN    = 80;
   {
type
  CBXData = packed record
    case Boolean of
      FALSE: (Data: pByteArray);
      TRUE: (Written: cardinal);
  end;}

type
  CBFNs = (cbfnOld, cbfnNew, cbfnExtended);

type
  PZCallBackStruct = ^ZCallBackStruct;

    { All the items in the CallBackStruct are passed to the Delphi
      program from the DLL.  Note that the "Caller" value returned
      here is the same one specified earlier in ZipParms by the
      Delphi pgm. }
  ZCallBackStruct = packed record
    Handle: HWND;
    Caller: Pointer;                { "self" reference of the Delphi form }
    Version: LongInt;               { version no. of DLL }
    IsOperationZip: LongBool;       { True=zip, False=unzip }
    ActionCode: Cardinal;//LongInt;  // 1.77
    ErrorCode: LongInt;
    FileSize: Cardinal;                        // 1.72 LongInt;
      //        FileNameOrMsg: array[0..511] of Char;
{        case Boolean of
          FALSE: (FileNameOrMsg: array[0..511] of Char);
          TRUE: (FileName: array[0..503] of Char;
             Data: Cardinal;
             Empty: cardinal);  }
    case cbfns of
      cbfnOld: (FileNameOrMsg: array[0..511] of Char);
      //          cbfnNew: (FileName: array[0..503] of Char;
      cbfnNew: (FileName: array[0..255] of Char;
        FileComment: array[0..247] of Char;
        Data: Cardinal;
        Empty: Cardinal);
      cbfnExtended: (Zero: Cardinal;
        FName: pChar;
        Args: array[0..125] of Cardinal);
  end;

type
    { Declare a function pointer type for the Delphi callback function, to
      be called by the DLL to pass updated status info back to Delphi. }
  { Your callback function must not be a member of a class! }
  ZFunctionPtrType = function(ZCallbackRec: PZCallBackStruct): LongInt{LongBool};
    stdcall;

implementation

end.
