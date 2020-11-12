unit w__lg__ana;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, DBGrids,
  dm__lg__01, utility, LazUTF8, strutils;

const
  enter = #13 + #10;

type

  { TForm1 }

  TForm1 = class(TForm)
    btnMakeFiles: TButton;
    DBGrid1: TDBGrid;
    DBGrid2: TDBGrid;
    edtProjectRootFolder: TEdit;
    Label1: TLabel;
    mmCreate: TMemo;
    mmIndex: TMemo;
    mmUpdate: TMemo;
    mmModel: TMemo;
    mmRoute: TMemo;
    mmController: TMemo;
    procedure btnMakeFilesClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormShow(Sender: TObject);
  private

  public
    procedure createFileAndWrite(pFile, pWrite: string);
    function GetModel(): string;
    function GetRoute(pTablo: string): string;
    function GetController(pTablo: string): string;
    function GetCreateBlade(): string;
    function GetIndexBlade(): string;
    function GetEditBlade(): string;
    function GetValidate(): string;
    function GetUpdateTransfer(): string;
    function GetStoreTransfer(): string;
  end;

var
  Form1: TForm1;

implementation

{$R *.lfm}

{ TForm1 }

procedure TForm1.btnMakeFilesClick(Sender: TObject);
var
  prjFolder, modelFile, ControllerFile, viewSubFolder, CreateBladeFile,
  IndexBladeFile, EditBladeFile: string;
begin
  prjFolder := edtProjectRootFolder.Text;
  ControllerFile := prjFolder + 'app/Http/Controllers/' +
    UTF8UppercaseFirstChar(dm01.zqTablestablename.AsString) + 'Controller.php';
  modelFile := prjFolder + 'app/Models/' + UTF8UppercaseFirstChar(
    dm01.zqTablestablename.AsString) + '.php';

  //Klasör oluştur.
  viewSubFolder := prjFolder + 'resources/views/' + dm01.zqTablestablename.AsString;

  CreateBladeFile := prjFolder + 'resources/views/' +
    dm01.zqTablestablename.AsString + '/create.blade.php';

  IndexBladeFile := prjFolder + 'resources/views/' +
    dm01.zqTablestablename.AsString + '/index.blade.php';

  EditBladeFile := prjFolder + 'resources/views/' + dm01.zqTablestablename.AsString +
    '/edit.blade.php';

  //1. Create ControllerFile and write.
  createFileAndWrite(ControllerFile, GetController(dm01.zqTablestablename.AsString));
  //2. Create modelFile and write.
  createFileAndWrite(modelFile, GetModel());
  //3. Create viewSubFolder
  CreateDir(viewSubFolder);
  //4. Create CreateBladeFile and write.
  createFileAndWrite(CreateBladeFile, GetCreateBlade());
  //5. Create IndexBladeFile and write.
  createFileAndWrite(IndexBladeFile, GetIndexBlade());
  //6. Create EditBladeFile and write.
  createFileAndWrite(EditBladeFile, GetEditBlade());

{
mYollar.Text := '';
mYollar.Lines.Add('ControllerFile : ' + ControllerFile);
mYollar.Lines.Add('modelFile : ' + modelFile);
mYollar.Lines.Add('viewSubFolder : ' + viewSubFolder);
mYollar.Lines.Add('CreateBladeFile : ' + CreateBladeFile);
mYollar.Lines.Add('IndexBladeFile : ' + IndexBladeFile);
mYollar.Lines.Add('EditBladeFile : ' + EditBladeFile);
}
  mmModel.Lines.Text := GetModel();
  mmRoute.Lines.Text := GetRoute(dm01.zqTablestablename.AsString);
  mmController.Lines.Text := GetController(dm01.zqTablestablename.AsString);
  mmCreate.Lines.Text := GetCreateBlade();
  mmIndex.Lines.Text := GetIndexBlade();
  mmUpdate.Lines.Text := GetEditBlade();

end;

procedure TForm1.FormClose(Sender: TObject; var CloseAction: TCloseAction);
begin
  dm01.zqTables.Close;
end;

