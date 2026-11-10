# Real-time Game Leaderboard — normalisation

The example uses the saved sample records. The full set of fields is in the design and schema.

## Starting grouped records

| player_id | score_event records (list) |
| --- | --- |
| 101 | [301] |


The record IDs are grouped in a list. In 1NF, each record has its own row and each cell holds one value.

## 1NF: one value per cell

| score_event.score_event_id | score_event.player_id | score_event.game_id | player.player_id | player.handle | game.game_id | game.title |
| --- | --- | --- | --- | --- | --- | --- |
| 301 | 101 | 201 | 101 | pixel_pilot | 201 | Sky Circuit |

Key: score_event_id.

## 2NF: depend on the whole key

The declared candidate keys do not introduce a partial dependency here, so the 1NF rows stay unchanged at this step.

## score_event_example

| score_event.score_event_id | score_event.player_id | score_event.game_id | player.player_id | player.handle | game.game_id | game.title |
| --- | --- | --- | --- | --- | --- | --- |
| 301 | 101 | 201 | 101 | pixel_pilot | 201 | Sky Circuit |

## 3NF: store each entity’s details once

The entity keys determine their own descriptions. Related records keep foreign keys rather than repeating those descriptions.

## player

| player_id | handle | display_name | joined_at | is_active |
| --- | --- | --- | --- | --- |
| 101 | pixel_pilot | Avery Quinn | 2026-01-15T10:30:00+00:00 | true |

## game

| game_id | title | starts_at | ends_at | status |
| --- | --- | --- | --- | --- |
| 201 | Sky Circuit | 2026-02-01T09:00:00+00:00 | 2026-02-01T18:00:00+00:00 | active |

## score_event

| score_event_id | player_id | game_id | points | recorded_at | is_current |
| --- | --- | --- | --- | --- | --- |
| 301 | 101 | 201 | 480 | 2026-02-01T12:45:00+00:00 | true |

## Dependencies

- player: (player_id) → handle, display_name, joined_at, is_active
- game: (game_id) → title, starts_at, ends_at, status
- score_event: (score_event_id) → player_id, game_id, points, recorded_at, is_current

Joining the decomposed sample tables reproduces the original 1 example rows. The design assumes the declared keys describe the relevant business dependencies.
