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
    StringGrid1: TStringGrid;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure StringGrid1DblClick(Sender: TObject);
 //   procedure AutoSizeCol(Grid: TStringGrid;
    private

    public

    end;
var
  Form1: TForm1;

implementation

{$R *.lfm}

{ TForm1 }
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
f1:='c:\test\user.txt';
cmdline:='/c query user >'+ f1;
  if ShellExecute(0,nil, PChar('cmd'),PChar(cmdline),nil,1)=0 then;
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
  f1, cmdline, line1:String;
  fL : TStringList;
begin
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

procedure TForm1.FormCreate(Sender: TObject);
begin

end;

procedure TForm1.StringGrid1DblClick(Sender: TObject);
var id:integer;
  ids, cmdline:string;
begin
// узнаем номер строки  IntToStr(StringGrid1.Row)
  id:=(StringGrid1.Row);
  ids:=StringGrid1.Cells[2,id];
  ids:= StringReplace(ids, 'rdp-tcp#', '', [rfReplaceAll]);
  cmdline:='/c mstsc /shadow:'+ ids;
 // ShowMessage(cmdline);
  if ShellExecute(0,nil, PChar('cmd'),PChar(cmdline),nil,1) =0 then;
end;

end.