procedure TForm1.FormShow(Sender: TObject);
begin
  dm01.zqTables.Open;
end;

procedure TForm1.createFileAndWrite(pFile, pWrite: string);
var
  f: Text;
begin
  with TStringList.Create do
    try
      Add(pWrite);
      SaveToFile(pFile);
    finally
      Free;
    end;

  {
  AssignFile(f,pFile);
  {$I-}
  Rewrite(f);
  {$I+}
  if IOResult =0 then begin
    WriteLn(pWrite);
    CloseFile(f);
  end else begin
    WriteLn('error opening file for writing');
  end;       }
end;

function TForm1.GetRoute(pTablo: string): string;
var
  rslt: string;
  nesne, classs: string;
begin
  classs := UTF8UppercaseFirstChar(pTablo);
  nesne := UTF8LowerCase(pTablo);
  rslt :=
    'use App\Http\Controllers\MisalController; ' + enter + #13 +
    #10 + 'Route::resource(' + #39 + '/misal' + #39 + ', MisalController::class);' +
    enter + 'Route::get(' + #39 + '/misal/delete/{id}' + #39 +
    ', function ($id) {' + enter + '    $misalController = new MisalController();' +
    enter + '    return $misalController->destroy($id);' + #13 +
    #10 + '});' + enter + '' + enter;
  rslt := ReplaceStr(rslt, 'misal', nesne);
  rslt := ReplaceStr(rslt, 'Misal', classs);
  Result := rslt;
end;

function TForm1.GetModel(): string;
var
  rslt: string;
  A: integer;
begin
  dm01.zqColumns.First;
  rslt :=
    '<?php' + enter + '' + enter + 'namespace App\Models;' + enter +
    '' + enter + 'use Illuminate\Database\Eloquent\Model;' + enter +
    '' + enter + 'class ' + UTF8UppercaseFirstChar(dm01.zqTablestablename.AsString) +
    ' extends Model' + enter + '{' + enter + '    protected $table = ' +
    #39 + dm01.zqTablesschemaname.AsString + '.' + dm01.zqTablestablename.AsString +
    #39 + ';' + enter + '    protected $primaryKey = ' + #39 +
    dm01.zqColumnscolumn_name.AsString + #39 + ';' + enter +
    '    public $timestamps = false; ' + enter + '    protected $fillable = [';

  dm01.zqColumns.Next;
  for A := 2 to dm01.zqColumns.RecordCount do
  begin
    if (not ((dm01.zqColumnscolumn_name.AsString = 'created_at') or
      (dm01.zqColumnscolumn_name.AsString = 'updated_at'))) then
    begin
      rslt := rslt + enter + '        ' + #39 +
        dm01.zqColumnscolumn_name.AsString + #39 + ',';
    end;

    dm01.zqColumns.Next;
  end;
  rslt := rslt + #10 + '    ];' + enter + '}' + enter + '' + enter;
  Result := rslt;
end;

function TForm1.GetController(pTablo: string): string;
var
  rslt: string;
  nesne, classs: string;
