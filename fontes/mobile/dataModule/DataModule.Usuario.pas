unit DataModule.Usuario;

interface

uses
  System.SysUtils, System.Classes, FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf,
  FireDAC.DApt.Intf, Data.DB, FireDAC.Comp.DataSet, FireDAC.Comp.Client,
  DataSet.Serialize.Config, RESTRequest4D, System.JSON;

type
  TDmUsuario = class(TDataModule)
    TabUsuario: TFDMemTable;
    procedure DataModuleCreate(Sender: TObject);
  private
  
  public
    procedure Login(email, senha: string);
    procedure CriarConta(nome, email, senha, endereco, bairro, cidade, uf,
      cep: string);

  end;

var
  DmUsuario: TDmUsuario;

implementation

{%CLASSGROUP 'FMX.Controls.TControl'}

{$R *.dfm}

const
    USER_NAME = 'nutrifit';
    PASSWORD = '123456';
    BASE_URL = 'http://localhost:3000';

procedure TDmUsuario.DataModuleCreate(Sender: TObject);
begin
  //TDataSetSerializeConfig.GetInstance.CaseNameDefinition := TCaseNameDefinition.cndLowerCamelCase;
  TDataSetSerializeConfig.GetInstance.CaseNameDefinition := cndLower;
end;

// login
procedure TDmUsuario.Login(email, senha: string);
var
  resp: IResponse;
  json: TJSONObject;
begin
  try
    json := TJSONObject.Create; //instaciar
    json.AddPair('email', email); //corpo da requisição
    json.AddPair('senha', senha); //corpo da requisição

    //resposta
    resp := TRequest.New.BaseURL(BASE_URL)
            .Resource('usuarios/login')
            .DataSetAdapter(TabUsuario)
            .AddBody(json.ToJSON)
            .Accept('application/json')
            .BasicAuthentication(USER_NAME, PASSWORD)
            .Post;
    if (resp.StatusCode = 401) then
        raise Exception.Create('E-mail ou senha inválida')
    else if (resp.StatusCode <> 200) then
        raise Exception.Create(resp.Content);
  finally
    json.DisposeOf; //destruindo o objeto json
  end;

end;

//criar conta
procedure TDmUsuario.CriarConta(nome, email, senha, endereco, bairro, cidade, uf, cep: string);
var
  resp: IResponse;
  json: TJSONObject;
begin
  try
    json := TJSONObject.Create; //instaciar
    json.AddPair('nome', nome);  //corpo da requisição
    json.AddPair('email', email); 
    json.AddPair('senha', senha); 
    json.AddPair('endereco', endereco);
    json.AddPair('bairro', bairro);  
    json.AddPair('cidade', cidade); 
    json.AddPair('uf ', uf);
    json.AddPair('cep', cep);  

    //resposta
    resp := TRequest.New.BaseURL(BASE_URL)  // requisição
            .Resource('usuarios/cadastro') //rota
            .DataSetAdapter(TabUsuario)
            .AddBody(json.ToJSON) //adicionar o json no corpo da requisicao
            .Accept('application/json')
            .BasicAuthentication(USER_NAME, PASSWORD)//autenticação
            .Post;
    if (resp.StatusCode = 401) then
        raise Exception.Create('Usuário não autorizado')
    else if (resp.StatusCode <> 201) then
        raise Exception.Create(resp.Content);
  finally
    json.DisposeOf; //destruindo o objeto json
  end;

end;
end.
