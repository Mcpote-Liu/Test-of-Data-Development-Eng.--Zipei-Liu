-- 1) 俱乐部
CREATE TABLE clubs (
  club_id     BIGINT PRIMARY KEY,
  name        VARCHAR(120) NOT NULL,
  address     VARCHAR(200),
  details     TEXT
);

-- 2) 棋手
CREATE TABLE players (
  player_id   BIGINT PRIMARY KEY,
  name        VARCHAR(120) NOT NULL,
  address     VARCHAR(200),
  details     TEXT,
  ranking     INT --不一定非要有，但是最多一个排名
);

-- 3) 会员
CREATE TABLE members (
  player_id   BIGINT PRIMARY KEY,           -
  club_id     BIGINT NOT NULL,              
  join_date   DATE,
  FOREIGN KEY (player_id) REFERENCES players(player_id),-- 保证与 players 一一对应
  FOREIGN KEY (club_id)  REFERENCES clubs(club_id)-- 保证与 clubs一一对应
);

-- 4) 锦标赛

CREATE TABLE tournaments (
  tournament_id  BIGINT PRIMARY KEY,
  name           VARCHAR(150) NOT NULL,
  host_club_id   BIGINT NULL,-- 俱乐部主办则填；其他组织主办则为空
  sponsors       TEXT, -- 可以采用逗号分隔以实现存0/1/多个赞助方
  start_date     DATE,
  end_date       DATE,
  FOREIGN KEY (host_club_id) REFERENCES clubs(club_id)
);

-- 5) 比赛-一场比赛发生在某个锦标赛中
CREATE TABLE matches (
  match_id        BIGINT PRIMARY KEY,
  tournament_id   BIGINT NOT NULL,
  white_player_id BIGINT NOT NULL,          
  black_player_id BIGINT NOT NULL,
  result          VARCHAR(20), -- 例如 '1-0','0-1','1/2-1/2'
  match_time      TIMESTAMP,
  FOREIGN KEY (tournament_id)   REFERENCES tournaments(tournament_id),
  FOREIGN KEY (white_player_id) REFERENCES members(player_id),-- 引用 members(player_id) 保证仅允许俱乐部会员参赛
  FOREIGN KEY (black_player_id) REFERENCES members(player_id),
  CHECK (white_player_id <> black_player_id)--不能是同一人
);
