USE imdb;

/* Now that you have imported the data sets, let’s explore some of the tables. 
 To begin with, it is beneficial to know the shape of the tables and whether any column has null values.
 Further in this segment, you will take a look at 'movies' and 'genre' tables.*/



-- Segment 1:




-- Q1. Find the total number of rows in each table of the schema?
-- Type your code below:
 
SELECT COUNT(*) AS TOTAL_NUMBERS FROM DIRECTOR_MAPPING;
SELECT COUNT(*) AS TOTAL_NUMBERS FROM GENRE;
SELECT COUNT(*) AS TOTAL_NUMBERS FROM MOVIE;
SELECT COUNT(*) AS TOTAL_NUMBERS FROM NAMES;
SELECT COUNT(*) AS TOTAL_NUMBERS FROM RATINGS;
SELECT COUNT(*) AS TOTAL_NUMBERS FROM role_mapping;


-- Q2. Which columns in the movie table have null values?
-- Type your code below:


SELECT Sum(CASE WHEN id IS NULL THEN 1 ELSE 0 END) AS ID_NULL_COUNT,Sum(CASE WHEN title IS NULL THEN 1 ELSE 0 END) AS title_NULL_COUNT,
Sum(CASE WHEN year IS NULL THEN 1 ELSE 0 END) AS year_NULL_COUNT, Sum(CASE WHEN date_published IS NULL THEN 1 ELSE 0 END) AS date_published_NULL_COUNT,
Sum(CASE WHEN duration IS NULL THEN 1 ELSE 0 END) AS duration_NULL_COUNT, Sum(CASE WHEN country IS NULL THEN 1 ELSE 0 END) AS country_NULL_COUNT,
Sum(CASE WHEN worlwide_gross_income IS NULL THEN 1 ELSE 0 END) AS worlwide_gross_income_NULL_COUNT,
Sum(CASE WHEN languages IS NULL THEN 1 ELSE 0 END) AS languages_NULL_COUNT,
Sum(CASE WHEN production_company IS NULL THEN 1 ELSE 0 END) AS production_company_NULL_COUNT
FROM   movie; 

-- Now as you can see four columns of the movie table has null values. Let's look at the at the movies released each year. 
-- Q3. Find the total number of movies released each year? How does the trend look month wise? (Output expected)



/* Output format for the first part:

+---------------+-------------------+
| Year			|	number_of_movies|
+-------------------+----------------
|	2017		|	2134			|
|	2018		|		.			|
|	2019		|		.			|
+---------------+-------------------+


Output format for the second part of the question:
+---------------+-------------------+
|	month_num	|	number_of_movies|
+---------------+----------------
|	1			|	 134			|
|	2			|	 231			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:

SELECT YEAR,COUNT(*) AS NUMBER_OF_MOVIES FROM MOVIE group by YEAR;

SELECT month(DATE_PUBLISHED) AS MONTH_NUM,COUNT(*) AS NUMBER_OF_MOVIES FROM MOVIE group by MONTH_NUM ORDER BY MONTH_NUM;



/*The highest number of movies is produced in the month of March.
So, now that you have understood the month-wise trend of movies, let’s take a look at the other details in the movies table. 
We know USA and India produces huge number of movies each year. Lets find the number of movies produced by USA or India for the last year.*/
  
-- Q4. How many movies were produced in the USA or India in the year 2019??
-- Type your code below:
 SELECT YEAR,COUNT(distinct ID) AS MOVIES_NUM FROM MOVIE  WHERE YEAR=2019 AND (COUNTRY LIKE '%USA%' OR COUNTRY LIKE '%INDIA%');

/* USA and India produced more than a thousand movies(you know the exact number!) in the year 2019.
Exploring table Genre would be fun!! 
Let’s find out the different genres in the dataset.*/

-- Q5. Find the unique list of the genres present in the data set?
-- Type your code below:

SELECT distinct GENRE FROM GENRE;









/* So, RSVP Movies plans to make a movie of one of these genres.
Now, wouldn’t you want to know which genre had the highest number of movies produced in the last year?
Combining both the movie and genres table can give more interesting insights. */

