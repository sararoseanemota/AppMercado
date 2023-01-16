unit UnitMercado;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Objects,
  FMX.Controls.Presentation, FMX.StdCtrls, FMX.Layouts, FMX.Edit, FMX.ListBox;

type
  TFrmMercado = class(TForm)
    lytToolBar: TLayout;
    lblTitulo: TLabel;
    imgVoltar: TImage;
    imgCarrinho: TImage;
    lytPesquisa: TLayout;
    rctPesquisa: TRectangle;
    edtPesquisa: TEdit;
    Image3: TImage;
    btnBuscar: TButton;
    lytEndereco: TLayout;
    lblEndereco: TLabel;
    imgEntrega: TImage;
    imgCompraMin: TImage;
    lblEntrega: TLabel;
    lblPedMin: TLabel;
    lbCategoria: TListBox;
    ListBoxItem1: TListBoxItem;
    rctCategoria: TRectangle;
    lblCategoria: TLabel;
    ListBoxItem2: TListBoxItem;
    Rectangle2: TRectangle;
    lblBebidas: TLabel;
    lbProdutos: TListBox;
    procedure FormShow(Sender: TObject);
    procedure lbCategoriaItemClick(const Sender: TCustomListBox;
      const Item: TListBoxItem);
    procedure lbProdutosItemClick(const Sender: TCustomListBox;
      const Item: TListBoxItem);
  private
    procedure AddProduto(id_produto: integer; descricao, unidade: string;
      valor: double);
    procedure ListarProdutos;
    procedure ListarCategorias;
    procedure AddCategoria(id_categoria: integer; descricao: string);
    procedure SelecionarCategoria(item: TListBoxItem);
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FrmMercado: TFrmMercado;

implementation

{$R *.fmx}

uses UnitPrincipal, Frame.ProdutoCard, UnitProduto;

procedure TFrmMercado.AddProduto(id_produto: integer; descricao, unidade: string; valor : double);
var
  item : TListBoxItem;
  frame : TFrameProdutoCard;
begin
  item := TListBoxItem.Create(lbProdutos); //instancia novo item em branco
  item.Selectable := false; // n�o deixar cinza ao selecionar
  item.Text := ''; //texto do item vazio
  item.Height := 180;
  item.Tag := id_produto;

  //frame
  frame := TframeProdutoCard.Create(item);
  //frame.imgFoto.bitmap :=
  frame.lblDescricao.text := descricao;
  frame.lblValor.text := FormatFloat('R$#,##0.00', valor);
  frame.lblUnidade.text := unidade;

  item.AddObject(frame);

  //adicionando itens na lista de produtos
  lbProdutos.AddObject(item);
end;

//consultar os produtos no banco
procedure TFrmMercado.ListarProdutos;
begin
  AddProduto(0, 'Melancia', 'Pre�o por Kg, unidade', 3);
  AddProduto(0, 'Melancia', 'Pre�o por Kg, unidade', 3);
  AddProduto(0, 'Melancia', 'Pre�o por Kg, unidade', 3);
  AddProduto(0, 'Melancia', 'Pre�o por Kg, unidade', 3);
  AddProduto(0, 'Melancia', 'Pre�o por Kg, unidade', 3);
  AddProduto(0, 'Melancia', 'Pre�o por Kg, unidade', 3);

end;

procedure TFrmMercado.SelecionarCategoria(item : TListBoxItem);
var
  x: integer;
  item_loop : TListBoxItem;
  rect : TRectangle;
  lbl : TLabel;
begin
  //zerar os itens
  for x := 0 to lbCategoria.Items.Count - 1 do
  begin
    item_loop := lbCategoria.ItemByIndex(x);

    rect := TRectangle(item_loop.Components[0]);
    rect.Fill.Color :=  $FFDADADA;

    lbl := TLabel(rect.Components[0]);
    lbl.FontColor := $FF565656;
  end;

  //ajustar somente item selecionado
  rect := TRectangle(item.Components[0]);
  rect.Fill.Color :=  $FF76B947;

  lbl := TLabel(rect.Components[0]);
  lbl.FontColor := $FFFFFFFF;

  //Salvar a categoria selecionada
  lbCategoria.tag := item.Tag;
end;

procedure TFrmMercado.AddCategoria(id_categoria : integer; descricao : string);
var
  item : TListBoxItem;
  rect : TRectangle;
  lbl : TLabel;
begin
  item := TListBoxItem.Create(lbProdutos); //instancia novo item em branco
  item.Selectable := false; // n�o deixar cinza ao selecionar
  item.Text := ''; //texto do item
  item.Width := 121;
  item.Tag := id_categoria;

  rect := TRectangle.Create(item);
  rect.Cursor := crHandPoint;  //cursor m�o
  rect.HitTest := false; // n�o clicar
  rect.Fill.Color :=  $FFDADADA; //cor do retangulo
  rect.Align := TAlignLayout.Client; //alinhando o retangulo
  //margins
  rect.Margins.Top := 8;
  rect.Margins.Bottom := 8;
  rect.Margins.Right := 8;
  rect.Margins.Left := 8;
  rect.XRadius := 20;
  rect.YRadius := 20;
  rect.Stroke.Kind := TBrushKind.None;

  //ajustando a label
  lbl := TLabel.Create(rect);
  lbl.Align := TAlignLayout.Client;
  lbl.Text := descricao;
  lbl.TextSettings.HorzAlign := TTextAlign.Center;
  lbl.TextSettings.VertAlign := TTextAlign.Center;

  //removendo configura��o do style texto
  lbl.StyledSettings := lbl.StyledSettings - [TStyledSetting.Size, TStyledSetting.FontColor, TStyledSetting.Style, TStyledSetting.Other];
  lbl.Font.Size := 13;
  lbl.FontColor := $FF565656;

  rect.AddObject(lbl); // adicionando a lbl no retangulo
  item.AddObject(rect); //adicionando retangulo na categoria
  lbCategoria.AddObject(item); //adicionando a categoria na lista
end;

procedure TFrmMercado.ListarCategorias;
begin
  //limpando os itens
  lbCategoria.Items.clear;

  //adicionando as categorias
  AddCategoria (0, 'Alimentos');
  AddCategoria (1, 'Bebidas');
  AddCategoria (2, 'Limpeza');
  AddCategoria (3, 'Eletr�nicos');
  AddCategoria (4, 'Inform�tica');

  //carregar listagem dos produtos
  ListarProdutos;
end;

procedure TFrmMercado.FormShow(Sender: TObject);
begin
  ListarCategorias;
end;

procedure TFrmMercado.lbCategoriaItemClick(const Sender: TCustomListBox;
  const Item: TListBoxItem);
begin
  SelecionarCategoria(Item);
end;

procedure TFrmMercado.lbProdutosItemClick(const Sender: TCustomListBox;
  const Item: TListBoxItem);
begin
   if NOT Assigned(FrmProduto) then
    Application.CreateForm(TFrmProduto, FrmProduto);

    FrmProduto.Show;
end;

end.