begin
  classs := UTF8UppercaseFirstChar(pTablo);
  nesne := UTF8LowerCase(pTablo);
  rslt :=
    '<?php' + enter + '' + enter + 'namespace App\Http\Controllers;' +
    enter + '' + enter + 'use Illuminate\Http\Request;' + enter +
    'use App\Models\Misal;' + enter + 'use Illuminate\Support\Facades\DB;' +
    enter + '' + #13 + #10 + 'class MisalController extends Controller' +
    enter + '{' + enter + '    /**' + enter +
    '     * Display a listing of the resource.' + enter + '     *' +
    enter + '     * @return \Illuminate\Http\Response' + #13 + #10 +
    '     */' + enter + '    public function index()' + enter + '    {' +
    enter + '        $misal = Misal::' + enter + '            //orderBy(' +
    #39 + 'soyisim' + #39 + ', ' + #39 + 'ASC' + #39 + ')->' + enter +
    '            get();' + enter + '        return view(' + #39 +
    'misal.index' + #39 + ', compact(' + #39 + 'misal' + #39 + '));' +
    enter + '    }' + enter + '    /**' + enter +
    '     * Show the form for creating a new resource.' + enter +
    '     *' + enter + '     * @return \Illuminate\Http\Response' +
    enter + '     */' + enter + '    public function create()' +
    enter + '    {' + enter + '        return view(' + #39 +
    'misal.create' + #39 + ');' + enter + '    }' + enter + '' +
    enter + '    /**' + enter + '     * Store a newly created resource in storage.' +
    enter + '     *' + enter + '     * @param  \Illuminate\Http\Request  $request' +
    enter + '     * @return \Illuminate\Http\Response' + #13 + #10 +
    '     */' + enter + '    public function store(Request $request)' +
    enter + '    {' + enter;

  rslt := rslt + enter + GetValidate();

  rslt := rslt + enter + GetStoreTransfer();

  rslt := rslt + #10 + '        $misal->save();' + enter + enter +
    '        return redirect(' + #39 + '/misal' + #39 + ')->with(' +
    #39 + 'tamam' + #39 + ', ' + #39 + 'Misal kaydedildi.' + #39 +
    ');' + enter + '    }' + enter + '' + enter + '    /**' + enter +
    '     * Display the specified resource.' + enter + '     *' +
    enter + '     * @param  int  $id' + enter +
    '     * @return \Illuminate\Http\Response' + enter + '     */' +
    enter + '    public function show($id)' + enter + '    {' +
    enter + '        //' + enter + '    }' + enter + '' + enter +
    '    /**' + enter + '     * Show the form for editing the specified resource.' +
    #13 + #10 + '     *' + enter + '     * @param  int  $id' + #13 +
    #10 + '     * @return \Illuminate\Http\Response' + enter +
    '     */' + enter + '    public function edit($okytno)' + enter +
    '    {' + enter + '        $misal = Misal::find($okytno);' +
    enter + '        return view(' + #39 + 'misal.edit' + #39 +
    ', compact(' + #39 + 'misal' + #39 + '));' + enter + '    }' +
    enter + '' + enter + '    /**' + enter +
    '     * Update the specified resource in storage.' + enter +
    '     *' + enter + '     * @param  \Illuminate\Http\Request  $request' +
    enter + '     * @param  int  $id' + enter +
    '     * @return \Illuminate\Http\Response' + enter + '     */' +
    enter + '    public function update(Request $request, $okytno) {' + enter;

  rslt := rslt + GetValidate();

  rslt := rslt + enter + '        $misal = Misal::find($okytno);';

  rslt := rslt + GetUpdateTransfer();
  rslt := rslt + '        $misal->save();' + enter + enter +
    '        return redirect(' + #39 + '/misal' + #39 + ')->with(' +
    #39 + 'tamam' + #39 + ', ' + #39 + 'Misal güncellendi.' + #39 +
    ');' + enter + '    }' + enter + '' + enter + '    /**' + enter +
    '     * Remove the specified resource from storage.' + enter +
    '     *' + enter + '     * @param  int  $id' + enter +
    '     * @return \Illuminate\Http\Response' + #13 + #10 + '     */' +
    enter + '    public function destroy($okytno)' + enter + '    {' +
    enter + '        $netice = [' + #39 + 'netice' + #39 + ' => ' +
    #39 + 'Tamam.' + #39 + '];' + #13 + #10 + '        $misal = Misal::find($okytno);' +
    enter + '        try {' + enter + '            $misal->delete($okytno);' +
    enter + '        } catch (\Exception $ex) {' + enter +
    '            $netice = [' + #39 + 'netice' + #39 + ' => ' + #39 +
    'Hata!' + #39 + ', ' + #39 + 'veri' + #39 + ' => $ex->getMessage()];' +
    enter + '        }' + enter +
    '        header("content-type: application/json");' +
    enter + '        echo json_encode($netice);' + enter + '    }' +
    #13 + #10 + '}' + enter;
  rslt := ReplaceStr(rslt, 'misal', nesne);
  rslt := ReplaceStr(rslt, 'Misal', classs);
  Result := rslt;
