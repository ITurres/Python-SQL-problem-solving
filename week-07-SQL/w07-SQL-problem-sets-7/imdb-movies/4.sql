-- SQL query to determine the number of movies with an IMDb rating of 10.0.
SELECT
    COUNT(*)
FROM
    ratings
WHERE
    ratings.rating = 10.0;