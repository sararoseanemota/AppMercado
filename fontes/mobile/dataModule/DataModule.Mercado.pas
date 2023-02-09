unit DataModule.Mercado;

interface

uses
  System.SysUtils, System.Classes, FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf,
  FireDAC.DApt.Intf, Data.DB, FireDAC.Comp.DataSet, FireDAC.Comp.Client,
  RESTRequest4D, DataSet.Serialize.Config, uConsts, FireDAC.Stan.Async,
  FireDAC.DApt;

type
  TDmMercado = class(TDataModule)
    TabMercado: TFDMemTable;
    TabCategoria: TFDMemTable;
    TabProduto: TFDMemTable;
    TabProdDetalhe: TFDMemTable;
    QryMercado: TFDQuery;
    procedure DataModuleCreate(Sender: TObject);
  private

      { Private declarations }
  public
    { Public declarations }
    procedure ListarMercado(busca, ind_entrega, ind_retira: string);
    procedure ListarMercadoId(id_mercado: integer);
    procedure ListarCategoria(id_mercado: integer);
    procedure ListarProduto(id_mercado, id_categoria : integer; busca : string);
    procedure ListarProdutoId(id_produto: integer);
    function ExistePedidoLocal(id_mercado: integer): Boolean;
  end;

var
  DmMercado: TDmMercado;

implementation

uses
  DataModule.Usuario;

{%CLASSGROUP 'FMX.Controls.TControl'}

{$R *.dfm}

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

//listar mercados
procedure TDmMercado.ListarMercadoId(id_mercado : integer);
var
  resp: IResponse;
begin
    //resposta
    resp := TRequest.New.BaseURL(BASE_URL)
            .Resource('mercados')
            .ResourceSuffix(id_mercado.ToString)
            .DataSetAdapter(TabMercado)
            .Accept('application/json')
            .BasicAuthentication(USER_NAME, PASSWORD)
            .Get;

    if (resp.StatusCode <> 200) then
        raise Exception.Create(resp.Content);
end;

//listar categoria por id
procedure TDmMercado.ListarCategoria(id_mercado : integer);
var
  resp: IResponse;
begin
    //resposta
    resp := TRequest.New.BaseURL(BASE_URL)
            .Resource('mercados')
            .ResourceSuffix(id_mercado.ToString + '/categorias')
            .DataSetAdapter(TabCategoria)
            .Accept('application/json')
            .BasicAuthentication(USER_NAME, PASSWORD)
            .Get;

    if (resp.StatusCode <> 200) then
        raise Exception.Create(resp.Content);
end;

//listar produtos
procedure TDmMercado.ListarProduto(id_mercado, id_categoria : integer; busca : string);
var
  resp: IResponse;
begin
    //resposta
    resp := TRequest.New.BaseURL(BASE_URL)
            .Resource('mercados')
            .ResourceSuffix(id_mercado.ToString + '/produtos')
            .AddParam('id_categoria', id_categoria.ToString)
            .AddParam('busca', busca)
            .DataSetAdapter(TabProduto)
            .Accept('application/json')
            .BasicAuthentication(USER_NAME, PASSWORD)
            .Get;

    if (resp.StatusCode <> 200) then
        raise Exception.Create(resp.Content);
end;

//listar produtos id
procedure TDmMercado.ListarProdutoId(id_produto : integer);
var
  resp: IResponse;
begin
    //resposta
    resp := TRequest.New.BaseURL(BASE_URL)
            .Resource('produtos')
            .ResourceSuffix(id_produto.ToString)
            .DataSetAdapter(TabProdDetalhe)
            .Accept('application/json')
            .BasicAuthentication(USER_NAME, PASSWORD)
            .Get;

    if (resp.StatusCode <> 200) then
        raise Exception.Create(resp.Content);
end;

//Pedido no carrino EXISTE
function TDmMercado.ExistePedidoLocal(id_mercado: integer) : Boolean;
begin
  with DmMercado.QryMercado do
  begin
      Active := False;
      SQL.Clear;
      SQL.Add('SELECT * FROM TAB_CARRINHO WHERE ID_MERCADO <> :ID_MERCADO');
      ParamByName('ID_MERCADO').value := id_mercado;
      Active := true;

      Result := RecordCount > 0;
  end;

end;

end.