end;

function TForm1.GetCreateBlade(): string;
var
  rslt: string;
  A: integer;
  typee: string;
begin
  dm01.zqColumns.First;
  rslt :=
    '@extends(' + #39 + 'layouts.ana' + #39 + ')' + enter + '@section(' +
    #39 + 'title' + #39 + ', ' + #39 + dm01.zqTablestablename.AsString +
    ' Kayıt' + #39 + ')' + enter + '' + enter + '@section(' + #39 +
    'sidebar' + #39 + ')' + enter + '    @parent' + #13 + #10 +
    '@endsection' + enter + '' + enter + '@section(' + #39 + 'icerik' +
    #39 + ')' + enter + '    <div class="row">' + enter +
    '        <div class="col-sm-8 offset-sm-2">' + #13 + #10 +
    '            <h1 class="display-3">' + dm01.zqTablestablename.AsString +
    ' Ekleme Formu</h1>' + enter + '            <div>' + #13 + #10 +
    '                @if ($errors->any())' + enter +
    '                    <div class="alert alert-danger">' + #13 +
    #10 + '                        <ul>' + enter +
    '                            @foreach ($errors->all() as $error)' +
    enter + '                                <li>{{ $error }}</li>' +
    enter + '                            @endforeach' + #13 + #10 +
    '                        </ul>' + enter + '                    </div><br />' +
    enter + '                @endif' + enter +
    '                <form method="post" action="{{ route(' + #39 +
    dm01.zqTablestablename.AsString + '.store' + #39 + ') }}">' +
    enter + '                    @csrf' + enter;


  dm01.zqColumns.Next;
  for A := 2 to dm01.zqColumns.RecordCount do
  begin
    if (not ((dm01.zqColumnscolumn_name.AsString = 'created_at') or
      (dm01.zqColumnscolumn_name.AsString = 'updated_at'))) then
    begin

      case dm01.zqColumnsudt_name.AsString of
        'timestamp': typee := 'date';
        'int4': typee := 'number';
        else
          typee := 'text';
      end;
      if (not (dm01.zqColumnsudt_name.AsString = 'bool')) then
      begin
        rslt := rslt + '                    <div class="form-group">' +
          enter + '                        <label for="first_name">' +
          dm01.zqColumnscolumn_name.AsString + ':</label>' + #13 +
          #10 + '                        <input type="' + typee +
          '" class="form-control" name="' + dm01.zqColumnscolumn_name.AsString +
          '" />' + enter + '                    </div>' + enter;
      end
      else
      begin
        rslt := rslt + ' <div class="form-check">' + enter +
          '    <input type="checkbox" class="form-check-input" name="' +
          dm01.zqColumnscolumn_name.AsString + '">' + enter +
          '    <label class="form-check-label" for="' +
          dm01.zqColumnscolumn_name.AsString + '">' +
          dm01.zqColumnscolumn_name.AsString + '</label>' + #13 +
          #10 + '  </div>' + enter;

      end;

    end;

    dm01.zqColumns.Next;
  end;
  rslt := rslt + enter +
    '                    <button type="submit" class="btn btn-primary">' +
    dm01.zqTablestablename.AsString + ' Ekle</button> | <a href="/' +
    dm01.zqTablestablename.AsString + '"' + enter +
    '                        class="btn btn-danger">İptal</a>' +
    enter + '                </form>' + enter + '' + #13 + #10 +
    '            </div>' + enter + '        </div>' + #13 + #10 +
    '    </div>' + enter + '@endsection' + enter;
  Result := rslt;
end;


function TForm1.GetIndexBlade(): string;
var
  rslt: string;
  A: integer;
  thler: string;
  nesne, classs: string;