-- Q6.Which genre had the highest number of movies produced overall?
-- Type your code below:

SELECT GENRE,COUNT(*) AS MOVIES_NUM FROM GENRE G INNER JOIN MOVIE M ON G.MOVIE_ID=M.ID group by GENRE ORDER BY MOVIES_NUM DESC;


/* So, based on the insight that you just drew, RSVP Movies should focus on the ‘Drama’ genre. 
But wait, it is too early to decide. A movie can belong to two or more genres. 
So, let’s find out the count of movies that belong to only one genre.*/

-- Q7. How many movies belong to only one genre?
-- Type your code below:

SELECT COUNT(*) AS MOVIES_WITH_ONE_GENRE FROM (SELECT MOVIE_ID FROM GENRE GROUP BY MOVIE_ID HAVING COUNT(distinct GENRE)=1) AS SINGLE_GENRE;

/* There are more than three thousand movies which has only one genre associated with them.
So, this figure appears significant. 
Now, let's find out the possible duration of RSVP Movies’ next project.*/

-- Q8.What is the average duration of movies in each genre? 
-- (Note: The same movie can belong to multiple genres.)



/* Output format:

+---------------+-------------------+
| genre			|	avg_duration	|
+-------------------+----------------
|	thriller	|		105			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:


SELECT GENRE,ROUND(AVG(DURATION),2) AS AVG_DURATION FROM GENRE G INNER JOIN MOVIE M ON G.MOVIE_ID=M.ID GROUP BY GENRE ORDER BY AVG_DURATION DESC;


/* Now you know, movies of genre 'Drama' (produced highest in number in 2019) has the average duration of 106.77 mins.
Lets find where the movies of genre 'thriller' on the basis of number of movies.*/

-- Q9.What is the rank of the ‘thriller’ genre of movies among all the genres in terms of number of movies produced? 
-- (Hint: Use the Rank function)


/* Output format:
+---------------+-------------------+---------------------+
| genre			|		movie_count	|		genre_rank    |	
+---------------+-------------------+---------------------+
|drama			|	2312			|			2		  |
+---------------+-------------------+---------------------+*/
-- Type your code below:

-- SELECT GENRE,MOVIE_COUNT ,RANK() OVER (ORDER BY MOVIE_COUNT DESC) AS GENRE_RANK 
-- FROM (SELECT GENRE,COUNT(DISTINCT MOVIE_ID) AS MOVIE_COUNT FROM GENRE GROUP BY GENRE) AS GENRE_COUNTS WHERE GENRE='THRILLER';

WITH genre_summary AS( SELECT genre, Count(movie_id) AS movie_count, Rank() OVER(ORDER BY Count(movie_id) DESC) AS genre_rank FROM genre GROUP BY   genre ) 
SELECT *FROM   genre_summary WHERE  genre = "THRILLER" ;


/*Thriller movies is in top 3 among all genres in terms of number of movies
 In the previous segment, you analysed the movies and genres tables. 
 In this segment, you will analyse the ratings table as well.
To start with lets get the min and max values of different columns in the table*/




-- Segment 2:




-- Q10.  Find the minimum and maximum values in  each column of the ratings table except the movie_id column?
/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+-----------------+
| min_avg_rating|	max_avg_rating	|	min_total_votes   |	max_total_votes 	 |min_median_rating|min_median_rating|
+---------------+-------------------+---------------------+----------------------+-----------------+-----------------+
|		0		|			5		|	       177		  |	   2000	    		 |		0	       |	8			 |
+---------------+-------------------+---------------------+----------------------+-----------------+-----------------+*/
-- Type your code below:


 select min(AVG_RATING) AS MIN_AVG_RATING,MAX(AVG_RATING) AS MAX_AVG_RATING,min(TOTAL_VOTES) AS MIN_TOTAL_VOTES,MAX(TOTAL_VOTES) AS MAX_TOTAL_VOTES,
 min(MEDIAN_RATING) AS MIN_MEDIAN_RATING, MAX(MEDIAN_RATING) AS MAX_MEDIAN_RATING FROM RATINGS;


