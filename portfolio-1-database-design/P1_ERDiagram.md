# Real-time Game Leaderboard — ER diagram

```mermaid
erDiagram
    direction LR
    player {
        bigint player_id PK
        text handle UK
        text display_name
        timestamptz joined_at
        boolean is_active
    }
    game {
        bigint game_id PK
        text title
        timestamptz starts_at
        timestamptz ends_at
        text status
    }
    score_event {
        bigint score_event_id PK
        bigint player_id FK
        bigint game_id FK
        integer points
        timestamptz recorded_at
        boolean is_current
    }
    player ||--o{ score_event : "player_id"
    game ||--o{ score_event : "game_id"
```

PK identifies a record; FK links to another table; UK marks a single-field unique value. The relationship ends show exactly one, zero or one, or zero or many records. Composite unique keys and conditional rules are listed in the schema and design.

[Diagram image](../images/Olajide_Joshua_301922715_ERDiagram.png)
