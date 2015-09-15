unit Meteo;


interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, ComCtrls;

  type
   TDataBytes = record
      Command : byte;
      Value1 : byte;
      Value2 : byte;
      Value3 : byte;
      Value4 : byte;
   end;

type
  TForm1 = class(TForm)
    Button1: TButton;
    ComboBox1: TComboBox;
    Timer1: TTimer;
    Memo1: TMemo;
    procedure Button1Click(Sender: TObject);
    procedure FormDestroy(Sender: TObject);

  private

  public
    { Public declarations }
  end;

  //Здесь необходимо описать класс TMyThread:
  TMyThread = class(TThread)
    private
    { Private declarations }
  protected
    procedure Execute; override;
  end;

  TMyReadThread = class(TThread)
    private
    { Private declarations }
  protected
    procedure Execute; override;
  end;

var
  Form1: TForm1;

  MyThread: TMyThread;
  MyReadThread: TMyReadThread;

  ComHandle:THandle;
  CurrentState:TComStat;
  CodeError:Cardinal;
  AvaibleBytes,RealRead:Cardinal;
  DATA: array [0..1] of byte;
  PData:^Pointer;

  Buffer :PCommConfig;
  Size: DWORD;

  DataBytes : TDataBytes;

implementation

{$R *.dfm}

procedure WriteCOM(DATA_TO_WRITE:byte);
var nBytesWrite:Cardinal;
begin
 WriteFile(ComHandle,DATA_TO_WRITE,1,nBytesWrite,nil);
end;

procedure TMyThread.Execute;
var it:integer;
begin
  while(true) do
  begin
   for it := 0 to SizeOf(DATA) - 1 do DATA[it]:=0;

   ClearCommError(ComHandle,CodeError,@CurrentState);
   AvaibleBytes:=CurrentState.cbInQue;
   if AvaibleBytes<>0 then
    Begin
      GetMem(PData,AvaibleBytes);
      PData:=@DATA;
      ReadFile(ComHandle,PData^,AvaibleBytes,RealRead,nil);
      Form1.Memo1.Lines.Add(FloatToStr((DATA[1]*256 + DATA[0])/16)) ;
    end;

    //Form1.Memo1.Lines.Add(IntToStr(DATA[0]) +' '+IntToStr(DATA[1])) ;

    sleep(500);
  end;



  end;

procedure TForm1.Button1Click(Sender: TObject);
var i:integer;
    st:PWideChar;
begin
  StringToWideChar(ComboBox1.Text,st,4);
  st:=PWideChar(ComboBox1.Text);
 ComHandle:=CreateFile(st,
                       GENERIC_READ or GENERIC_WRITE,
                       0,
                       nil,
                       OPEN_EXISTING,
                       FILE_ATTRIBUTE_NORMAL,
                       0);
 if ComHandle=INVALID_HANDLE_VALUE then
  begin
   MessageDLG('Ошибка открытия порта!',mtError,[mbOK],0);
   Exit;
  end;

  GetMem(Buffer,SizeOf(TCommConfig));
  Size:=0;
  GetCommConfig(ComHandle,Buffer^,Size);
  FreeMem(Buffer,SizeOf(TCommConfig));
  GetMem(Buffer,Size);
  GetCommConfig(ComHandle,Buffer^,Size);
  Buffer^.dcb.BaudRate:=9600;
  Buffer^.dcb.Parity:=NOPARITY;
  Buffer^.dcb.StopBits:=ONESTOPBIT;
  Buffer^.dcb.ByteSize:=8;
  SetCommConfig(ComHandle,Buffer^,Size);
  FreeMem(Buffer,Size);

 PurgeComm(ComHandle,PURGE_RXCLEAR);

 for i := 0 to SizeOf(DATA) - 1 do DATA[i]:=0;

 MyThread:=TMyThread.Create(False);
 MyThread.Priority:=tpNormal;

 Memo1.Lines.Add('OK');

end;

procedure TMyReadThread.Execute;
var    sysTime:TDateTime;
begin
   while  true do
   begin

   if MyReadThread.Terminated then break;
   sleep(500);
  end;
end;

procedure TForm1.FormDestroy(Sender: TObject);
begin
 Form1.Timer1.Enabled:=False;
 if ComHandle <> null then CloseHandle(ComHandle);
end;

end.

