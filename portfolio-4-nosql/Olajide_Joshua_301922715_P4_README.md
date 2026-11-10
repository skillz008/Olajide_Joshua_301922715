# Portfolio 4 — NoSQL and Advanced Data Models

I used MongoDB collection score_events for score_submitted and score_corrected events. These are fictional event examples based on score_event, player, game.

## Document model

| Field | Meaning |
| --- | --- |
| _id | Unique string event ID |
| eventType | One of the two selected case event labels |
| occurredAt | Native BSON Date; sample timestamps are in 2030 |
| source | Original entity, primary key and saved JSON snapshot |
| embedded | Linked record snapshots read with the event |
| references | Keys for linked sources kept outside the embedded snapshots |
| details | Event metadata whose fields vary |

Related player, game details are stored as snapshots with the event. This makes an event readable in one document. It duplicates some information, and later SQL changes do not automatically update the snapshots. PostgreSQL continues to enforce the relational rules.

## Example document

```javascript
{
    "_id": "event_000001",
    "schemaVersion": 1,
    "simulation": true,
    "eventType": "score_submitted",
    "occurredAt": ISODate("2030-01-01T10:00:00Z"),
    "source": {
        "entity": "score_event",
        "key": {
            "score_event_id": 301
        },
        "snapshot": {
            "score_event_id": 301,
            "player_id": 101,
            "game_id": 201,
            "points": 480,
            "recorded_at": "2026-02-01T12:45:00Z",
            "is_current": true
        }
    },
    "embedded": {
        "player": [
            {
                "key": {
                    "player_id": 101
                },
                "snapshot": {
                    "player_id": 101,
                    "handle": "pixel_pilot",
                    "display_name": "Avery Quinn",
                    "joined_at": "2026-01-15T10:30:00Z",
                    "is_active": true
                },
                "via": [
                    "score_event.player_id → player"
                ]
            }
        ],
        "game": [
            {
                "key": {
                    "game_id": 201
                },
                "snapshot": {
                    "game_id": 201,
                    "title": "Sky Circuit",
                    "starts_at": "2026-02-01T09:00:00Z",
                    "ends_at": "2026-02-01T18:00:00Z",
                    "status": "active"
                },
                "via": [
                    "score_event.game_id → game"
                ]
            }
        ]
    },
    "references": {},
    "details": {
        "channel": "web"
    }
}
```

## Queries and results

| Query | Returned documents |
| --- | --- |
| Find the first sample event type (up to five documents). | 1 |
| Find events for the first source record using nested key fields (up to five). | 2 |
| Find events in the sample time range using a MongoDB Date filter (up to five). | 2 |
| Count documents for each event type. | 2 |

## 1. Find the first sample event type (up to five documents).

```javascript
db.getCollection("score_events").find({"eventType":"score_submitted"}).sort({_id:1}).limit(5).toArray();
```

Selected fields from the returned documents:

```json
[
  {
    "_id": "event_000001",
    "eventType": "score_submitted",
    "occurredAt": {
      "$date": "2030-01-01T10:00:00Z"
    },
    "source": {
      "score_event_id": 301
    }
  }
]
```

## 2. Find events for the first source record using nested key fields (up to five).

```javascript
db.getCollection("score_events").find({"source.key.score_event_id":301}).sort({_id:1}).limit(5).toArray();
```

Selected fields from the returned documents:

```json
[
  {
    "_id": "event_000001",
    "eventType": "score_submitted",
    "occurredAt": {
      "$date": "2030-01-01T10:00:00Z"
    },
    "source": {
      "score_event_id": 301
    }
  },
  {
    "_id": "event_000002",
    "eventType": "score_corrected",
    "occurredAt": {
      "$date": "2030-01-01T10:01:00Z"
    },
    "source": {
      "score_event_id": 301
    }
  }
]
```

## 3. Find events in the sample time range using a MongoDB Date filter (up to five).

```javascript
db.getCollection("score_events").find({"occurredAt":{"$gte":ISODate("2030-01-01T10:00:00Z"), "$lt":ISODate("2030-01-01T11:00:00Z")}}).sort({_id:1}).limit(5).toArray();
```

Selected fields from the returned documents:

```json
[
  {
    "_id": "event_000001",
    "eventType": "score_submitted",
    "occurredAt": {
      "$date": "2030-01-01T10:00:00Z"
    },
    "source": {
      "score_event_id": 301
    }
  },
  {
    "_id": "event_000002",
    "eventType": "score_corrected",
    "occurredAt": {
      "$date": "2030-01-01T10:01:00Z"
    },
    "source": {
      "score_event_id": 301
    }
  }
]
```

## 4. Count documents for each event type.

```javascript
db.getCollection("score_events").aggregate([{"$group":{"_id":"$eventType", "documentCount":{"$sum":1}}}, {"$sort":{"_id":1}}]).toArray();
```

| _id | documentCount |
| --- | --- |
| score_corrected | 1 |
| score_submitted | 1 |

## Validation and suitability

MongoDB inserted 2 documents. An invalid date type was rejected with code 121 and a repeated event ID with 11000. The collection still contained 2 valid documents. The compound eventType/occurredAt index supports those access fields; this exercise does not measure its speed.

The details field can vary across event types, while the common fields have a validator. Events can be added as separate documents rather than growing one large history record.

## Run the script

Connect mongosh to a fresh exercise database and run Olajide_Joshua_301922715_P4_MongoDB.js. It selects portfolio_nosql, creates the collection, inserts the sample documents and displays the query results. [Implementation evidence](screenshots/Olajide_Joshua_301922715_P4_DocumentsAndQueries.png).

## References

- [MongoDB — data modelling](https://www.mongodb.com/docs/manual/data-modeling/)