begin
  classs := UTF8UppercaseFirstChar(dm01.zqTablestablename.AsString);
  nesne := UTF8LowerCase(dm01.zqTablestablename.AsString);
  dm01.zqColumns.First;
  dm01.zqColumns.Next;
  for A := 2 to dm01.zqColumns.RecordCount do
  begin
    if (not ((dm01.zqColumnscolumn_name.AsString = 'created_at') or
      (dm01.zqColumnscolumn_name.AsString = 'updated_at'))) then
    begin
      thler := thler + '<th>' + dm01.zqColumnscolumn_name.AsString + '</th>' + enter;
    end;

    dm01.zqColumns.Next;
  end;

  rslt :=
    '@extends(' + #39 + 'layouts.ana' + #39 + ')' + enter + '@section(' +
    #39 + 'title' + #39 + ', ' + #39 + 'Misal' + #39 + ')' + enter +
    '' + enter + '@section(' + #39 + 'css' + #39 + ')' + enter +
    '<style>' + enter + '    .title .baslik {' + enter + '        float: left' +
    enter + '    }' + #13 + #10 + '' + enter + '    .title .buton {' +
    enter + '        float: right' + enter + '    }' + enter + '</style>' +
    enter + '@endsection' + enter + '' + enter + '@section(' + #39 +
    'icerik' + #39 + ')' + enter + '<!-- DataTales Example -->' +
    enter + '<div class="card shadow mb-4">' + enter +
    '    <div class="card-header py-3">' + enter + '        <div class="title">' +
    enter + '            <span class="m-0 font-weight-bold text-primary baslik">Misal</span> <span class="buton">' + enter + '                <a href="/misal/create" class="btn btn-outline-primary btn-sm">Misal' + enter + '                    Ekle</a> </span>' + #13 + #10 + '        </div>' + enter + '    </div>' + enter + '    <div class="card-body">' + enter + '        <div class="table-responsive">' + enter + '            <table class="table table-striped table-sm" id="dataTable" width="100%" cellspacing="0">' + enter + '                <thead>' + enter + '                    <tr>' + enter + thler + '                    </tr>' + enter + '                </thead>' + enter + '                <tfoot>' + enter + '                    <tr>' + enter + thler + '                    </tr>' + enter + '                </tfoot>' + enter + '                <tbody>' + enter + '                    @foreach ($misal as $birKayit)' + enter + '                    <tr>' + enter;

  dm01.zqColumns.First;
  dm01.zqColumns.Next;
  for A := 2 to dm01.zqColumns.RecordCount do
  begin
    if (not ((dm01.zqColumnscolumn_name.AsString = 'created_at') or
      (dm01.zqColumnscolumn_name.AsString = 'updated_at'))) then
    begin
      rslt := rslt + '<td>{{ $birKayit->' + dm01.zqColumnscolumn_name.AsString +
        ' }}</td>' + enter;
    end;
    dm01.zqColumns.Next;
  end;
  rslt := rslt + '                        <td>' + enter +
    '                            <a href="{{ route(' + #39 + 'misal.edit' +
    #39 + ', $birKayit->okytno) }}" class="btn btn-outline-primary btn-sm"><i class="fa fa-edit"></i></a>'
    + enter +
    '                            <a class="sil-butonu btn btn-outline-danger btn-sm" data-url="/misal/delete/{{ $birKayit->okytno }}" data-hedefurl="<?= $_SERVER[' + #39 + 'REQUEST_URI' + #39 + '] ?>"><i class="fa fa-trash"></i></a>' + enter + '                        </td>' + enter + '                        <td> </td>' + enter + '                    </tr>' + enter + '                    @endforeach' + enter + '                </tbody>' + enter + '            </table>' + enter + '        </div>' + enter + '    </div>' + enter + '</div>' + enter + '@endsection' + enter + '' + enter + '@section(' + #39 + 'js' + #39 + ')' + enter + '<script src="/assets/js/custom-datatables.js"></script>' + enter + '@endsection' + enter;
  rslt := ReplaceStr(rslt, 'misal', nesne);
  rslt := ReplaceStr(rslt, 'Misal', classs);
  Result := rslt;
end;

function TForm1.GetEditBlade(): string;
var
  rslt: string;
  A: integer;
  typee: string;
  nesne, classs: string;
