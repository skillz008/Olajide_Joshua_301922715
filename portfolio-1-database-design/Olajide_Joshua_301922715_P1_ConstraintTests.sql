-- Run these deliberately invalid statements one at a time, outside a transaction.
-- Each should fail at the named constraint; the sample rows should remain unchanged.

-- 1. reject player pk. Expected: pk_player, SQLSTATE 23505.
INSERT INTO portfolio."player" ("player_id", "handle", "display_name", "joined_at", "is_active")
VALUES (101, 'fresh_handle', 'Jordan Lee', '2026-03-01T10:00:00Z', TRUE);

-- 2. reject player unique. Expected: uq_player_0, SQLSTATE 23505.
INSERT INTO portfolio."player" ("player_id", "handle", "display_name", "joined_at", "is_active")
VALUES (401, 'pixel_pilot', 'Morgan Reed', '2026-03-02T10:00:00Z', TRUE);

-- 3. reject player id not null. Expected: player_id, SQLSTATE 23502.
INSERT INTO portfolio."player" ("player_id", "handle", "display_name", "joined_at", "is_active")
VALUES (NULL, 'fresh_handle_402', 'Casey Park', '2026-03-03T10:00:00Z', TRUE);

-- 4. reject player handle not null. Expected: handle, SQLSTATE 23502.
INSERT INTO portfolio."player" ("player_id", "handle", "display_name", "joined_at", "is_active")
VALUES (403, NULL, 'Casey Park', '2026-03-03T10:00:00Z', TRUE);

-- 5. reject player display name not null. Expected: display_name, SQLSTATE 23502.
INSERT INTO portfolio."player" ("player_id", "handle", "display_name", "joined_at", "is_active")
VALUES (404, 'fresh_handle_404', NULL, '2026-03-03T10:00:00Z', TRUE);

-- 6. reject player joined at not null. Expected: joined_at, SQLSTATE 23502.
INSERT INTO portfolio."player" ("player_id", "handle", "display_name", "joined_at", "is_active")
VALUES (405, 'fresh_handle_405', 'Casey Park', NULL, TRUE);

-- 7. reject player active not null. Expected: is_active, SQLSTATE 23502.
INSERT INTO portfolio."player" ("player_id", "handle", "display_name", "joined_at", "is_active")
VALUES (406, 'fresh_handle_406', 'Casey Park', '2026-03-03T10:00:00Z', NULL);

-- 8. reject game pk. Expected: pk_game, SQLSTATE 23505.
INSERT INTO portfolio."game" ("game_id", "title", "starts_at", "ends_at", "status")
VALUES (201, 'New Circuit', '2026-04-01T09:00:00Z', '2026-04-01T18:00:00Z', 'scheduled');

-- 9. reject game id not null. Expected: game_id, SQLSTATE 23502.
INSERT INTO portfolio."game" ("game_id", "title", "starts_at", "ends_at", "status")
VALUES (NULL, 'Fresh Circuit 408', '2026-04-01T09:00:00Z', '2026-04-01T18:00:00Z', 'scheduled');

-- 10. reject game title not null. Expected: title, SQLSTATE 23502.
INSERT INTO portfolio."game" ("game_id", "title", "starts_at", "ends_at", "status")
VALUES (409, NULL, '2026-04-01T09:00:00Z', '2026-04-01T18:00:00Z', 'scheduled');

-- 11. reject game starts at not null. Expected: starts_at, SQLSTATE 23502.
INSERT INTO portfolio."game" ("game_id", "title", "starts_at", "ends_at", "status")
VALUES (410, 'Fresh Circuit 410', NULL, '2026-04-01T18:00:00Z', 'scheduled');

-- 12. reject game ends at not null. Expected: ends_at, SQLSTATE 23502.
INSERT INTO portfolio."game" ("game_id", "title", "starts_at", "ends_at", "status")
VALUES (411, 'Fresh Circuit 411', '2026-04-01T09:00:00Z', NULL, 'scheduled');