/* So, the minimum and maximum values in each column of the ratings table are in the expected range. 
This implies there are no outliers in the table. 
Now, let’s find out the top 10 movies based on average rating.*/

-- Q11. Which are the top 10 movies based on average rating?
/* Output format:
+---------------+-------------------+---------------------+
| title			|		avg_rating	|		movie_rank    |
+---------------+-------------------+---------------------+
| Fan			|		9.6			|			5	  	  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
|	.			|		.AVG_RATING			|			.		  |
+---------------+-------------------+---------------------+*/
-- Type your code below:
-- It's ok if RANK() or DENSE_RANK() is used too

SELECT TITLE,AVG_RATING,RANK() OVER(ORDER BY AVG_RATING DESC) AS MOVIE_RANK FROM RATINGS R INNER JOIN MOVIE M ON R.MOVIE_ID=M.ID ORDER BY AVG_RATING DESC LIMIT 10;


/* Do you find you favourite movie FAN in the top 10 movies with an average rating of 9.6? If not, please check your code again!!
So, now that you know the top 10 movies, do you think character actors and filler actors can be from these movies?
Summarising the ratings table based on the movie counts by median rating can give an excellent insight.*/

-- Q12. Summarise the ratings table based on the movie counts by median ratings.
/* Output format:

+---------------+-------------------+
| median_rating	|	movie_count		|
+-------------------+----------------
|	1			|		105			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:
-- Order by is good to have

SELECT MEDIAN_RATING,COUNT(distinct MOVIE_ID) AS MOVIE_COUNT FROM RATINGS GROUP BY MEDIAN_RATING ORDER  BY MEDIAN_RATING;



/* Movies with a median rating of 7 is highest in number. 
Now, let's find out the production house with which RSVP Movies can partner for its next project.*/

-- Q13. Which production house has produced the most number of hit movies (average rating > 8)??
/* Output format:
+------------------+-------------------+---------------------+
|production_company|movie_count	       |	prod_company_rank|
+------------------+-------------------+---------------------+
| The Archers	   |		1		   |			1	  	 |
+------------------+-------------------+---------------------+*/
-- Type your code below:
SELECT PRODUCTION_COMPANY,COUNT(MOVIE_ID) AS MOVIE_COUNT,RANK() OVER(ORDER BY COUNT(MOVIE_ID) DESC) AS PROD_COMPANY_RANK FROM RATINGS R INNER JOIN MOVIE M ON R.MOVIE_ID=M.ID 
WHERE R.AVG_RATING>8 AND PRODUCTION_COMPANY IS NOT NULL GROUP BY PRODUCTION_COMPANY;






-- It's ok if RANK() or DENSE_RANK() is used too
-- Answer can be Dream Warrior Pictures or National Theatre Live or both

-- Q14. How many movies released in each genre during March 2017 in the USA had more than 1,000 votes?
/* Output format:

+---------------+-------------------+
| genre			|	movie_count		|
+-------------------+----------------
|	thriller	|		105			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:

SELECT G.GENRE,COUNT(G.MOVIE_ID)AS MOVIE_COUNT FROM GENRE G INNER JOIN MOVIE M ON G.MOVIE_ID=M.ID INNER JOIN RATINGS R ON M.ID=R.MOVIE_ID
WHERE MONTH(M.DATE_PUBLISHED)=3 AND YEAR=2017 AND M.COUNTRY LIKE '%USA%' AND R.TOTAL_VOTES>1000 GROUP BY GENRE ORDER BY MOVIE_COUNT DESC;







-- Lets try to analyse with a unique problem statement.
-- Q15. Find movies of each genre that start with the word ‘The’ and which have an average rating > 8?
/* Output format:
+---------------+-------------------+---------------------+
| title			|		avg_rating	|		genre	      |
+---------------+-------------------+---------------------+
| Theeran		|		8.3			|		Thriller	  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
+---------------+-------------------+---------------------+*/
-- Type your code below:

SELECT M.title,AVG(R.avg_rating) AS avg_rating,G.genre FROM movie AS M INNER JOIN genre AS G ON G.movie_id = M.id INNER JOIN ratings AS R ON R.movie_id = M.id
WHERE R.avg_rating > 8 AND M.title LIKE 'THE%' GROUP BY M.title, G.genre ORDER BY avg_rating DESC;


-- You should also try your hand at median rating and check whether the ‘median rating’ column gives any significant insights.
-- Q16. Of the movies released between 1 April 2018 and 1 April 2019, how many were given a median rating of 8?
-- Type your code below:


SELECT COUNT(*) AS MOVIE_COUNT FROM RATINGS R INNER JOIN MOVIE M ON R.MOVIE_ID=M.ID WHERE M.DATE_PUBLISHED BETWEEN '2018-04-01' AND '2019-04-01' AND MEDIAN_RATING=8;


-- Once again, try to solve the problem given below.
-- Q17. Do German movies get more votes than Italian movies? 
-- Hint: Here you have to find the total number of votes for both German and Italian movies.
-- Type your code below:

SELECT LANGUAGES,SUM(R.TOTAL_VOTES) AS TOAL_VOTES FROM MOVIE M INNER JOIN RATINGS R ON M.ID=R.MOVIE_ID WHERE LANGUAGES LIKE '%GERMAN%' OR LANGUAGES LIKE '%ITALIAN%'
GROUP BY LANGUAGES ORDER BY SUM(R.TOTAL_VOTES) DESC;



-- Answer is Yes

/* Now that you have analysed the movies, genres and ratings tables, let us now analyse another table, the names table. 
Let’s begin by searching for null values in the tables.*/




-- Segment 3:



-- Q18. Which columns in the names table have null values??
/*Hint: You can find null values for individual columns or follow below output format
+---------------+-------------------+---------------------+----------------------+
| name_nulls	|	height_nulls	|date_of_birth_nulls  |known_for_movies_nulls|
+---------------+-------------------+---------------------+----------------------+
|		0		|			123		|	       1234		  |	   12345	    	 |
+---------------+-------------------+---------------------+----------------------+*/
-- Type your code below:

SELECT SUM(CASE WHEN NAME IS NULL THEN 1 ELSE 0 END) AS NAME_NULL,SUM(CASE WHEN HEIGHT IS NULL THEN 1 ELSE 0 END) AS HEIGHT_NULL,
SUM(CASE WHEN DATE_OF_BIRTH IS NULL THEN 1 ELSE 0 END)  AS DATE_OF_BIRTH_NULL,SUM(CASE WHEN KNOWN_FOR_MOVIES IS NULL THEN 1 ELSE 0 END) AS KNOWN_FOR_MOVIES_NULL FROM NAMES;


/* There are no Null value in the column 'name'.
The director is the most important person in a movie crew. 
Let’s find out the top three directors in the top three genres who can be hired by RSVP Movies.*/

-- Q19. Who are the top three directors in the top three genres whose movies have an average rating > 8?
-- (Hint: The top three genres would have the most number of movies with an average rating > 8.)
/* Output format:

+---------------+-------------------+
| director_name	|	movie_count		|
+---------------+-------------------|
|James Mangold	|		4			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:

WITH top_3_genres AS(SELECT genre,Count(m.id) AS movie_count,Rank() OVER(ORDER BY Count(m.id) DESC) AS genre_rank FROM movie AS m INNER JOIN
genre AS g ON g.movie_id = m.id INNER JOIN ratings AS r ON  r.movie_id = m.id WHERE avg_rating > 8 GROUP BY   genre limit 3 ) SELECT n.NAME AS director_name ,
Count(d.movie_id) AS movie_count FROM director_mapping AS d INNER JOIN genre G using (movie_id) INNER JOIN names AS n ON n.id = d.name_id
INNER JOIN top_3_genres using (genre) INNER JOIN ratings using (movie_id) WHERE avg_rating > 8 GROUP BY NAME ORDER BY movie_count DESC limit 3 ;



/* James Mangold can be hired as the director for RSVP's next project. Do you remeber his movies, 'Logan' and 'The Wolverine'. 
Now, let’s find out the top two actors.*/

