unit backup;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  stdCtrls, {LZRW1KH,} FileCtrl;

type
  TAlloc = function (AppData: Pointer; Items, Size: Integer): Pointer;
  TFree = procedure (AppData, Block: Pointer);

  // Internal structure.  Ignore.
  TZStreamRec = packed record
    next_in: PChar;       // next input byte
    avail_in: Integer;    // number of bytes available at next_in
    total_in: Integer;    // total nb of input bytes read so far

    next_out: PChar;      // next output byte should be put here
    avail_out: Integer;   // remaining free space at next_out
    total_out: Integer;   // total nb of bytes output so far

    msg: PChar;           // last error message, NULL if no error
    internal: Pointer;    // not visible by applications

    zalloc: TAlloc;       // used to allocate the internal state
    zfree: TFree;         // used to free the internal state
    AppData: Pointer;     // private data object passed to zalloc and zfree

    data_type: Integer;   //  best guess about the data type: ascii or binary
    adler: Integer;       // adler32 value of the uncompressed data
    reserved: Integer;    // reserved for future use
  end;

type
  TPercentage        = 0..100;
  TBackupMode        = (bmAll, bmIncremental);
  TRestoreMode       = (rmAll, rmNoOverwrite, rmNewer, rmExisting, rmExistingNewer);
  TCompressionLevel  = (clFastest, clNone, clDefault, clMax);
  TProgressEvent     = procedure(Sender : TObject; Filename: String; Percent: TPercentage; var Continue: Boolean) of object;
  TNeedDiskEvent     = procedure(Sender : TObject; DiskID: word; var Continue: Boolean) of object;
  TRestoreFileEvent  = procedure(Sender : TObject; var Filename: String; FA: Integer; var DoRestore: Boolean) of object;
  TFileRestoredEvent = procedure(Sender : TObject; var Filename: String; var Stream: TFilestream) of object;
  TBackupErrorEvent  = procedure(Sender : TObject; const Error: integer; ErrString: string) of object;

  TBackupFile = class(TComponent)
  private
    FBackupTitle: string;
    fMaxSize: Integer;
    fBackupMode: TBackupmode;
    fRestoreMode: TRestoremode;
    fCompressionLevel: TCompressionLevel;
    fSetArchiveFlag: Boolean;
    fFilesTotal, fFilesProcessed, fSizeTotal, fProgressSize, fCompressedTotal: Integer;
    CurrentFile: string;
    IsBusy, Continue: boolean;
    fLastErr: integer;

    fInputStream, fOutputStream: TStream;
    fRestoreFullPath: Boolean;
    fSaveFileID: Boolean;

    fOnProgress: TProgressEvent;
    fOnNeedDisk: TNeedDiskEvent;
    fOnRestoreFile: TRestoreFileEvent;
    fOnFileRestored: TFileRestoredEvent;
    fOnError: TBackupErrorEvent;
    function  GetVersion: string;
    procedure SetVersion(dummy: string);
    procedure SetBackupMode(value: TBackupmode);
    procedure DeCompress(InStream, OutStream: TStream; DoWrite: Boolean);
{
    procedure DeCompressOldMethod(InStream, OutStream: TStream; DoWrite: Boolean);
    old compression method used in version 1
}
    procedure MessageError(err: integer);
  protected
  public
    property  FilesTotal: Integer read fFilesTotal;
    property  SizeTotal: Integer read fSizeTotal;
    property  FilesProcessed: Integer read fFilesProcessed;
    function  BackupToStream(const Filelist: TStrings; Target: TStream): boolean;
    function  Backup(const Filelist: TStrings; Target: string): boolean;
    function  RestoreFromStream(Source: TStream; TargetPath: string): boolean;
    function  Restore(Source: String; TargetPath: string): boolean;
    function  GetArchiveTitle(const Source: String; var Filelist: TStringlist): string;
    function  GetArchiveTitleFromStream(Source: TStream; var Filelist: TStringlist): string;
    function  CompressionRate: integer;
    function  Busy: boolean;
    procedure Stop;
  published
    property Version: string read GetVersion write SetVersion;
    property BackupTitle: string read fBackupTitle write fBackupTitle;
    property BackupMode: TBackupmode read fBackupMode write SetBackupMode;
    property CompressionLevel: TCompressionLevel read fCompressionLevel write fCompressionLevel;
    property RestoreMode: TRestoremode read fRestoreMode write fRestoreMode;
    property MaxSize: Integer read fMaxSize write fMaxSize;
    property SetArchiveFlag: Boolean read fSetArchiveFlag write fSetArchiveFlag;
    property OnProgress: TProgressEvent read fOnProgress write fOnProgress;
    property OnNeedDisk: TNeedDiskEvent read fOnNeedDisk write fOnNeedDisk;
    property OnRestoreFile: TRestoreFileEvent read fOnRestoreFile write fOnRestoreFile;
    property OnFileRestored: TFileRestoredEvent read fOnFileRestored write fOnFileRestored;
    property OnError: TBackupErrorEvent read fOnError write fOnError;
    property RestoreFullPath: Boolean read fRestoreFullPath write fRestoreFullPath;
    property SaveFileID: Boolean read fSaveFileID write fSaveFileID;
  end;