-- 13. reject game status not null. Expected: status, SQLSTATE 23502.
INSERT INTO portfolio."game" ("game_id", "title", "starts_at", "ends_at", "status")
VALUES (412, 'Fresh Circuit 412', '2026-04-01T09:00:00Z', '2026-04-01T18:00:00Z', NULL);

-- 14. reject game time window. Expected: game_time_window, SQLSTATE 23514.
INSERT INTO portfolio."game" ("game_id", "title", "starts_at", "ends_at", "status")
VALUES (413, 'Time Trial', '2026-05-01T18:00:00Z', '2026-05-01T09:00:00Z', 'scheduled');

-- 15. reject score pk. Expected: pk_score_event, SQLSTATE 23505.
INSERT INTO portfolio."score_event" ("score_event_id", "player_id", "game_id", "points", "recorded_at", "is_current")
VALUES (301, 101, 201, 490, '2026-02-01T13:00:00Z', FALSE);

-- 16. reject score player fk. Expected: fk_score_event_0, SQLSTATE 23503.
INSERT INTO portfolio."score_event" ("score_event_id", "player_id", "game_id", "points", "recorded_at", "is_current")
VALUES (414, 9414, 201, 200, '2026-02-02T10:00:00Z', FALSE);

-- 17. reject score game fk. Expected: fk_score_event_1, SQLSTATE 23503.
INSERT INTO portfolio."score_event" ("score_event_id", "player_id", "game_id", "points", "recorded_at", "is_current")
VALUES (415, 101, 9415, 200, '2026-02-02T11:00:00Z', FALSE);

-- 18. reject score event id not null. Expected: score_event_id, SQLSTATE 23502.
INSERT INTO portfolio."score_event" ("score_event_id", "player_id", "game_id", "points", "recorded_at", "is_current")
VALUES (NULL, 101, 201, 200, '2026-02-02T12:00:00Z', FALSE);

-- 19. reject score player id not null. Expected: player_id, SQLSTATE 23502.
INSERT INTO portfolio."score_event" ("score_event_id", "player_id", "game_id", "points", "recorded_at", "is_current")
VALUES (416, NULL, 201, 200, '2026-02-02T12:00:00Z', FALSE);

-- 20. reject score game id not null. Expected: game_id, SQLSTATE 23502.
INSERT INTO portfolio."score_event" ("score_event_id", "player_id", "game_id", "points", "recorded_at", "is_current")
VALUES (417, 101, NULL, 200, '2026-02-02T12:00:00Z', FALSE);

-- 21. reject score points not null. Expected: points, SQLSTATE 23502.
INSERT INTO portfolio."score_event" ("score_event_id", "player_id", "game_id", "points", "recorded_at", "is_current")
VALUES (418, 101, 201, NULL, '2026-02-02T12:00:00Z', FALSE);

-- 22. reject score recorded at not null. Expected: recorded_at, SQLSTATE 23502.
INSERT INTO portfolio."score_event" ("score_event_id", "player_id", "game_id", "points", "recorded_at", "is_current")
VALUES (419, 101, 201, 200, NULL, FALSE);

-- 23. reject score is current not null. Expected: is_current, SQLSTATE 23502.
INSERT INTO portfolio."score_event" ("score_event_id", "player_id", "game_id", "points", "recorded_at", "is_current")
VALUES (420, 101, 201, 200, '2026-02-02T12:00:00Z', NULL);

-- 24. reject score nonnegative. Expected: score_nonnegative, SQLSTATE 23514.
INSERT INTO portfolio."score_event" ("score_event_id", "player_id", "game_id", "points", "recorded_at", "is_current")
VALUES (421, 101, 201, -1, '2026-02-02T12:00:00Z', FALSE);

-- 25. reject one current score. Expected: one_current_score, SQLSTATE 23505.
INSERT INTO portfolio."score_event" ("score_event_id", "player_id", "game_id", "points", "recorded_at", "is_current")
VALUES (422, 101, 201, 300, '2026-02-02T13:00:00Z', TRUE);
