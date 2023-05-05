program AppMercado;

uses
  System.StartUpCopy,
  FMX.Forms,
  UnitLogin in 'UnitLogin.pas' {FrmLogin},
  UnitPrincipal in 'UnitPrincipal.pas' {FrmPrincipal},
  UnitMercado in 'UnitMercado.pas' {FrmMercado},
  Frame.ProdutoCard in 'frames\Frame.ProdutoCard.pas' {FrameProdutoCard: TFrame},
  UnitSplash in 'UnitSplash.pas' {FrmSplash},
  UnitProduto in 'UnitProduto.pas' {FrmProduto},
  UnitCarrinho in 'UnitCarrinho.pas' {FrmCarrinho},
  Fram.ProdutoLista in 'frames\Fram.ProdutoLista.pas' {FrameProdutoLista: TFrame},
  UnitPedido in 'UnitPedido.pas' {FrmPedidos},
  UnitPedidoDetalhe in 'UnitPedidoDetalhe.pas' {FrmPedidoDetalhe},
  DataModule.Usuario in 'dataModule\DataModule.Usuario.pas' {DmUsuario: TDataModule},
  uLoading in 'Units\uLoading.pas',
  DataModule.Mercado in 'dataModule\DataModule.Mercado.pas' {DmMercado: TDataModule},
  uConsts in 'Units\uConsts.pas',
  uFunctions in 'Units\uFunctions.pas',
  UnitInstala in 'D:\AppMonitorInstalador\fontes\mobile\UnitInstala.pas' {FrmInstala},
  uSession in 'Units\uSession.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TDmUsuario, DmUsuario);
  Application.CreateForm(TDmMercado, DmMercado);
  Application.CreateForm(TFrmLogin, FrmLogin);
  Application.Run;
end.
