DROP TABLE IF EXISTS Sightings;
DROP TABLE IF EXISTS CelestialObjects;

CREATE TABLE CelestialObjects (
    ObjectID INTEGER PRIMARY KEY,
    ObjectName TEXT NOT NULL
);

CREATE TABLE Sightings (
    SightingID INTEGER PRIMARY KEY,
    ObjectID INTEGER NOT NULL,
    ObservationDate TEXT NOT NULL,
    ObservationTime TEXT,
    Magnitude REAL,
    FOREIGN KEY (ObjectID) REFERENCES CelestialObjects(ObjectID)
);

INSERT INTO CelestialObjects VALUES
(1, 'Mars'),
(2, 'Jupiter'),
(3, 'Saturn');

INSERT INTO Sightings VALUES
(101, 1, '2026-01-10', '20:00', -1.2),
(102, 1, '2026-02-15', '21:00', -1.5),
(103, 2, '2026-01-20', '20:30', -2.1),
(104, 2, '2026-03-05', '21:15', -2.4),
(105, 3, '2026-02-01', '22:00', 0.8);
