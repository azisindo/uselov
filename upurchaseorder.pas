unit upurchaseorder;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, DB, Forms, Controls, Graphics, Dialogs, ExtCtrls, StdCtrls,
  DBCtrls, RxDBGrid, ZConnection, ZDataset, ZAbstractRODataset,uConnect,setkoneksi,
  Libstring,libdata,LCLType,uLov,uSetVarGlobal ;

type

  { Tfrm_template }

  Tfrm_template = class(TForm)
    Button1: TButton;
    c_db: TZConnection;
    dbed_date_come: TDBEdit;
    dbed_po_id: TDBEdit;
    dbed_serial_no: TDBEdit;
    dbed_sup_id: TDBEdit;
    dbed_top: TDBEdit;
    dbg_pod: TRxDBGrid;
    ds_pod: TDataSource;
    ds_poh: TDataSource;
    ed_store_id: TEdit;
    ed_store_name: TEdit;
    lbl_date_come: TLabel;
    lbl_dsstate: TLabel;
    lbl_id_po: TLabel;
    lbl_serial_no: TLabel;
    lbl_top: TLabel;
    lbl_vendor_id: TLabel;
    ed_vendor_name: TEdit;
    pnl_body: TPanel;
    pnl_bottom: TPanel;
    pnl_disc: TPanel;
    pnl_head: TPanel;
    pnl_head_vendor: TPanel;
    pnl_ship_to: TPanel;
    pnl_time: TPanel;
    pnl_top: TPanel;
    sds_pod: TZQuery;
    sds_podtpod_created_by: TZRawStringField;
    sds_podtpod_created_date: TZDateField;
    sds_podtpod_id: TZRawStringField;
    sds_podtpod_mp_barcode: TZIntegerField;
    sds_podtpod_mp_sku: TZIntegerField;
    sds_podtpod_nama_barang: TStringField;
    sds_podtpod_price: TZBCDField;
    sds_podtpod_quantity: TZIntegerField;
    sds_podtpod_tax_1: TZBCDField;
    sds_podtpod_tax_2: TZBCDField;
    sds_podtpod_total_price: TZBCDField;
    sds_podtpod_tpoh_id: TZRawStringField;
    sds_podtpod_updated_by: TZRawStringField;
    sds_podtpod_updated_date: TZDateField;
    sds_poh: TZQuery;
    sds_pohtpoh_bu_id: TZIntegerField;
    sds_pohtpoh_created_by: TZRawStringField;
    sds_pohtpoh_created_date: TZDateField;
    sds_pohtpoh_id: TZRawStringField;
    sds_pohtpoh_number: TZRawStringField;
    sds_pohtpoh_order_arrival_date: TZDateField;
    sds_pohtpoh_order_date: TZDateField;
    sds_pohtpoh_status: TZRawStringField;
    sds_pohtpoh_supplier_id: TZIntegerField;
    sds_pohtpoh_top_id: TZRawStringField;
    sds_pohtpoh_total_amount: TZBCDField;
    sds_pohtpoh_updated_by: TZRawStringField;
    sds_pohtpoh_updated_date: TZDateField;
    store_id: TLabel;
    procedure Button1Click(Sender: TObject);
    procedure ed_store_idKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormShow(Sender: TObject);
    procedure sds_podCalcFields(DataSet: TDataSet);
    procedure sds_podNewRecord(DataSet: TDataSet);
  private
   procedure baru;
   function showstatedataset(dataset: TDataSet):string;
  public

  end;

var
  frm_template: Tfrm_template;

implementation

{$R *.lfm}

{ Tfrm_template }

procedure Tfrm_template.FormShow(Sender: TObject);
var
  err : string;
begin

  //testing jika terjadi Error koneksi OK
  if not Conn_db(c_db,'laz') then
     begin
       ShowMessage('Error '+Logg_error);
       frm_template.Close;
     end;
  baru;
  //state dataset aktif
  lbl_dsstate.Caption:=showstatedataset(sds_pod);
end;

