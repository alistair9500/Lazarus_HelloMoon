unit Main;

{$mode objfpc}{$H+}

interface

// Icons made by Smashicons from www.flaticon.com
// https://www.flaticon.com/authors/smashicons

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ComCtrls, StdCtrls,
  ExtCtrls;

const
  CRLF = chr(13)+chr(10);

type

  TAdjustBurn = (abText, abTrack);

  { TfrmMain }

  TfrmMain = class(TForm)
    btnBurn: TButton;
    imgLander: TImage;
    txtFuel: TEdit;
    prgHeight: TProgressBar;
    prgFuel: TProgressBar;
    StatusBar1: TStatusBar;
    trkFuel: TTrackBar;
    procedure btnBurnClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure trkFuelChange(Sender: TObject);
    procedure txtFuelChange(Sender: TObject);
  private
    FuelBurn: integer;
    Fuel: integer;
    VelBeforeBurn: integer;
    VelAfterBurn: integer;
    llHeight: double;
    Time: integer;

    procedure Init;
    procedure ShowData;
    procedure DoCalc;
    procedure DoBurn;
    procedure ShowHeader;
    procedure NoFuelCheck;
    procedure HeightCheck;

    procedure AdjustBurn(From: TAdjustBurn);

  public

  end;

var
  frmMain: TfrmMain;

implementation

uses
  instructions;

{$R *.lfm}

{ TfrmMain }

procedure TfrmMain.FormCreate(Sender: TObject);
begin
  Init;
  ShowData;
  ShowHeader;
end;

procedure TfrmMain.btnBurnClick(Sender: TObject);
begin
  DoBurn;
end;

procedure TfrmMain.trkFuelChange(Sender: TObject);
begin
  AdjustBurn(abTrack);
end;

procedure TfrmMain.txtFuelChange(Sender: TObject);
begin
  AdjustBurn(abText);
end;

procedure TfrmMain.Init;
begin
  FuelBurn:=0;
  Fuel:=150;
  VelBeforeBurn:=50;
  VelAfterBurn:=0;
  llHeight:=1000;
  Time:=0;
end;

procedure TfrmMain.ShowData;
begin
  StatusBar1.Panels.Items[1].Text:=Format('%6.1f',[llHeight]);
  prgHeight.Position:=round(llHeight);
  imgLander.Top := Round(((1000 - prgHeight.Position)/prgHeight.Max)*prgHeight.Height - 50);
  //
  StatusBar1.Panels.Items[3].Text:=Format('%3d',[Time]);
  //
  StatusBar1.Panels.Items[5].Text:=Format('%5d',[VelbeforeBurn]);
  //
  StatusBar1.Panels.Items[7].Text:=Format('%4d',[Fuel]);
  prgFuel.Position:=Fuel;
end;

procedure TfrmMain.DoCalc;
begin
  if FuelBurn<0 then FuelBurn:=0;
  if FuelBurn>30 then FuelBurn:=30;
  if FuelBurn > Fuel then FuelBurn:=Fuel;
  Fuel := Fuel - FuelBurn;
  VelAfterBurn := VelBeforeBurn - FuelBurn + 5;
  llHeight := llHeight - (VelBeforeBurn + VelAfterBurn)/2;
  inc(Time);
  VelBeforeBurn := VelAfterBurn;
end;

procedure TfrmMain.DoBurn;
begin
  FuelBurn:=trkFuel.Position;
  DoCalc;
  ShowData;
  NoFuelCheck;
  HeightCheck;
end;

procedure TfrmMain.ShowHeader;
var
  frmInstructions: TfrmInstructions;