const
  BufferSize = 16384; //32768;  optimize buffer size, disk size and update speed

  cVersion = '5.10';
  fSignature = 'EC2';
//  fOldSignature = 'ECS';

  idCantreadFile =     1;
  idCantwriteFile =    2;
  idCantreadArchive =  3;
  idCantwriteArchive = 4;
  idInvalidfiletype =  5;
  idCompression =      6;
  idCantCreateFileID = 7;

  zlib_Version = '1.1.3';

procedure Register;

implementation

resourcestring
  cInsertDisk = 'Please insert disk %s and click OK to continue.';
  errCantreadFile = 'Cannot read file';
  errCantwriteFile = 'Overwriting file failed';
  errCantreadArchive = 'Cannot read archive';
  errCantwriteArchive = 'Cannot write to archive';
  errInvalidfiletype = 'Invalid archive type';
  errCompression = 'Compression error';
  errCantCreateFileID = 'Cannot create temporary file to save the file IDs';

const
  Z_NO_FLUSH      = 0;
  Z_PARTIAL_FLUSH = 1;
  Z_SYNC_FLUSH    = 2;
  Z_FULL_FLUSH    = 3;
  Z_FINISH        = 4;

  Z_OK            = 0;
  Z_STREAM_END    = 1;
  Z_NEED_DICT     = 2;
  Z_ERRNO         = (-1);
  Z_STREAM_ERROR  = (-2);
  Z_DATA_ERROR    = (-3);
  Z_MEM_ERROR     = (-4);
  Z_BUF_ERROR     = (-5);
  Z_VERSION_ERROR = (-6);

  Z_NO_COMPRESSION       =   0;
  Z_BEST_SPEED           =   1;
  Z_BEST_COMPRESSION     =   9;
  Z_DEFAULT_COMPRESSION  = (-1);

  Z_FILTERED            = 1;
  Z_HUFFMAN_ONLY        = 2;
  Z_DEFAULT_STRATEGY    = 0;

  Z_BINARY   = 0;
  Z_ASCII    = 1;
  Z_UNKNOWN  = 2;

  Z_DEFLATED = 8;

  _z_errmsg: array[0..9] of PChar = (
    'need dictionary',      // Z_NEED_DICT      (2)
    'stream end',           // Z_STREAM_END     (1)
    '',                     // Z_OK             (0)
    'file error',           // Z_ERRNO          (-1)
    'stream error',         // Z_STREAM_ERROR   (-2)
    'data error',           // Z_DATA_ERROR     (-3)
    'insufficient memory',  // Z_MEM_ERROR      (-4)
    'buffer error',         // Z_BUF_ERROR      (-5)
    'incompatible version', // Z_VERSION_ERROR  (-6)
    ''
  );

{$L deflate.obj}
{$L inflate.obj}
{$L inftrees.obj}
{$L trees.obj}
{$L adler32.obj}
{$L infblock.obj}
{$L infcodes.obj}
{$L infutil.obj}
{$L inffast.obj}

