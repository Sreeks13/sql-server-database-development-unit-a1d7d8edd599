import sqlite3
import subprocess
from pathlib import Path

DB = "telescope.db"

def setup_database():
    conn = sqlite3.connect(DB)
    conn.executescript(Path("setup.sql").read_text())
    conn.commit()
    conn.close()

def test_latest_sightings():
    conn = sqlite3.connect(DB)

    conn.executescript(Path("setup.sql").read_text())
    conn.executescript("""
    WITH RankedSightings AS
    (
        SELECT
            s.*,
            ROW_NUMBER() OVER
            (
                PARTITION BY s.ObjectID
                ORDER BY s.ObservationDate DESC, s.ObservationTime DESC
            ) AS rn
        FROM Sightings s
    )
    SELECT ObjectID, SightingID, ObservationDate
    FROM RankedSightings
    WHERE rn = 1
    ORDER BY ObjectID;
    """)

    rows = conn.execute("""
        WITH RankedSightings AS
        (
            SELECT
                s.*,
                ROW_NUMBER() OVER
                (
                    PARTITION BY s.ObjectID
                    ORDER BY s.ObservationDate DESC, s.ObservationTime DESC
                ) AS rn
            FROM Sightings s
        )
        SELECT ObjectID, SightingID, ObservationDate
        FROM RankedSightings
        WHERE rn = 1
        ORDER BY ObjectID
    """).fetchall()

    assert rows == [
        (1, 102, "2026-02-15"),
        (2, 104, "2026-03-05"),
        (3, 105, "2026-02-01")
    ]

    conn.close()

def test_index_exists():
    conn = sqlite3.connect(DB)

    indexes = conn.execute("""
        SELECT name
        FROM sqlite_master
        WHERE type = 'index'
          AND name = 'IX_Sightings_ObjectID_ObservationDate'
    """).fetchall()

    assert len(indexes) == 1
    conn.close()

if __name__ == "__main__":
    setup_database()
    test_latest_sightings()
    test_index_exists()
    print("All tests passed!")
