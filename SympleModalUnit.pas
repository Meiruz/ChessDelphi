unit SympleModalUnit;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Global;

type
  TSympleModalForm = class(TForm)
    ContentLabel: TLabel;
    procedure FormShow(Sender: TObject);
  public
    title, content: string;
  end;

var
  SympleModalForm: TSympleModalForm;

procedure OpenSympleModal(parent: TForm; const formTitle, formContent: string);

implementation

{$R *.dfm}

procedure TSympleModalForm.FormShow(Sender: TObject);
begin
    Self.Caption := Title;

    ContentLabel.Caption := Content;
    ContentLabel.Width := Self.Width - 100;
    CenterLabelOnScreen(Self, ContentLabel);

    Self.Height := ContentLabel.Height + 150;
end;

procedure OpenSympleModal(parent: TForm; const formTitle, formContent: string);
begin
    with TSympleModalForm.Create(Parent) do
        try
            title := formTitle;
            content := formContent;
            ShowModal;
        finally
            Free;
        end;
end;

end.
