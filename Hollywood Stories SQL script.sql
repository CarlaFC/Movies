--- CREATION OF HOLLYWOOD STORIES DATA FOR ANALYSIS ---

-- DROP TABLE IN CASE IT ALREADY EXISTS
--DROP TABLE HollywoodStories;

-- CREATION OF TABLE
CREATE TABLE HollywoodStories 
(
 Film nvarchar(50) NOT NULL
,Genre nvarchar(50) NULL
,Studio nvarchar(50) NULL
,[Audience_score] tinyint NULL
,[Rotten_Tomatoes] tinyint NULL
,Profitability float NULL
,[Worldwide_Gross] float NULL
,[Year] smallint NULL
PRIMARY KEY (Film)
);

-- INSERTING DATA INTO THE TABLE
--INSERT INTO HollywoodStories (Film,Genre,Studio,[Audience_score],[Rotten_Tomatoes],Profitability,[Worldwide_Gross],[Year])
--VALUES  ('27 Dresses','Comedy','Fox','71','40','5.3436218','160308654','2008');


-- OVERVIEW OF THE TABLE
SELECT * FROM HollywoodStories;
		
-- OBSERVE NULL DATA
SELECT * 
FROM HollywoodStories
WHERE Film IS NULL
	OR Genre IS NULL
	OR Studio IS NULL
	OR [Audience_score] IS NULL
	OR [Rotten_Tomatoes] IS NULL
	OR Profitability IS NULL
	OR [Worldwide_Gross] IS NULL
	OR [Year] IS NULL
;

-- DELETE ROWS WITH NULL VALUES
DELETE FROM HollywoodStories
WHERE Film IS NULL
	OR Genre IS NULL
	OR Studio IS NULL
	OR [Audience_score] IS NULL
	OR [Rotten_Tomatoes] IS NULL
	OR Profitability IS NULL
	OR [Worldwide_Gross] IS NULL
	OR [Year] IS NULL
;

-- VIEW PROFITABILITY BY GENRE
SELECT   Genre
		,AVG(Profitability)		AS Profitability  --NOTE THIS IS AN INDEX VALUE THE FURTHER TO 1 THE MORE PROFITABLE IT IS
FROM HollywoodStories
GROUP BY Genre
ORDER BY AVG(Profitability) DESC
;

-- VIEW GROSS BY GENRE
SELECT   Genre
		,SUM(CAST([Worldwide_Gross] AS bigint))		AS Gross  
FROM HollywoodStories
GROUP BY Genre
ORDER BY SUM(CAST([Worldwide_Gross] AS bigint))	 DESC
;

-- VIEW OF SCORES AND PROFITABILITY BY GENRE
SELECT   Genre
		,AVG(Profitability)																AS Profitability
		,AVG([Audience_score])															AS [Audience Score]
		,AVG([Rotten_Tomatoes])															AS [Rotten Tomatoes Score]
		,CASE WHEN 
		AVG([Audience_score]) >= AVG([Rotten_Tomatoes])	THEN 'Audience Likes the Movie'
		ELSE 'Critics Like the Movie' END												AS [Final Opinion]
FROM HollywoodStories
GROUP BY Genre
ORDER BY AVG(Profitability) DESC
;

-- VIEW PROFITABILITY BY STUDIO
SELECT   Studio
		,AVG(Profitability)		AS Profitability  --NOTE THIS IS AN INDEX VALUE THE FURTHER TO 1 THE MORE PROFITABLE IT IS
FROM HollywoodStories
GROUP BY Studio
ORDER BY AVG(Profitability) DESC
;

-- VIEW GROSS BY STUDIO
SELECT   Studio
		,SUM(CAST([Worldwide_Gross] AS bigint))		AS Gross  
FROM HollywoodStories
GROUP BY Studio
ORDER BY SUM(CAST([Worldwide_Gross] AS bigint))	 DESC
;

--STUDIO OVERRVIEW
SELECT   Studio
		,SUM(CAST([Worldwide_Gross] AS bigint))		AS Gross 
		,AVG(Profitability)							AS Profitability
FROM HollywoodStories
GROUP BY Studio
ORDER BY SUM(CAST([Worldwide_Gross] AS bigint))	 DESC
;

--STUDIO GROSS PER YEAR
SELECT Studio 
	,[Year]
	,SUM(CAST([Worldwide_Gross] AS bigint))		AS Gross
FROM HollywoodStories
GROUP BY Studio 
		,[Year]
ORDER BY [Year]
;	

--TOP GROSS MOVIES
SELECT TOP 5 *
FROM HollywoodStories
ORDER BY [Worldwide_Gross] DESC
;

--TOP GROSS MOVIES BY DISNEY
SELECT TOP 5 *
FROM HollywoodStories
WHERE Studio = 'Disney'
ORDER BY [Worldwide_Gross] DESC
;

--TOP PROFITABILITY MOVIES
SELECT TOP 5 *
FROM HollywoodStories
ORDER BY Profitability DESC
;

--TOP PROFITABILITY MOVIES BY GENRE ANIMATION
SELECT TOP 5 *
FROM HollywoodStories
WHERE Genre = 'Animation'
ORDER BY Profitability DESC
;