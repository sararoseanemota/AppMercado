unit DataModule.Mercado;

interface

uses
  System.SysUtils, System.Classes, FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf,
  FireDAC.DApt.Intf, Data.DB, FireDAC.Comp.DataSet, FireDAC.Comp.Client,
  RESTRequest4D, DataSet.Serialize.Config;

type
  TDmMercado = class(TDataModule)
    TabMercado: TFDMemTable;
    procedure DataModuleCreate(Sender: TObject);
  private

    { Private declarations }
  public
    { Public declarations }
    procedure ListarMercado(busca, ind_entrega, ind_retira: string);
  end;

var
  DmMercado: TDmMercado;

implementation

{%CLASSGROUP 'FMX.Controls.TControl'}

{$R *.dfm}
const
    USER_NAME = 'nutrifit';
    PASSWORD = '123456';
    BASE_URL = 'http://localhost:3000';

procedure TDmMercado.DataModuleCreate(Sender: TObject);
begin
  TDataSetSerializeConfig.GetInstance.CaseNameDefinition := cndLower;
end;

// listar mercados
procedure TDmMercado.ListarMercado(busca, ind_entrega, ind_retira: string);
var
  resp: IResponse;
begin
    //resposta
    resp := TRequest.New.BaseURL(BASE_URL)
            .Resource('mercados')
            .DataSetAdapter(TabMercado)
            .AddParam('busca', busca)
            .AddParam('ind_entrega', ind_entrega)
            .AddParam('ind_retira', ind_retira)
            .Accept('application/json')
            .BasicAuthentication(USER_NAME, PASSWORD)
            .Get;

    if (resp.StatusCode <> 200) then
        raise Exception.Create(resp.Content);
end;

end.
