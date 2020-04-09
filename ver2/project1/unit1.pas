unit Unit1;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, ExtCtrls,
  Grids, ShellApi;

type

  { TForm1 }

  TForm1 = class(TForm)
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    GroupBox1: TGroupBox;
    GroupBox2: TGroupBox;
    Label1: TLabel;
    b_fio: TRadioButton;
    b_id: TRadioButton;
    b_mess: TRadioButton;
    b_rdp: TRadioButton;
    RadioButton5: TRadioButton;
    StringGrid1: TStringGrid;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure b_rdpChange(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Label1Click(Sender: TObject);
    procedure b_fioChange(Sender: TObject);
    procedure b_idChange(Sender: TObject);
    procedure RadioButton5Change(Sender: TObject);
    procedure StringGrid1DblClick(Sender: TObject);
 //   procedure AutoSizeCol(Grid: TStringGrid;
     procedure UserF2Array;
    procedure SortGrid(Column: integer);

    private

    public

    end;

var
  Form1: TForm1;
  fam: array[0..2, 0..500] of string;  //500макс-количество пользователей
const f_d='c:\test\';
  function SearchArr(login: string):integer;
//  const f_d='c:\test\';
implementation

{$R *.lfm}

{ TForm1 }
function SearchArr(login: string):integer;
var i:integer;
begin
  for i:= 0 to 500 do
    begin
  //  showmessage(fam[1,i]+fam[0,i]+'_'+login);
     if AnsiCompareStr(fam[0,i],login)=0 then
       begin
         SearchArr:=i;
         Exit;     {выход из функции последовательного поиска}
       end;
    end;
   {возвращаем -1 если ничего не нашли}
   SearchArr := -1;
end;

procedure TForm1.SortGrid(Column: integer);
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
{procedure TForm1.AutoSizeCol(Grid: TStringGrid;
Column: integer);
var
  i, W, WMax: integer;
begin
  WMax := 0;
  for i := 0 to (Grid.RowCount - 1) do begin
    W := Grid.Canvas.TextWidth(Grid.Cells[Column, i]);
    if W > WMax then
      WMax := W;
  end;
  Grid.ColWidths[Column] := WMax + 5;
end;}
procedure TForm1.Button1Click(Sender: TObject);
var
  F:TextFile;
  i,j,n:integer;
  f1, cmdline, line1:String;
   fL : TStringList;
begin
//f1:='c:\test\user.txt';
f1:=f_d+'user.txt';
cmdline:='/c query user >'+ f1;
  // убрат !!! if ShellExecute(0,nil, PChar('cmd'),PChar(cmdline),nil,1)=0 then;
  Sleep(5);
  /////////////===================
  f1:='c:\test\user.txt';
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
      //  for j := 0 to fl.Count - 1 do
//      ShowMessageFmt('%d="%s"', [j, fL[j]]);
       StringGrid1.Cells[0,i]:=IntToStr(i);
       StringGrid1.Cells[1,i]:=Fl[1];
       StringGrid1.Cells[2,i]:=Fl[3];
     end;end;end;

     // Готово. Закрываем файл.
   //  SortGrid(1);
   if (b_id.Checked=true) then SortGrid(0) else SortGrid(1);
     StringGrid1.AutoSizeColumn(0);
          StringGrid1.AutoSizeColumn(1);
          StringGrid1.AutoSizeColumn(2);
     CloseFile(F);
     Fl.Free;
   except
     on E: EInOutError do
      writeln('Ошибка обработки файла. Детали: ', E.Message);

 {   AutoSizeCol(StringGrid1,1);}
   end;

end;

procedure TForm1.Button2Click(Sender: TObject);
var
  F:TextFile;
  i,j,n:integer;
  f1, cmdline, line1, login1:String;
  fL : TStringList;
begin
  stringgrid1.Clear;
//f1:='c:\test\user.txt';
f1:=f_d+'user.txt';
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
      //  for j := 0 to fl.Count - 1 do
//      ShowMessageFmt('%d="%s"', [j, fL[j]]);
//       StringGrid1.Cells[0,i]:=IntToStr(i);
       StringGrid1.Cells[0,i]:=Fl[1];
       StringGrid1.Cells[2,i]:=Fl[3];
//       StringGrid1.Cells[3,i]:=fam[1,SearchArr(Fl[1])];
//ShowMessage(IntToStr(SearchArr(Fl[1])));
login1:=StringReplace(fL[1],' ','',[rfReplaceall, rfIgnoreCase]);
if (SearchArr(login1)>=0) then
StringGrid1.Cells[1,i]:=fam[1,SearchArr(login1)]
else StringGrid1.Cells[1,i]:='+';
//    ShowMessage(fam[1,(SearchArr(Fl[1]))]);

     end;end;end;

     // Готово. Закрываем файл.
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

 {   AutoSizeCol(StringGrid1,1);}
   end;
  end;

procedure TForm1.Button3Click(Sender: TObject);
var // !!!! не закончено
    F:TextFile;
  i,j,n:integer;
  f1, cmdline, line1:String;
  fL : TStringList;
begin
  UserF2Array;
{f1:=f_d+'user_name.txt';     //задача считать в массив содержимое файла
fL := TStringList.Create;
fL.Delimiter := '|';
fL.StrictDelimiter := True;
AssignFile(F,f1);
try
// Открыть файл для чтения
  reset(F);
  ReadLn(F,line1);
//    ShowMessage(line1);
     i:=0;
// Считываем строки, пока не закончится файл
     while not eof(F) do
     begin
     ReadLn(F,line1);
//ShowMessage(line1);
     line1:= StringReplace(line1, '  ', '|',[]);
// | разделитель столбцов
       while pos('  ',line1)>0 do begin
       line1:= StringReplace(line1, '  ', ' ', [rfReplaceAll]);
       end;
//   ShowMessage(line1);
//    if (pos('>',line1)=0) then
    begin
  if (pos('|',line1)>0) then
      begin
//       inc(i);
       fL.DelimitedText :=line1;
//  for j := 0 to fl.Count - 1 do
//      ShowMessageFmt('%d="%s"', [j, fL[j]]);
   if (fL[0]<>'') then //если учетка имеет имя
      begin //вносим ее в массив
      inc(i);
       fam[0,i]:=StringReplace(fL[1],' ','',[rfReplaceall, rfIgnoreCase]);
       fam[1,i]:=fL[0];
     end;
      end;end;end;
     // Готово. Закрываем файл.
     CloseFile(F);
     Fl.Free;
   except
     on E: EInOutError do
      ShowMessage('Ошибка обработки файла. Детали: '+E.Message);
   end;}
end;

procedure TForm1.b_rdpChange(Sender: TObject);
begin

end;

procedure TForm1.FormCreate(Sender: TObject);
begin
     Form1.Caption:='rdp_viewer_©UDP_SIKO_2020';
end;

procedure TForm1.Label1Click(Sender: TObject);
begin

end;

procedure TForm1.b_fioChange(Sender: TObject);
begin
  SortGrid(1);
end;

procedure TForm1.b_idChange(Sender: TObject);
begin
  SortGrid(0);
end;

procedure TForm1.RadioButton5Change(Sender: TObject);
var message,cmdline:string;
begin
message:=InputBox('сообщение для пользователя','сообщение для пользователя','');
    cmdline:='/c msg *'+' '+message;
  if ShellExecute(0,nil, PChar('cmd'),PChar(cmdline),nil,1) =0 then;
end;

procedure TForm1.StringGrid1DblClick(Sender: TObject);
var id:integer;
  ids, cmdline, message:string;
begin
// узнаем номер строки  IntToStr(StringGrid1.Row)
  id:=(StringGrid1.Row);
  ids:=StringGrid1.Cells[2,id];
  ids:= StringReplace(ids, 'rdp-tcp#', '', [rfReplaceAll]);
  cmdline:='/c mstsc /shadow:'+ ids;
 // ShowMessage(cmdline);
 if (b_rdp.Checked=True) then  if ShellExecute(0,nil, PChar('cmd'),PChar(cmdline),nil,1) =0 then;
 if (b_mess.Checked=True) then
 begin
    message:=InputBox('сообщение для пользователя','сообщение для пользователя','');
    cmdline:='/c msg '+StringGrid1.Cells[0,id]+' '+message;
  if ShellExecute(0,nil, PChar('cmd'),PChar(cmdline),nil,1) =0 then;
 end;
end;
procedure TForm1.UserF2Array;
var // !!!! не закончено
    F:TextFile;
  i,j,n:integer;
  f1, cmdline, line1:String;
  fL : TStringList;
begin
f1:=f_d+'user_name.txt';     //задача считать в массив содержимое файла
fL := TStringList.Create;
fL.Delimiter := '|';
fL.StrictDelimiter := True;
AssignFile(F,f1);
try
// Открыть файл для чтения
  reset(F);
  ReadLn(F,line1);
//    ShowMessage(line1);
     i:=0;
// Считываем строки, пока не закончится файл
     while not eof(F) do
     begin
     ReadLn(F,line1);
//ShowMessage(line1);
     line1:= StringReplace(line1, '  ', '|',[]);
// | разделитель столбцов
       while pos('  ',line1)>0 do begin
       line1:= StringReplace(line1, '  ', ' ', [rfReplaceAll]);
       end;
//   ShowMessage(line1);
//    if (pos('>',line1)=0) then
    begin
  if (pos('|',line1)>0) then
      begin
//       inc(i);
       fL.DelimitedText :=line1;
//  for j := 0 to fl.Count - 1 do
//      ShowMessageFmt('%d="%s"', [j, fL[j]]);
   if (fL[0]<>'') then //если учетка имеет имя
      begin //вносим ее в массив
      inc(i);
       fam[0,i]:=StringReplace(fL[1],' ','',[rfReplaceall, rfIgnoreCase]);
       fam[1,i]:=fL[0];
     end;
      end;end;end;
     // Готово. Закрываем файл.
     CloseFile(F);
     Fl.Free;
   except
     on E: EInOutError do
      ShowMessage('Ошибка обработки файла. Детали: '+E.Message);
   end;
end;
end.

