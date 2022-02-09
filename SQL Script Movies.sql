-- ----------------------------- --
-- CREATION OF NEW DB FOR MOVIE DATA
-- ----------------------------- --

CREATE DATABASE IF NOT EXISTS movies;
USE movies;

-- ----------------------------- --
-- CREATION OF TABLES WITH MOVIES AND ACTORS INFORMATION
-- ----------------------------- --

CREATE TABLE `movies`.`movie_data` (
  `Rank` INT NOT NULL,
  `imdb_id` VARCHAR(10) NOT NULL,
  `Title` VARCHAR(62) NOT NULL,
  `All_Genre` VARCHAR(26) NULL,
  `Description` VARCHAR(45) NULL,
  `Director` VARCHAR(32) NULL,
  `Actors` VARCHAR(78) NULL,
  `Year` INT NULL,
  `Runtime (Minutes)` INT NULL,
  `Rating` DECIMAL(2) NULL,
  `Votes` INT NULL,
  `Movies_datacol` VARCHAR(45) NULL,
  `Revenue (Millions)` DECIMAL NULL,
  `Metascore` INT NULL,
  `Genre1` VARCHAR(9) NULL,
  `Genre2` VARCHAR(9) NULL,
  `Genre3` VARCHAR(9) NULL,
  `Actor1` VARCHAR(45) NULL,
  `Actor2` VARCHAR(45) NULL,
  `Actor3` VARCHAR(45) NULL,
  `Actor4` VARCHAR(45) NULL,
  `Drama` INT NOT NULL,
  `Action` INT NOT NULL,
  `Adventure` INT NOT NULL,
  `Horror` INT NOT NULL,
  `Animation` INT NOT NULL,
  `Comedy` INT NOT NULL,
  `Biography` INT NOT NULL,
  `Crime` INT NOT NULL,
  `Romance` INT NOT NULL,
  `Mystery` INT NOT NULL,
  `Thriller` INT NOT NULL,
  `Sci-F` INT NOT NULL,
  `Fantasy` INT NOT NULL,
  PRIMARY KEY (`imdb_id`));
 
CREATE TABLE `movies`.`actors_data` (
  `imdb_name_id` VARCHAR(9) NOT NULL,
  `name`VARCHAR(22),
  `height`INT,
  `birth_year` INT,
  `date_of_birth` TEXT,
  `place_of_birth` VARCHAR(82),
  `death_details` VARCHAR(90),
  `death_year` INT,
  `date_of_death` TEXT,
  `place_of_death`VARCHAR(60),
  `spouses`INT,
  `divorces`INT,
  `children`INT,
  `imdb_id`VARCHAR(10) NOT NULL);

-- ----------------------------- --
-- ADITION OF INFORMATION TO MOVIE AND ACTOR TABLES
-- ----------------------------- --
 
LOAD DATA INFILE 'C:\Users\Carla\Desktop\Projects\Movies_Raw_Data\Clean_IMDB-Movie-Data_CSV2.csv' 
INTO TABLE `movies`.`movie_data` 
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;  

SELECT * FROM movie_data
LIMIT 10;


LOAD DATA INFILE 'C:\Users\Carla\Desktop\Projects\Movies_Raw_Data\Actors_Final_Movies.csv' 
INTO TABLE `movies`.`movie_data` 
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;  

SELECT * FROM actors_data
LIMIT 10;


-- ----------------------------- --
-- QUERY OF DATA FOR FURTHER USE
-- ----------------------------- --
-- FOR MOVIES OBTAIN ACTORS IN THEM WITH THEIR PERSONAL INFORMATION
-- 1ST CREATE TEMPORARY TABLE TO OBTAIN ALL ACTORS IN MOVIES
-- ----------------------------- --

CREATE TEMPORARY TABLE act_table 
SELECT imdb_id,
	Title,
	TRIM(Actor1) AS Actor
FROM movie_data m1
	UNION
SELECT imdb_id,
	Title,
	Actor2
FROM movie_data
	UNION
SELECT imdb_id,
	Title,
	Actor3
FROM movie_data
	UNION
SELECT imdb_id,
	Title,
	Actor4
FROM movie_data
GROUP BY imdb_id
ORDER BY imdb_id, Actor;

-- ----------------------------- --
-- 2ND JOIN TABLE WITH ACTORS INFORMATION
-- ----------------------------- --

SELECT 
	act_table.Title,
	TRIM(act_table.Actor) AS Actor_Name,
	ad.date_of_birth AS Birth_day,
	ad.place_of_birth AS Birth_Location,
	ad.date_of_death AS Death_day,
	ad.place_of_death AS Death_Location
FROM act_table
LEFT JOIN actors_data ad
	ON ad.imdb_id = act_table.imdb_id;


  
-- ----------------------------- --
-- FOR MOVIES OBTAIN GENRES PREVALENCE RELATED WITH REVENUE
-- 1ST CREATE A TEMPORARY TABLE WITH THE AMOUNT OF MOVIES PER GENRE
-- ----------------------------- --  

CREATE TEMPORARY TABLE genres_total
SELECT 
	SUM(Drama) AS Drama,
	SUM(`Action`) AS `Action`,
	SUM(Adventure) AS Adventure,
	SUM(Horror) AS Horror,
	SUM(Animation) AS Animation,
	SUM(Comedy) AS Comedy,
	SUM(Biography) AS Biography,
	SUM(Crime) AS Crime,
	SUM(Romance) AS Romance,
	SUM(Mystery) AS Mystery,
	SUM(Thriller) AS Thriller,
	SUM(`Sci-F`) AS `Sci-F`,
	SUM(Fantasy) AS Fantasy
FROM movie_data;

