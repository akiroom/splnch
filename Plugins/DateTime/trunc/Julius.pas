unit Julius;

interface

uses SysUtils;

// �N�����������E�X���ɕϊ�����
function YMDToJD(Y: Integer; M, D: Integer): Integer;
// �����E�X����N�����ɕϊ�����
function JDToYMD(JD: Integer; var Y: Integer; var M, D: Integer): Integer;
// �����E�X����j���ɕϊ�����
function JDToDayOfWeek(JD: Integer): Integer;
// �N���犱�x�𓾂�
function YToEto(Y: Integer): String;
// �����E�X�����猎��𓾂�
function JDToMoon(JD: Double): Double;
// �N����t���̓��̃����E�X���𓾂�
function GetSpringEquinox(Y: Integer): Integer;
// �N����H���̓��̃����E�X���𓾂�
function GetAutumnEquinox(Y: Integer): Integer;
// ����̔N���[�N�ł��邩���f����
function IsLeapYear(Y: Integer): Boolean;
// ����̌��̓����𓾂�
function GetNumberOfDays(Y: Integer; M: Integer): Integer;

// �����E�X��烆���E�X���ɕϊ�����
function JToJD(Y: Integer; M, D: Integer): Integer;
// �O���S���I��烆���E�X���ɕϊ�����
function GToJD(Y: Integer; M, D: Integer): Integer;
// �����E�X�����烆���E�X��ɕϊ�����
function JDToJ(JD: Integer; var Y: Integer; var M, D: Integer): Integer;
// �����E�X������O���S���I��ɕϊ�����
function JDToG(JD: Integer; var Y: Integer; var M, D: Integer): Integer;
// ����̔N�̏\���𓾂�
function YToJikkan(Y: Integer): Integer;
// ����̔N�̏\��x�𓾂�
function YToJyunishi(Y: Integer): Integer;

type
  EJuliusError=class(Exception);

