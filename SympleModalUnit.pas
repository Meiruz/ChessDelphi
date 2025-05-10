Unit SympleModalUnit;

Interface

Uses
    Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
    System.Classes, Vcl.Graphics,
    Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Global;

Type
    TSympleModalForm = Class(TForm)
        ContentLabel: TLabel;
        Procedure FormShow(Sender: TObject);
    Public
        Title, Content: String;
    End;

Var
    SympleModalForm: TSympleModalForm;

Procedure OpenSympleModal(Parent: TForm; Const FormTitle, FormContent: String);

Implementation

{$R *.dfm}

Procedure TSympleModalForm.FormShow(Sender: TObject);
Begin
    Self.Caption := Title;

    ContentLabel.Caption := Content;
    ContentLabel.Width := Self.Width - 100;
    CenterLabelOnScreen(Self, ContentLabel);

    Self.Height := ContentLabel.Height + 150;
End;

Procedure OpenSympleModal(Parent: TForm; Const FormTitle, FormContent: String);
Begin
    With TSympleModalForm.Create(Parent) Do
        Try
            Title := FormTitle;
            Content := FormContent;
            ShowModal;
        Finally
            Free;
        End;
End;

End.