procedure Tfrm_template.sds_podCalcFields(DataSet: TDataSet);
begin
    sds_pod.FieldByName('tpod_total_price').AsInteger:= (sds_pod.FieldByName('tpod_quantity').AsInteger* sds_pod.FieldByName('tpod_price').AsInteger)+ sds_pod.FieldByName('tpod_tax_1').AsInteger;
end;

procedure Tfrm_template.Button1Click(Sender: TObject);
begin
  sds_poh.ApplyUpdates;
end;

procedure Tfrm_template.ed_store_idKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
var
  FrmLov:TFrmLov;
  vSqlForms:string;
  LValues: TStringList;
  ed_store_idPos:TPoint;
begin
  FrmLov         := TFrmLov.Create(Self);
  Case Key of
    VK_RETURN:
    begin
      if (Sender=dbg_pod) then
         begin

          null;
         end
      else
      begin
        SelectNext(ActiveControl,True,True);
      end;
    end;
    VK_F2:
    begin
      if (sender=ed_store_id) then
      begin
        ed_store_idPos := ed_store_id.ClientToScreen(Point(0, 0));

        try
          vSqlForms :='Select msf_id,ms_descp from '+SetVarGlobal.Db1  +'.ms_forms ';

          FrmLov.Caption :='Lov Master Unit Usaha';
          FrmLov.SqlLov  := vSqlForms;
          FrmLov.SetJudulLov :='Judul Lov;Id Forms;150;L;Desc;300;L';
          FrmLov.Left    := ed_store_idPos.X;
          FrmLov.Top     := ed_store_idPos.Y ;//+ ed_store_idPos.height;
          FrmLov.ShowModal;
          LValues:=FrmLov.LovSelectedValues;

          if LValues.count=0 then
             ShowMessage('LOV tidak ada yang di pilih');

          ShowMessage('bug');

          ed_store_id.Text   :=LValues[0];
          ed_store_name.Text :=LValues[1];;
        finally
          FrmLov.Free;
        end;

      end;
    end;
  end;
end;

procedure Tfrm_template.sds_podNewRecord(DataSet: TDataSet);
begin
  sds_pod.FieldByName('tpod_id').AsString:=libdata.get_pk;
  sds_pod.FieldByName('tpod_tpoh_id').AsString:=sds_poh.FieldByName('tpoh_id').AsString;
end;


{
tpoh_id INT PRIMARY KEY,
   tpoh_bu_id INT,
   tpoh_number VARCHAR(10),
   tpoh_supplier_id INT,
   tpoh_order_date DATE,
   tpoh_order_arrival_date DATE,
   tpoh_top_id VARCHAR(1),
   tpoh_total_amount DECIMAL(10, 2),
   tpoh_status VARCHAR(255),
   tpoh_created_by VARCHAR(50),
   tpoh_created_date DATE,
   tpoh_updated_by VARCHAR(50),
   tpoh_updated_date DATE
}

procedure Tfrm_template.baru;
begin

  sds_poh.Active:=False;
  sds_poh.SQL.Text:='select * from laz.tr_purchase_order_head ';
  sds_poh.Active:=True;
  sds_poh.Append;
  sds_poh.FieldByName('tpoh_id').AsString:= libdata.get_pk;

  sds_pod.Active:=False ;
  sds_pod.SQL.Text:='Select * from laz.tr_purchase_order_details where tpod_tpoh_id="'+sds_poh.FieldByName('tpoh_id').AsString+'"';
  sds_pod.Active:=True;

end;

function Tfrm_template.showstatedataset(dataset: TDataSet): string;
begin
  if dataset.State = dsInactive then
    begin
      Result := 'Dataset tidak aktif.';
    end
    else if dataset.State = dsBrowse then
    begin
      Result := 'Dataset dalam mode tampilan data.';
    end
    else if dataset.State = dsEdit then
    begin
      Result := 'Dataset dalam mode edit.';
    end
    else if dataset.State = dsInsert then
    begin
      Result := 'Dataset dalam mode input (insert).';
    end
    else
    begin
      Result := 'Status dataset tidak dikenali.';
    end;
end;


end.

