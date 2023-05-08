unit UnitPedidoDetalhe;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Objects,
  FMX.Controls.Presentation, FMX.StdCtrls, FMX.Layouts, FMX.ListBox, uLoading, System.JSON, uFunctions;

type
  TFrmPedidoDetalhe = class(TForm)
    lytEndereco: TLayout;
    lblMercado: TLabel;
    lblEnderecoMercado: TLabel;
    lytToolBar: TLayout;
    lblTitulo: TLabel;
    imgVoltar: TImage;
    rctngl: TRectangle;
    lytSubTotal: TLayout;
    lblSubTotal: TLabel;
    lblSubTotalValor: TLabel;
    lytTaxa: TLayout;
    lblTaxa: TLabel;
    lblTaxaValor: TLabel;
    lytTotal: TLayout;
    lblTotal: TLabel;
    lblTotalValor: TLabel;
    lblEndereco2: TLabel;
    lblEnderecoEntrega: TLabel;
    lbProdutos: TListBox;
    rctnglEndereco: TRectangle;
    procedure FormShow(Sender: TObject);
    procedure imgVoltarClick(Sender: TObject);
  private
    FId_pedido: integer;
    procedure AddProduto(id_produto: integer; descricao, url_foto: string; qtd, valor_unit : double);
    procedure CarregarPedido;
    procedure ThreadDadosTerminate(Sender: TObject);
    procedure DownloadFoto(lb: TListBox);
    { Private declarations }
  public
    { Public declarations }
    property id_pedido: integer read FId_pedido write FId_pedido;
  end;

var
  FrmPedidoDetalhe: TFrmPedidoDetalhe;

implementation

uses
  Fram.ProdutoLista, DataModule.Usuario;

{$R *.fmx}

{baixar imagens}
procedure TFrmPedidoDetalhe.DownloadFoto(lb: TListBox);
var
  t: TThread;
  foto : Tbitmap;
  frame : TFrameProdutoLista;
begin
  //carregar imagens
  t := TThread.CreateAnonymousThread(procedure
  var
  i : Integer;
  begin
    for i := 0 to lb.Items.Count - 1 do
    begin
//      Sleep(1000);
      frame := TFrameProdutoLista(lb.ItemByIndex(i).Components[0]); //metodo para procurar pelo index o objeto

      if frame.imgFoto.TagString <>  '' then
      begin
        foto := TBitmap.Create;
        LoadImageFromURL(foto, frame.imgFoto.TagString);

        frame.imgFoto.TagString := ''; //limpar
        frame.imgFoto.Bitmap := foto;
      end;
    end;
  end);

  t.Start; //iniciar a thread
end;

{add produto}
procedure TFrmPedidoDetalhe.AddProduto(id_produto: integer; descricao, url_foto: string; qtd, valor_unit : double);
var
  item : TListBoxItem;
  frame : TFrameProdutoLista;
begin
  item := TListBoxItem.Create(lbProdutos); //instancia novo item em branco
  item.Selectable := false; // n�o deixar cinza ao selecionar
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

{carregar os pedidos}
procedure TFrmPedidoDetalhe.CarregarPedido;
var
  t : TThread;
  jsonObj: TJSONObject;
  arrayItem : TJSONArray;
begin
  TLoading.Show(FrmPedidoDetalhe, '');
  lbProdutos.Items.Clear; //limpar os itens da list box

  t := TThread.CreateAnonymousThread(procedure
  begin
    jsonObj := DmUsuario.JsonPedido(id_pedido);

    {thread paralela para sicronizar}
    TThread.Synchronize(TThread.CurrentThread, procedure
    var
      x : Integer;
    begin
      lblTitulo.Text := 'Pedido #' + jsonObj.GetValue<string>('id_pedido', '');
      lblMercado.Text := jsonObj.GetValue<string>('nome_mercado', '');
      lblEnderecoMercado.Text := jsonObj.GetValue<string>('endereco_mercado', '');
      lblSubTotalValor.Text := FormatFloat('R$ #,##0.00', jsonObj.GetValue<double>('vl_subtotal', 0));
      lblTaxaValor.Text := FormatFloat('R$ #,##0.00', jsonObj.GetValue<double>('vl_entrega', 0));
      lblTotalValor.Text := FormatFloat('R$ #,##0.00',jsonObj.GetValue<double>('vl_total', 0));
      lblEnderecoEntrega.Text := jsonObj.GetValue<string>('endereco', '');

      {itens}
      arrayItem := jsonObj.GetValue<TJSONArray>('itens');

      for x := 0 to arrayItem.Size - 1 do
      begin
          AddProduto(arrayItem.Get(x).GetValue<Integer>('id_produto',0),
                     arrayItem.Get(x).GetValue<string>('descricao',''),
                     arrayItem.Get(x).GetValue<string>('url_foto',''),
                     arrayItem.Get(x).GetValue<integer>('qtd', 0),
                     arrayItem.Get(x).GetValue<double>('vl_unitario',0));
      end;

    end);

    jsonObj.DisposeOf; //destruir objeto
  end);

  t.OnTerminate := ThreadDadosTerminate; //rotina de erro
  t.Start;
end;

{thread terminate dados}
procedure TFrmPedidoDetalhe.ThreadDadosTerminate(Sender: TObject);
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

  DownloadFoto(lbProdutos);
end;

procedure TFrmPedidoDetalhe.FormShow(Sender: TObject);
begin
  CarregarPedido;
end;
procedure TFrmPedidoDetalhe.imgVoltarClick(Sender: TObject);
begin
  Close;
end;

end.
