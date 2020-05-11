program HelloMoon;

uses
  SysUtils;

var
  FuelBurn: integer;
  Fuel: integer;
  VelBeforeBurn: integer;
  VelAfterBurn: integer;
  Height: double;
  Time: integer;


procedure ShowHeader;
begin
  Writeln('  -- Moon Lander -- ');
  Writeln();
  Writeln(' YOU ARE LANDING ON THE MOON AND AND HAVE TAKEN OVER MANUAL');
  Writeln(' CONTROL 1000 FEET ABOVE A GOOD LANDING SPOT. YOU HAVE A DOWN-');
  Writeln(' WARD VELOCITY OF 50 FEET/SEC. 150 UNITS OF FUEL REMAIN.');
  Writeln( );
  Writeln(' HERE ARE THE RULES THAT GOVERN YOUR APOLLO SPACE-CRAFT:');
  Writeln( );
  Writeln(' (1) AFTER EACH SECOND THE HEIGHT, VELOCITY, AND REMAINING FUEL');
  Writeln('     WILL BE REPORTED VIA DIGBY YOUR ON-BOARD COMPUTER.');
  Writeln(' (2) AFTER THE REPORT A "?" WILL APPEAR. ENTER THE NUMBER');
  Writeln('     OF UNITS OF FUEL YOU WISH TO BURN DURING THE NEXT');
  Writeln('     SECOND. EACH UNIT OF FUEL WILL SLOW YOUR DESCENT BY');
  Writeln('     1 FOOT/SEC.');
  Writeln(' (3) THE MAXIMUM THRUST OF YOUR ENGINE IS 30 FEET/SEC/SEC');
  Writeln('     OR 30 UNITS OF FUEL PER SECOND.');
  Writeln(' (4) WHEN YOU CONTACT THE LUNAR SURFACE. YOUR DESCENT ENGINE');
  Writeln('     WILL AUTOMATICALLY SHUT DOWN AND YOU WILL BE GIVEN A');
  Writeln('     REPORT OF YOUR LANDING SPEED AND REMAINING FUEL.');
  Writeln(' (5) IF YOU RUN OUT OF FUEL THE "?" WILL NO LONGER APPEAR' );
  Writeln('     BUT YOUR SECOND BY SECOND REPORT WILL CONTINUE UNTIL');
  Writeln('     YOU CONTACT THE LUNAR SURFACE.');
  Writeln( );
  Writeln(' BEGINNING LANDING PROCEDURE........');
  Writeln(' G O O D  L U C K ! ! !');
  Writeln( );
  Writeln(' SEC   FEET SPEED FUEL PLOT OF DISTANCE');
end;

procedure Init;
begin
  FuelBurn:=0;
  Fuel:=150;
  VelBeforeBurn:=50;
  VelAfterBurn:=0;
  Height:=1000;
  Time:=0;
end;

procedure ShowData;
begin
  Writeln(Format(' %3d %6.1f %5d %4d',[Time, Height, VelBeforeBurn, Fuel]));
end;

function GetBurn:integer;
var
  x:string;
begin
  if Fuel>0 then
  begin
    Readln(x);
  end else begin
    x:='0';
  end;
  result:=StrToIntDef(x,0);
end;

procedure DoCalc;
begin
  if FuelBurn<0 then FuelBurn:=0;
  if FuelBurn>30 then FuelBurn:=30;
  if FuelBurn > Fuel then FuelBurn:=Fuel;
  Fuel := Fuel - FuelBurn;
  VelAfterBurn := VelBeforeBurn - FuelBurn + 5;
  Height := Height - (VelBeforeBurn + VelAfterBurn)/2;
  inc(Time);
  VelBeforeBurn := VelAfterBurn;
end;

procedure ShowLanding;
var
  ActualTimeToContact: double;
  Vel: double;
begin
  Height := Height + (VelBeforeBurn + VelAfterBurn)/2;
  dec(Time);
  if FuelBurn=5 then
  begin
    ActualTimeToContact := Height/VelBeforeBurn;
  end else begin
    ActualTimeToContact := (-VelBeforeBurn + Sqrt(VelbeforeBurn*VelBeforeBurn + Height*(10-2*FuelBurn))) / (5-FuelBurn);
  end;
  Vel := VelBeforeBurn + (5-FuelBurn) * ActualTimeToContact;
  writeln;
  writeln(Format('Touchdown at %7.2f seconds',[Time+ActualTimeToContact]));
  writeln(Format('Landing Velocity = %6.2f Feet/Sec',[Vel]));
  writeln(intToStr(Fuel)+' units of Fuel remaining');
  writeln;
  if abs(Vel) <= 0.01 then
  begin
    writeln('CONGRATULATIONS! A PERFECT LANDING!!');
    writeln('YOUR LICENSE WILL BE RENEWED  ....  LATER.');
  end else begin
    if abs(Vel) <=2 then
    begin
	  writeln('Any Landing you can walk away from is a good landing');
    end else begin
      writeln('***** SORRY, BUT YOU BLEW IT!!!!');
      writeln('APPROPRIATE CONDOLENCES WILL BE SENT TO YOUR NEXT OF KIN');
	end;
  end;
end;


begin
  ShowHeader;
  Init;
  ShowData;
  Repeat
    Fuelburn:=GetBurn;
    DoCalc;
    ShowData;
  until Height<=0;
  ShowLanding;
  ReadLn;
end.

