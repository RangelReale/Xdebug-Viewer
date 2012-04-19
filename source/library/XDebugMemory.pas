unit XDebugMemory;

interface

uses XDebugFile, XDebugItem, Classes, Contnrs, stringhash;

type
  TXMemoryItem = class
    private
      FFunctionName: string;
      FMemory: Integer;
      FCount: Integer;
    public
      constructor Create(AFunctionName: string);

      property FunctionName: string read FFunctionName;
      property Memory: Integer read FMemory write FMemory;
      property Count: Integer read FCount write FCount;
  end;

  TXMemory = class
  private
    FList: tStringHash;
    procedure AddItem(AItem: PXItem);
  public
    constructor Create(ADebugFile: XFile);
    destructor Destroy; override;

    property List: tStringHash read FList;
  end;


implementation

{ TXMemory }

procedure TXMemory.AddItem(AItem: PXItem);
var
  I: Integer;
  MI: TXMemoryItem;
begin
  if AItem^.FunctionName <> '' then
  begin
    MI := TXMemoryItem(FList.getValue(AItem^.FunctionName));
    if MI = nil then
    begin
      MI := TXMemoryItem.Create(AItem^.FunctionName);
      FList.setValue(AItem^.FunctionName, MI);
    end;
    //MI.Memory := MI.Memory + AItem^.OwnMemory;
    MI.Memory := MI.Memory + AItem^.DebugMemoryUsage;
    MI.Count := MI.Count + 1; 
  end;

  for I := 0 to AItem^.ChildCount - 1 do
  begin
    AddItem(AItem^.Children[I]);
  end;
end;

constructor TXMemory.Create(ADebugFile: XFile);
begin
  inherited Create;
  FList := tStringHash.Create;
  AddItem(ADebugFile.Root);
end;

destructor TXMemory.Destroy;
begin
  FList.deleteAll;
  FList.Free;
  inherited;
end;

{ TXMemoryItem }

constructor TXMemoryItem.Create(AFunctionName: string);
begin
  inherited Create;
  FFunctionName := AFunctionName;
  FMemory := 0;
  FCount := 0;
end;

end.
