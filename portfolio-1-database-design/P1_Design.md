# Real-time Game Leaderboard — database design

My case study records player, game, score_event.

## Users

- Players submitting scores
- Game operators reviewing leaderboards

## Main operations

- Register players and games
- Record score updates while retaining history
- Filter score history and calculate game leaderboards

## Entities

| Entity | Information stored |
| --- | --- |
| player | A person who participates in games and submits scores. |
| game | A game with a scheduled time window and lifecycle status. |
| score_event | A score submission or correction, retaining prior rows and identifying the current score. |

## player

| Field | Type | Key | Required |
| --- | --- | --- | --- |
| player_id | BIGINT | PK | Yes |
| handle | TEXT | Unique | Yes |
| display_name | TEXT |  | Yes |
| joined_at | TIMESTAMPTZ |  | Yes |
| is_active | BOOLEAN |  | Yes |
- Unique key: (handle).

## game

| Field | Type | Key | Required |
| --- | --- | --- | --- |
| game_id | BIGINT | PK | Yes |
| title | TEXT |  | Yes |
| starts_at | TIMESTAMPTZ |  | Yes |
| ends_at | TIMESTAMPTZ |  | Yes |
| status | TEXT |  | Yes |


## score_event

| Field | Type | Key | Required |
| --- | --- | --- | --- |
| score_event_id | BIGINT | PK | Yes |
| player_id | BIGINT | FK | Yes |
| game_id | BIGINT | FK | Yes |
| points | INTEGER |  | Yes |
| recorded_at | TIMESTAMPTZ |  | Yes |
| is_current | BOOLEAN |  | Yes |
- player_id → player.player_id
- game_id → game.game_id

## Relationships and business rules

- Each player handle must be unique.
- Each score event references an existing player.
- Each score event references an existing game.
- Score points must be zero or greater.
- At most one score event per player and game may be marked current.
- A game's end time must be later than its start time.

## Assumptions

- Each entity uses a globally unique UUID as its single-column primary key.
- A score update retains a history row and marks at most one score as current for each player and game.
- Leaderboard totals sum current non-negative integer scores.
- Normalization example: score_event references player by player_id instead of repeating the player's handle and display name; this example focuses on that relationship.
- Separate benchmark plan: generate 50000 synthetic score_event rows, compare the same recorded_at date-range filter before and after a B-tree index, and inspect the query plan without asserting timings.
- Use only synthetic player names, IDs, games, and scores.