procedure _tr_init; external;
procedure _tr_tally; external;
procedure _tr_flush_block; external;
procedure _tr_align; external;
procedure _tr_stored_block; external;
procedure adler32; external;
procedure inflate_blocks_new; external;
procedure inflate_blocks; external;
procedure inflate_blocks_reset; external;
procedure inflate_blocks_free; external;
procedure inflate_set_dictionary; external;
procedure inflate_trees_bits; external;
procedure inflate_trees_dynamic; external;
procedure inflate_trees_fixed; external;
procedure inflate_codes_new; external;
procedure inflate_codes; external;
procedure inflate_codes_free; external;
procedure _inflate_mask; external;
procedure inflate_flush; external;
procedure inflate_fast; external;

procedure _memset(P: Pointer; B: Byte; count: Integer);cdecl;
begin
  FillChar(P^, count, B);
end;

procedure _memcpy(dest, source: Pointer; count: Integer);cdecl;
begin
  Move(source^, dest^, count);
end;


function deflateInit_(var strm: TZStreamRec; level: Integer; version: PChar; recsize: Integer): Integer; external;
function deflate(var strm: TZStreamRec; flush: Integer): Integer; external;
function deflateEnd(var strm: TZStreamRec): Integer; external;

function inflateInit_(var strm: TZStreamRec; version: PChar; recsize: Integer): Integer; external;
function inflate(var strm: TZStreamRec; flush: Integer): Integer; external;
function inflateEnd(var strm: TZStreamRec): Integer; external;
function inflateReset(var strm: TZStreamRec): Integer; external;


function zcalloc(AppData: Pointer; Items, Size: Integer): Pointer;
begin
  GetMem(Result, Items*Size);
end;

procedure zcfree(AppData, Block: Pointer);
begin
  FreeMem(Block);
end;


{ TBackupFile +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++}

function TBackupFile.GetVersion: string;
begin
  Result := cVersion;
end;

procedure TBackupFile.SetVersion(dummy: string);
begin
end;

procedure TBackupFile.SetBackupMode(value: TBackupmode);
begin
  if value <> fBackupMode then
  begin
    if value = bmIncremental then SetArchiveFlag := true;
    fBackupMode := value;
  end;
end;

function TBackupFile.BackupToStream(const Filelist: TStrings; Target: TStream): boolean;
begin
  Result := False;
  if Target <> nil then
  try
    fOutputStream := Target;
    fMaxSize := 0;
    Result := Backup(Filelist, ':STREAM');
  except
  end;
end;

function TBackupFile.Backup(const Filelist: TStrings; Target: string): boolean;
const
  Levels: array [TCompressionLevel] of ShortInt =
    (Z_BEST_SPEED, Z_NO_COMPRESSION, Z_DEFAULT_COMPRESSION, Z_BEST_COMPRESSION);
var
  ext: string;
  I,L: Integer;
  FA: integer;
  S: String;
  Files: TStringlist;
  Size: Longint;
  SStr: TFilestream;
  TStr: TStream;
  ArchiveNumber: Word;

  UseStream: boolean;

  FID: TStringlist;
  FIDTemp: string;
  TempFileP: array[0..255] of Char;

  procedure BackupFile;
  var
    InBuffer: array[0..BufferSize-1] of Byte;
    OutBuffer: array[0..BufferSize-1] of Byte;
    Res, CompressedSize, BytesRead: Integer;
    FZRec: TZStreamRec;
    IsCompressed: boolean;
  begin
    IsCompressed := False;
    try
      TStr.WriteBuffer(FSignature, SizeOf(FSignature));  //new signature "EC2" in ver 2.00!
      Inc(fCompressedTotal, sizeof(FSignature));

      while (Size > 0) and Continue and ((TStr.position < (MaxSize-100-BufferSize)) or (MaxSize = 0)) do
      begin
