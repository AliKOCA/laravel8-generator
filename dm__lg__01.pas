unit dm__lg__01;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, DB, ZConnection, ZDataset;

type

  { Tdm01 }

  Tdm01 = class(TDataModule)
    DataSource1: TDataSource;
    DataSource10: TDataSource;
    DataSource11: TDataSource;
    DataSource12: TDataSource;
    DataSource13: TDataSource;
    DataSource14: TDataSource;
    dsColumns: TDataSource;
    dsTables: TDataSource;
    DataSource2: TDataSource;
    DataSource3: TDataSource;
    DataSource4: TDataSource;
    DataSource5: TDataSource;
    DataSource6: TDataSource;
    DataSource7: TDataSource;
    DataSource8: TDataSource;
    DataSource9: TDataSource;
    ZConnection1: TZConnection;
    zqColumnscharacter_maximum_length: TLongintField;
    zqColumnscharacter_octet_length: TLongintField;
    zqColumnscharacter_set_catalog: TStringField;
    zqColumnscharacter_set_name: TStringField;
    zqColumnscharacter_set_schema: TStringField;
    zqColumnscollation_catalog: TStringField;
    zqColumnscollation_name: TStringField;
    zqColumnscollation_schema: TStringField;
    zqColumnscolumn_default: TMemoField;
    zqColumnscolumn_name: TStringField;
    zqColumnsdata_type: TMemoField;
    zqColumnsdatetime_precision: TLongintField;
    zqColumnsdomain_catalog: TStringField;
    zqColumnsdomain_name: TStringField;
    zqColumnsdomain_schema: TStringField;
    zqColumnsdtd_identifier: TStringField;
    zqColumnsgeneration_expression: TMemoField;
    zqColumnsidentity_cycle: TStringField;
    zqColumnsidentity_generation: TMemoField;
    zqColumnsidentity_increment: TMemoField;
    zqColumnsidentity_maximum: TMemoField;
    zqColumnsidentity_minimum: TMemoField;
    zqColumnsidentity_start: TMemoField;
    zqColumnsinterval_precision: TLongintField;
    zqColumnsinterval_type: TMemoField;
    zqColumnsis_generated: TMemoField;
    zqColumnsis_identity: TStringField;
    zqColumnsis_nullable: TStringField;
    zqColumnsis_self_referencing: TStringField;
    zqColumnsis_updatable: TStringField;
    zqColumnsmaximum_cardinality: TLongintField;
    zqColumnsnumeric_precision: TLongintField;
    zqColumnsnumeric_precision_radix: TLongintField;
    zqColumnsnumeric_scale: TLongintField;
    zqColumnsordinal_position: TLongintField;
    zqColumnsscope_catalog: TStringField;
    zqColumnsscope_name: TStringField;
    zqColumnsscope_schema: TStringField;
    zqColumnstable_catalog: TStringField;
    zqColumnstable_name: TStringField;
    zqColumnstable_schema: TStringField;
    zqColumnsudt_catalog: TStringField;
    zqColumnsudt_name: TStringField;
    zqColumnsudt_schema: TStringField;
    zqTableshasindexes: TBooleanField;
    zqTableshasrules: TBooleanField;
    zqTableshastriggers: TBooleanField;
    zqTablesrowsecurity: TBooleanField;
    zqTablesschemaname: TStringField;
    zqTablestablename: TStringField;
    zqTablestableowner: TStringField;
    zqTablestablespace: TStringField;
    ZQuery1: TZQuery;
    ZQuery10: TZQuery;
    ZQuery11: TZQuery;
    ZQuery12: TZQuery;
    ZQuery13: TZQuery;
    ZQuery14: TZQuery;
    zqColumns: TZQuery;
    zqTables: TZQuery;
    ZQuery2: TZQuery;
    ZQuery3: TZQuery;
    ZQuery4: TZQuery;
    ZQuery5: TZQuery;
    ZQuery6: TZQuery;
    ZQuery7: TZQuery;
    ZQuery8: TZQuery;
    ZQuery9: TZQuery;
    procedure ZConnection1AfterConnect(Sender: TObject);
    procedure zqTablesAfterScroll(DataSet: TDataSet);
  private

  public

  end;

var
  dm01: Tdm01;

implementation

{$R *.lfm}

{ Tdm01 }

procedure Tdm01.zqTablesAfterScroll(DataSet: TDataSet);
begin
  dm01.zqColumns.Close;
  dm01.zqColumns.SQL.Text :=
    'SELECT *' + #13 + #10 + '  FROM information_schema.columns' +
    #13 + #10 + '  WHERE table_schema = ' + #39 + dm01.zqTablesschemaname.AsString +
    #39 + ' And table_name   = ' + #39 + dm01.zqTablestablename.AsString + #39 + ';' + #13 + #10;
  dm01.zqColumns.Open;

end;

procedure Tdm01.ZConnection1AfterConnect(Sender: TObject);
begin

end;

end.