-- ----------------------------- --
-- 2ND PIVOT VALUES FROM GENRE AND CREATE ANOTHER TEMP TABLE
-- ----------------------------- --  
CREATE TEMPORARY TABLE genres
SELECT 
	'Drama' Genre,
	Drama Frequency 
FROM genres_total
	UNION
SELECT 
	'Action' Genre,
	Action Frequency 
FROM genres_total
	UNION
SELECT 
	'Adventure' Genre,
	Adventure Frequency 
FROM genres_total
	UNION
SELECT 
	'Horror' Genre,
	Horror Frequency 
FROM genres_total
	UNION
SELECT 
	'Animation' Genre,
	Animation Frequency 
FROM genres_total
	UNION
SELECT 
	'Comedy' Genre,
	Comedy Frequency 
FROM genres_total
	UNION
SELECT 
	'Biography' Genre,
	Biography Frequency 
FROM genres_total
	UNION
SELECT 
	'Crime' Genre,
	Crime Frequency 
FROM genres_total
	UNION
SELECT 
	'Romance' Genre,
	Romance Frequency 
FROM genres_total
	UNION
SELECT 
	'Mystery' Genre,
	Mystery Frequency 
FROM genres_total
	UNION
SELECT 
	'Thriller' Genre,
	Thriller Frequency 
FROM genres_total
	UNION
SELECT 
	'Sci-F' Genre,
	`Sci-F` Frequency 
FROM genres_total
	UNION
SELECT 
	'Fantasy' Genre,
	Fantasy Frequency 
FROM genres_total;

-- ----------------------------- --
-- 3RD OBTAIN REVENUE PER GENRE AND CRETAE TEMPORARY TABLE WITH INFORMATION
-- ----------------------------- --  
CREATE TEMPORARY TABLE revenue_genre
SELECT
	SUM(CASE WHEN Drama=1 THEN `Revenue (Millions)`END) AS Drama,
	SUM(CASE WHEN `Action`=1 THEN `Revenue (Millions)`END) AS `Action`,
	SUM(CASE WHEN Adventure=1 THEN `Revenue (Millions)`END) AS Adventure,
	SUM(CASE WHEN Horror=1 THEN `Revenue (Millions)`END) AS Horror,
	SUM(CASE WHEN Animation=1 THEN `Revenue (Millions)`END) AS Animation,
	SUM(CASE WHEN Comedy=1 THEN `Revenue (Millions)`END) AS Comedy,
	SUM(CASE WHEN Biography=1 THEN `Revenue (Millions)`END) AS Biography,
	SUM(CASE WHEN Crime=1 THEN `Revenue (Millions)`END) AS Crime,
	SUM(CASE WHEN Romance=1 THEN `Revenue (Millions)`END) AS Romance,
	SUM(CASE WHEN Mystery=1 THEN `Revenue (Millions)`END) AS Mystery,
	SUM(CASE WHEN Thriller=1 THEN `Revenue (Millions)`END) AS Thriller,
	SUM(CASE WHEN `Sci-F`=1 THEN `Revenue (Millions)`END) AS `Sci-F`,
	SUM(CASE WHEN Fantasy=1 THEN `Revenue (Millions)`END) AS Fantasy
FROM movie_data;


-- ----------------------------- --
-- 4TH PIVOT VALUES FROM REVENUE AND CREATE ANOTHER TEMP TABLE
-- ----------------------------- --  

CREATE TABLE revenue
SELECT 
	'Drama' Genre,
	Drama Total_Revenue 
FROM revenue_genre
	UNION
SELECT 
	'Action' Genre,
	Action Total_Revenue 
FROM revenue_genre
	UNION
SELECT 
	'Adventure' Genre,
	Adventure Total_Revenue 
FROM revenue_genre
	UNION
SELECT 
	'Horror' Genre,
	Horror Total_Revenue 
FROM revenue_genre
	UNION
SELECT 
	'Animation' Genre,
	Animation Total_Revenue 
FROM revenue_genre
	UNION
SELECT 
	'Comedy' Genre,
	Comedy Total_Revenue 
FROM revenue_genre
	UNION
SELECT 
	'Biography' Genre,
	Biography Total_Revenue 
FROM revenue_genre
	UNION
SELECT 
	'Crime' Genre,
	Crime Total_Revenue 
FROM revenue_genre
	UNION
SELECT 
	'Romance' Genre,
	Romance Total_Revenue 
FROM revenue_genre
	UNION
SELECT 
	'Mystery' Genre,
	Mystery Total_Revenue 
FROM revenue_genre
	UNION
SELECT 
	'Thriller' Genre,
	Thriller Total_Revenue 
FROM revenue_genre
	UNION
SELECT 
	'Sci-F' Genre,
	`Sci-F` Total_Revenue 
FROM revenue_genre
	UNION
SELECT 
	'Fantasy' Genre,
	Fantasy Total_Revenue 
FROM revenue_genre;

-- ----------------------------- --
-- 5TH JOIN REVENUE AND GENRE TABLES
-- ----------------------------- --  
SELECT
	genres.Genre,
	Frequency,
	Total_Revenue/Frequency AS Avg_Revenue_Movie,
	Total_Revenue
FROM genres
LEFT JOIN revenue 
	ON genres.Genre = revenue.Genre
ORDER BY Total_Revenue/Frequency DESC;


  
-- ----------------------------- --
-- OBTAIN TOP 10 MOVIES INFO BY REVENUE
-- ----------------------------- --  

SELECT
	Title,
	All_Genre,
	Director,
	Actors,
	Year,
	Rating,
	`Revenue (Millions)`
FROM movie_data
ORDER BY `Revenue (Millions)` DESC
LIMIT 10;

