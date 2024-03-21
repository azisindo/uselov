unit utemplate;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, DB, Forms, Controls, Graphics, Dialogs, ExtCtrls, RxDBGrid,
  ZConnection, ZDataset;

type

  { Tfrm_template }

  Tfrm_template = class(TForm)
    c_db: TZConnection;
    dbg_pod: TRxDBGrid;
    ds_pod: TDataSource;
    ds_poh: TDataSource;
    pnl_body: TPanel;
    pnl_bottom: TPanel;
    pnl_detail: TPanel;
    pnl_head: TPanel;
    pnl_top: TPanel;
    sds_pod: TZQuery;
    sds_poh: TZQuery;
  private

  public

  end;

var
  frm_template: Tfrm_template;

implementation

{$R *.lfm}

end.