begin
  classs := UTF8UppercaseFirstChar(dm01.zqTablestablename.AsString);
  nesne := UTF8LowerCase(dm01.zqTablestablename.AsString);

  dm01.zqColumns.First;
  rslt :=
    '@extends(' + #39 + 'layouts.ana' + #39 + ')' + #13 + #10 +
    '@section(' + #39 + 'title' + #39 + ', ' + #39 + 'Misal Düzeltme' +
    #39 + ')' + #13 + #10 + '' + #13 + #10 + '@section(' + #39 +
    'sidebar' + #39 + ')' + #13 + #10 + '    @parent' + #13 + #10 +
    '@endsection' + #13 + #10 + '' + #13 + #10 + '@section(' + #39 +
    'icerik' + #39 + ')' + #13 + #10 + '    <div class="row">' + #13 +
    #10 + '        <div class="col-sm-8 offset-sm-2">' + #13 + #10 +
    '            <h1 class="display-3">Misali Düzelt</h1>' + #13 +
    #10 + '            @if ($errors->any())' + #13 + #10 +
    '                <div class="alert alert-danger">' + #13 + #10 +
    '                    <ul>' + #13 + #10 +
    '                        @foreach ($errors->all() as $error)' +
    #13 + #10 + '                            <li>{{ $error }}</li>' +
    #13 + #10 + '                        @endforeach' + #13 + #10 +
    '                    </ul>' + #13 + #10 + '                </div>' +
    #13 + #10 + '                <br />' + #13 + #10 + '            @endif' +
    #13 + #10 + '            <form method="post" action="{{ route(' +
    #39 + 'misal.update' + #39 + ', $misal->okytno) }}">' + #13 +
    #10 + '                @method(' + #39 + 'PATCH' + #39 + ')' +
    #13 + #10 + '                @csrf' + #13 + #10;

  dm01.zqColumns.First;
  dm01.zqColumns.Next;
  for A := 2 to dm01.zqColumns.RecordCount do
  begin
    if (not ((dm01.zqColumnscolumn_name.AsString = 'created_at') or
      (dm01.zqColumnscolumn_name.AsString = 'updated_at'))) then
    begin

      case dm01.zqColumnsudt_name.AsString of
        'timestamp': typee := 'date';
        'int4': typee := 'number';
        else
          typee := 'text';
      end;
      if (dm01.zqColumnsudt_name.AsString = 'bool') then
      begin
        rslt := rslt + ' <div class="form-check">' + enter +
          '    <input type="checkbox" class="form-check-input" name="' +
          dm01.zqColumnscolumn_name.AsString + '"   value="{{ $misal->' +
          dm01.zqColumnscolumn_name.AsString + '}}" ' + '  {{$misal->' +
          dm01.zqColumnscolumn_name.AsString + ' == ' + #39 + 'true' +
          #39 + ' ? ' + #39 + 'checked' + #39 + ' : null }} />' +
          enter + '    <label class="form-check-label" for="' +
          dm01.zqColumnscolumn_name.AsString + '">' +
          dm01.zqColumnscolumn_name.AsString + '</label>' + #13 +
          #10 + '  </div>' + enter;
      end
      else
      begin
        if (dm01.zqColumnsudt_name.AsString = 'timestamp') then
        begin
          rslt := rslt + '                    <div class="form-group">' +
            enter + '                        <label for="first_name">' +
            dm01.zqColumnscolumn_name.AsString + ':</label>' + #13 +
            #10 + '                        <input type="' + typee +
            '" class="form-control" name="' + dm01.zqColumnscolumn_name.AsString +
            '" value="{{  old(' + #39 + dm01.zqColumnscolumn_name.AsString +
            #39 + ') ?? $misal->' + dm01.zqColumnscolumn_name.AsString +
            '->format(' + #39 + 'Y-m-d' + #39 + ') }}"   />' + enter +
            '                    </div>' + enter;
        end
        else
        begin
          rslt := rslt + '                    <div class="form-group">' +
            enter + '                        <label for="first_name">' +
            dm01.zqColumnscolumn_name.AsString + ':</label>' + #13 +
            #10 + '                        <input type="' + typee +
            '" class="form-control" name="' + dm01.zqColumnscolumn_name.AsString +
            '" value="{{  old(' + #39 + dm01.zqColumnscolumn_name.AsString +
            #39 + ') ?? $misal->' + dm01.zqColumnscolumn_name.AsString +
            '}}"   />' + enter + '                    </div>' + enter;
        end;
      end;

    end;

    dm01.zqColumns.Next;
  end;
  rslt := rslt +
    '                <button type="submit" class="btn btn-primary">Güncelle</button>' +
    #13 + #10 + '            </form>' + #13 + #10 + '        </div>' +
    #13 + #10 + '    </div>' + #13 + #10 + '@endsection' + #13 + #10;

  rslt := ReplaceStr(rslt, 'misal', nesne);
  rslt := ReplaceStr(rslt, 'Misal', classs);
  Result := rslt;
