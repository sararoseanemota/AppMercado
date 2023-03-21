unit UnitCarrinho;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Objects,
  FMX.Controls.Presentation, FMX.StdCtrls, FMX.Layouts, FMX.ListBox, uFunctions,
  System.JSON,uLoading;

type
  TFrmCarrinho = class(TForm)
    lytToolBar: TLayout;
    lblTitulo: TLabel;
    imgVoltar: TImage;
    lytEndereco: TLayout;
    lblNome: TLabel;
    lblEndereco: TLabel;
    btnFinalizarPedido: TButton;
    rctngl: TRectangle;
    lytSubTotal: TLayout;
    lblSubTotal: TLabel;
    lblSubTotalValor: TLabel;
    lytTaxa: TLayout;
    lblTaxa: TLabel;
    lblTaxaEntrega: TLabel;
    lytTotal: TLayout;
    lblTotal: TLabel;
    lblTotalValor: TLabel;
    lblEndEntrega1: TLabel;
    lblEndEntrega: TLabel;
    lbProdutos: TListBox;
    ln1: TLine;
    procedure FormShow(Sender: TObject);
    procedure imgVoltarClick(Sender: TObject);
    procedure btnFinalizarPedidoClick(Sender: TObject);
  private
    procedure AddProduto(id_produto: integer; descricao, url_foto: string;
                                 qtd, valor_unit : double);
    procedure CarregarCarrinho;
    procedure DownloadFoto(lb: TListBox);
    procedure ThreadPedidoTerminate(Sender: TObject);
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FrmCarrinho: TFrmCarrinho;

implementation
{$R *.fmx}

uses
  UnitPrincipal, Fram.ProdutoLista, DataModule.Mercado, DataModule.Usuario;


//baixar imagens
procedure TFrmCarrinho.DownloadFoto(lb: TListBox);
var
    t: TThread;
    frame : TFrameProdutoLista;
begin
  //carregar imagens
  t := TThread.CreateAnonymousThread(procedure
  var
  i : Integer;
  begin
    for i := 0 to lb.Items.Count - 1 do
    begin
      //Sleep(500);
      frame := TFrameProdutoLista(lb.ItemByIndex(i).Components[0]); //metodo para procurar pelo index o objeto

      if frame.imgFoto.TagString <>  '' then
        LoadImageFromURL(frame.imgFoto.Bitmap, frame.imgFoto.TagString);
    end;
  end);

  t.Start; //iniciar a thread
end;

//rotina adicionar produtos
procedure TFrmCarrinho.AddProduto(id_produto: integer; descricao, url_foto: string;
                                 qtd, valor_unit : double);
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
  frame.imgFoto.TagString := url_foto;
  frame.lblDescricao.text := descricao;
  frame.lblQtd.text := qtd.ToString + ' x ' + FormatFloat('R$#,##0.00', valor_unit);
  frame.lblValor.text := FormatFloat('R$#,##0.00', qtd * valor_unit);

  item.AddObject(frame);

  //adicionando itens na lista de produtos
  lbProdutos.AddObject(item);
end;

procedure TFrmCarrinho.ThreadPedidoTerminate(Sender: TObject);
begin
  TLoading.Hide;

  if Sender is TThread then
  begin
    if Assigned(TThread(Sender).FatalException) then
    begin
        ShowMessage(Exception(TThread(sender).FatalException).Message);
        Exit;
    end;
  end;

  DmMercado.LimparCarrinhoLocal;
  Close;

end;

//finalizar pedido
procedure TFrmCarrinho.btnFinalizarPedidoClick(Sender: TObject);
var
  t : tthread;
  jsonPedido : TjsonObject;
  arrayItem : TJSONArray;

begin
  Tloading.Show(FrmCarrinho, '');
  t := TThread.CreateAnonymousThread(procedure
  begin
    jsonPedido := DmMercado.JsonPedido;
  end);
  t.OnTerminate := ThreadPedidoTerminate;
  t.Start;

end;

//inserindo produtos
procedure TFrmCarrinho.CarregarCarrinho;
var
  subtotal: double;
begin
  try
    DmMercado.ListarCarrinhoLocal;
    DmMercado.ListarItemCarrinhoLocal;
    DmUsuario.ListarUsuarioLocal;

    //dados mercado
    lblNome.Text := DmMercado.QryCarrinho.FieldByName('NOME_MERCADO').AsString;
    lblEndereco.Text := DmMercado.QryCarrinho.FieldByName('ENDERECO_MERCADO').AsString;
    lblTaxaEntrega.Text := FormatFloat('R$ #,##0.00', DmMercado.QryCarrinho.FieldByName('TAXA_ENTREGA').AsFloat);
    lblTaxaEntrega.TagFloat := DmMercado.QryCarrinho.FieldByName('TAXA_ENTREGA').AsFloat;

    //dados usuario
    lblEndEntrega.Text := DmUsuario.QryUsuario.FieldByName('ENDERECO').AsString + ' - '+
                          DmUsuario.QryUsuario.FieldByName('BAIRRO').AsString +  ' - '+
                          DmUsuario.QryUsuario.FieldByName('CIDADE').AsString + ' - '+
                          DmUsuario.QryUsuario.FieldByName('UF').AsString;

    //itens do carrinho
    subtotal := 0;
    lbProdutos.Items.Clear;
    with DmMercado.QryCarrinhoItem do
    begin
      while NOT EOF do
      begin
        AddProduto(FieldByName('id_produto').AsInteger,
                  FieldByName('nome_produto').AsString,
                  FieldByName('url_foto').AsString,
                  FieldByName('qtd').AsFloat,
                  FieldByName('valor_unitario').AsFloat);

        subtotal := subtotal + FieldByName('valor_total').AsFloat;

        Next;
      end;
    end;

    lblSubTotalValor.Text := FormatFloat('R$ #,##0.00', subtotal);
    lblTotalValor.Text := FormatFloat('R$ #,##0.00', subtotal + lblTaxaEntrega.TagFloat);

    //carrega as imagens
    DownloadFoto(lbProdutos);

  except on ex:exception do
    ShowMessage('Erro ao carregar carrinho:' + ex.Message);
  end;


end;

procedure TFrmCarrinho.FormShow(Sender: TObject);
begin
  CarregarCarrinho;
end;

procedure TFrmCarrinho.imgVoltarClick(Sender: TObject);
begin
  Close;
end;

end.
