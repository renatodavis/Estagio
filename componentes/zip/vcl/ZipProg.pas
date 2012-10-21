unit ZipProg;
      
{$INCLUDE '..\vcl\ZipConfig.inc'}

interface

uses
  classes;

type
{$IFDEF ALLOW_2G}
  TProgressSize = Int64;
{$ELSE}
  TProgressSize = Integer;// - will allow uncompressed size to almost 2G
 //  TProgressSize = Cardinal;// - will allow uncompressed size to almost 4G
{$ENDIF}

type
  ProgressType = (NewFile, ProgressUpdate, EndOfBatch, TotalFiles2Process,
    TotalSize2Process, NewExtra, ExtraUpdate);

type
  TProgressDetails = class(TObject)
  protected
    FProgType: ProgressType;
    FItemCount: Integer;
    FWritten: Int64;
    FTotalSize: Int64;
    FTotalPosition: Int64;
    FItemSize: Cardinal;
    FItemPosition: Cardinal;
    FItemName: String;
    FItemNumber: Integer;
    function GetItemPerCent: Integer;
    function GetTotalPerCent: Integer;
  public
    destructor Destroy; override;
    property ItemPerCent: Integer Read GetItemPerCent;
    property TotalPerCent: Integer Read GetTotalPerCent;
    property Order: ProgressType Read FProgType;
    property TotalCount: Integer Read FItemCount;
    property BytesWritten: Int64 Read FWritten;
    property TotalSize: Int64 Read FTotalSize;
    property TotalPosition: Int64 Read FTotalPosition;
    property ItemSize: Cardinal Read FItemSize;
    property ItemPosition: Cardinal Read FItemPosition;
    property ItemName: String Read FItemName;
    property ItemNumber: Integer Read FItemNumber;
  end;
     
type
  TProgDetails = class(TProgressDetails)
  public
    procedure Clear;
    procedure Advance(adv: Cardinal);
    procedure SetCount(Count: Cardinal);
    procedure SetSize(FullSize: Int64);
    procedure SetItem(const fname: String; fsize: Cardinal);
    procedure SetEnd;
    procedure AdvanceXtra(adv: Cardinal);
    procedure SetItemXtra(xtype: Integer; const xmsg: String; fsize: Cardinal);
    procedure Wrote(bytes: Cardinal);
  end;

implementation

uses ZipMsg, ZipStrs;

const
  MAX_PERCENT = MAXINT div 10000;  

function TProgressDetails.GetItemPerCent: Integer;
begin
  if (ItemSize > 0) and (ItemPosition > 0) then
    if ItemSize < MAX_PERCENT then
      Result := (100 * ItemPosition) div ItemSize
    else
      Result := ItemPosition div (ItemSize div 100)
  else
    Result := 0;
end;

function TProgressDetails.GetTotalPerCent: Integer;
begin
  if (TotalSize > 0) and (TotalPosition > 0) then
    Result := (100 * TotalPosition) div TotalSize
  else
    Result := 0;
end;

destructor TProgressDetails.Destroy;
begin
  FItemName := '';
  inherited;
end;

procedure TProgDetails.Clear;
begin
  FProgType     := EndOfBatch;
  FItemCount    := 0;
  FWritten      := 0;
  FTotalSize    := 0;
  FTotalPosition := 0;
  FItemSize     := 0;
  FItemPosition := 0;
  FItemName     := '';
  FItemNumber   := 0;
end;

procedure TProgDetails.AdvanceXtra(adv: Cardinal);
begin
  Inc(FItemPosition, adv);
  FProgType := ExtraUpdate;
end;

procedure TProgDetails.SetItemXtra(xtype: Integer; const xmsg: String; fsize: Cardinal);
begin
  FItemName     := ZipLoadStr(PR_Progress + xtype, xmsg);
  FItemSize     := fsize;
  FItemPosition := 0;
  FProgType     := NewExtra;
end;

procedure TProgDetails.Advance(adv: Cardinal);
begin
  Inc(FTotalPosition, adv);
  Inc(FItemPosition, adv);
  FProgType := ProgressUpdate;
end;

procedure TProgDetails.SetCount(Count: Cardinal);
begin
  Clear;
  FItemCount  := Count;
  FItemNumber := 0;
  FProgType   := TotalFiles2Process;
end;

procedure TProgDetails.SetSize(FullSize: Int64);
begin
  FTotalSize := FullSize;
  FTotalPosition := 0;
  FItemName := '';
  FItemSize := 0;
  FItemPosition := 0;
  FProgType := TotalSize2Process;
  FWritten := 0;
end;

procedure TProgDetails.SetItem(const fname: String; fsize: Cardinal);// wrote: cardinal);
begin
  Inc(FItemNumber);
  FItemName     := fname;
  FItemSize     := fsize;
  FItemPosition := 0;
  FProgType     := NewFile;
end;

procedure TProgDetails.SetEnd;
begin
  FItemName := '';
  FItemSize := 0;
  FProgType := EndOfBatch;
end;

procedure TProgDetails.Wrote(bytes: Cardinal);
begin
  Inc(FWritten, bytes);
end;

end.
 