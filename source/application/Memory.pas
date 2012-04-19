unit Memory;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, XDebugFile, XDebugItem, ComCtrls, XDebugMemory, stringhash;

type
  TMemoryForm = class(TForm)
    lvMemory: TListView;
    procedure lvMemoryCompare(Sender: TObject; Item1, Item2: TListItem;
      Data: Integer; var Compare: Integer);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    FFile: XFile;
    FTotalMemory: Integer;
    FIncludeMemory: Integer;
    FIsInclude: Boolean;

    procedure processItem(AItem: PXItem);
  public
    constructor Create(AOwner: TComponent; AFile: XFile);
  end;

var
  MemoryForm: TMemoryForm;

implementation

{$R *.dfm}

{ TMemoryForm }

constructor TMemoryForm.Create(AOwner: TComponent; AFile: XFile);
var
  XM: TXMemory;
  SH: tStrHashIterator;
begin
  inherited Create(AOwner);
  FFile := AFile;

  {
  FTotalMemory := 0;
  FIncludeMemory := 0;
  FIsInclude := false;

  processItem(FFile.Root);

  txtAnalysis.Lines.Add(Format('Total Memory: %d', [FTotalMemory]));
  txtAnalysis.Lines.Add(Format('Include Memory: %d', [FIncludeMemory]));
  }


  XM := TXMemory.Create(AFile);
  try
    SH := XM.List.getIterator;
    while SH.validEntry do
    begin
      with lvMemory.Items.Add do
      begin
        Caption := TXMemoryItem(SH.value).FunctionName;
        Data := Pointer(TXMemoryItem(SH.value).Memory);
        SubItems.Add(Format('%.0n', [TXMemoryItem(SH.value).Memory * 1.0]));
        SubItems.Add(Format('%.0n', [TXMemoryItem(SH.value).Count * 1.0]));
      end;
      SH.next;
    end;
    SH.Free;
  finally
    XM.Free;
  end;

  lvMemory.SortType := stData;
end;

procedure TMemoryForm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := caFree;
end;

procedure TMemoryForm.lvMemoryCompare(Sender: TObject; Item1, Item2: TListItem;
  Data: Integer; var Compare: Integer);
var
  V1, V2: Integer;
begin
  V1 := Integer(Item1.Data);
  V2 := Integer(Item2.Data);

  if V1 > V2 then
    Compare := -1
  else if V1 < V2 then
    Compare := 1
  else
    Compare := 0;
end;

procedure TMemoryForm.processItem(AItem: PXItem);
var
  I: Integer;
  includeChanged: Boolean;
begin
  includeChanged := false;
  if AItem^.Level > 0 then
  begin
      if (not FIsInclude) and
        ((AItem^.FunctionName = 'include') or (AItem^.FunctionName = 'include_once') or
         (AItem^.FunctionName = 'require') or (AItem^.FunctionName = 'require_once')) then
      begin
        FIsInclude := true;
        includeChanged := true;
      end;
  end;

  if FIsInclude then
  begin
    FIncludeMemory := FIncludeMemory + (AItem^.MemoryEnd - AItem^.MemoryStart);
  end
  else
  begin
      if AItem^.ChildCount > 0 then
      begin
          for I := 0 to AItem^.ChildCount - 1 do
          begin
             processItem(AItem^.Children[I]);
          end;
      end
      else
        if AItem^.MemoryEnd > 0 then
          FTotalMemory := FTotalMemory + (AItem^.MemoryEnd - AItem^.MemoryStart);
  end;

  if includeChanged then
    FIsInclude := false;
end;

end.
