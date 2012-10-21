 (******************************************************************)
 (* SFX for DelZip v1.7                                            *)
 (* Copyright 1997-2004 E. W. Engler, C. Vleghert, M. Stephany     *)
 (*                                                                *)
 (* modified by Markus Stephany                                    *)
 (* mailto:delphizip@mirkes.de                                     *)
 (* http://delphizip.mirkes.de                                     *)
 (*                                                                *)
 (* last changed: 01/13/2003                                       *)
 (*  modified 10/04/2004 R. Peters - use EZipMaster                *)
 (*                                                                *)
 (******************************************************************)
unit DZUtils;

{
this unit contains the EZipException error handler and some zip
archive related utility functions
}

{$DEFINE USE_EZipMaster}
interface

uses
{$IFDEF USE_EZipMaster}
  ZipXcpt,
{$ENDIF}
  Windows, SysUtils, Classes, Graphics, ZipMsg, SFXStructs, ShellAPI, Forms;

{$I DELVER.INC}

type
  THowToDeleteFile = (htdFinal, htdAllowUndo);
  TDeleteOpts      = THowToDeleteFile; // compatibility with TZipMaster

{$IFNDEF USE_EZipMaster}
type
  // exception class
  EDelphiZip = class(Exception)
  public
    FDisplayMsg: Boolean; // We do not always want to see a message after an exception.
    // We also save the Resource ID in case the resource is not linked in the application.
    FResIdent: Integer;

    constructor CreateResDisp(const Ident: Integer; const Display: Boolean);
    constructor CreateResDisk(const Ident: Integer; const DiskNo: ShortInt);
    constructor CreateResDrive(const Ident: Integer; const Drive: String);
    constructor CreateResFile(const Ident: Integer; const File1, File2: String);
    constructor CreateDisp(const Message: String; const Display: Boolean);
  end;

  THowToDeleteFile = (htdFinal, htdAllowUndo);
  TDeleteOpts      = THowToDeleteFile; // compatibility with TZipMaster

const
  RESOURCE_ERROR: String = 'ZipMsgXX.res is probably not linked to the executable' +
    #10 + 'Missing String ID is: ';

// replaces an icon in an executable file (stream)
{$ELSE}
type
  EDelphiZip = EZipMaster;

{$ENDIF}
procedure ReplaceIcon(str: TStream; oIcon: TIcon);

// replace an icon in a file
procedure FileReplaceIcon(const sFile: String; oIcon: TIcon);

// adjusts the relative offsets while copying a zip central structure from one stream to another
procedure CopyAndAdjustCentralStructures(strIn, strOut: TStream;
  const iNumEntries, iOffsetDelta, iThisDisk: Integer);

 // copies central structures from one stream to another while removing
 // comments and extra data
procedure CopyStrippedCentralStructures(strIn, strOut: TStream;
  const iNumEntries, iOffsetDelta, iThisDisk: Integer);

// reads the end of central structure in a stream and returns its position
function ReadEndOfCentral(str: TStream; var recEOC: TZipEndOfCentral): Integer;

// find the earliest local zip data
function FindStartOfZipData(str: TStream): Integer;

// erases a file or moves it to recycle bin
procedure EraseFile(const sFile: String; const HowTo: THowToDeleteFile);

// wait cursor handling
procedure StartWaitCursor;
procedure StopWaitCursor;

type
  PImageResourceDirectory = ^_IMAGE_RESOURCE_DIRECTORY;

  _IMAGE_RESOURCE_DIRECTORY = packed record
    Characteristics: DWORD;
    TimeDateStamp: DWORD;
    MajorVersion: Word;
    MinorVersion: Word;
    NumberOfNamedEntries: Word;
    NumberOfIdEntries: Word;
  end;
  TImageResourceDirectory = _IMAGE_RESOURCE_DIRECTORY;

  PImageResourceDirectoryEntry = ^_IMAGE_RESOURCE_DIRECTORY_ENTRY;

  _IMAGE_RESOURCE_DIRECTORY_ENTRY = packed record
    un1: record
      case Integer of
        1: (NameIsString: DWORD); // Bit 31
        2: (NameOffset: DWORD);   // Bits 30..0
        3: (Name: DWORD);
        4: (Id: Word);
    end;
    un2: record
      case Integer of
        1: (OffsetToData: DWORD);
        2: (DataIsDirectory: DWORD);   // Bit 31
        3: (OffsetToDirectory: DWORD); // Bits 30..0
    end;
  end;
  TImageResourceDirectoryEntry = _IMAGE_RESOURCE_DIRECTORY_ENTRY;

  PImageResourceDataEntry = ^_IMAGE_RESOURCE_DATA_ENTRY;

  _IMAGE_RESOURCE_DATA_ENTRY = packed record
    OffsetToData: DWORD;
    Size: DWORD;
    CodePage: DWORD;
    Reserved: DWORD;
  end;
  TImageResourceDataEntry = _IMAGE_RESOURCE_DATA_ENTRY;


  PIconDir = ^ICONDIR;

  ICONDIR = packed record
    Reserved: Word;
    ResType: Word;
    ResCount: Word;
    // idEntries[]: ICONDIRENTRY
  end;
  TIconDir = ICONDIR;

  PIconDirEntry = ^ICONDIRENTRY;

  ICONDIRENTRY = packed record
    bWidth,
    bHeight,
    bColorCount,
    bReserved: Byte;
    wPlanes,
    wBitCount: Word;
    dwBytesInRes,
    dwImageOffset: DWORD;
  end;
  TIconDirEntry = ICONDIRENTRY;


const
  IMAGE_RESOURCE_DATA_IS_DIRECTORY = $80000000;
{ $ifdef BCB}
{$ifndef BCB6}
{$NoDefine IMAGE_RESOURCE_DATA_IS_DIRECTORY}
{$endif}
{ $endif}

// d4 does not know about the PCardinal type
{$IFNDEF DELPHI6UP}
type
  PCardinal = ^Cardinal;
{$ENDIF}

{$I missing_types.inc}

implementation

uses
  Controls;

var
  FWaitCursor: Integer = 0;
  FSaveCursor: TCursor = crDefault;

// wait cursor handling
procedure StartWaitCursor;
begin
  if FWaitCursor = 0 then
  begin
    FSaveCursor   := Screen.Cursor;
    Screen.Cursor := crHourGlass;
  end;
  Inc(FWaitCursor);
end;

procedure StopWaitCursor;
begin
  if FWaitCursor <> 0 then
    Dec(FWaitCursor);
  if FWaitCursor = 0 then
    Screen.Cursor := FSaveCursor;
end;

// erases a file or moves it to recycle bin
procedure EraseFile(const sFile: String; const HowTo: THowToDeleteFile);
var
  recSHF: TSHFileOpStruct;
  sFileToDelete: String;
begin
  // If we do not have a full path then FOF_ALLOWUNDO does not work!?
  sFileToDelete := ExpandFileName(sFile);

  // We need to be able to 'Delete' without getting an error
  // if the file does not exists as in ReadSpan() can occur.
  if not FileExists(sFileToDelete) then
    exit;

  sFileToDelete := sFileToDelete + #0#0;
  FillChar(recSHF, sizeof(recSHF), 0);

  with recSHF do
  begin
    Wnd    := Application.Handle;
    wFunc  := FO_DELETE;
    pFrom  := PChar(sFileToDelete);
    pTo    := NIL;
    fFlags := FOF_SILENT or FOF_NOCONFIRMATION;
    if HowTo = htdAllowUndo then
      fFlags := fFlags or FOF_ALLOWUNDO;
  end;

  if SHFileOperation(recSHF) <> ERROR_SUCCESS then
    raise EDelphiZip.CreateDisp(SysErrorMessage(GetLastError), False);
end;


// replaces an icon in an executable file (stream)
procedure ReplaceIcon(str: TStream; oIcon: TIcon);

var
  hdrSection: TImageSectionHeader;

  function FindFirstIcon(var rec: TImageResourceDataEntry;
  const iLevel: Integer): Boolean;
  var
    recDir:  TImageResourceDirectory;
    recEnt:  TImageResourceDirectoryEntry;
    i, iPos: Integer;
  begin
    // position must be correct
    Result := False;
    if (str.Read(recDir, sizeof(recDir)) <> sizeof(recDir)) then
      raise EDelphiZip.CreateDisp('Error while browsing resources.', True);
    // not yet localized

    with recDir do
      for i := 0 to Pred(NumberOfNamedEntries + NumberOfIdEntries) do
      begin
        if (str.Read(recEnt, sizeof(recEnt)) <> sizeof(recEnt)) then
          raise EDelphiZip.CreateDisp('Error while browsing resources.', True);
        // not yet localized

        // check if a directory or a resource
        with recEnt, recEnt.un1, recEnt.un2 do
        begin
          iPos := str.Position;
          try
            if (DataIsDirectory and IMAGE_RESOURCE_DATA_IS_DIRECTORY) =
              IMAGE_RESOURCE_DATA_IS_DIRECTORY then
            begin
              if ((iLevel = 0) and (MakeIntResource(Name) <> RT_ICON)) or
                ((iLevel = 1) and (Id <> 1)) then
                Continue; // not an icon of id 1

              str.Seek(OffsetToDirectory and ( not IMAGE_RESOURCE_DATA_IS_DIRECTORY) +
                hdrSection.PointerToRawData, soFromBeginning);
              Result := FindFirstIcon(rec, iLevel + 1);
              if Result then
                Break;

            end
            else begin
              // is resource bin data
              str.Seek(OffsetToData + hdrSection.PointerToRawData, soFromBeginning);
              if str.Read(rec, sizeof(rec)) <> sizeof(rec) then
                raise EDelphiZip.CreateDisp('Error while browsing resources.', True);
              // not yet localized
              Result := True;
              Break;
            end;
          finally
            str.Position := iPos;
          end;
        end;
      end;
  end;

var
  hdrDos: TImageDosHeader;
  hdrNT:  TImageNTHeaders;
  i:      Integer;
  bFound: Boolean;
  cAddress: Cardinal;
  recIcon: TImageResourceDataEntry;
  strIco: TMemoryStream;
begin
  bFound := False;

  // check if we have an executable
  str.Seek(0, soFromBeginning);
  if (str.Read(hdrDos, sizeof(hdrDos)) <> sizeof(hdrDos)) or
    (hdrDos.e_magic <> IMAGE_DOS_SIGNATURE) then
    raise EDelphiZip.CreateResDisp(CZ_InputNotExe, True);

  str.Seek(hdrDos._lfanew, soFromBeginning);
  if (str.Read(hdrNT, sizeof(hdrNT)) <> sizeof(hdrNT)) or
    (hdrNT.Signature <> IMAGE_NT_SIGNATURE) then
    raise EDelphiZip.CreateResDisp(CZ_InputNotExe, True);

  // check if we have a resource section
  with hdrNT.OptionalHeader.DataDirectory[IMAGE_DIRECTORY_ENTRY_RESOURCE] do
    if (VirtualAddress = 0) or (Size = 0) then
      raise EDelphiZip.CreateDisp('No resources found in executable.', True)
    // not yet localized
    else
      cAddress := VirtualAddress; // store address

  // iterate over sections
  for i := 0 to Pred(hdrNT.FileHeader.NumberOfSections) do
  begin
    if (str.Read(hdrSection, sizeof(hdrSection)) <> sizeof(hdrSection)) then
      raise EDelphiZip.CreateDisp('Error while reading executable sections.', True);
    // not yet localized

    with hdrSection do
      if VirtualAddress = cAddress then
      begin
        bFound := True;
        Break;
      end;
  end;

  if not bFound then
    raise EDelphiZip.CreateDisp('No resources found in executable.', True);
  // not yet localized

  // go to resource data
  str.Seek(hdrSection.PointerToRawData, soFromBeginning);

  // recourse through the resource dirs to find an icon
  if not FindFirstIcon(recIcon, 0) then
    raise EDelphiZip.CreateDisp('No icon resources found in executable.', True);
  // not yet localized

  // now check the icon
  strIco := TMemoryStream.Create;
  try
    oIcon.SaveToStream(strIco);

    // now search for matching icon
    with PIconDir(strIco.Memory)^ do
    begin
      if (ResType <> RES_ICON) or (ResCount < 1) or (Reserved <> 0) then
        raise EDelphiZip.CreateDisp('No icon found.', True); // not yet localized

      for i := 0 to Pred(ResCount) do
        with PIconDirEntry(PChar(strIco.Memory) + sizeof(TIconDir) +
            (i * sizeof(TIconDirEntry)))^ do
          if (dwBytesInRes = recIcon.Size) and (bReserved = 0) then
          begin
            // matching icon found, replace
            strIco.Seek(dwImageOffset, soFromBeginning);
            str.Seek(hdrSection.PointerToRawData - hdrSection.VirtualAddress +
              recIcon.OffsetToData, soFromBeginning);
            if str.CopyFrom(strIco, recIcon.Size) <> Integer(recIcon.Size)
            then
              raise EDelphiZip.CreateDisp('Cannot copy icon.', True);
            // not yet localized

            // ok and out
            Exit;
          end;
    end;
  finally
    strIco.Free;
  end;

  // no icon copied, so none of matching size found
  raise EDelphiZip.CreateDisp('No matching icon found.', True); // not yet localized
end;

// replace an icon in a file
procedure FileReplaceIcon(const sFile: String; oIcon: TIcon);
var
  str: TFileStream;
begin
  str := TFileStream.Create(sFile, fmOpenReadWrite or fmShareDenyNone);
  try
    ReplaceIcon(str, oIcon);
  finally
    str.Free;
  end;
end;

// adjusts the relative offsets while copying a zip central structure from one stream to another
procedure CopyAndAdjustCentralStructures(strIn, strOut: TStream;
  const iNumEntries, iOffsetDelta, iThisDisk: Integer);
var
  iCur:  Integer;
  recCentral: TZipCentralHeader;
  pData: Pointer;
  rEOC:  TZipEndOfCentral;
begin
  GetMem(pData, 65536 * 3); // filename + extrafield + filecomment
  try
    if iNumEntries > 0 then
      for iCur := 0 to Pred(iNumEntries) do
      begin
        if (strIn.Read(recCentral, sizeof(TZipCentralHeader)) <>
          sizeof(TZipCentralHeader)) or
          (recCentral.HeaderSig <> ZipCentralHeaderSig) then
          raise EDelphiZip.CreateResDisp(DS_CEHBadRead, True); // invalid record

        if recCentral.DiskStart = iThisDisk then
          Inc(recCentral.RelOffLocal, iOffsetDelta);  // adjust offset

        if strOut.Write(recCentral, sizeof(TZipCentralHeader)) <>
          sizeof(TZipCentralHeader) then
          raise EDelphiZip.CreateResDisp(DS_CEHBadWrite, True); // error on writing

        // read and write extra data
        with recCentral do
          if (FileNameLen + ExtraLen + FileComLen) > 0 then
          begin
            if strIn.Read(pData^, FileNameLen + ExtraLen + FileComLen) <>
              (FileNameLen + ExtraLen + FileComLen) then
              raise EDelphiZip.CreateResDisp(DS_CEExtraLen, True); // cannot read

            if strOut.Write(pData^, FileNameLen + ExtraLen + FileComLen) <>
              (FileNameLen + ExtraLen + FileComLen) then
              raise EDelphiZip.CreateResDisp(DS_CEHBadWrite, True); // error on writing
          end;
      end;

    // read, adjust and write end of central
    if (strIn.Read(rEOC, sizeof(TZipEndOfCentral)) <> sizeof(TZipEndOfCentral)) or
      (rEOC.HeaderSig <> ZipEndOfCentralSig) then
      raise EDelphiZip.CreateResDisp(DS_EOCBadRead, True); // invalid eoc

    rEOC.ThisDiskNo := iThisDisk;

    Inc(rEOC.CentralOffset, iOffsetDelta);
    if strOut.Write(rEOC, sizeof(TZipEndOfCentral)) <> sizeof(TZipEndOfCentral) then
      raise EDelphiZip.CreateResDisp(DS_EOCBadWrite, True); // error on writing

    // read an possibly existing file comment
    with rEOC do
      if ZipCommentLen > 0 then
      begin
        if strIn.Read(pData^, ZipCommentLen) <> ZipCommentLen then
          raise EDelphiZip.CreateResDisp(DS_EOArchComLen, True); // error on reading

        if StrOut.Write(pData^, ZipCommentLen) <> ZipCommentLen then
          raise EDelphiZip.CreateResDisp(DS_EOCBadCopy, True); // error on writing

      end

  finally
    FreeMem(pData);
  end;
end;

 // copies central structures from one stream to another while removing
 // comments and extra data
procedure CopyStrippedCentralStructures(strIn, strOut: TStream;
  const iNumEntries, iOffsetDelta, iThisDisk: Integer);
var
  iCur:  Integer;
  recCentral: TZipCentralHeader;
  pData: Pointer;
  rEOC:  TZipEndOfCentral;
  cStrippedDataSize: Cardinal;

  iLenSkipped: Integer;
begin
  GetMem(pData, 65536); // filename
  try
    cStrippedDataSize := 0;

    if iNumEntries > 0 then
      for iCur := 0 to Pred(iNumEntries) do
      begin
        if (strIn.Read(recCentral, sizeof(TZipCentralHeader)) <>
          sizeof(TZipCentralHeader)) or
          (recCentral.HeaderSig <> ZipCentralHeaderSig) then
          raise EDelphiZip.CreateResDisp(DS_CEHBadRead, True); // invalid record

        if recCentral.DiskStart = iThisDisk then
          Inc(recCentral.RelOffLocal, iOffsetDelta);  // adjust offset

        // strip comments and extra data
        iLenSkipped := recCentral.ExtraLen + recCentral.FileComLen;
        recCentral.ExtraLen := 0;
        recCentral.FileComLen := 0;

        // remember size of extra and filecom
        Inc(cStrippedDataSize, iLenSkipped);

        if strOut.Write(recCentral, sizeof(TZipCentralHeader)) <>
          sizeof(TZipCentralHeader) then
          raise EDelphiZip.CreateResDisp(DS_CEHBadWrite, True); // error on writing

        // read and write filename
        with recCentral do
          if (FileNameLen) > 0 then
          begin
            if strIn.Read(pData^, FileNameLen) <> FileNameLen then
              raise EDelphiZip.CreateResDisp(DS_CEExtraLen, True); // cannot read

            if strOut.Write(pData^, FileNameLen) <> FileNameLen then
              raise EDelphiZip.CreateResDisp(DS_CEHBadWrite, True); // error on writing
          end;

        // skip filecom and extra data
        strIn.Seek(iLenSkipped, soFromCurrent);

      end;

    // read, adjust and write end of central
    if (strIn.Read(rEOC, sizeof(TZipEndOfCentral)) <> sizeof(TZipEndOfCentral)) or
      (rEOC.HeaderSig <> ZipEndOfCentralSig) then
      raise EDelphiZip.CreateResDisp(DS_EOCBadRead, True); // invalid eoc

    rEOC.ThisDiskNo := iThisDisk;

//    Inc(rEOC.CentralOffset, iOffsetDelta + ( -cStrippedDataSize));
    Inc(rEOC.CentralOffset, iOffsetDelta - Integer(cStrippedDataSize)); //RP
    iLenSkipped := rEOC.ZipCommentLen;
    //Inc(cStrippedDataSize, iLenSkipped); Zipcomment not in CentralSize!
    rEOC.ZipCommentLen := 0;
    Dec(rEOC.CentralSize, cStrippedDataSize);

    if strOut.Write(rEOC, sizeof(TZipEndOfCentral)) <> sizeof(TZipEndOfCentral) then
      raise EDelphiZip.CreateResDisp(DS_EOCBadWrite, True); // error on writing

    // read an possibly existing file comment (but skip it)
    with rEOC do
      if iLenSkipped > 0 then
        if strIn.Read(pData^, ZipCommentLen) <> ZipCommentLen then
          raise EDelphiZip.CreateResDisp(DS_EOArchComLen, True)

  finally
    FreeMem(pData);
  end;
end;

// reads the end of central structure in a stream and returns its position
function ReadEndOfCentral(str: TStream; var recEOC: TZipEndOfCentral): Integer;
var
  pRec: ^ZipEndOfCentral;
  iBufferSize, iRead: Integer;
  pBuffer: PChar;
  i:   Integer;
  bOK: Boolean;
begin
  bOK := False;
  iBufferSize := str.Size;
  if iBufferSize > (sizeof(TZipEndOfCentral) + 65536) then
    iBufferSize := (sizeof(TZipEndOfCentral) + 65536);

  // first try to read the record straight from the end ( works if no comment is stored)
  Result := str.Seek( -sizeof(TZipEndOfCentral), soFromEnd);
  if Result <> -1 then
  begin
    str.Read(recEOC, sizeof(TZipEndOfCentral));
    if recEOC.HeaderSig <> ZipEndOfCentralSig then
    begin
      // not found at the end, read in a buffer
      if iBufferSize > sizeof(TZipEndOfCentral) then
      begin
        Result := str.Seek( -iBufferSize, soFromEnd);
        if Result <> -1 then
        begin
          GetMem(pBuffer, iBufferSize + 1);
          try
            iRead := str.Read(pBuffer^, iBufferSize);
            if iRead = iBufferSize then
              for i := 0 to iBufferSize - sizeof(TZipEndOfCentral) do
              begin
                pRec := Pointer(pBuffer + i);
                with pRec^ do
                  if HeaderSig = ZipEndOfCentralSig then
                    if (ZipCommentLen + Result + i +
                      sizeof(TZipEndOfCentral)) <= str.Size then
                      //changed because of winzip sfx trash
                    begin
                      bOK    := True; // set ok flag
                      Result := Result + i;
                      Move(pRec^, recEOC, sizeof(TZipEndOfCentral));
                      Break;
                    end;
              end
          finally
            FreeMem(pBuffer);
          end;
        end;
      end;
    end
    else
      bOK := True;
  end;

  if not bOK then
    raise EDelphiZip.CreateResDisp(DS_EOCBadRead, True);
end;

// find the first local zip data
function FindStartOfZipData(str: TStream): Integer;
var
  iSavePos:  Integer;
  recCentral: ZipCentralHeader;
  iCur:      Integer; // loop
  recEOC:    TZipEndOfCentral;
  iDelta:    Integer;
  cPosOfEOC: Cardinal;
  iRealPos:  Integer;
begin
  Result   := -1;
  iSavePos := str.Position;
  try
    cPosOfEOC := ReadEndOfCentral(str, recEOC);
    with recEOC do
    begin
      iDelta := cPosOfEOC - (CentralOffset + CentralSize);
      if CentralEntries = 0 then
        Result := cPosOfEOC
      else begin
        str.Position := Integer(CentralOffset) + iDelta;
        for iCur := 0 to Pred(CentralEntries) do
        begin
          if (str.Read(recCentral, sizeof(recCentral)) <> sizeof(recCentral)) or
            (recCentral.HeaderSig <> ZipCentralHeaderSig) then
            raise EDelphiZip.CreateResDisp(DS_CEHBadRead, True);

          iRealPos := Integer(recCentral.RelOffLocal) + iDelta;
          if (iRealPos < Result) or (Result < 0) then
            if recCentral.DiskStart = recEOC.ThisDiskNo then
              Result := iRealPos;

          with recCentral do
            if (FileNameLen + ExtraLen + FileComLen) > 0 then
              str.Seek(FileNameLen + ExtraLen + FileComLen, soFromCurrent);
        end;
        if Result = -1 then
          Result := Integer(CentralOffset) + iDelta;
      end;
    end;
  finally
    str.Position := iSavePos;
  end;

  if Result = -1 then
    raise EDelphiZip.CreateResDisp(DS_CEHBadRead, True);
end;

{ EZipException }

{$IFNDEF USE_EZipMaster}
constructor EDelphiZip.CreateResDisp(const Ident: Integer; const Display: Boolean);
begin
  inherited CreateRes(Ident);

  if Message = '' then
    Message := RESOURCE_ERROR + IntToStr(Ident);
  FDisplayMsg := Display;
  FResIdent := Ident;
end;

constructor EDelphiZip.CreateResDisk(const Ident: Integer; const DiskNo: ShortInt);
begin
  inherited CreateRes(Ident);

  if Message = '' then
    Message := RESOURCE_ERROR + IntToStr(Ident)
  else
    Message := Format(Message, [DiskNo]);
  FDisplayMsg := True;
  FResIdent := Ident;
end;

constructor EDelphiZip.CreateResDrive(const Ident: Integer; const Drive: String);
begin
  inherited CreateRes(Ident);

  if Message = '' then
    Message := RESOURCE_ERROR + IntToStr(Ident)
  else
    Message := Format(Message, [Drive]);
  FDisplayMsg := True;
  FResIdent := Ident;
end;

constructor EDelphiZip.CreateResFile(const Ident: Integer; const File1, File2: String);
begin
  inherited CreateRes(Ident);

  if Message = '' then
    Message := RESOURCE_ERROR + IntToStr(Ident)
  else
    Message := Format(Message, [File1, File2]);
  FDisplayMsg := True;
  FResIdent := Ident;
end;


constructor EDelphiZip.CreateDisp(const Message: String; const Display: Boolean);
begin
  inherited Create(Message);
  FDisplayMsg := Display;
end;

{$ENDIF}

end.