-- Q20. Who are the top two actors whose movies have a median rating >= 8?
/* Output format:

+---------------+-------------------+
| actor_name	|	movie_count		|
+-------------------+----------------
|Christain Bale	|		10			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:


SELECT N.name AS actor_name, COUNT(M.id) AS movie_count FROM names AS N INNER JOIN role_mapping AS RM ON N.id = RM.name_id INNER JOIN movie AS M ON RM.movie_id = M.id
INNER JOIN ratings AS R ON M.id = R.movie_id WHERE R.median_rating >= 8 AND RM.category = 'ACTOR' GROUP BY actor_name ORDER BY movie_count DESC LIMIT 2;



/* Have you find your favourite actor 'Mohanlal' in the list. If no, please check your code again. 
RSVP Movies plans to partner with other global production houses. 
Let’s find out the top three production houses in the world.*/

-- Q21. Which are the top three production houses based on the number of votes received by their movies?
/* Output format:
+------------------+--------------------+---------------------+
|production_company|vote_count			|		prod_comp_rank|
+------------------+--------------------+---------------------+
| The Archers		|		830			|		1	  		  |
|	.				|		.			|			.		  |
|	.				|		.			|			.		  |
+-------------------+-------------------+---------------------+*/
-- Type your code below:

SELECT PRODUCTION_COMPANY,SUM(R.TOTAL_VOTES) AS VOTE_COUNT,RANK() OVER(ORDER BY SUM(R.TOTAL_VOTES) DESC) AS PROD_COMP_RANK FROM MOVIE M INNER JOIN RATINGS R ON 
M.ID=R.MOVIE_ID  GROUP BY PRODUCTION_COMPANY LIMIT 3;




/*Yes Marvel Studios rules the movie world.
So, these are the top three production houses based on the number of votes received by the movies they have produced.

Since RSVP Movies is based out of Mumbai, India also wants to woo its local audience. 
RSVP Movies also wants to hire a few Indian actors for its upcoming project to give a regional feel. 
Let’s find who these actors could be.*/

-- Q22. Rank actors with movies released in India based on their average ratings. Which actor is at the top of the list?
-- Note: The actor should have acted in at least five Indian movies. 
-- (Hint: You should use the weighted average based on votes. If the ratings clash, then the total number of votes should act as the tie breaker.)

/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| actor_name	|	total_votes		|	movie_count		  |	actor_avg_rating 	 |actor_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	Yogi Babu	|			3455	|	       11		  |	   8.42	    		 |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:



WITH actor_summary AS ( SELECT N.name AS actor_name,SUM(R.total_votes) AS total_votes, COUNT(R.movie_id) AS movie_count,SUM(R.avg_rating * R.total_votes)
AS weighted_rating_sum,ROUND(SUM(R.avg_rating * R.total_votes) / SUM(R.total_votes), 2) AS actor_avg_rating FROM movie AS M INNER JOIN ratings AS R ON M.id = R.movie_id 
INNER JOIN role_mapping AS RM ON M.id = RM.movie_id INNER JOIN names AS N ON RM.name_id = N.id WHERE RM.category = 'ACTOR' AND M.country = 'India' GROUP BY N.name HAVING 
COUNT(R.movie_id) >= 5) SELECT actor_name,total_votes,movie_count,actor_avg_rating, RANK() OVER (ORDER BY actor_avg_rating DESC, total_votes DESC) AS actor_rank 
FROM actor_summary ORDER BY actor_rank;

-- Top actor is Vijay Sethupathi

-- Q23.Find out the top five actresses in Hindi movies released in India based on their average ratings? 
-- Note: The actresses should have acted in at least three Indian movies. 
-- (Hint: You should use the weighted average based on votes. If the ratings clash, then the total number of votes should act as the tie breaker.)
/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| actress_name	|	total_votes		|	movie_count		  |	actress_avg_rating 	 |actress_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	Tabu		|			3455	|	       11		  |	   8.42	    		 |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:


WITH actress_summary AS ( SELECT n.name AS actress_name,COUNT(r.movie_id) AS movie_count,SUM(r.total_votes) AS total_votes,SUM(r.avg_rating * r.total_votes) AS weighted_rating_sum,
ROUND(SUM(r.avg_rating * r.total_votes) / SUM(r.total_votes), 2) AS actress_avg_rating FROM movie AS m INNER JOIN ratings AS r ON m.id = r.movie_id INNER JOIN
role_mapping AS rm ON m.id = rm.movie_id INNER JOIN names AS n ON rm.name_id = n.id WHERE rm.category = 'ACTRESS' AND m.country = 'India' AND m.languages LIKE '%HINDI%'
GROUP BY n.name HAVING COUNT(r.movie_id) >= 3)SELECT actress_name,total_votes, movie_count, actress_avg_rating, RANK() OVER (ORDER BY actress_avg_rating DESC, total_votes DESC) AS actress_rank
FROM actress_summary ORDER BY actress_rank LIMIT 5;



/* Taapsee Pannu tops with average rating 7.74. 
Now let us divide all the thriller movies in the following categories and find out their numbers.*/


/* Q24. Select thriller movies as per avg rating and classify them in the following category: 

			Rating > 8: Superhit movies
			Rating between 7 and 8: Hit movies
			Rating between 5 and 7: One-time-watch movies
			Rating < 5: Flop movies
--------------------------------------------------------------------------------------------*/
-- Type your code below:

with thriller_movie as (select distinct title,avg_rating from genre g inner join movie m on g.movie_id=m.id inner join ratings r on m.id=r.movie_id 
where genre like 'thriller')
select *,case 
when avg_rating >8 then 'superhit movies'
when avg_rating between 7 and 8 then 'hit movies'
when avg_rating between 5 and 7 then 'one-time-watch movies'
else 'flop movies'
end as movie_category from thriller_movie order by avg_rating desc;




/* Until now, you have analysed various tables of the data set. 
Now, you will perform some tasks that will give you a broader understanding of the data in this segment.*/

-- Segment 4:

-- Q25. What is the genre-wise running total and moving average of the average movie duration? 
-- (Note: You need to show the output table in the question.) 
/* Output format:
+---------------+-------------------+---------------------+----------------------+
| genre			|	avg_duration	|running_total_duration|moving_avg_duration  |
+---------------+-------------------+---------------------+----------------------+
|	comdy		|			145		|	       106.2	  |	   128.42	    	 |
|		.		|			.		|	       .		  |	   .	    		 |
|		.		|			.		|	       .		  |	   .	    		 |
|		.		|			.		|	       .		  |	   .	    		 |
+---------------+-------------------+---------------------+----------------------+*/
-- Type your code below:

SELECT genre,ROUND(AVG(duration),2) AS avg_duration,SUM(ROUND(AVG(duration),2)) OVER(ORDER BY genre ROWS UNBOUNDED PRECEDING) AS running_total_duration,
AVG(ROUND(AVG(duration),2)) OVER(ORDER BY genre ROWS 10 PRECEDING) AS moving_avg_duration FROM movie AS m  INNER JOIN genre AS g ON m.id= g.movie_id
GROUP BY genre ORDER BY genre;

-- Round is good to have and not a must have; Same thing applies to sorting


-- Let us find top 5 movies of each year with top 3 genres.

-- Q26. Which are the five highest-grossing movies of each year that belong to the top three genres? 
-- (Note: The top 3 genres would have the most number of movies.)

/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| genre			|	year			|	movie_name		  |worldwide_gross_income|movie_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	comedy		|			2017	|	       indian	  |	   $103244842	     |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:

-- Top 3 Genres based on most number of movies

with top_genre as (select genre,count(m.id) as movie_count,rank() over(order by count(m.id) desc) as genre_rank
from movie m inner join genre g on m.id=g.movie_id group by genre limit 3),top_movies as 
(select genre,year,title as movie_name,cast(replace(replace(ifnull(worlwide_gross_income,0),'INR',''),'$','') AS DECIMAL(10))  AS worlwide_gross_income,
dense_rank() over(partition by year order by cast(replace(replace(ifnull(worlwide_gross_income,0),'INR',''),'$','') AS DECIMAL(10)) desc) as movie_rank from movie m
inner join genre g on m.id=g.movie_id where genre in (select genre from top_genre) order by movie_name)

