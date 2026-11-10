-- Fictional sample records for Real-time Game Leaderboard.
BEGIN;
SET LOCAL standard_conforming_strings = on;
INSERT INTO portfolio."player" ("player_id", "handle", "display_name", "joined_at", "is_active") VALUES (101, 'pixel_pilot', 'Avery Quinn', '2026-01-15T10:30:00Z', TRUE);
INSERT INTO portfolio."game" ("game_id", "title", "starts_at", "ends_at", "status") VALUES (201, 'Sky Circuit', '2026-02-01T09:00:00Z', '2026-02-01T18:00:00Z', 'active');
INSERT INTO portfolio."score_event" ("score_event_id", "player_id", "game_id", "points", "recorded_at", "is_current") VALUES (301, 101, 201, 480, '2026-02-01T12:45:00Z', TRUE);
COMMIT;