end;

function TForm1.GetValidate(): string;
var
  rslt: string;
  A: integer;
begin
  rslt :=
    '$request->validate([';
  dm01.zqColumns.First;
  dm01.zqColumns.Next;
  for A := 2 to dm01.zqColumns.RecordCount do
  begin
    if (not ((dm01.zqColumnscolumn_name.AsString = 'created_at') or
      (dm01.zqColumnscolumn_name.AsString = 'updated_at'))) then
    begin
      if (dm01.zqColumnsis_nullable.AsString = 'NO') then
      begin
        rslt := rslt + enter + #39 + dm01.zqColumnscolumn_name.AsString +
          #39 + ' => ' + #39 + 'required' + #39 + ', ';

      end;
    end;
    dm01.zqColumns.Next;
  end;
  Result := rslt + enter + '        ]);' + enter;
end;

function TForm1.GetUpdateTransfer(): string;
var
  rslt: string;
  A: integer;
begin
  rslt := '';
  dm01.zqColumns.First;
  dm01.zqColumns.Next;
  for A := 2 to dm01.zqColumns.RecordCount do
  begin
    if (not ((dm01.zqColumnscolumn_name.AsString = 'created_at') or
      (dm01.zqColumnscolumn_name.AsString = 'updated_at'))) then
    begin
      if (dm01.zqColumnsis_nullable.AsString = 'NO') then
      begin
        if (dm01.zqColumnsudt_name.AsString = 'bool') then
        begin
          rslt := rslt + enter + '$misal->' + dm01.zqColumnscolumn_name.AsString +
            ' =  $request->has(' + #39 + dm01.zqColumnscolumn_name.AsString +
            #39 + '); ';
        end
        else
        begin
          rslt := rslt + enter + '$misal->' + dm01.zqColumnscolumn_name.AsString +
            ' =  $request->get(' + #39 + dm01.zqColumnscolumn_name.AsString +
            #39 + '); ';
        end;
      end;
    end;
    dm01.zqColumns.Next;
  end;
  Result := rslt;
end;

function TForm1.GetStoreTransfer(): string;
var
  rslt: string;
  A: integer;
begin
  rslt := '        $misal = new Misal([';
  dm01.zqColumns.First;
  dm01.zqColumns.Next;
  for A := 2 to dm01.zqColumns.RecordCount do
  begin
    if (not ((dm01.zqColumnscolumn_name.AsString = 'created_at') or
      (dm01.zqColumnscolumn_name.AsString = 'updated_at'))) then
    begin
      if (dm01.zqColumnsis_nullable.AsString = 'NO') then
      begin
        if (dm01.zqColumnsudt_name.AsString = 'bool') then
        begin
          rslt := rslt + enter + #39 + dm01.zqColumnscolumn_name.AsString +
            #39 + ' =>  $request->has(' + #39 + dm01.zqColumnscolumn_name.AsString +
            #39 + '), ';
        end
        else
        begin
          rslt := rslt + enter + #39 + dm01.zqColumnscolumn_name.AsString +
            #39 + ' =>  $request->get(' + #39 + dm01.zqColumnscolumn_name.AsString +
            #39 + '), ';

        end;
      end;
    end;
    dm01.zqColumns.Next;
  end;
  Result := rslt + enter + '                 ]);';
end;

end.
