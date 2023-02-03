unit UnitProduto;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Objects,
  FMX.Controls.Presentation, FMX.StdCtrls, FMX.Layouts;

type
  TFrmProduto = class(TForm)
    lytToolBar: TLayout;
    lblTitulo: TLabel;
    imgVoltar: TImage;
    lytFoto: TLayout;
    imgFoto: TImage;
    lblDescricao: TLabel;
    lblInformacao: TLabel;
    lblPreco: TLabel;
    lytPreco: TLayout;
    lblValor: TLabel;
    lytPrecoUnd: TLayout;
    lblPrecoUnd: TLabel;
    lblValorUnd: TLabel;
    rctBottom: TRectangle;
    lytAdicionar: TLayout;
    imgMenos: TImage;
    imgMais: TImage;
    lblQtd: TLabel;
    btnAdicionar: TButton;
    lytFundo: TLayout;
    procedure FormResize(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FrmProduto: TFrmProduto;

implementation

{$R *.fmx}

uses UnitPrincipal;

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

end.
