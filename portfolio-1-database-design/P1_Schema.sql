-- Real-time Game Leaderboard: tables, keys and business constraints.
-- Run once in a fresh PostgreSQL database.
BEGIN;
SET LOCAL standard_conforming_strings = on;
CREATE SCHEMA portfolio;
CREATE TABLE portfolio."player" (
  "player_id" bigint NOT NULL,
  "handle" text NOT NULL,
  "display_name" text NOT NULL,
  "joined_at" timestamptz NOT NULL,
  "is_active" boolean NOT NULL,
  CONSTRAINT "pk_player" PRIMARY KEY ("player_id"),
  CONSTRAINT "uq_player_0" UNIQUE ("handle")
);
CREATE TABLE portfolio."game" (
  "game_id" bigint NOT NULL,
  "title" text NOT NULL,
  "starts_at" timestamptz NOT NULL,
  "ends_at" timestamptz NOT NULL,
  "status" text NOT NULL,
  CONSTRAINT "pk_game" PRIMARY KEY ("game_id")
);
CREATE TABLE portfolio."score_event" (
  "score_event_id" bigint NOT NULL,
  "player_id" bigint NOT NULL,
  "game_id" bigint NOT NULL,
  "points" bigint NOT NULL,
  "recorded_at" timestamptz NOT NULL,
  "is_current" boolean NOT NULL,
  CONSTRAINT "pk_score_event" PRIMARY KEY ("score_event_id")
);
ALTER TABLE portfolio."score_event" ADD CONSTRAINT "fk_score_event_0" FOREIGN KEY ("player_id") REFERENCES portfolio."player" ("player_id");
ALTER TABLE portfolio."score_event" ADD CONSTRAINT "fk_score_event_1" FOREIGN KEY ("game_id") REFERENCES portfolio."game" ("game_id");
ALTER TABLE portfolio."score_event" ADD CONSTRAINT "score_nonnegative" CHECK ("points" >= 0);
CREATE UNIQUE INDEX "one_current_score" ON portfolio."score_event" ("player_id", "game_id") WHERE ("is_current" IS NOT NULL);
ALTER TABLE portfolio."game" ADD CONSTRAINT "game_time_window" CHECK ("ends_at" > "starts_at");
COMMIT;
