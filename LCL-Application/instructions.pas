unit instructions;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls;

type

  { TfrmInstructions }

  TfrmInstructions = class(TForm)
    btnOK: TButton;
    Memo1: TMemo;
  private

  public

  end;

var
  frmInstructions: TfrmInstructions;

implementation

{$R *.lfm}

end.