const
  JikkanNames: array[1..10] of String =
    ('�b','��','��','��','��','��','�M','�h','�p','�');
  JyunishiNames: array[1..12] of String =
    ('�q','�N','��','�K','�C','��','��','��','�\','��','��','��');
  WeekNames: array[0..6] of String =
    ('��', '��', '��', '��', '��', '��', '�y');

implementation

  // ��ʃ��[�`��(�ӂ��̃��[�U�[����)

function YMDToJD(Y: Integer; M, D: Integer): Integer;
var
  Flag: Integer;
begin

  Result:=0;

  if Y<1582 then Flag:=0 else
  if Y>1582 then Flag:=1 else
    if M<10 then Flag:=0 else
    if M>10 then Flag:=1 else
    if D<5  then Flag:=0 else
    if D>14 then Flag:=1 else
                 Flag:=2;

  case Flag of
    0: Result:=JToJD(Y, M, D);
    1: Result:=GToJD(Y, M, D);
    2: raise EJuliusError.Create('1582/10/5-10/14�͑��݂��܂���B');
  end;
end;

function JDToYMD(JD: Integer; var Y: Integer; var M, D: Integer): Integer;
begin
  Result:=0;
  if JD>2299160 then JDToG(JD, Y, M, D) else JDToJ(JD, Y, M, D);
end;

function JDToDayOfWeek(JD: Integer): Integer;
begin
  Result:=1 + (JD+1) mod 7;
end;

function YToEto(Y: Integer): String;
begin
  Result:=JikkanNames[YToJikkan(Y)]+JyunishiNames[YToJyunishi(Y)];
end;

function JDToMoon(JD: Double): Double;
begin
  JD:=JD-1/24*9; //���E�W�����ɂ��킹�邽��
  Result:=JD+20.3-29.530589*Trunc((JD+20.3)/29.530589);
end;

function IsLeapYear(Y: Integer): Boolean;
begin
  Result:=False;
  case Y<1582 of
    True:
    begin
      if (Y+4712) mod 4=0 then Result:=True;
    end;
    False:
    begin
      if Y mod 4=0    then Result:=True;
      if Y mod 100=0  then Result:=False;
      if Y mod 400=0  then Result:=True;
      if Y mod 4000=0 then Result:=False;
    end;
  end;
end;

function GetSpringEquinox(Y: Integer): Integer;
var
  m: Integer;
  dT, dV: Double;
begin
  m:=Y-2000;
  dV:=-0.00005*0.9743700647852*m
     +0.002*(sin((321-30.37*m)/180*PI)
            +sin((249+0.19*m)/180*PI)
            +sin((202-132.57*m)/180*PI)
            +sin((84-90.37*m)/180*PI))
     +0.001*sin((132-134.81*m)/180*PI)
     +0.005*sin((239-19.34*m)/180*PI);
  dT:=-dV+0.0000001*m*m;
  Result:=Trunc(2451544+80.683+365.24229*m+dT);
end;

function GetAutumnEquinox(Y: Integer): Integer;
var
  m: Integer;
  dT, dV: Double;
begin

  m:=Y-2000;
  dV:= 0.00005*0.9743700647852*m
     +0.002*(sin((485-30.37*m)/180*PI)
            +sin((249+0.19*m)/180*PI)
            +sin((268.2-132.57*m)/180*PI)
          +sin((309.2-90.37*m)/180*PI))
     +0.001*sin((244.6-134.81*m)/180*PI)
     +0.005*sin((248.6-19.34*m)/180*PI);
  dT:=-dV+0.0000001*m*m;
  Result:=Trunc(2451544+267.096+365.24206*m+dT);

end;

function GetNumberOfDays(Y: Integer; M: Integer): Integer;
const
  DY: array[1..12] of Integer=(31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31);
begin

  Result:=DY[M];
  if (IsLeapYear(Y)) and (M=2) then Inc(Result);

end;

  // �������[�`��(�}�j�A����)

function JToJD(Y: Integer; M, D: Integer): Integer;
begin
  if M>2 then Result:=-Trunc(0.4*M+1.2)+Trunc(Trunc( (Y+4712) / 4 ) + 1 - (Y+4712) / 4 )- 1
         else Result:=0;

  Result:=Result+D-1+31*(M-1)+Trunc(365.25*(Y+4715))-1095;

end;

function GToJD(Y: Integer; M, D: Integer): Integer;
begin

  Result:=JToJD(Y, M, D);

  Result:=Result-10;

  if M>2 then Result:=Result
                     +Trunc(1+Trunc(Y/400)-(Y/400))
                     -Trunc(1+Trunc(Y/100)-(Y/100))
                     -Trunc(1+Trunc(Y/4000)-(Y/4000));

  Result:=Result-Trunc(0.75*Trunc((Y-1501)/100))-Trunc((Y-1)/4000);

end;


function YToJikkan(Y: Integer): Integer;
begin
  Result:=1 + ((Y+4736) mod 10);
end;

function YToJyunishi(Y: Integer): Integer;
begin
  Result:=1 + ((Y+4736) mod 12);
end;


function JDToJ(JD: Integer; var Y: Integer; var M, D: Integer): Integer;
const
  YY: array[-1..3] of Integer=(-1, 365, 730, 1095, 1460);
  CDY: array[1..12] of Integer=(31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31);
var
  I: Integer;
  R, BaseYear, DD: Integer;
  DY: array[1..12] of Integer;
begin

  Result:=0;
  R:=JD mod 1461;
  BaseYear:=4*Trunc(JD/1461)-4712;

  for I := 1 to SizeOf(CDY) do
  begin
    DY[I]:=CDY[I];
  end;

  for I:=0 to 3 do
  begin
    if R<=YY[I] then
    begin
      Y:=BaseYear+I;
      break;
    end;
  end;

  DD:=JD-JToJD(Y, 1, 1);

  DY[2]:=28;
  if IsLeapYear(Y) then Inc(DY[2]);

  for I:=1 to 12 do
  begin
    if DD<DY[I] then
    begin
      M:=I;
      D:=DD+1;
      break;
    end
    else DD:=DD-DY[I];
  end;

end;

function JDToG(JD: Integer; var Y: Integer; var M, D: Integer): Integer;
var
  JDj: Integer;
begin

  Result:=0;

  JD:=JD+10;
  JD:=JD+Trunc((JD- 3182395+1460969) / 1460969);
  JD:=JD-Trunc((JD- 2305448+146097) / 146097);
  JD:=JD+Trunc((JD- 2305448+36524) / 36524);

  JDj:=JD;

  JDToJ(JDj, Y, M, D);

end;


end.