begin
  frmInstructions := TfrmInstructions.Create(frmMain);
  with frmInstructions.Memo1 do
  begin
    Lines.Clear;
    Lines.Add(' YOU ARE LANDING ON THE MOON AND AND HAVE TAKEN OVER MANUAL');
    Lines.Add(' CONTROL 1000 FEET ABOVE A GOOD LANDING SPOT. YOU HAVE A DOWN-');
    Lines.Add(' WARD VELOCITY OF 50 FEET/SEC. 150 UNITS OF FUEL REMAIN.');
    Lines.Add('' );
    Lines.Add(' HERE ARE THE RULES THAT GOVERN YOUR APOLLO SPACE-CRAFT:');
    Lines.Add('' );
    Lines.Add(' (1) AFTER EACH SECOND THE HEIGHT, VELOCITY, AND REMAINING FUEL');
    Lines.Add('     WILL BE REPORTED VIA DIGBY YOUR ON-BOARD COMPUTER.');
    Lines.Add(' (2) AFTER THE REPORT A "?" WILL APPEAR. ENTER THE NUMBER');
    Lines.Add('     OF UNITS OF FUEL YOU WISH TO BURN DURING THE NEXT');
    Lines.Add('     SECOND. EACH UNIT OF FUEL WILL SLOW YOUR DESCENT BY');
    Lines.Add('     1 FOOT/SEC.');
    Lines.Add(' (3) THE MAXIMUM THRUST OF YOUR ENGINE IS 30 FEET/SEC/SEC');
    Lines.Add('     OR 30 UNITS OF FUEL PER SECOND.');
    Lines.Add(' (4) WHEN YOU CONTACT THE LUNAR SURFACE. YOUR DESCENT ENGINE');
    Lines.Add('     WILL AUTOMATICALLY SHUT DOWN AND YOU WILL BE GIVEN A');
    Lines.Add('     REPORT OF YOUR LANDING SPEED AND REMAINING FUEL.');
    Lines.Add(' (5) IF YOU RUN OUT OF FUEL THE "?" WILL NO LONGER APPEAR' );
    Lines.Add('     BUT YOUR SECOND BY SECOND REPORT WILL CONTINUE UNTIL');
    Lines.Add('     YOU CONTACT THE LUNAR SURFACE.');
    Lines.Add('' );
    Lines.Add(' BEGINNING LANDING PROCEDURE........');
    Lines.Add(' G O O D  L U C K ! ! !');
  end;
  frmInstructions.ShowModal;
end;

procedure TfrmMain.NoFuelCheck;
begin
  if Fuel <=0 then
  begin
    trkFuel.Position := 0;
    btnBurn.Enabled:=false;
    while (llHeight>0) do
    begin
      FuelBurn:=0;
      DoCalc;
      ShowData;
      Application.ProcessMessages;
      sleep(1000);
    end;
  end;
end;

procedure TfrmMain.HeightCheck;
var
  ActualTimeToContact:double;
  Vel: double;
  x: string;
begin
  if llHeight <= 0 then
  begin
    btnBurn.Enabled := false;
    llHeight := llHeight + (VelBeforeBurn + VelAfterBurn)/2;
    dec(Time);
    if FuelBurn=5 then
    begin
      ActualTimeToContact := llHeight/VelBeforeBurn;
    end else begin
      ActualTimeToContact := (-VelBeforeBurn + Sqrt(VelbeforeBurn*VelBeforeBurn + llHeight*(10-2*FuelBurn))) / (5-FuelBurn);
    end;
    Vel := VelBeforeBurn + (5-FuelBurn) * ActualTimeToContact;
    //
    x:=Format('Touchdown at %7.2f seconds',[Time+ActualTimeToContact]);
    x:=x+CRLF+Format('Landing Velocity = %6.2f Feet/Sec',[Vel]);
    x:=x+CRLF;
    if abs(Vel) <= 0.01 then
    begin
      x:=x+CRLF+('CONGRATULATIONS! A PERFECT LANDING!!');
      x:=x+CRLF+('YOUR LICENSE WILL BE RENEWED  ....  LATER.');
    end else begin
      if abs(Vel)<= 2 then
      begin
  	  x:=x+CRLF+('Any Landing you can walk away from is a good landing');
      end else begin
        x:=x+CRLF+('***** SORRY, BUT YOU BLEW IT!!!!');
        x:=x+CRLF+('APPROPRIATE CONDOLENCES WILL BE SENT TO YOUR NEXT OF KIN');
      end;
    end;
    ShowMessage(x);
  end;
end;

procedure TfrmMain.AdjustBurn(From: TAdjustBurn);
begin
  case From of
    abText: trkFuel.Position:=StrToIntDef(txtFuel.Text,0);
    abTrack: txtFuel.Text:=IntToStr(trkFuel.Position);
  end;
end;

end.

