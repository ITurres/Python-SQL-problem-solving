-- SQL query that returns the average energy of songs that are by Drake.
SELECT
    AVG(energy) AS Drake_average_song_energy
FROM
    songs
WHERE
    artist_id = (
        SELECT
            id
        FROM
            artists
        WHERE
            name = "Drake"
    );

--OR
SELECT
    AVG(energy) AS Drake_average_song_energy
FROM
    songs
    JOIN artists ON songs.artist_id = artists.id
WHERE
    artists.name = "Drake";