unit MainU;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, System.Diagnostics, System.IOUtils, System.Generics.Collections;

type
  TFormMain = class(TForm)
    Button1: TButton;
    Memo1: TMemo;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure Button1Click(Sender: TObject);
  private
    WordList: TStringlist;
    gWordList: TList<string>;
  public
    { Public declarations }
  end;

var
  FormMain: TFormMain;

implementation

uses
  FindNearestStringU;

{$R *.dfm}

procedure TFormMain.Button1Click(Sender: TObject);
  function IntStr(const Value: Extended): string;
  begin
    Result := FormatFloat('#,##0', trunc(Value))
  end;

var
  StopWatch: TStopwatch;
  aWord: string;
const
  SEARCH_WORD = 'HEST';
begin
  Memo1.Lines.Clear;

  StopWatch := TStopwatch.StartNew;
  aWord := FindNearestString.Get(WordList, SEARCH_WORD, False);
  StopWatch.Stop;

  Memo1.Lines.Add('');
  Memo1.Lines.Add('Test 1: TStrings');
  Memo1.Lines.Add('Number of elements in list: ' + IntStr(WordList.Count));
  Memo1.Lines.Add('Nearest word to "' + SEARCH_WORD + '": ' + aWord);
  Memo1.Lines.Add('Elapsed Milliseconds: ' + IntStr(StopWatch.ElapsedMilliseconds));
  Memo1.Lines.Add('Average speed elements/ms: ' + IntStr(WordList.Count / StopWatch.ElapsedMilliseconds));

  StopWatch := TStopwatch.StartNew;
  aWord := FindNearestString.Get(gWordList, SEARCH_WORD, False);
  StopWatch.Stop;
  Memo1.Lines.Add('');
  Memo1.Lines.Add('Test 2: TEnumerable<string>');
  Memo1.Lines.Add('Number of elements in list: ' + IntStr(gWordList.Count));
  Memo1.Lines.Add('Nearest word to "' + SEARCH_WORD + '": ' + aWord);
  Memo1.Lines.Add('Elapsed Milliseconds: ' + IntStr(StopWatch.ElapsedMilliseconds));
  Memo1.Lines.Add('Average speed elements/ms: ' + IntStr(gWordList.Count / StopWatch.ElapsedMilliseconds));
end;

procedure TFormMain.FormCreate(Sender: TObject);
var
  List: TStringlist;
  s, t: string;
begin
  List := TStringlist.Create;
  WordList := TStringlist.Create;
  gWordList := TList<string>.Create;

  List.LoadFromFile('../../../In Search of Lost Time/Swann''s Way .txt');
  for s in List do
  begin
    for t in s.Split([#32]) do
      if t.Trim <> '' then
      begin
        WordList.Add(t);
        gWordList.Add(t);
      end;
  end;

  List.Free;
end;

procedure TFormMain.FormDestroy(Sender: TObject);
begin
  WordList.Free;
  gWordList.Free;
end;

end.
