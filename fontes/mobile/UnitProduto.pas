unit UnitProduto;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Objects,
  FMX.Controls.Presentation, FMX.StdCtrls, FMX.Layouts,
  System.Net.HttpClientComponent, System.Net.HttpClient, uLoading, uFunctions;

type
  TFrmProduto = class(TForm)
    lytToolBar: TLayout;
    lblTitulo: TLabel;
    imgVoltar: TImage;
    lytFoto: TLayout;
    imgFoto: TImage;
    lblNome: TLabel;
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
    lblUnidade: TLabel;
    lytAdCarrinho: TLayout;
    procedure FormResize(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure imgVoltarClick(Sender: TObject);
    procedure imgMenosClick(Sender: TObject);
  private
    FId_produto: Integer;
    procedure CarregarDados;
    procedure ThreadDadosTerminate(Sender: TObject);
    procedure Opacity(op: integer);
    procedure Qtd(valor: integer);
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

//opacidade dos componentes
procedure TFrmProduto.Opacity(op : integer);
begin
  imgFoto.Opacity := op;
  lblNome.Opacity := op;
  lblUnidade.Opacity :=op;
  lblValor.Opacity := op;
  lblDescricao.Opacity :=op;
end;

//carregar dados
procedure TFrmProduto.CarregarDados;
var
  t : TThread;
begin
  Qtd(0);
  Opacity(0);
  TLoading.Show(FrmProduto, '');

  t := TThread.CreateAnonymousThread(procedure
  begin
    //Sleep(3000); //teste do loading

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

        //carregar foto do produto
        LoadImageFromURL(imgFoto.Bitmap, fieldbyname('url_foto').asstring);

      end;
  end);

    t.OnTerminate := ThreadDadosTerminate; //rotina de erro
    t.Start;
end;

//thread terminate dados
procedure TFrmProduto.ThreadDadosTerminate(Sender: TObject);
begin
  Sleep(1500);
  TLoading.Hide; //parar de exibir a bolinha executando

  if Sender is TThread then
  begin
    if Assigned(TThread(Sender).FatalException) then
    begin
        ShowMessage(Exception(TThread(sender).FatalException).Message);
        Exit;
    end;
  end;

  Opacity(1);

end;

//carregar dados ao abrir a tela
procedure TFrmProduto.FormShow(Sender: TObject);
begin
   CarregarDados;
end;

//bot�o voltar
procedure TFrmProduto.imgVoltarClick(Sender: TObject);
begin
  close;
end;

//ajustar largura
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

//alterando a quantidade
procedure TFrmProduto.Qtd(valor : integer);
begin
  try
    if valor = 0 then
      lblQtd.Tag := 1
    else
      lblQtd.Tag := lblQtd.Tag + valor;

    if lblQtd.Tag <= 0 then
        lblQtd.Tag := 1;
  except
    lblQtd.Tag := 1;
  end;

  lblQtd.Text := FormatFloat('00', lblQtd.Tag);
end;

//menos e mais qtd
procedure TFrmProduto.imgMenosClick(Sender: TObject);
begin
  Qtd(TImage(Sender).Tag);
end;

end.
