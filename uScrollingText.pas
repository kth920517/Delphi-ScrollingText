{******************************************************************************}
{                                                                              }
{                       Delphi Scrolling Text Sample                           }
{                                                                              }
{                       Copyright (C) TeakHyun Kang                            }
{                                                                              }
{                       https://github.com/kth920517                           }
{                       https://developist.tistory.com/                        }
{                                                                              }
{******************************************************************************}

unit uScrollingText;

interface

uses
  Vcl.ExtCtrls,
  Vcl.StdCtrls,
  Vcl.Controls,
  Vcl.Forms,
  System.Classes,
  System.SysUtils,
  System.Types;

type
  ScrollDirection = (sdVertical, sdHorizontal);

  TfrmMain = class(TForm)
    pnlNotice: TPanel;
    pnlButton: TPanel;
    btnDown: TButton;
    btnUp: TButton;
    pbxTitleArea: TPaintBox;
    lblTitle: TLabel;
    tmrNextTitle: TTimer;
    tmrScrollTitle: TTimer;
    btnStart: TButton;
    cmbDirection: TComboBox;
    procedure FormDestroy(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure tmrNextTitleTimer(Sender: TObject);
    procedure tmrScrollTitleTimer(Sender: TObject);
    procedure btnStartClick(Sender: TObject);
    procedure btnUpClick(Sender: TObject);
    procedure btnDownClick(Sender: TObject);
    procedure cmbDirectionChange(Sender: TObject);

    const
      Sec = 1000;
  private
    { Private declarations }
    FTitleList: TStringList;
    FTitleIndex: Integer;

    FDirection: ScrollDirection;
    FMoveInterval: Integer;
    FNextInterval: Integer;
    FCurrPoint: TPoint;
    FMargins: TMargins;

    procedure NextTitle;
    procedure PrevTitle;
    procedure SetTitle;
    function GetTitle: string;
  public
    { Public declarations }
    procedure Start;
    procedure Stop;

    procedure AddTitle(ATitle: string);
    procedure SetMargins(ARect: TRect);

    property Direction: ScrollDirection write FDirection;
    property MoveInterval: Integer write FMoveInterval;
    property NextInterval: Integer write FNextInterval;
  end;

var
  frmMain: TfrmMain;

implementation

{$R *.dfm}

{ TfrmMain }

procedure TfrmMain.FormCreate(Sender: TObject);
begin
  FTitleList := TStringList.Create;

  FTitleIndex := 0;
  FCurrPoint := Point(0, 0);

  //Font
  lblTitle.Font.Assign(Self.Font);
  pbxTitleArea.Canvas.Font.Assign(Self.Font);

  //Margins
  FMargins := TMargins.Create(nil);
  SetMargins(Rect(5, 5, 5, 5));

  //Interval
  FMoveInterval := 60;
  FNextInterval := 5 * Sec;

  //Direction
  FDirection := sdVertical;
end;

procedure TfrmMain.FormDestroy(Sender: TObject);
begin
  Stop;

  FMargins.Free;

  FTitleList.Clear;
  FTitleList.Free;
end;

function TfrmMain.GetTitle: string;
begin
  if FTitleList.Count = 0 then
    Result := ''
  else
    Result := FTitleList[FTitleIndex];
end;

procedure TfrmMain.btnStartClick(Sender: TObject);
var
  I: Integer;
begin
  FDirection := ScrollDirection(cmbDirection.ItemIndex);

  for I := 0 to 9 do
    AddTitle('[' + IntToStr(I + 1) + '] This is Scrolling Text..');

  Start;
end;

procedure TfrmMain.AddTitle(ATitle: string);
begin
  if ATitle.IsEmpty then Exit;

  FTitleList.Add(ATitle);
end;

procedure TfrmMain.btnDownClick(Sender: TObject);
begin
  Stop;
  NextTitle;
  SetTitle;
end;

procedure TfrmMain.btnUpClick(Sender: TObject);
begin
  Stop;
  PrevTitle;
  SetTitle;
end;

procedure TfrmMain.cmbDirectionChange(Sender: TObject);
begin
  if cmbDirection.ItemIndex < 0 then Exit;

  FDirection := ScrollDirection(cmbDirection.ItemIndex);

  Stop;
  SetTitle;
end;

procedure TfrmMain.NextTitle;
begin
  Inc(FTitleIndex);

  //Index Rotation
  if FTitleIndex > FTitleList.Count - 1 then
    FTitleIndex := 0;
end;

procedure TfrmMain.PrevTitle;
begin
  Dec(FTitleIndex);

  //Index Rotation
  if FTitleIndex < 0 then begin
    if FTitleList.Count = 0 then
      FTitleIndex := 0
    else
      FTitleIndex := FTitleList.Count - 1;
  end;
end;

procedure TfrmMain.SetMargins(ARect: TRect);
begin
  FMargins.Left := ARect.Left;
  FMargins.Right := ARect.Right;
  FMargins.Top := ARect.Top;
  FMargins.Bottom := ARect.Bottom;
end;

procedure TfrmMain.SetTitle;
begin
  //?????? ????????? ??? ???????????? ?????? ??? Repaint ????????? ??????.
  lblTitle.Caption := GetTitle;
  lblTitle.Margins.Left := FMargins.Left;
  lblTitle.Visible := True;

  //?????????
  pbxTitleArea.Repaint;

  //?????? ??????
  FCurrPoint.Y := (pbxTitleArea.Height - pbxTitleArea.Canvas.TextHeight(GetTitle)) div 2;
  FCurrPoint.X := FMargins.Left;

  //n??? ???????????? ?????? ?????????
  tmrNextTitle.Interval := FNextInterval;
  tmrNextTitle.Enabled := True;
end;

procedure TfrmMain.Start;
begin
  Stop;

  //??????
  SetTitle;
end;

procedure TfrmMain.Stop;
begin
  tmrScrollTitle.Enabled := False;
  tmrNextTitle.Enabled := False;
end;

procedure TfrmMain.tmrNextTitleTimer(Sender: TObject);
begin
  //n??? ???????????? ?????????
  tmrScrollTitle.Interval := FMoveInterval;
  tmrScrollTitle.Enabled := True;

  lblTitle.Visible := False;
end;

procedure TfrmMain.tmrScrollTitleTimer(Sender: TObject);
var
  sTitle: string;
  nHeight: Integer;
  nWidth: Integer;
  Rect: TRect;
begin
  pbxTitleArea.Repaint;

  Rect := pbxTitleArea.ClientRect;
  InflateRect(Rect, -FMargins.Left, -FMargins.Top);

  sTitle := GetTitle;

  case FDirection of
    sdVertical: begin
      nHeight := pbxTitleArea.Canvas.TextHeight(sTitle);

      pbxTitleArea.Canvas.TextRect(Rect, FCurrPoint.X, FCurrPoint.Y, sTitle);

      Dec(FCurrPoint.Y);

      //???????????? ????????? ?????? ?????????
      if FCurrPoint.Y + nHeight <= FMargins.Top  then begin
        NextTitle;

        FCurrPoint.Y := pbxTitleArea.Height - FMargins.Bottom;
      end;

      //???????????? ???????????? ?????? ??????
      if FCurrPoint.Y = (pbxTitleArea.Height - nHeight) div 2 then begin
        Stop;
        SetTitle;
      end;
    end;

    sdHorizontal: begin
      nWidth := pbxTitleArea.Canvas.TextWidth(sTitle);

      //????????? ????????? ????????? ???????????? ?????? ???
      if FCurrPoint.X > pbxTitleArea.Width then
        FCurrPoint.X := pbxTitleArea.Width;

      pbxTitleArea.Canvas.TextRect(Rect, FCurrPoint.X, FCurrPoint.Y, sTitle);

      Dec(FCurrPoint.X);

      //???????????? ????????? ?????? ?????????
      if FCurrPoint.X + nWidth <= FMargins.Left  then begin
        NextTitle;

        //????????? ????????? ??????
        FCurrPoint.X := pbxTitleArea.Width - FMargins.Right;
      end;

      //???????????? ???????????? ?????? ??????
      if FCurrPoint.X = FMargins.Left then begin
        Stop;
        SetTitle;
      end;
    end;
  end;
end;

end.
