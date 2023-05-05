unit UnitPrincipal;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Objects,
  FMX.Layouts, FMX.Controls.Presentation, FMX.StdCtrls, FMX.Edit,
  FMX.ListView.Types, FMX.ListView.Appearances, FMX.ListView.Adapters.Base,
  FMX.ListView, FMX.Ani, uLoading;

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
    rctLogout: TRectangle;
    lblSair: TLabel;
    AnimationMenu: TFloatAnimation;
    procedure FormShow(Sender: TObject);
    procedure lvMercadoItemClick(const Sender: TObject;
      const AItem: TListViewItem);
    procedure lblCasaClick(Sender: TObject);
    procedure ImgCarrinhoClick(Sender: TObject);
    procedure imgMenuClick(Sender: TObject);
    procedure imgVoltarMenuClick(Sender: TObject);
    procedure rctMeusPedidosClick(Sender: TObject);
    procedure btnBuscarClick(Sender: TObject);
    procedure rctLogoutClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure AnimationMenuFinish(Sender: TObject);

  private
     { Private declarations }
    FInd_Retira: string;
    FInd_Entrega: string;
    procedure AddMercadoLv(id_mercado: integer; nome, endereco: string;
      tx_entrega, vl_min_ped: double);
    procedure ListarMercados;
    procedure SelecionarEntrega(lbl: Tlabel);
    procedure OpenMenu(ind: Boolean);
    procedure ThreadMercadosTerminate(Sender: TObject);

  public
    { Public declarations }
    property Ind_Entrega : string read FInd_Entrega write FInd_Entrega;
    property Ind_Retira : string read FInd_Retira write FInd_Retira;
  end;

var
  FrmPrincipal: TFrmPrincipal;

implementation

{$R *.fmx}

uses UnitMercado, UnitCarrinho, UnitPedido, DataModule.Mercado, UnitLogin,
  DataModule.Usuario;

//list view
procedure TFrmPrincipal.AddMercadoLv(id_mercado : integer; nome, endereco : string; tx_entrega, vl_min_ped: double);
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

//thread
procedure TFrmPrincipal.ThreadMercadosTerminate(Sender: TObject);
begin
  TLoading.Hide; //parar de exibir a bolinha executando
  lvMercado.EndUpdate;
  if Sender is TThread then
  begin
    if Assigned(TThread(Sender).FatalException) then
    begin
        ShowMessage(Exception(TThread(sender).FatalException).Message);
        Exit;
    end;
  end;
end;

//array listar mercados
procedure TFrmPrincipal.ListarMercados;
begin
var
  t : TThread;
begin
  TLoading.Show(FrmPrincipal, '');
  //inserir na lista
  lvMercado.Items.Clear;
  lvMercado.BeginUpdate;

  t := TThread.CreateAnonymousThread(procedure
var
  i : integer;
  begin
    //Sleep(1500); //teste do loading
    DmMercado.ListarMercado(edtPesquisa.Text, Ind_Entrega, Ind_Retira);

    //
    with DmMercado.TabMercado do
    begin
      for i := 0 to recordcount - 1 do
      begin
        //thread paralela para sicronizar
        TThread.Synchronize(TThread.CurrentThread, procedure
        begin
         AddMercadoLv(fieldbyname('id_mercado').asinteger,
                   fieldbyname('nome').asstring,
                   fieldbyname('endereco').asstring,
                   fieldbyname('vl_entrega').asfloat,
                   fieldbyname('vl_compra_min').asfloat);
        end);
        Next;
      end;
    end;
  end);

  t.OnTerminate := ThreadMercadosTerminate; //rotina de erro
  t.Start;
end;
end;

procedure TFrmPrincipal.lvMercadoItemClick(const Sender: TObject; const AItem: TListViewItem);
begin
  if NOT Assigned(FrmMercado) then
      Application.CreateForm(TFrmMercado, FrmMercado);

  FrmMercado.id_mercado := AItem.Tag;
  FrmMercado.Show;

end;

procedure TFrmPrincipal.btnBuscarClick(Sender: TObject);
begin
  ListarMercados;
end;

{close}
procedure TFrmPrincipal.FormClose(Sender: TObject; var Action: TCloseAction);
begin
//  Action:= TCloseAction.caFree;
//  FrmLogin := nil;
end;

{show}
procedure TFrmPrincipal.FormShow(Sender: TObject);
begin
  rectMenu.tag := 0;
  rectMenu.Margins.Right := rectMenu.Width + 50;
  rectMenu.Visible := False;

  SelecionarEntrega(lblCasa);
end;

{clicando na imagem carrinho e carregando o form Carrinho}
procedure TFrmPrincipal.ImgCarrinhoClick(Sender: TObject);
begin
  if not Assigned(FrmCarrinho) then
    Application.CreateForm(TFrmCarrinho, FrmCarrinho);

  FrmCarrinho.Show;
end;

{menu}
procedure TFrmPrincipal.OpenMenu(ind : Boolean);
begin
  if rectMenu.Tag = 0 then
     rectMenu.Visible := True;

//animação da tela
//  AnimationMenu.StartValue := rectMenu.Width + 50;
//  AnimationMenu.StopValue := 0;

  AnimationMenu.Start;
end;

{finalizar animação do menu}
procedure TFrmPrincipal.AnimationMenuFinish(Sender: TObject);
begin
  AnimationMenu.Inverse := not AnimationMenu.Inverse;

  if rectMenu.Tag = 1 then
  begin
    rectMenu.Tag := 0;
    rectMenu.Visible := False;
  end
  else
    rectMenu.Tag := 1;
end;

{logout}
procedure TFrmPrincipal.rctLogoutClick(Sender: TObject);
begin
  DmUsuario.Logout;

  if not Assigned(FrmLogin) then
    Application.CreateForm(TFrmLogin, FrmLogin);

  Application.MainForm := FrmLogin;
  FrmLogin.Show;
  FrmPrincipal.Close;

end;

{meus pedidos}
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

{voltar menu}
procedure TFrmPrincipal.imgVoltarMenuClick(Sender: TObject);
begin
  OpenMenu(false);
end;

{selecionar a entrega}
procedure TFrmPrincipal.SelecionarEntrega(lbl : Tlabel);
begin
  lblCasa.FontColor := $FF747474;
  lblRetira.FontColor := $FF747474;

  lbl.FontColor := $FFFFFFFF;
  Ind_Entrega :='';
  Ind_Retira := '';

  if lbl.Tag = 0 then
    ind_entrega := 'S'
  else
    ind_retira := 'S';

  ListarMercados;

  AnimationFiltro.StopValue := lbl.Position.X; //posicao final da animação
  AnimationFiltro.Start;


end;

{entrega em casa}
procedure TFrmPrincipal.lblCasaClick(Sender: TObject);
begin
  SelecionarEntrega(TLabel(Sender));
end;

end.
