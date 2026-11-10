# Real-time Game Leaderboard — SQL queries

## 1. Show related score_event, player records (up to 20).

```sql
SELECT t0."score_event_id" AS "score_event_score_event_id",
       t0."points" AS "score_event_points",
       t1."player_id" AS "player_player_id",
       t1."handle" AS "player_handle"
FROM portfolio."score_event" t0
JOIN portfolio."player" t1 ON t0."player_id" = t1."player_id"
ORDER BY t0."score_event_id", t1."player_id"
LIMIT 20;
```

| score_event_score_event_id | score_event_points | player_player_id | player_handle |
| --- | --- | --- | --- |
| 301 | 480 | 101 | pixel_pilot |

## 2. Find score_event records where recorded_at matches "2026-02-01T12:45:00Z" (up to 20).

```sql
SELECT * FROM portfolio."score_event"
WHERE "recorded_at" IS NOT DISTINCT FROM '2026-02-01T12:45:00Z'
ORDER BY "score_event_id"
LIMIT 20;
```

| score_event_id | player_id | game_id | points | recorded_at | is_current |
| --- | --- | --- | --- | --- | --- |
| 301 | 101 | 201 | 480 | 2026-02-01T12:45:00+00:00 | true |

## 3. Count score_event records for each player_id (up to 20 groups).

```sql
SELECT "player_id", count(*) AS record_count
FROM portfolio."score_event"
GROUP BY "player_id"
ORDER BY record_count DESC, "player_id" NULLS LAST
LIMIT 20;
```

| player_id | record_count |
| --- | --- |
| 101 | 1 |


## Index comparison

| Phase | Median (ms) | Three runs (ms) | Plan nodes | Buffer hits |
| --- | --- | --- | --- | --- |
| Before index | 2.345 | 2.345, 2.481, 2.336 | Sort → Seq Scan | 274 |
| After index | 0.317 | 0.323, 0.317, 0.293 | Sort → Bitmap Heap Scan → Bitmap Index Scan | 55 |

The median execution time changed from 2.345 ms to 0.317 ms. The measured plan used p2_filter_idx. The results matched in both phases. An index adds storage and write-maintenance costs; timings depend on the selected lookup and environment.

## Execution plans

### Before index, run 1

```text
Sort (actual time=2.315..2.318 rows=50 loops=1)
  Seq Scan on score_event (actual time=0.015..2.277 rows=50 loops=1)
Planning Time: 0.333 ms
Execution Time: 2.345 ms
```

### Before index, run 2

```text
Sort (actual time=2.447..2.45 rows=50 loops=1)
  Seq Scan on score_event (actual time=0.016..2.409 rows=50 loops=1)
Planning Time: 0.346 ms
Execution Time: 2.481 ms
```

### Before index, run 3

```text
Sort (actual time=2.306..2.309 rows=50 loops=1)
  Seq Scan on score_event (actual time=0.016..2.268 rows=50 loops=1)
Planning Time: 0.339 ms
Execution Time: 2.336 ms
```

### After index, run 1

```text
Sort (actual time=0.267..0.27 rows=50 loops=1)
  Bitmap Heap Scan on score_event (actual time=0.052..0.229 rows=50 loops=1)
    Bitmap Index Scan using p2_filter_idx (actual time=0.016..0.016 rows=50 loops=1)
Planning Time: 0.549 ms
Execution Time: 0.323 ms
```

### After index, run 2

```text
Sort (actual time=0.259..0.262 rows=50 loops=1)
  Bitmap Heap Scan on score_event (actual time=0.032..0.222 rows=50 loops=1)
    Bitmap Index Scan using p2_filter_idx (actual time=0.016..0.016 rows=50 loops=1)
Planning Time: 0.549 ms
Execution Time: 0.317 ms
```

### After index, run 3

```text
Sort (actual time=0.239..0.241 rows=50 loops=1)
  Bitmap Heap Scan on score_event (actual time=0.033..0.201 rows=50 loops=1)
    Bitmap Index Scan using p2_filter_idx (actual time=0.016..0.016 rows=50 loops=1)
Planning Time: 0.548 ms
Execution Time: 0.293 ms
```

## Reproduce

Use a fresh database with the Portfolio 1 schema and sample data. Run Olajide_Joshua_301922715_P2_Queries.sql, then Olajide_Joshua_301922715_P2_Optimisation.sql. The optimisation script creates a separate performance table and runs EXPLAIN (ANALYZE, BUFFERS).

[Query screenshot](screenshots/Olajide_Joshua_301922715_P2_QueryResults.png) · [Index comparison](screenshots/Olajide_Joshua_301922715_P2_IndexComparison.png)

## References

- [PostgreSQL — EXPLAIN](https://www.postgresql.org/docs/17/using-explain.html)

