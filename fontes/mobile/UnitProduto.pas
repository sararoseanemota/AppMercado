unit UnitProduto;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Objects,
  FMX.Controls.Presentation, FMX.StdCtrls, FMX.Layouts,
  System.Net.HttpClientComponent, System.Net.HttpClient, uLoading,
  uFunctions, FMX.DialogService;

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
    lblDescricao: TLabel;
    lyt1: TLayout;
    lblPreco: TLabel;
    lytAdCarrinho: TLayout;
    lytInfo: TLayout;
    lblInfo: TLabel;
    lytEmb: TLayout;
    lblUnidade: TLabel;
    lblEmb: TLabel;
    lytDesc: TLayout;
    lblDesc: TLabel;
    ln1: TLine;
    procedure FormResize(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure imgVoltarClick(Sender: TObject);
    procedure imgMenosClick(Sender: TObject);
    procedure btnAdicionarClick(Sender: TObject);
    procedure ln1Click(Sender: TObject);
  private
    FId_produto: Integer;
    FId_Mercado: Integer;
    FNome_Mercado: String;
    FTaxa_entrega: Double;
    FEndereco_mercado: String;
    procedure CarregarDados;
    procedure ThreadDadosTerminate(Sender: TObject);
    procedure Opacity(op: integer);
    procedure Qtd(valor: integer);
    { Private declarations }
  public
    { Public declarations }
  property Id_produto : Integer read FId_produto write FId_produto;
  property Id_mercado : Integer read FId_Mercado write FId_Mercado;
  property Nome_mercado : String read FNome_Mercado write FNome_Mercado;
  property Endereco_mercado : String read FEndereco_mercado write FEndereco_mercado;
  property Taxa_entrega :Double read FTaxa_entrega write FTaxa_entrega;
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

//adicionar carrinho
procedure TFrmProduto.btnAdicionarClick(Sender: TObject);
begin
  //Consiste se possui pedido de outro mercado em aberto
  if DmMercado.ExistePedidoLocal(Id_mercado) then
  begin
    TDialogService.MessageDialog('Voc� s� pode adicionar itens de um mercado por vez. Deseja esvaziar a sacola e adicionar esse item?',
                  TMsgDlgType.mtConfirmation,
                  [TMsgDlgBtn.mbYes, TMsgDlgBtn.mbNo],
                  TMsgDlgBtn.mbNo,
                  0,
       procedure(const Aresult : TModalResult)
       begin
         if AResult = mrYes then
         begin
          //rotina
          DmMercado.LimparCarrinho;
          DmMercado.AdicionarCarrinho(Id_mercado, Nome_mercado, Endereco_mercado, Taxa_entrega);
          //DmMercado.AdicionarItemCarrinho;

         end;
       end);

  end;
  //else


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

procedure TFrmProduto.ln1Click(Sender: TObject);
begin

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
