-- Show related score_event, player records (up to 20).
SELECT t0."score_event_id" AS "score_event_score_event_id",
       t0."points" AS "score_event_points",
       t1."player_id" AS "player_player_id",
       t1."handle" AS "player_handle"
FROM portfolio."score_event" t0
JOIN portfolio."player" t1 ON t0."player_id" = t1."player_id"
ORDER BY t0."score_event_id", t1."player_id"
LIMIT 20;

EXPLAIN (ANALYZE, BUFFERS, FORMAT JSON)
SELECT t0."score_event_id" AS "score_event_score_event_id",
       t0."points" AS "score_event_points",
       t1."player_id" AS "player_player_id",
       t1."handle" AS "player_handle"
FROM portfolio."score_event" t0
JOIN portfolio."player" t1 ON t0."player_id" = t1."player_id"
ORDER BY t0."score_event_id", t1."player_id"
LIMIT 20;

-- Find score_event records where recorded_at matches "2026-02-01T12:45:00Z" (up to 20).
SELECT * FROM portfolio."score_event"
WHERE "recorded_at" IS NOT DISTINCT FROM '2026-02-01T12:45:00Z'
ORDER BY "score_event_id"
LIMIT 20;

EXPLAIN (ANALYZE, BUFFERS, FORMAT JSON)
SELECT * FROM portfolio."score_event"
WHERE "recorded_at" IS NOT DISTINCT FROM '2026-02-01T12:45:00Z'
ORDER BY "score_event_id"
LIMIT 20;

-- Count score_event records for each player_id (up to 20 groups).
SELECT "player_id", count(*) AS record_count
FROM portfolio."score_event"
GROUP BY "player_id"
ORDER BY record_count DESC, "player_id" NULLS LAST
LIMIT 20;

EXPLAIN (ANALYZE, BUFFERS, FORMAT JSON)
SELECT "player_id", count(*) AS record_count
FROM portfolio."score_event"
GROUP BY "player_id"
ORDER BY record_count DESC, "player_id" NULLS LAST
LIMIT 20;
