unit UnitCarrinho;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Objects,
  FMX.Controls.Presentation, FMX.StdCtrls, FMX.Layouts, FMX.ListBox;

type
  TFrmCarrinho = class(TForm)
    lytToolBar: TLayout;
    lblTitulo: TLabel;
    imgVoltar: TImage;
    lytEndereco: TLayout;
    lblEndereco: TLabel;
    lblEndereco1: TLabel;
    btnBuscar: TButton;
    rctngl: TRectangle;
    lytSubTotal: TLayout;
    lblSubTotal: TLabel;
    lblSubTotalValor: TLabel;
    lytTaxa: TLayout;
    lblTaxaValor: TLabel;
    lblTaxa: TLabel;
    lytTotal: TLayout;
    lblTotal: TLabel;
    lblTotalValor: TLabel;
    lblEndereco2: TLabel;
    lblEndereco11: TLabel;
    lbProdutos: TListBox;
    procedure FormShow(Sender: TObject);
  private
    procedure AddProduto(id_produto: integer; descricao: string; qtd,
      valor_unit: double; foto: TStream);
    procedure CarregarCarrinho;
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FrmCarrinho: TFrmCarrinho;

implementation
{$R *.fmx}

uses
  UnitPrincipal, Fram.ProdutoLista;

//rotina
procedure TFrmCarrinho.AddProduto(id_produto: integer; descricao: string; qtd, valor_unit : double; foto : TStream);
var
  item : TListBoxItem;
  frame : TFrameProdutoLista;
begin
  item := TListBoxItem.Create(lbProdutos); //instancia novo item em branco
  item.Selectable := false; // não deixar cinza ao selecionar
  item.Text := ''; //texto do item vazio
  item.Height := 65;
  item.Tag := id_produto;

  //frame
  frame := TFrameProdutoLista.Create(item);
  //frame.imgFoto.bitmap :=
  frame.lblDescricao.text := descricao;
  frame.lblQtd.text := qtd.ToString + 'x' + FormatFloat('R$#,##0.00', valor_unit);
  frame.lblValor.text := FormatFloat('R$#,##0.00', qtd * valor_unit);

  item.AddObject(frame);

  //adicionando itens na lista de produtos
  lbProdutos.AddObject(item);
end;

//inserindo produtos
procedure TFrmCarrinho.CarregarCarrinho;
begin
  AddProduto(0,'Melancia',1,8, nil);
  AddProduto(1,'Melancia',1,4.5, nil);
  AddProduto(2,'Melancia',1,3, nil);
  AddProduto(3,'Melancia',1,9.99, nil);
end;

procedure TFrmCarrinho.FormShow(Sender: TObject);
begin
  CarregarCarrinho;
end;

end.
