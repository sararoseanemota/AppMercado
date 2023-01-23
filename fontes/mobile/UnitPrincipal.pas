unit UnitPrincipal;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Objects,
  FMX.Layouts, FMX.Controls.Presentation, FMX.StdCtrls, FMX.Edit,
  FMX.ListView.Types, FMX.ListView.Appearances, FMX.ListView.Adapters.Base,
  FMX.ListView, FMX.Ani;

type
  TFrmPrincipal = class(TForm)
    lytToolBar: TLayout;
    imgMenu: TImage;
    ImgCarrinho: TImage;
    lblAcessar: TLabel;
    lytPesquisa: TLayout;
    StyleBook: TStyleBook;
    rctPesquisa: TRectangle;
    edtPesquisa: TEdit;
    Image3: TImage;
    btnBuscar: TButton;
    lytSwitch: TLayout;
    rcSwitch: TRectangle;
    rctSelecao: TRectangle;
    lblCasa: TLabel;
    lblRetira: TLabel;
    lvMercado: TListView;
    imgShop: TImage;
    ImgTaxa: TImage;
    ImgPedidoMinimo: TImage;
    AnimationFiltro: TFloatAnimation;
    rectMenu: TRectangle;
    imgPerfil: TImage;
    imgVoltarMenu: TImage;
    lblNome: TLabel;
    lblEmail: TLabel;
    rctMeusPedidos: TRectangle;
    lblMeusPedidos: TLabel;
    rctPerfil: TRectangle;
    lblPerfil: TLabel;
    rctSair: TRectangle;
    lblSair: TLabel;
    procedure FormShow(Sender: TObject);
    procedure lvMercadoItemClick(const Sender: TObject;
      const AItem: TListViewItem);
    procedure lblCasaClick(Sender: TObject);
    procedure ImgCarrinhoClick(Sender: TObject);
    procedure imgMenuClick(Sender: TObject);
    procedure imgVoltarMenuClick(Sender: TObject);
    procedure rctMeusPedidosClick(Sender: TObject);

  private
    procedure AddMercadoLv(id_mercado: integer; nome, endereco: string;
      tx_entrega, vl_min_ped: double);
    procedure ListarMercados;
    procedure SelecionarEntrega(lbl: Tlabel);
    procedure OpenMenu(ind: Boolean);
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FrmPrincipal: TFrmPrincipal;

implementation

{$R *.fmx}

uses UnitMercado, UnitCarrinho, UnitPedido;

//list view
procedure TFrmPrincipal.AddMercadoLv(id_mercado : integer;
                                      nome, endereco : string;
                                      tx_entrega, vl_min_ped: double);
var
  img : TListItemImage;
  txt : TListItemText;
begin
  with lvMercado.Items.Add do
  begin
    Height := 120;

    Tag :=  id_mercado; //propriedade para salvar informações do tipo inteiro

    img :=  TListItemImage(Objects.FindDrawable('imgShop'));
    img.Bitmap := imgShop.Bitmap;   // objeto fixo no form

    img :=  TListItemImage(Objects.FindDrawable('imgTaxa'));
    img.Bitmap := ImgTaxa.Bitmap;   // objeto fixo no form

    img :=  TListItemImage(Objects.FindDrawable('imgCompraMin'));
    img.Bitmap := ImgPedidoMinimo.Bitmap;   // objeto fixo no form

    txt:= TListItemText(Objects.FindDrawable('txtNome'));
    txt.Text := nome;

    txt:= TListItemText(Objects.FindDrawable('txtEndereco'));
    txt.Text := endereco;

    txt:= TListItemText(Objects.FindDrawable('txtTaxa'));
    txt.Text := 'Taxa de entrega: ' + FormatFloat('R$#,##0.00', tx_entrega);

    txt:= TListItemText(Objects.FindDrawable('txtCompraMin'));
    txt.Text := 'Compra mínima: ' + FormatFloat('R$#,##0.00', vl_min_ped);

  end;

end;


//array
procedure TFrmPrincipal.ListarMercados;
begin
  AddMercadoLv(1, 'Pão de Açúcar', 'CNB 7, lote 02, lojas 01-10', 10, 50);
  AddMercadoLv(1, 'Pão de Açúcar', 'CNB 7, lote 02, lojas 01-10', 10, 50);
  AddMercadoLv(1, 'Pão de Açúcar', 'CNB 7, lote 02, lojas 01-10', 10, 50);
  AddMercadoLv(1, 'Pão de Açúcar', 'CNB 7, lote 02, lojas 01-10', 10, 50);
end;

procedure TFrmPrincipal.lvMercadoItemClick(const Sender: TObject;
  const AItem: TListViewItem);
begin
  if NOT Assigned(FrmMercado) then
      Application.CreateForm(TFrmMercado, FrmMercado);

  FrmMercado.Show;

end;

procedure TFrmPrincipal.FormShow(Sender: TObject);
begin
  ListarMercados;
end;

//clicando na imagem carrinho e carregando o form Carrinho
procedure TFrmPrincipal.ImgCarrinhoClick(Sender: TObject);
begin
  if not Assigned(FrmCarrinho) then
    Application.CreateForm(TFrmCarrinho, FrmCarrinho);

  FrmCarrinho.Show;
end;

procedure TFrmPrincipal.OpenMenu(ind : Boolean);
begin
  rectMenu.Visible := ind;
end;

procedure TFrmPrincipal.rctMeusPedidosClick(Sender: TObject);
begin
  // ao clicar no menu Meus Pedidos
  if NOT Assigned(FrmPedidos) then
    Application.CreateForm(TFrmPedidos, FrmPedidos);
  OpenMenu(false);   //fechando o menu
  FrmPedidos.Show;   //exibir formulário
end;

procedure TFrmPrincipal.imgMenuClick(Sender: TObject);
begin
  OpenMenu(true);
end;

procedure TFrmPrincipal.imgVoltarMenuClick(Sender: TObject);
begin
  OpenMenu(false);
end;

procedure TFrmPrincipal.SelecionarEntrega(lbl : Tlabel);
begin
  lblCasa.FontColor := $FF747474;
  lblRetira.FontColor := $FF747474;

  lbl.FontColor := $FFFFFFFF;

  AnimationFiltro.StopValue := lbl.Position.X; //posicao final da animação
  AnimationFiltro.Start;


end;

procedure TFrmPrincipal.lblCasaClick(Sender: TObject);
begin
  SelecionarEntrega(TLabel(Sender));
end;

end.
