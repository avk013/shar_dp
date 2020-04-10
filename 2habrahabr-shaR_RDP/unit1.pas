unit Unit1;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, ExtCtrls,
  Grids, ShellApi,LConvEncoding;

type

  { Tf_rdp }

  Tf_rdp = class(TForm)
    Button1: TButton;
    g_sort: TGroupBox;
    g_act: TGroupBox;
    Label1: TLabel;
    b_fio: TRadioButton;
    b_id: TRadioButton;
    b_mess: TRadioButton;
    b_rdp: TRadioButton;
    b_mall: TRadioButton;
    StringGrid1: TStringGrid;
    procedure Button1Click(Sender: TObject);
    procedure b_messChange(Sender: TObject);
    procedure b_rdpChange(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormPaint(Sender: TObject);
    procedure Label1Click(Sender: TObject);
    procedure b_fioChange(Sender: TObject);
    procedure b_idChange(Sender: TObject);
    procedure b_mallChange(Sender: TObject);
    procedure StringGrid1DblClick(Sender: TObject);
    procedure UserF2Array;
    procedure Data2StringGrid;
    procedure SortGrid(Column: integer);

    private

    public

    end;

var
  f_rdp: Tf_rdp;
  fam: array[0..2, 0..500] of string;  //500макс-количество пользователей
const f_d='c:\test\';
  function SearchArr(login: string):integer;
implementation

{$R *.lfm}

{ Tf_rdp }
function SearchArr(login: string):integer;
var i:integer;
begin
  for i:= 0 to 500 do
    begin
     if AnsiCompareStr(fam[0,i],login)=0 then
       begin
         SearchArr:=i;
         Exit;     {выход из функции последовательного поиска}
       end;
    end;
   {возвращаем -1 если ничего не нашли}
   SearchArr := -1;
end;

procedure Tf_rdp.SortGrid(Column: integer);
var
  i, j: integer;
  tmpRow: TStringList;
begin
  tmpRow:= TStringList.Create;
  try
    for i:=0 to StringGrid1.RowCount-1 do
      for j:=i+1 to StringGrid1.RowCount-1 do
        // сортируем по возрастанию.
        if AnsiCompareStr(StringGrid1.Cells[Column, i], StringGrid1.Cells[Column, j])>0 then
          begin
            tmpRow.Assign(StringGrid1.Rows[i]);
            StringGrid1.Rows[i]:=StringGrid1.Rows[j];
            StringGrid1.Rows[j]:=tmpRow;
          end;
  finally
    tmpRow.Free;
  end;
end;
procedure Tf_rdp.Button1Click(Sender: TObject);
begin
  Data2StringGrid;
end;
procedure Tf_rdp.b_messChange(Sender: TObject);
begin
Sleep(10);
end;

procedure Tf_rdp.b_rdpChange(Sender: TObject);
begin
  Sleep(10);
end;

procedure Tf_rdp.FormCreate(Sender: TObject);
begin
     f_rdp.Caption:='2Habr-rdp_viewer_©avk013_2020';
end;

procedure Tf_rdp.FormPaint(Sender: TObject);
begin
 StringGrid1.Width:=f_rdp.Width-5;
  StringGrid1.Height:=f_rdp.Height-70;
  label1.Top:=f_rdp.Height-16;
end;

procedure Tf_rdp.Label1Click(Sender: TObject);
begin

end;

procedure Tf_rdp.b_fioChange(Sender: TObject);
begin
  SortGrid(1);
end;

procedure Tf_rdp.b_idChange(Sender: TObject);
begin
  SortGrid(0);
end;

procedure Tf_rdp.b_mallChange(Sender: TObject);
var message,cmdline:string;
begin
message:=UTF8ToCP1251(InputBox('сообщение для пользователя','сообщение для пользователя',''));
if (message<>'') then
begin
cmdline:='/c msg *'+' '+message;
  if ShellExecute(0,nil, PChar('cmd'),PChar(cmdline),nil,1) =0 then;
  end;
b_mess.Checked:=True;;
end;

procedure Tf_rdp.StringGrid1DblClick(Sender: TObject);
var id:integer;
  ids, cmdline, message:string;
begin
// узнаем номер строки  IntToStr(StringGrid1.Row)
  id:=(StringGrid1.Row);
  ids:=StringGrid1.Cells[2,id];
  ids:= StringReplace(ids, 'rdp-tcp#', '', [rfReplaceAll]);
  cmdline:='/c mstsc /shadow:'+ ids;
 if (b_rdp.Checked=True) then  if ShellExecute(0,nil, PChar('cmd'),PChar(cmdline),nil,1) =0 then;
 if (b_mess.Checked=True) then
 begin
    message:=UTF8ToCP1251(InputBox('сообщение для пользователя','сообщение для пользователя',''));
    cmdline:='/c msg '+StringGrid1.Cells[0,id]+' '+message;
  if ShellExecute(0,nil, PChar('cmd'),PChar(cmdline),nil,1) =0 then;
 end;
end;
procedure Tf_rdp.UserF2Array;
var // !!!! не закончено
    F:TextFile;
  i:integer;
  f1, line1:String;
  fL: TStringList;
begin
f1:=f_d+'user_name.txt';     //задача считать в массив содержимое файла
fL := TStringList.Create;
fL.Delimiter := '|';
fL.StrictDelimiter := True;
AssignFile(F,f1);
try // Открыть файл для чтения
  reset(F); ReadLn(F,line1);
  i:=0;
while not eof(F) do // Считываем строки, пока не закончится файл
begin
ReadLn(F,line1);
line1:= StringReplace(line1, '  ', '|',[]); //заменяем первый попавш.2пробела разделителем |
// удаляем все двойные пробелы
while pos('  ',line1)>0 do line1:= StringReplace(line1, '  ', ' ', [rfReplaceAll]);
begin
if (pos('|',line1)>0) then
begin //если разделитель существует заносим его в массив
fL.DelimitedText :=line1; // разбиваем на столбцы
if (fL[0]<>'') then //если учетка имеет имя
begin //вносим ее в массив
 inc(i); // избавляемся от возможных одиночных пробелов в логине
 fam[0,i]:=StringReplace(fL[1],' ','',[rfReplaceall, rfIgnoreCase]);
 fam[1,i]:=fL[0];
 end;end;end;end; // Готово. Закрываем файл.
 CloseFile(F);
 Fl.Free;
 except
 on E: EInOutError do  ShowMessage('Ошибка обработки файла. Детали: '+E.Message);
 end;end;
procedure Tf_rdp.Data2StringGrid;
var
  F:TextFile;
  i,j,n:integer;
  f1, cmdline, line1, login1:String;
  fL : TStringList;
begin
  UserF2Array;
  f1:=f_d+'user.txt';
cmdline:='/c query user >'+ f1;
if ShellExecute(0,nil, PChar('cmd'),PChar(cmdline),nil,1)=0 then;
Sleep(500);
  stringgrid1.Clear;
fL := TStringList.Create;
fL.Delimiter := ' ';
fL.StrictDelimiter := True;
  AssignFile(F,f1);
  try
     // Открыть файл для чтения
     reset(F);
     ReadLn(F,line1);
     i:=0;
 // Считываем строки, пока не закончится файл
     while not eof(F) do
     begin

       ReadLn(F,line1);
       while pos('  ',line1)>0 do begin
       line1:= StringReplace(line1, '  ', ' ', [rfReplaceAll]);
       end;
    //   ShowMessage(line1);
//    if (pos('>',line1)=0) then
    begin
    if ((pos('rdp-tcp',line1)>0)and(pos('>',line1)=0)) then begin
//       inc(i);
    inc(i);
       StringGrid1.RowCount:=i+1;
       fL.DelimitedText :=line1;
       StringGrid1.Cells[0,i]:=Fl[1];
       StringGrid1.Cells[2,i]:=Fl[3];
login1:=StringReplace(fL[1],' ','',[rfReplaceall, rfIgnoreCase]);
if (SearchArr(login1)>=0) then
StringGrid1.Cells[1,i]:=fam[1,SearchArr(login1)]
else StringGrid1.Cells[1,i]:='+';
     end;end;end; // Готово. Закрываем файл.
     if (b_id.Checked=true) then SortGrid(0) else SortGrid(1);
     StringGrid1.AutoSizeColumn(0);
          StringGrid1.AutoSizeColumn(1);
          StringGrid1.AutoSizeColumn(2);
          StringGrid1.AutoSizeColumn(3);
     CloseFile(F);
     Fl.Free;
   except
     on E: EInOutError do
      writeln('Ошибка обработки файла. Детали: ', E.Message);
   end;
  end;
end.

