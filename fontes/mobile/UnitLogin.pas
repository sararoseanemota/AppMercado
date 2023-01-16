unit UnitLogin;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.TabControl,
  FMX.StdCtrls, FMX.Edit, FMX.Controls.Presentation, FMX.Layouts, FMX.Objects;

type
  TFrmLogin = class(TForm)
    TabControl: TTabControl;
    TabILogin: TTabItem;
    TabConta1: TTabItem;
    TabConta2: TTabItem;
    imgLogo: TImage;
    lytLogin: TLayout;
    lblAcessar: TLabel;
    edtLoginEmail: TEdit;
    edtLoginSenha: TEdit;
    btnAcessar: TButton;
    lblCrieAgora: TLabel;
    imgConta1Login: TImage;
    lytConta1: TLayout;
    lblCriarNovaConta: TLabel;
    btnProximo: TButton;
    lblConta1: TLabel;
    lblPasso1: TLabel;
    imgConta2Logo: TImage;
    lytConta2: TLayout;
    lblCriarConta2: TLabel;
    btnCriarConta: TButton;
    lblPasso2: TLabel;
    lblConta2: TLabel;
    ltyConta2: TLayout;
    rctLoginEmail: TRectangle;
    rctLoginSenha: TRectangle;
    StyleBook1: TStyleBook;
    rctConta1Nome: TRectangle;
    edtNome: TEdit;
    rctConta1Senha: TRectangle;
    edtConta1Senha: TEdit;
    rctConta1Email: TRectangle;
    edtContaEmail: TEdit;
    rctCep: TRectangle;
    edtCep: TEdit;
    rctEndereco: TRectangle;
    edtEndereco: TEdit;
    rctNumero: TRectangle;
    edtNumero: TEdit;
    rctBairro: TRectangle;
    edtBairro: TEdit;
    rctUf: TRectangle;
    edtUF: TEdit;
    rctCidade: TRectangle;
    edtCidade: TEdit;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FrmLogin: TFrmLogin;

implementation

{$R *.fmx}

end.
