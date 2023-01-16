program AppMercado;

uses
  System.StartUpCopy,
  FMX.Forms,
  UnitLogin in 'UnitLogin.pas' {FrmLogin},
  UnitPrincipal in 'UnitPrincipal.pas' {FrmPrincipal},
  UnitMercado in 'UnitMercado.pas' {FrmMercado},
  Frame.ProdutoCard in 'frames\Frame.ProdutoCard.pas' {FrameProdutoCard: TFrame},
  UnitSplash in 'UnitSplash.pas' {FrmSplash},
  UnitProduto in 'UnitProduto.pas' {FrmProduto};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TFrmPrincipal, FrmPrincipal);
  Application.CreateForm(TFrmMercado, FrmMercado);
  Application.CreateForm(TFrmSplash, FrmSplash);
  Application.CreateForm(TFrmProduto, FrmProduto);
  Application.Run;
end.
