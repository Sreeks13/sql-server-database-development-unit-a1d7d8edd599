-- Latest observation for every celestial object
WITH RankedSightings AS
(
    SELECT
        s.ObjectID,
        s.SightingID,
        s.ObservationDate,
        s.ObservationTime,
        s.Magnitude,
        ROW_NUMBER() OVER
        (
            PARTITION BY s.ObjectID
            ORDER BY s.ObservationDate DESC, s.ObservationTime DESC
        ) AS rn
    FROM Sightings AS s
)
SELECT
    c.ObjectID,
    c.ObjectName,
    r.SightingID,
    r.ObservationDate,
    r.ObservationTime,
    r.Magnitude
FROM CelestialObjects AS c
INNER JOIN RankedSightings AS r
    ON c.ObjectID = r.ObjectID
WHERE r.rn = 1
ORDER BY c.ObjectID;

-- Nonclustered-style index for object + date searches
CREATE INDEX IF NOT EXISTS IX_Sightings_ObjectID_ObservationDate
ON Sightings(ObjectID, ObservationDate DESC);

-- Verified latest observation and index query
