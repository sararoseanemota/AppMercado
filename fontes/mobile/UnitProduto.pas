unit UnitProduto;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Objects,
  FMX.Controls.Presentation, FMX.StdCtrls, FMX.Layouts,
  System.Net.HttpClientComponent, System.Net.HttpClient, uLoading;

type
  TFrmProduto = class(TForm)
    lytToolBar: TLayout;
    lblTitulo: TLabel;
    imgVoltar: TImage;
    lytFoto: TLayout;
    imgFoto: TImage;
    lblNome: TLabel;
    lblInformacao: TLabel;
    lytPreco: TLayout;
    lblValor: TLabel;
    rctBottom: TRectangle;
    lytAdicionar: TLayout;
    imgMenos: TImage;
    imgMais: TImage;
    lblQtd: TLabel;
    btnAdicionar: TButton;
    lytFundo: TLayout;
    lytDescricao: TLayout;
    lblDescricao: TLabel;
    lyt1: TLayout;
    Layout1: TLayout;
    lblUnidade: TLabel;
    procedure FormResize(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure lblUnidade1Click(Sender: TObject);
  private
    FId_produto: Integer;
    procedure LoadImageFromURL(img: TBitmap; url: string);
    procedure CarregarDados;
    procedure ThreadDadosTerminate(Sender: TObject);
    { Private declarations }
  public
    { Public declarations }
  property Id_produto : Integer read FId_produto write FId_produto;
  end;

var
  FrmProduto: TFrmProduto;

implementation

{$R *.fmx}

uses UnitPrincipal, DataModule.Mercado;

procedure TFrmProduto.CarregarDados;
begin
  var
  t : TThread;
  begin
    TLoading.Show(FrmProduto, '');
    t := TThread.CreateAnonymousThread(procedure
    var
    i : integer;
    begin
//    Sleep(3000); //teste do loading

    //buscando os dados do produto
    DmMercado.ListarProdutoId(Id_produto);

      with DmMercado.TabProdDetalhe do
      begin
      //thread paralela
      TThread.Synchronize(TThread.CurrentThread, procedure
        begin
           lblNome.Text := FieldByName('nome').AsString;
           lblUnidade.Text := fieldbyname('unidade').asstring;
           lblValor.Text := FormatFloat(' R$#,##0.00', fieldbyname('preco').asfloat);
           lblDescricao.Text := fieldbyname('descricao').asstring;

        end);
      end;
  end);

    t.OnTerminate := ThreadDadosTerminate; //rotina de erro
    t.Start;
  end;
end;

//thread terminate dados
procedure TFrmProduto.ThreadDadosTerminate(Sender: TObject);
begin
  TLoading.Hide; //parar de exibir a bolinha executando

  if Sender is TThread then
  begin
    if Assigned(TThread(Sender).FatalException) then
    begin
        ShowMessage(Exception(TThread(sender).FatalException).Message);
        Exit;
    end;
  end;

   //carregar foto do produto

end;

procedure TFrmProduto.FormShow(Sender: TObject);
begin
   CarregarDados;
end;


procedure TFrmProduto.lblUnidade1Click(Sender: TObject);
begin

end;

//dowloand pela URL
procedure TFrmProduto.LoadImageFromURL (img: TBitmap; url : string);
var
  http: TNetHttpClient;
  vStream : TMemoryStream;
begin
  try
    try
      http := TNetHTTPClient.Create(nil);
      vStream := TMemoryStream.Create;

      if (Pos('https', LowerCase(url)) > 0) then
        HTTP.SecureProtocols := [THTTPSecureProtocol.TLS1,
                                 THTTPSecureProtocol.TLS11,
                                 THTTPSecureProtocol.TLS12];
     http.Get(url, vStream);
     vStream.Position :=0;

     img.LoadFromStream(vStream);

    except
    end;

  finally
    vStream.DisposeOf;
    http.DisposeOf;
  end;
end;

procedure TFrmProduto.FormResize(Sender: TObject);
begin
  if (FrmProduto.Width > 600) and (FrmProduto.Height > 600) then
  begin
      lytFundo.Align := TAlignLayout.Center;
      lytFundo.Height := 350;
  end
  else
      lytFundo.Align := TAlignLayout.Client;
end;


end.
