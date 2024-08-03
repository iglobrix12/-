program SnakeGameWithBorders;

uses
  crt;

const
  Width = 20;
  Height = 10;
  MaxLength = 100;

type
  TDirection = (dirUp, dirDown, dirLeft, dirRight);
  TPoint = record
    x, y: integer;
  end;
  TSnake = record
    Body: array[1..MaxLength] of TPoint;
    Length: integer;
    Dir: TDirection;
  end;

var
  Snake: TSnake;
  Food: TPoint;
  Key: char;
  GameOver: boolean;

procedure InitGame;
begin
  ClrScr;
  Randomize;
  Snake.Length := 1;
  Snake.Body[1].x := Width div 2;
  Snake.Body[1].y := Height div 2;
  Snake.Dir := dirRight;
  Food.x := Random(Width) + 1;
  Food.y := Random(Height) + 1;
  GameOver := False;
end;

procedure DrawBorders;
var
  i: integer;
begin
  for i := 1 to Width + 2 do
  begin
    GotoXY(i, 1);
    Write('#');
    GotoXY(i, Height + 2);
    Write('#');
  end;
  for i := 2 to Height + 1 do
  begin
    GotoXY(1, i);
    Write('#');
    GotoXY(Width + 2, i);
    Write('#');
  end;
end;

procedure Draw;
var
  i: integer;
begin
  ClrScr;
  DrawBorders;
  for i := 1 to Snake.Length do
  begin
    GotoXY(Snake.Body[i].x + 1, Snake.Body[i].y + 1);
    Write('*');
  end;
  GotoXY(Food.x + 1, Food.y + 1);
  Write('🍎');
  GotoXY(1, Height + 3);
end;

procedure MoveSnake;
var
  i: integer;
  Head: TPoint;
begin
  Head := Snake.Body[1];
  case Snake.Dir of
    dirUp: Dec(Head.y);
    dirDown: Inc(Head.y);
    dirLeft: Dec(Head.x);
    dirRight: Inc(Head.x);
  end;

  if (Head.x < 1) or (Head.x > Width) or (Head.y < 1) or (Head.y > Height) then
    GameOver := True;

  for i := Snake.Length downto 2 do
    Snake.Body[i] := Snake.Body[i - 1];

  Snake.Body[1] := Head;

  if (Head.x = Food.x) and (Head.y = Food.y) then
  begin
    if Snake.Length < MaxLength then
      Inc(Snake.Length);
    Food.x := Random(Width) + 1;
    Food.y := Random(Height) + 1;
  end;
end;

begin
  InitGame;
  repeat
    if KeyPressed then
    begin
      Key := ReadKey;
      case Key of
        'w': if Snake.Dir <> dirDown then Snake.Dir := dirUp;
        's': if Snake.Dir <> dirUp then Snake.Dir := dirDown;
        'a': if Snake.Dir <> dirRight then Snake.Dir := dirLeft;
        'd': if Snake.Dir <> dirLeft then Snake.Dir := dirRight;
      end;
    end;
    MoveSnake;
    Draw;
    Delay(200);
  until GameOver;
  GotoXY(1, Height + 4);
  WriteLn('Вы проиграли');
end.
