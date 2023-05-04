unit UnitPedido;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Objects,
  FMX.Controls.Presentation, FMX.StdCtrls, FMX.Layouts, FMX.ListView.Types,
  FMX.ListView.Appearances, FMX.ListView.Adapters.Base, FMX.ListView, uLoading;

type
  TFrmPedidos = class(TForm)
    lytToolBar: TLayout;
    lblTitulo: TLabel;
    w: TImage;
    lvPedido: TListView;
    imgShop: TImage;
    procedure FormShow(Sender: TObject);
    procedure lvPedidoItemClick(const Sender: TObject;
      const AItem: TListViewItem);
  private
    procedure AddPedidoLv(id_pedido, qtd_itens : integer;
                                  nome, endereco, dt_pedido : string; vl_pedido: double);
    procedure ListarPedidos;
    procedure ThreadDadosTerminate(Sender: TObject);
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FrmPedidos: TFrmPedidos;

implementation

{$R *.fmx}

uses
  UnitPrincipal, UnitPedidoDetalhe, DataModule.Usuario;

//list view
procedure TFrmPedidos.AddPedidoLv(id_pedido, qtd_itens : integer;
                                  nome, endereco, dt_pedido : string; vl_pedido: double);
var
  img : TListItemImage;
  txt : TListItemText;
begin
  with lvPedido.Items.Add do
  begin
    Height := 120;

    Tag :=  id_pedido; //propriedade para salvar informações do tipo inteiro

    img :=  TListItemImage(Objects.FindDrawable('imgShop'));
    img.Bitmap := imgShop.Bitmap;   // objeto fixo no form

    txt:= TListItemText(Objects.FindDrawable('txtNome'));
    txt.Text := nome;

    txt:= TListItemText(Objects.FindDrawable('txtPedido'));
    txt.Text := 'Pedido: ' + id_pedido.ToString;

    txt:= TListItemText(Objects.FindDrawable('txtValor'));
    txt.Text := FormatFloat('R$#,##0.00', vl_pedido) + ' - ' + qtd_itens.ToString + ' itens ';

    txt:= TListItemText(Objects.FindDrawable('txtData'));
    txt.Text := dt_pedido;
  end;

end;

{listar pedidos}
procedure TFrmPedidos.ListarPedidos;
var
  t : TThread;
begin
  TLoading.Show(FrmPedidos, '');

  t := TThread.CreateAnonymousThread(procedure
  begin
    //DmUsuario.ListarPedido();
  end);

  t.OnTerminate := ThreadDadosTerminate; //rotina de erro
  t.Start;
end;

{thread terminate dados}
procedure TFrmPedidos.ThreadDadosTerminate(Sender: TObject);
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
end;

{detalhes do pedido}
procedure TFrmPedidos.lvPedidoItemClick(const Sender: TObject;
  const AItem: TListViewItem);
begin
  if NOT Assigned(FrmPedidoDetalhe) then
    Application.CreateForm(TFrmPedidoDetalhe, FrmPedidos);

  FrmPedidoDetalhe.Show;
end;

{show}
procedure TFrmPedidos.FormShow(Sender: TObject);
begin
  ListarPedidos;
end;

end.
