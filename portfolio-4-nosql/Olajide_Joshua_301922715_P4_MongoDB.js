// Run once in mongosh against a fresh exercise database.
// These records are fictional events for the case study.
(async function () {
  db = db.getSiblingDB('portfolio_nosql');
  if ((await db.getCollectionNames()).includes("score_events")) {
    throw new Error('The exercise collection already exists. Use a fresh database.');
  }

  // The validator checks the stable event fields while details can vary.
  await db.createCollection("score_events", {
    validator: {
    "$jsonSchema": {
        "bsonType": "object",
        "required": [
            "_id",
            "schemaVersion",
            "simulation",
            "eventType",
            "occurredAt",
            "source",
            "embedded",
            "references",
            "details"
        ],
        "properties": {
            "_id": {
                "bsonType": "string",
                "minLength": 1
            },
            "schemaVersion": {
                "enum": [
                    1
                ]
            },
            "simulation": {
                "enum": [
                    true
                ]
            },
            "eventType": {
                "bsonType": "string",
                "enum": [
                    "score_submitted",
                    "score_corrected"
                ]
            },
            "occurredAt": {
                "bsonType": "date"
            },
            "source": {
                "bsonType": "object",
                "required": [
                    "entity",
                    "key",
                    "snapshot"
                ],
                "properties": {
                    "entity": {
                        "enum": [
                            "score_event"
                        ]
                    },
                    "key": {
                        "bsonType": "object",
                        "required": [
                            "score_event_id"
                        ]
                    },
                    "snapshot": {
                        "bsonType": "object"
                    }
                }
            },
            "embedded": {
                "bsonType": "object"
            },
            "references": {
                "bsonType": "object"
            },
            "details": {
                "bsonType": "object"
            }
        }
    }
},
    validationLevel: 'strict', validationAction: 'error'
  });

  // Insert the four example events and show their IDs.
  printjson(await db.getCollection("score_events").insertMany([
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
    },
    {
        "_id": "event_000002",
        "schemaVersion": 1,
        "simulation": true,
        "eventType": "score_corrected",
        "occurredAt": ISODate("2030-01-01T10:01:00Z"),
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
            "channel": "mobile",
            "note": "Illustrative event-specific metadata",
            "examples": {
                "event_type": "illustrative event_type",
                "bonus_metadata": "illustrative bonus_metadata",
                "client_version": "illustrative client_version"
            }
        }
    }
]));
  await db.getCollection("score_events").createIndex({eventType: 1, occurredAt: -1}, {name: 'event_type_time'});

  // 1. Find the first sample event type (up to five documents).
  printjson(await db.getCollection("score_events").find({"eventType":"score_submitted"}).sort({_id:1}).limit(5).toArray());

  // 2. Find events for the first source record using nested key fields (up to five).
  printjson(await db.getCollection("score_events").find({"source.key.score_event_id":301}).sort({_id:1}).limit(5).toArray());

  // 3. Find events in the sample time range using a MongoDB Date filter (up to five).
  printjson(await db.getCollection("score_events").find({"occurredAt":{"$gte":ISODate("2030-01-01T10:00:00Z"), "$lt":ISODate("2030-01-01T11:00:00Z")}}).sort({_id:1}).limit(5).toArray());

  // 4. Count documents for each event type.
  printjson(await db.getCollection("score_events").aggregate([{"$group":{"_id":"$eventType", "documentCount":{"$sum":1}}}, {"$sort":{"_id":1}}]).toArray());

  // A date stored as text should be rejected by the validator.
  try {
    await db.getCollection("score_events").insertOne({...{
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
}, _id: 'invalid_date_example', occurredAt: 'not-a-date'});
  } catch (error) { print('Invalid date error: ' + error.code); }

  // Reusing an event ID should be rejected by the unique _id index.
  try { await db.getCollection("score_events").insertOne({
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
}); }
  catch (error) { print('Duplicate ID error: ' + error.code); }

  print('Document count: ' + await db.getCollection("score_events").countDocuments());
})().catch(error => { print(error.stack || String(error)); quit(1); });