select * from top_movies where movie_rank<=5 order by year,movie_rank;
 


-- Finally, let’s find out the names of the top two production houses that have produced the highest number of hits among multilingual movies.
-- Q27.  Which are the top two production houses that have produced the highest number of hits (median rating >= 8) among multilingual movies?
/* Output format:
+-------------------+-------------------+---------------------+
|production_company |movie_count		|		prod_comp_rank|
+-------------------+-------------------+---------------------+
| The Archers		|		830			|		1	  		  |
|	.				|		.			|			.		  |
|	.				|		.			|			.		  |
+-------------------+-------------------+---------------------+*/
-- Type your code below:

select production_company,count(id) as movie_count,rank() over(order by count(id) desc) as prod_comp_rank from movie m inner join
ratings r on m.id=r.movie_id where r.median_rating>=8 and production_company is not null and position(','in languages)>0 
group by production_company limit 2;


-- Multilingual is the important piece in the above question. It was created using POSITION(',' IN languages)>0 logic
-- If there is a comma, that means the movie is of more than one language


-- Q28. Who are the top 3 actresses based on number of Super Hit movies (average rating >8) in drama genre?
/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| actress_name	|	total_votes		|	movie_count		  |actress_avg_rating	 |actress_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	Laura Dern	|			1016	|	       1		  |	   9.60			     |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:

with top_actress as (select n.name as actress_name,sum(total_votes)as total_votes,count(r.movie_id)as movie_count,round(sum(avg_rating*total_votes)/sum(total_votes),2)
as actress_avg_rating from movie m inner join ratings r on m.id=r.movie_id inner join role_mapping rm on m.id=rm.movie_id inner join names n on rm.name_id=n.id
inner join genre g on m.id=g.movie_id where category='actress' and avg_rating>8 and genre='drama' group by actress_name)
select *,rank() over(order by movie_count desc) as actreess_rank from top_actress limit 3;


/* Q29. Get the following details for top 9 directors (based on number of movies)
Director id
Name
Number of movies
Average inter movie duration in days
Average movie ratings
Total votes
Min rating
Max rating
total movie durations

Format:
+---------------+-------------------+---------------------+----------------------+--------------+--------------+------------+------------+----------------+
| director_id	|	director_name	|	number_of_movies  |	avg_inter_movie_days |	avg_rating	| total_votes  | min_rating	| max_rating | total_duration |
+---------------+-------------------+---------------------+----------------------+--------------+--------------+------------+------------+----------------+
|nm1777967		|	A.L. Vijay		|			5		  |	       177			 |	   5.65	    |	1754	   |	3.7		|	6.9		 |		613		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
+---------------+-------------------+---------------------+----------------------+--------------+--------------+------------+------------+----------------+

--------------------------------------------------------------------------------------------*/
-- Type you code below:


    
WITH next_date_published_summary 
As(SELECT d.name_id,NAME,d.movie_id,duration,r.avg_rating,total_votes,m.date_published,Lead(date_published,1) 
OVER(partition BY d.name_id ORDER BY date_published,movie_id ) AS next_date_published FROM director_mapping AS d INNER JOIN names AS n
ON n.id = d.name_id INNER JOIN movie AS m ON m.id = d.movie_id INNER JOIN ratings AS r ON r.movie_id = m.id ),
 top_director_summary 
AS(SELECT *,Datediff(next_date_published, date_published) AS date_difference FROM   next_date_published_summary )
SELECT 
name_id AS director_id,
NAME AS director_name,Count(movie_id)AS number_of_movies,Round(Avg(date_difference),2) AS avg_inter_movie_days,Round(Avg(avg_rating),2) AS avg_rating,
Sum(total_votes)AS total_votes,Min(avg_rating)AS min_rating,Max(avg_rating)AS max_rating,Sum(duration) AS total_duration FROM  top_director_summary 
GROUP BY director_id ORDER BY Count(movie_id) DESC limit 9;