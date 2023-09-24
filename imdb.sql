use imdb;
CREATE TABLE movies (
  director_name varchar(255) DEFAULT NULL,
  num_critic_for_reviews int DEFAULT NULL,
  gross int DEFAULT NULL,
  genres varchar(255) DEFAULT NULL,
  actor_1_name varchar(255) DEFAULT NULL,
  movie_title varchar(255) DEFAULT NULL,
  num_voted_users int DEFAULT NULL,
  num_user_for_reviews int DEFAULT NULL,
  language varchar(255) DEFAULT NULL,
  budget int DEFAULT NULL,
  title_year int DEFAULT NULL,
  imdb_score float DEFAULT NULL,
  movie_facebook_likes int DEFAULT NULL,
  Profit int
);

select movie_title, Profit
From movies
ORDER BY Profit DESc
LIMIT 10;


select *  from imdb.movies;


CREATE TABLE imdb.imdb_top_250 AS
SELECT
  imdb_score,
  movie_title AS  imdb_top_250,
  language,
  RANK() OVER (
    ORDER BY imdb_score DESC, movie_title ASC
    ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
  ) AS ranks
FROM movies
WHERE num_voted_users > 25000
ORDER BY imdb_score DESC, movie_title ASC
LIMIT 250;


SELECT imdb_score, imdb_top_250, ranks FROM imdb_top_250;

select * from imdb_top_250;

SELECT imdb_score, imdb_top_250 as Top_Foreign_Lang_Film, language, ranks
FROM imdb_top_250
WHERE language <> "English";

SELECT director_name AS top_10_directors, AVG(imdb_score) AS mean_IMDBscore,
RANK() OVER (ORDER BY AVG(imdb_score) DESC, director_name ASC
ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS ranks
FROM movies
GROUP BY director_name
ORDER BY mean_IMDBscore DESC, ranks ASC
LIMIT 10;

SELECT genres AS popular_genres, avg(imdb_score) AS highest_mean_IMDBscore,
RANK() OVER (ORDER BY AVG(imdb_score) DESC, genres ASC
ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS ranks
FROM movies
GROUP BY genres
ORDER BY highest_mean_IMDBscore DESC
LIMIT 10;

SELECT movie_title AS Leonardo_DiCaprio_movies
FROM movies
WHERE actor_1_name = "Leonardo DiCaprio";

SELECT movie_title AS Meryl_Streep_movies
FROM movies
WHERE actor_1_name = "Meryl Streep";

SELECT movie_title AS Brad_Pitt_movies
FROM movies
WHERE actor_1_name = "Brad Pitt";

SELECT actor_1_name, avg(num_critic_for_reviews) as critics_favourite, avg(num_user_for_reviews) as audience_favourite
FROM movies
WHERE actor_1_name IN ('Leonardo DiCaprio', 'Meryl Streep', 'Brad Pitt')
GROUP BY actor_1_name
ORDER BY critics_favourite DESC, audience_favourite DESC;


SELECT FLOOR(title_year / 10) * 10 AS decade,
sum(num_voted_users) AS total_users_voted
FROM movies
GROUP BY decade
ORDER BY decade ASC;