//      if  (DiskFree(0)-10*1024) < size then break;

        BytesRead := SStr.Read(InBuffer, BufferSize);
        Dec(Size, BytesRead);
        Inc(fProgressSize, BytesRead);

        FillChar(FZRec, sizeof(FZRec), 0);
        FZRec.next_out := @OutBuffer;
        FZRec.avail_out := sizeof(OutBuffer);

        if deflateInit_(FZRec, Levels[fCompressionLevel], zlib_version, sizeof(FZRec)) < 0 then
        begin
          fLastErr := idCompression;
          Continue := false;
        end;

        FZRec.next_in := @InBuffer;
        FZRec.avail_in := BytesRead;

        Res := deflate(FZRec, Z_FINISH);
        case Res of
          Z_OK:
            IsCompressed := false;  //buffer to large, no compression
          Z_STREAM_END:
            IsCompressed := true;   //compressed buffer
          else
            begin
              fLastErr := idCompression;
              continue := false;
            end;
        end;
        if Continue then
        begin
          if IsCompressed then
          begin
            CompressedSize := FZRec.total_out;
            TStr.WriteBuffer(CompressedSize, SizeOf(CompressedSize));
            TStr.Write(OutBuffer, CompressedSize);
          end else
          begin
            CompressedSize := BytesRead * (-1);
            TStr.WriteBuffer(CompressedSize, SizeOf(CompressedSize));
            TStr.Write(InBuffer, BytesRead);
          end;
        end;

        deflateEnd(FZRec);

        Inc(fCompressedTotal, abs(CompressedSize));
        Inc(fCompressedTotal, sizeof(CompressedSize));

        Application.processmessages;
        if assigned(fOnProgress) then fOnProgress(self, CurrentFile, round((fProgressSize/fSizeTotal)*100), Continue);
      end;

      CompressedSize := 0;  //end of file or disk
      TStr.WriteBuffer(CompressedSize, SizeOf(CompressedSize));

      if (Size > 0) and Continue then
      begin
        Inc(ArchiveNumber);
        ext := ('00'+inttostr(ArchiveNumber));
        ext := copy(ext, length(ext)-2, 3);
        S := 'NEXT:DISK'+Ext;
        L := length(s);
        TStr.writeBuffer(L, sizeof(L));    //Size of file name
        TStr.writeBuffer(PChar(s)^,L);     //file name

        TStr.free;
        TStr := nil;

        if assigned(fOnNeedDisk) then
          fOnNeedDisk(self, ArchiveNumber, Continue)
        else
          Continue := MessageDlg(Format(cInsertDisk, [inttostr(ArchiveNumber)]), mtInformation, mbOKCancel, 0) = mrOK;

        if Continue then
        begin
          Target := ChangeFileExt(target, '.'+ext);
          TStr := TFilestream.create(Target, fmCreate);
          TStr.seek(0, 0);
        end;
      end;

    except
      Continue := false;
      fLastErr := idCantWriteArchive;
    end;
  end;

  procedure FindFiles(pattern: string);
  var
      IncludeSubs: boolean;
      SR: TSearchRec;
      FindResult: Integer;
  begin
    pattern := lowercase(pattern);
    IncludeSubs := pos('/s',pattern) > 0;

    if IncludeSubs then
    begin
      pattern := trim(copy(pattern, 1, pos('/s',pattern)-1));
      FindResult := FindFirst(ExtractFilePath(pattern)+'*.*', faDirectory, SR);
      while FindResult = 0 do
      begin
        if (SR.Name <> '.') and (SR.Name <> '..') and (sr.Attr AND faDirectory > 0) then
        begin
          S := ExpandFilename(ExtractFilepath(pattern)+SR.name+'\'+extractfilename(pattern))+' /s';
          FindFiles(lowercase(S));
        end;
        FindResult := FindNext(SR);
      end;
      FindClose(SR);
    end;
    FindResult := FindFirst(pattern, faAnyFile-faDirectory, SR);
    while FindResult = 0 do
    begin
      S := lowercase(ExpandFilename(ExtractFilepath(pattern)+SR.name));
      if (files.indexof(S) = -1) and (S <> lowercase(Target)) then
      begin
        if BackupMode = bmAll then Files.add(S)
        else if (SR.Attr AND faArchive > 0) then Files.add(S);
      end;
      FindResult := FindNext(SR);
    end;
    FindClose(SR);
  end;

begin
  UseStream := Target = ':STREAM';
  fLastErr := 0;
  IsBusy := true;
  Files := TStringlist.create;
  if fSaveFileID then FID := TStringlist.create
  else FID := nil;

  files.beginupdate;
  for I := 0 to Filelist.count-1 do FindFiles(Filelist[i]);
  files.endupdate;

  result := false;
  Continue := true;
  if assigned(fOnProgress) then fOnProgress(self, '', 0, Continue);
  fSizeTotal := 0;
  fFilesProcessed := 0;
  for I := 0 to files.count-1 do
    if Fileexists(files[i]) then
  try
     SStr := TFilestream.create(files[i], fmOpenRead or fmShareDenyNone);
     fSizeTotal := fSizeTotal + SStr.Size;
     if fSaveFileID then
       FID.add(files[i] + #9 + inttostr(Fileage(Files[i])) + '=' + inttostr(SStr.size));
  finally
     SStr.free;
  end;

  if fSaveFileID then
  try
    GetTempPath(SizeOf(TempFileP),@TempFileP);
    GetTempFileName(TempFileP, 'FID', 0, TempFileP);
    FIDTemp := StrPas(TempFileP);
    FID.savetofile(FIDTemp);
    Files.insert(0, FIDTemp);
    Inc(fSizeTotal, length(FID.text));
    FID.free;
  except;
    Continue := false;
    fLastErr := idCantCreateFileID;
  end;

  try
    ArchiveNumber := 1;

    if UseStream then TStr := fOutputStream
    else begin
      TStr := TFilestream.create(Target, fmCreate);
      TStr.seek(0, 0);
    end;

    fFilesTotal := files.count;
    if fSaveFileID then fFilesTotal := files.count-1;
    L := length(fBackupTitle);
    TStr.writeBuffer(L, sizeof(L));    //Size of title
    TStr.writeBuffer(PChar(fBackupTitle)^,L);     //title
    TStr.writeBuffer(fSizeTotal, sizeof(fSizeTotal));    //Total Size of backup
    TStr.writeBuffer(fFilesTotal, sizeof(fFilesTotal));    //Total file count

    fProgressSize := 0;
    fCompressedTotal := 0;
  except
    fLastErr := idCantwriteArchive;
    Continue := false;
  end;

  for I := 0 to files.count-1 do
  begin
    if Fileexists(files[i]) and Continue then
    begin
      try
        if fSaveFileID and (I = 0) then CurrentFile := 'FILE:LIST'
        else CurrentFile := trim(files[i]);

        l := length(CurrentFile);
        TStr.writeBuffer(L, sizeof(L));    //Size of file name
        TStr.writeBuffer(PChar(CurrentFile)^,L);     //file name

        CurrentFile := trim(files[i]);
        try
          SStr := TFilestream.create(Currentfile, fmOpenRead or fmShareDenyNone);
          FA := FileGetDate(SStr.handle);
          TStr.writeBuffer(FA, sizeof(FA));  //file age
          Size := SStr.Size;

//        while (Size > 0) and Continue do BackupFile; //zero file size bug
          if Continue then
          repeat
              BackupFile;
          until (Size <= 0) or (not Continue);

          if (CurrentFile <> FIDTemp) or (not fSaveFileID) then Inc(fFilesProcessed);
        except
          continue := false;
          fLastErr := idCantReadfile;
        end;
        if not continue then break;

      finally
        SStr.free;
        if fSetArchiveFlag then FileSetAttr(files[i], FileGetAttr(files[i])- faArchive);
      end;
    end;
  end;

  if Continue then
  try
    L := 0;
    TStr.writeBuffer(L, sizeof(L));    //end backup
    result := true;
  except
    fLastErr := idCantwriteArchive;
    Continue := false;
  end;

  try
    Files.free;
    if not UseStream then TStr.free;
  except
  end;

  if fSaveFileID and (FIDTemp <> '') and Fileexists(FIDTemp) then Deletefile(FIDTemp);
  if assigned(fOnProgress) then fOnProgress(self, '', 100, Continue);
  IsBusy := false;

  if (fLastErr <> 0) then MessageError(fLastErr);
end;

procedure TBackupFile.MessageError(err: integer);
var
   S: string;
begin
  case err of
  idCantreadFile:     S := errCantreadFile;
  idCantwriteFile:    S := errCantwriteFile;
  idCantreadArchive:  S := errCantreadArchive;
  idCantwriteArchive: S := errCantwriteArchive;
  idInvalidfiletype:  S := errInvalidfiletype;
  idCompression:      S := errCompression;
  idCantCreateFileID: S := errCantCreateFileID;
  end;

  if assigned(fOnError) then fOnError(self, err, S)
  else MessageDlg(S, mtError, [mbOK], 0);
end;

function TBackupFile.CompressionRate: integer;
begin
  try
    result := 100 - round((fCompressedTotal/fSizeTotal)*100);
  except
    result := 0;
  end;
end;

function TBackupFile.RestoreFromStream(Source: TStream; TargetPath: string): boolean;
begin
  Result := False;
  if Source <> nil then
  try
    fInputStream := Source;
    Result := Restore(':STREAM', TargetPath);
  except
  end;
end;

function TBackupFile.Restore(Source: String; TargetPath: string): boolean;
var
   L: Integer;
   FA, FAT: integer;
   S, Disk: String;
   SStr: TStream;
   TStr: TFilestream;
   DoRestore: Boolean;
   UseStream: Boolean;
begin
  if (TargetPath <> '') and (TargetPath[length(TargetPath)] <> '\') then
    TargetPath := TargetPath + '\';

  UseStream := Source = ':STREAM';
  fLastErr := 0;
  result := false;
  fFilesProcessed := 0;
  Continue := true;
  try
    if UseStream then SStr := fInputStream
    else begin
      if not Fileexists(Source) then Exit;

      SStr := TFilestream.create(Source, fmOpenRead or fmShareDenyNone);
      SStr.Seek(0,0);
    end;

    IsBusy := True;

    SStr.readbuffer(L, sizeof(L));
    SetString(S, PChar(nil), L);
    SStr.ReadBuffer(PChar(S)^,L);  //Title
    SStr.readbuffer(fSizeTotal, sizeof(fSizeTotal));
    SStr.readbuffer(fFilesTotal, sizeof(fFilesTotal));
    fProgressSize := 0;
  except
    raise Exception.Create(errCantreadArchive);
    IsBusy := False;
    if not UseStream then SStr.free;

    Exit;
  end;

  DoRestore := true;
  repeat
    SStr.readbuffer(L, sizeof(L)); // File size
    if L > 0 then
    begin
      SetString(S, PChar(nil), L);
      SStr.ReadBuffer(PChar(S)^,L);     //File name

      if copy(s,1,9) = 'NEXT:DISK' then
      begin
        SStr.free;
        SStr := nil;
        Disk := copy(S, 10, 3);
        while copy(disk,1,1) = '0' do Disk := copy(Disk, 2, length(Disk)-1);

        repeat
          if assigned(fOnNeedDisk) then
            fOnNeedDisk(self, strtoint(Disk), Continue)
          else
            Continue := MessageDlg(Format(cInsertDisk, [Disk]), mtInformation, mbOKCancel, 0) = mrOK;
          Source := changeFileext(source, '.'+copy(S,10,3));
        until Fileexists(Source) or (not Continue);

        if Continue then
        try
          SStr := TFilestream.create(Source, fmOpenRead or fmShareDenyNone);
          SStr.seek(0,0);

          if DoRestore then
          begin
            TStr := TFilestream.create(CurrentFile, fmOpenWrite);
            TStr.seek(TStr.size, soFromBeginning);
          end;

          DeCompress(SStr, TStr, DoRestore);
        finally
          if DoRestore then
          begin
            if assigned(fOnFileRestored) then fOnFileRestored(self, CurrentFile, TStr);
            FileSetDate(TStr.handle, FA);  //set original file date + time
            TStr.free;
          end;
        end;

      end else
      begin
        // Read file.
        SStr.ReadBuffer(FA, sizeof(FA));  //File age

        if TargetPath <> '' then
          CurrentFile := TargetPath+ExtractFileName(S)
        else
          CurrentFile := S;

        if fRestoreFullPath and (TargetPath <> '') then
          CurrentFile := TargetPath + copy(S, 4, Length(S));

        FAT := FileAge(CurrentFile);
        case fRestoreMode of
        rmAll: DoRestore := true;
        rmNoOverwrite: DoRestore := not Fileexists(CurrentFile);
        rmNewer: DoRestore := not Fileexists(CurrentFile) or (FA > FAT);
        rmExisting: DoRestore := Fileexists(CurrentFile);
        rmExistingNewer: DoRestore := Fileexists(CurrentFile) and (FA > FAT);
        end;

        if S = 'FILE:LIST' then
          DoRestore := false
        else if assigned(fOnRestoreFile) then
          fOnRestoreFile(self, CurrentFile, FA, doRestore);

        if DoRestore then
        begin
          ForceDirectories(extractFileDir(CurrentFile));
          DoRestore := DirectoryExists(extractFileDir(CurrentFile));
        end;
        if DoRestore then
        try
          try
            TStr := TFileStream.create(CurrentFile, fmCreate);
            TStr.seek(0, 0);
            DeCompress(SStr, TStr, true);
            Inc(fFilesProcessed);
          except
            fLastErr := idCantReadFile;
            Continue := false;
          end;
        finally
          if assigned(fOnFileRestored) then
            fOnFileRestored(self, CurrentFile, TStr);
          FileSetDate(TStr.handle, FA);  //set original file date + time
          TStr.free;
        end
        else DeCompress(SStr, nil, false);
      end;
    end;
  until (L = 0) or (not Continue);

  if not UseStream and (SStr <> nil) then SStr.free;

  result := (fLastErr = 0) and Continue;  //sucessful restore !
  if assigned(fOnProgress) then fOnProgress(self, '', 100, Continue);

  IsBusy := false;
  if fLastErr <> 0 then MessageError(fLastErr);
end;

function TBackupFile.Busy: boolean;
begin
   Result := IsBusy;
end;

procedure TBackupFile.Stop;
begin
   Continue := false;
end;

function TBackupFile.GetArchiveTitleFromStream(Source: TStream; var Filelist: TStringlist): string;
begin
  if Source <> nil then
  try
    fInputStream := Source;
    Result := GetArchiveTitle(':STREAM', Filelist);
  except
    Result := '';
  end;
end;

function TBackupFile.GetArchiveTitle(const Source: String; var Filelist: TStringlist): string;
var
  L: Integer;
  S: String;
  SStr: TFilestream;
  FIDStr: TMemorystream;
  UseStream: Boolean;
begin
  UseStream := Source = ':STREAM';
  Result := '';
  fSizeTotal := 0;
  fFilesTotal := 0;
  fFilesProcessed := 0;

  if UseStream then SStr := TFileStream(fInputStream)
  else begin
    if not Fileexists(Source) then Exit;

    SStr := nil;
    try
      SStr := TFilestream.Create(Source, fmOpenRead or fmShareDenyNone);
      SStr.Seek(0,0);
    except
      fLastErr := idCantReadArchive;
      MessageError(fLastErr);
      Abort;
    end;
  end;

  try
    SStr.readbuffer(L, sizeof(L));
    SetString(S, PChar(nil), L);
    SStr.ReadBuffer(PChar(S)^,L);  //Title
    Result := S;
    SStr.readbuffer(fSizeTotal, sizeof(fSizeTotal));
    SStr.readbuffer(fFilesTotal, sizeof(fFilesTotal));

    SStr.readbuffer(L, sizeof(L)); // File size
    if (L > 0) and (Filelist <> nil) then
    begin
      SetString(S, PChar(nil), L);
      SStr.ReadBuffer(PChar(S)^,L);     //File name
      if S = 'FILE:LIST' then
      begin
        FIDStr := TMemoryStream.create;
        FIDStr.seek(0, 0);
        SStr.ReadBuffer(L, sizeof(L));  //File age, dummy
        Continue := true;
        DeCompress(SStr, FIDStr, true);
        FIDStr.seek(0, 0);
        Filelist.loadfromstream(FIDStr);
        FIDStr.free;
      end;
    end;
  except
    fLastErr := idInvalidFileType;
    MessageError(fLastErr);
  end;

  if not UseStream then SStr.Free;
end;

procedure TBackupFile.DeCompress(InStream, OutStream: TStream; DoWrite: Boolean);
var
  InBuffer:  array[0..BufferSize-1] of Byte;
  OutBuffer: array[0..BufferSize-1] of Byte;
  CompressedSize, UncompressedSize: Integer;
  Sig: array[0..SizeOf(FSignature)-1] of Char;
  FZRec: TZStreamRec;
  IsCompressed: boolean;
begin
  InStream.ReadBuffer(Sig, SizeOf(FSignature));
{ Old compression method used in version 1
  if Sig = FOldSignature
  begin
       DeCompressOldMethod(InStream, OutStream, DoWrite);
       exit;
  end; }

  if Sig <> FSignature then raise Exception.Create(errInvalidfiletype);

  CompressedSize := -1;
  UncompressedSize := 0;
  while (CompressedSize <> 0) and Continue do
  begin
    InStream.ReadBuffer(CompressedSize, SizeOf(CompressedSize));
    if CompressedSize <> 0 then
    begin
      IsCompressed := CompressedSize > 0;
      CompressedSize := abs(CompressedSize);
      if DoWrite then
      begin
        InStream.Readbuffer(InBuffer, CompressedSize);

        if IsCompressed then
        begin
          FillChar(FZRec, sizeof(FZRec), 0);
          FZRec.next_in := @OutBuffer;
          FZRec.avail_in := 0;
          if inflateInit_(FZRec, zlib_version, sizeof(FZRec)) < 0 then
          begin
            fLastErr := idCompression;
            Continue := false;
          end;

          FZRec.next_in := @InBuffer;
          FZRec.avail_in := CompressedSize;
          FZRec.next_out := @OutBuffer;
          FZRec.avail_out := BufferSize;

          if inflate(FZRec, 0) < 0 then
          begin
            fLastErr := idCompression;
            Continue := false;
          end;

          uncompressedSize := FZRec.total_out;
          OutStream.Write(OutBuffer, UnCompressedSize);

          inflateEnd(FZRec);
        end else
        begin
          uncompressedSize := CompressedSize;
          OutStream.Write(InBuffer, UnCompressedSize);
        end;
      end else
      begin
        InStream.position := InStream.position + CompressedSize;
        UncompressedSize := BufferSize;
      end;
    end;

    Application.processmessages;
    if OutStream is TFilestream then
    begin
      Inc(fProgressSize, UnCompressedSize);
      if assigned(fOnProgress) then
        fOnProgress(self, CurrentFile, round((fProgressSize/fSizeTotal)*100), Continue);
    end;
  end;
end;

{procedure TBackupFile.DeCompressOldMethod(InStream, OutStream: TStream; DoWrite: Boolean);
var
    InBuffer, OutBuffer: BufferArray;
    CompressedSize, UnCompressedSize, InSize: LongInt;
begin
  InStream.ReadBuffer(InSize, SizeOf(InSize));
  while (InSize > 0) and Continue do
  begin
    InStream.ReadBuffer(CompressedSize, SizeOf(CompressedSize));
    InStream.ReadBuffer(InBuffer, CompressedSize);
    if DoWrite then
    begin
         UnCompressedSize := DeCompression(@InBuffer, @OutBuffer, CompressedSize);
         OutStream.WriteBuffer(OutBuffer, UnCompressedSize);
    end;
    InSize := InSize - CompressedSize - SizeOf(CompressedSize);

    Application.processmessages;
    inc(fProgressSize, UnCompressedSize);
    if assigned(fOnProgress) then fOnProgress(self, CurrentFile, (fProgressSize*100) div fSizeTotal, Continue);
  end;
end;}

procedure Register;
begin
  RegisterComponents('EC', [TBackupFile]);
end;

end.



