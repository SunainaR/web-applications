TRUNCATE TABLE albums RESTART IDENTITY CASCADE;
TRUNCATE TABLE artists RESTART IDENTITY CASCADE;

INSERT INTO artists ("name", "genre") VALUES
('Artist 1', 'Genre 1'),
('Artist 2', 'Genre 2');

INSERT INTO albums ("title", "release_year", "artist_id") VALUES
('Album 1', 1989, 1),
('Album 2', 1995, 1),
('Album 3', 2023, 2);