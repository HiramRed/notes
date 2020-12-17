-- 1.
SELECT
	stu.s_id AS '学号',
	stu.s_name AS '姓名',
	s1.c_id AS '课程号1',
	s1.sc_score AS '成绩1',
	s2.c_id AS '课程号2',
	s2.sc_score AS '成绩2' 
FROM
	sc s1
	LEFT JOIN sc s2 ON s1.s_id = s2.s_id 
	AND s1.sc_score > s2.sc_score
	LEFT JOIN student stu ON s1.s_id = stu.s_id 
WHERE
	s1.c_id = '01' 
	AND s2.c_id = '02'
	
-- 1.1.
SELECT
	s1.s_id AS '学号',
	stu.s_name AS '姓名',
	s1.c_id AS '课程1',
	s2.c_id AS '课程2'
FROM
	sc s1
LEFT JOIN
	sc s2
ON
	s1.s_id = s2.s_id
LEFT JOIN
	student stu
ON
	stu.s_id = s1.s_id
WHERE
	s1.c_id = '01' AND
	s2.c_id = '02'
	
-- 1.2.
SELECT
	s1.s_id AS '学号',
	stu.s_name AS '姓名',
	s1.c_id AS '课程1',
	s2.c_id AS '课程2'
FROM
	sc s1
LEFT JOIN
	sc s2
ON
	s1.s_id = s2.s_id AND
	s2.c_id = '02'
LEFT JOIN
	student stu
ON
	stu.s_id = s1.s_id
WHERE
	s1.c_id = '01'
	
-- 1.3.
SELECT
	s1.s_id
FROM
	sc s1
WHERE
	s1.c_id = '02' AND
	s1.s_id NOT IN(SELECT s_id FROM sc WHERE c_id = '01')
	
-- 2.
SELECT
	s1.s_id AS '学号',
	stu.s_name AS '姓名',
	s1.avg AS '平均成绩'
FROM
	(SELECT s_id,AVG(sc_score) AS 'avg' FROM sc GROUP BY s_id HAVING avg > 60) s1
LEFT JOIN
	student stu
ON
	stu.s_id = s1.s_id

-- 3.
SELECT DISTINCT
	s1.s_id AS '学号',
	stu.s_name AS '姓名',
	stu.s_sex	AS '性别'
FROM
	sc s1
LEFT JOIN
	student stu
ON
	s1.s_id = stu.s_id
	
-- 4.
SELECT
	stu.s_id AS '学号',
	COUNT(s1.c_id) AS '选课总数',
	SUM(s1.sc_score) AS '总成绩'
FROM
	student stu
LEFT JOIN
	sc s1
ON
	stu.s_id = s1.s_id
GROUP BY
	stu.s_id
	
-- 4.1.
SELECT DISTINCT
	s1.s_id AS '学生号',
	stu.s_name AS '姓名',
	stu.s_sex	AS '性别'
FROM
	sc s1
LEFT JOIN
	student stu
ON
	s1.s_id = stu.s_id

-- 5.
SELECT
	COUNT(1) AS 'count'
FROM
	teacher
WHERE
	teacher.t_name REGEXP '^李'
	
-- 6.
SELECT
	stu.s_id AS '学号',
	stu.s_name AS '姓名',
	t1.t_name AS '授课教师' 
FROM
	student stu
	LEFT JOIN sc s1 ON stu.s_id = s1.s_id
	LEFT JOIN course c1 ON s1.c_id = c1.c_id
	LEFT JOIN teacher t1 ON c1.t_id = t1.t_id 
WHERE
	t1.t_name = '张三'
	
-- 7.
SELECT
	stu.s_id AS '学号',
	stu.s_name AS '姓名',
	stu.s_sex	AS '性别'
FROM
	student stu,
	(SELECT @c := COUNT(1) FROM course) a
WHERE
	stu.s_id IN
		(SELECT s_id FROM sc GROUP BY s_id HAVING COUNT(c_id) < @c)
		
-- 8.
SELECT DISTINCT
	stu.s_id AS '学号',
	stu.s_name AS '姓名',
	stu.s_sex	AS '性别'
FROM
	student stu
LEFT JOIN
	sc s1
ON
	stu.s_id = s1.s_id
LEFT JOIN
	(SELECT s_id,c_id,sc_score FROM sc WHERE s_id = '01') as s2
ON
	s1.c_id = s2.c_id
WHERE
	stu.s_id != '01'
	
-- 9.
set @c = (SELECT COUNT(*) FROM sc WHERE s_id = '01');

SELECT
	stu.s_id AS '学号',
	stu.s_name AS '姓名',
	stu.s_sex AS '性别' 
FROM
	student stu 
WHERE
	stu.s_id IN (
		SELECT
			s1.s_id
		FROM
			sc s1
			LEFT JOIN ( SELECT s_id, c_id FROM sc WHERE s_id = '01' ) s2 
				ON s1.c_id = s2.c_id 
		WHERE
			s1.s_id != '01' 
		GROUP BY
			s1.s_id 
		HAVING
			COUNT( s1.c_id ) = @c
	);
	
-- 10.
SELECT s2.s_name AS '姓名'
FROM student s2
	LEFT JOIN (
		SELECT stu.s_id
		FROM teacher t1, course c1, student stu, sc s1
		WHERE (t1.t_name = '张三'
			AND t1.t_id = c1.t_id
			AND s1.c_id = c1.c_id
			AND stu.s_id = s1.s_id)
	) res
	ON res.s_id = s2.s_id
WHERE res.s_id IS NULL;

-- 11.
SELECT stu.s_id    AS '学号' , 
			 stu.s_name  AS '姓名' , 
			 rst.avg     AS '平均分'
FROM student stu
	JOIN (
		SELECT s_id, AVG(sc_score) AS 'avg'
		FROM sc
		WHERE sc_score < 60
		GROUP BY s_id
		HAVING COUNT(sc_score) >= 2
	) rst
	ON rst.s_id = stu.s_id;
		
-- 12.
SELECT stu.s_id    AS '学号',
       stu.s_name  AS '姓名',
       stu.s_sex   AS '性别',
       s1.sc_score AS '成绩'
FROM   student stu
       JOIN sc s1
         ON stu.s_id = s1.s_id
            AND s1.c_id = '01'
            AND sc_score < 60
ORDER  BY s1.sc_score DESC

	
-- 13.
SELECT stu.s_id   AS '学号',
       stu.s_name AS '姓名',
       res.c1     AS '课程01',
       res.c2     AS '课程02',
       res.c3     AS '课程03',
       res.avg    AS '平均分'
FROM   student stu
       JOIN (SELECT s_id,
                    Max(CASE c_id
                          WHEN '01' THEN sc_score
                          ELSE ''
                        END)      AS 'c1',
                    Max(CASE c_id
                          WHEN '02' THEN sc_score
                          ELSE ''
                        END)      AS 'c2',
                    Max(CASE c_id
                          WHEN '03' THEN sc_score
                          ELSE ''
                        END)      AS 'c3',
                    Avg(sc_score) AS 'avg'
             FROM   sc
             GROUP  BY s_id) res
         ON res.s_id = stu.s_id
ORDER  BY res.avg DESC;

-- SELECT	DISTINCT
-- 				stu.s_id   		AS '学号',
-- 				stu.s_name 		AS '姓名',
-- 				stu.s_sex  		AS '性别',
-- 				s2.sc_score 	AS '01'	 ,
-- 				s3.sc_score		AS '02'  ,
-- 				s4.sc_score 	AS '03'  ,
-- 				s5.avg 				AS '平均分'
-- 				
-- FROM 		sc s1
-- 				LEFT JOIN
-- 							sc s2
-- 					ON	s1.s_id = s2.s_id
-- 							AND s2.c_id = '01'
-- 				LEFT JOIN
-- 							sc s3
-- 					ON	s1.s_id = s3.s_id
-- 							AND s3.c_id = '02'
-- 				LEFT JOIN
-- 							sc s4
-- 					ON 	s1.s_id = s4.s_id
-- 							AND s4.c_id = '03'
-- 				JOIN (
-- 					SELECT s_id,AVG(sc_score) AS 'avg' FROM sc GROUP BY s_id
-- 				) s5
-- 					ON	s5.s_id = s1.s_id
-- 				JOIN	student stu
-- 					ON 	stu.s_id = s1.s_id
-- 					
-- ORDER 	BY	s5.avg	DESC;

-- 14.		
SELECT	s.c_id 						 AS '课程号',
				c1.c_name 				 AS '课程名',
				MAX(s.sc_score) 	 AS '最高分',
				MIN(s.sc_score) 	 AS '最低分',
				COUNT(s1.s_id) /
						COUNT(s.s_id)  AS '及格率',
				COUNT(s2.s_id) / 
						COUNT(s.s_id)  AS '中等率',
				COUNT(s3.s_id) /
						COUNT(s.s_id)  AS '优良率',
				COUNT(s4.s_id) /
						COUNT(s.s_id)  AS '优秀率',
				COUNT(s.s_id) 		 AS '选修人数'
				
FROM		sc s
				LEFT JOIN sc s1
							 ON s1.c_id = s.c_id
									AND s1.s_id = s.s_id
									AND s1.sc_score >= 60
									
				LEFT JOIN sc s2
					ON s2.c_id = s.c_id
						 AND s2.s_id = s.s_id
						 AND s2.sc_score BETWEEN 70 AND 79
						 
			  LEFT JOIN sc s3
							 ON s3.c_id = s.c_id
						      AND s3.s_id = s.s_id
						      AND s3.sc_score BETWEEN 80 AND 89
									
			  LEFT JOIN sc s4
							 ON s4.c_id = s.c_id
									AND s4.s_id = s.s_id
									AND s4.sc_score >= 90
									
			  JOIN course c1
					ON c1.c_id = s.c_id
					
GROUP  BY s.c_id,
					c1.c_name
					
ORDER  BY	`选修人数`,
					s.c_id

-- 15.
SELECT	stu.s_id 			AS '学号'
			, stu.s_name 		AS '姓名'
			, rst1.sc_score AS '课程01'
			, rst1.rank 		AS '排名'
			, rst2.sc_score AS '课程02'
			, rst2.rank 		AS '排名'
			, rst3.sc_score AS '课程03'
			, rst3.rank 		AS '排名'
				
FROM		student stu
				LEFT JOIN (
						SELECT  s_id, c_id, sc_score
									, @curRank1 := IF(@prevRank1 = sc_score,@curRank1,@incRank1) AS 'rank'
									, @incRank1 := @incRank1 + 1
									, @prevRank1 := sc_score
						FROM		sc, (
											SELECT @curRank1 := 0, @prevRank1 := NULL
													 , @incRank1 := 1
										) a
						WHERE 	c_id = '01'
						ORDER BY sc_score DESC
				) rst1
				ON rst1.s_id = stu.s_id
				
				LEFT JOIN (
						SELECT s_id, c_id, sc_score
								 , @curRank2 := IF(@prevRank2 = sc_score,@curRank2,@incRank2) AS 'rank'
								 , @incRank2 := @incRank2 + 1
								 , @prevRank2 := sc_score
					  FROM 	 sc, (
										SELECT @curRank2 := 0, @prevRank := null
												 , @incRank2 := 1
									 ) b
					  WHERE  c_id = '02'
						ORDER BY sc_score DESC
				) rst2
				ON rst2.s_id = stu.s_id
				
				LEFT JOIN (
						SELECT s_id, c_id, sc_score
								 , @curRank3 := IF(@prevRank3 = sc_score,@curRank3,@incRank3) AS 'rank'
								 , @incRank3 := @incRank3 + 1
								 , @prevRank3 := sc_score
					  FROM   sc, (
										SELECT @curRank3 := 0, @prevRank3 := NULL
												 , @incRank3 := 1
									 ) c
					  WHERE  c_id = '03'
						ORDER BY sc_score DESC
				) rst3
				ON rst3.s_id = stu.s_id
ORDER BY stu.s_id
							
-- 15.1.
SELECT	stu.s_id 	 		AS '学号',
				stu.s_name 		AS '姓名',
				rst1.sc_score AS '成绩01',
				rst1.rank 		AS '排名',
				rst2.sc_score AS '成绩02',
				rst2.rank  		AS '排名',
				rst3.sc_score AS '成绩03',
				rst3.rank  		AS '排名'
				
FROM		student stu
				LEFT JOIN (
						SELECT s_id, c_id, sc_score
								, CASE
										WHEN @prevRank1 = sc_score THEN @curRank1
										WHEN @prevRank1 := sc_score THEN @curRank1 := @curRank1 + 1
									END AS 'rank'
						FROM	 sc, (
										 SELECT @curRank1 := 0, @prevRank1 := NULL
									 ) a
						WHERE  c_id = '01'
						ORDER  BY sc_score DESC
				) rst1
				ON rst1.s_id = stu.s_id
				
				LEFT JOIN (
						SELECT s_id, c_id, sc_score
								, CASE
										WHEN @prevRank2 = sc_score THEN @curRank2
										WHEN @prevRank2 := sc_score THEN @curRank2 := @curRank2 + 1
									END AS 'rank'
						FROM	 sc, (
										 SELECT @curRank2 := 0, @prevRank2 := NULL
									 ) b
						WHERE  c_id = '02'
						ORDER  BY sc_score DESC
				) rst2
				ON rst2.s_id = stu.s_id
				
				LEFT JOIN (
						SELECT s_id, c_id, sc_score
								, CASE
									  WHEN @prevRank3 = sc_score THEN @curRank3
									  WHEN @prevRank3 := sc_score THEN @curRank3 := @curRank3 + 1
									END AS 'rank'
						FROM	 sc, (
										 SELECT @curRank3 := 0, @prevRank3 := NULL
									 ) c
						WHERE  c_id = '03'
						ORDER  BY sc_score DESC
				) rst3
				ON rst3.s_id = stu.s_id
				
-- 16.
SELECT	stu.s_id 			AS '学号'
			, stu.s_name 		AS '姓名'
			, rst.sum_score AS '总分'
			, rst.rank 			AS '排名'
FROM		student stu
				LEFT JOIN	(
						SELECT s1.s_id
								 , s1.sum_score
								 , @curRank := IF(@prevRank = s1.sum_score, @curRank, @incRank) AS 'rank'
								 , @incRank := @incRank + 1
								 , @prevRank := s1.sum_score
					  FROM	 (SELECT s_id, SUM(sc_score) AS 'sum_score' FROM sc GROUP BY s_id) s1, (
											SELECT @curRank := 0, @prevRank := NULL
													 , @incRank := 1
									  ) a
						ORDER BY s1.sum_score DESC
				) rst
				ON rst.s_id = stu.s_id;
WHERE rst.rank IS NOT NULL
ORDER BY rst.rank;

-- 16.1.
SELECT	stu.s_id 			AS '学号'
			, stu.s_name 		AS '姓名'
			, rst.sum_score AS '总分'
			, rst.rank 			AS '排名'

FROM		student stu
				LEFT JOIN	(
						SELECT s1.s_id
								 , s1.sum_score
								 , CASE
										 WHEN @prevRank = s1.sum_score THEN @curRank
										 WHEN @prevRank := s1.sum_score THEN @curRank := @curRank + 1
									 END AS 'rank'
					  FROM	 (SELECT s_id, SUM(sc_score) AS 'sum_score' FROM sc GROUP BY s_id) s1, (
											SELECT @curRank := 0, @prevRank := NULL
									  ) a
						ORDER BY s1.sum_score DESC
				) rst
				ON rst.s_id = stu.s_id
WHERE rst.rank IS NOT NULL
ORDER BY rst.rank;

-- 17. 
SELECT c1.c_id, c1.c_name
		 , COUNT(IF(s1.sc_score >= 0 
				 AND s1.sc_score < 60, s1.sc_score, NULL)) / COUNT(1)   AS '[60-0]'
		 , COUNT(IF(s1.sc_score >= 60 
			   AND s1.sc_score < 70, s1.sc_score, NULL)) / COUNT(1)   AS '[60-70]'
		 , COUNT(IF(s1.sc_score >= 70 
			   AND s1.sc_score < 85, s1.sc_score, NULL)) / COUNT(1)   AS '[70-85]'
		 , COUNT(IF(s1.sc_score >= 85 
			   AND s1.sc_score <= 100, s1.sc_score, NULL)) / COUNT(1) AS '[85-100]'
FROM	sc s1, course c1
WHERE s1.c_id = c1.c_id
GROUP BY c1.c_id, c1.c_name
-- SELECT c1.c_name
-- 		 , c1.c_id
-- 		 , rst1.sum / rst.sum
-- 		 , rst2.sum / rst.sum
-- 		 , rst3.sum / rst.sum
-- 		 , rst4.sum / rst.sum
-- FROM   course c1
--        LEFT JOIN (SELECT c_id,
--                          Sum(1) AS 'sum'
--                   FROM   sc
--                   GROUP  BY c_id) rst
--               ON c1.c_id = rst.c_id
--        LEFT JOIN (SELECT c_id,
--                          Sum(1) AS 'sum'
--                   FROM   sc
--                   WHERE  sc.sc_score >= 85
--                          AND sc.sc_score <= 100
--                   GROUP  BY c_id) rst1
--               ON rst1.c_id = c1.c_id
--        LEFT JOIN (SELECT c_id,
--                          Sum(1) AS 'sum'
--                   FROM   sc
--                   WHERE  sc.sc_score >= 70
--                          AND sc.sc_score < 85
--                   GROUP  BY c_id) rst2
--               ON rst2.c_id = c1.c_id
--        LEFT JOIN (SELECT c_id,
--                          Sum(1) AS 'sum'
--                   FROM   sc
--                   WHERE  sc.sc_score >= 60
--                          AND sc.sc_score < 70
--                   GROUP  BY c_id) rst3
--               ON rst3.c_id = c1.c_id
--        LEFT JOIN (SELECT c_id,
--                          Sum(1) AS 'sum'
--                   FROM   sc
--                   WHERE  sc.sc_score >= 0
--                          AND sc.sc_score < 60
--                   GROUP  BY c_id) rst4
--               ON rst4.c_id = c1.c_id
-- 							

-- 18.
-- 1.选出所有s2比s1同课程成绩高的
-- 2.筛选出比当前成绩高的数量少于三个的
SELECT s1.s_id, s1.c_id, s1.sc_score
FROM   sc s1
			 LEFT JOIN sc s2
			 ON s2.c_id = s1.c_id
					 AND s2.sc_score > s1.sc_score
GROUP  BY s1.s_id, s1.c_id, s1.sc_score
HAVING COUNT(s1.s_id) < 3
ORDER  BY s1.c_id, s1.sc_score DESC

-- 19.
SELECT c1.c_id, c1.c_name, COUNT(s1.s_id) AS '人数'
FROM   course c1, sc s1
WHERE  c1.c_id = s1.c_id
GROUP  BY c1.c_id, c1.c_name

-- 20.
SELECT stu.s_id, stu.s_name
FROM   student stu
			 JOIN (
					 SELECT s_id
					 FROM   sc
					 GROUP  BY s_id
					 HAVING COUNT(1) = 2
			 ) rst
			 ON	rst.s_id = stu.s_id
			 
-- 21.
SELECT stu.s_sex, COUNT(1)

FROM 	 student stu
GROUP  BY stu.s_sex

-- 22.
SELECT stu.s_id, stu.s_name
FROM  student stu
WHERE stu.s_name REGEXP '风'

-- 23.
SELECT stu1.s_name, stu1.s_sex, COUNT(*)
FROM	 student stu1
			 JOIN student stu2
				 ON stu1.s_id != stu2.s_id
						AND stu1.s_name = stu2.s_name
						AND stu1.s_sex = stu2.s_sex
GROUP  BY	stu1.s_name, stu1.s_sex

-- 24.
SELECT stu.s_id, stu.s_name, stu.s_age
FROM 	 student stu
HAVING YEAR(stu.s_age) = '1990'

-- 25.
SELECT sc.c_id, AVG(sc.sc_score) AS 'avg'
FROM	 sc
GROUP  BY sc.c_id
ORDER  BY avg DESC, sc.c_id

-- 26.
SELECT stu.s_id, stu.s_name, a.avg
FROM	 student stu
			 JOIN (
				 SELECT s_id, AVG(sc_score) AS 'avg'
				 FROM 	sc
				 GROUP  BY s_id
			 ) a
			 ON a.avg >= 85 AND a.s_id = stu.s_id
			 
-- 27.
SELECT stu.s_id, stu.s_name, s1.sc_score
FROM	 student stu
			 LEFT JOIN sc s1
						  ON s1.sc_score < 60
								 AND s1.s_id = stu.s_id
WHERE  EXISTS(
				 SELECT c1.c_id
				 FROM   course c1
				 WHERE  c1.c_name = '数学' AND c1.c_id = s1.c_id
			 )
			 
-- 28.
SELECT stu.s_id, stu.s_name
		 , a.k1 AS '01'
		 , a.k2 AS '02'
		 , a.k3 AS '03'
FROM	 student stu
			 LEFT JOIN (
					 SELECT s_id
							  , MAX(IF(c_id = '01', sc_score, NULL)) AS 'k1'
 							  , MAX(IF(c_id = '02', sc_score, NULL)) AS 'k2'
 							  , MAX(IF(c_id = '03', sc_score, NULL)) AS 'k3'
					 FROM	  sc
					 GROUP  BY s_id
			 ) a
			 ON a.s_id = stu.s_id
			 
-- 29.
SELECT stu.s_name, c1.c_name, s1.sc_score
FROM	 student stu
			 JOIN sc s1
			 ON	s1.sc_score > 70
				   AND s1.s_id = stu.s_id
			 LEFT JOIN course c1 ON c1.c_id = s1.c_id
ORDER  BY stu.s_name, s1.sc_score DESC

-- 30.
SELECT stu.s_name, c1.c_name, s1.sc_score
FROM	 student stu
			 JOIN sc s1
			  ON s1.sc_score < 60
					 AND s1.s_id = stu.s_id
		   LEFT JOIN course c1
			  ON c1.c_id = s1.c_id
				
-- 31.
SELECT stu.s_id, stu.s_name, s1.sc_score
FROM	 student stu
			 JOIN sc s1
			  ON s1.c_id = '01'
					  AND s1.sc_score > 80
						AND s1.s_id = stu.s_id
						
-- 32.
SELECT c1.c_id, c1.c_name, a.count
FROM	 course c1
			 LEFT JOIN (
					 SELECT c_id, COUNT(1) AS 'count'
					 FROM		sc
					 GROUP  BY c_id
			 ) a
			 ON a.c_id = c1.c_id
			 
-- 33.
SELECT stu.s_id 	 AS '学号'
		 , stu.s_name  AS '姓名'
		 , s1.c_id 		 AS '课程号'
		 , s1.sc_score AS '成绩'
FROM	 student stu
			 JOIN sc s1
			 ON EXISTS (
						SELECT c1.c_id
						FROM	 course c1
						WHERE  EXISTS (
										 SELECT 1 
										 FROM   teacher t1
										 WHERE  t1.t_name = '张三'
														 AND t1.t_id = c1.t_id
									) AND c1.c_id = s1.c_id
				 ) AND s1.s_id = stu.s_id
ORDER  BY s1.sc_score DESC
LIMIT  1

-- 34.
SELECT stu.s_id 	 AS '学号'
		 , stu.s_name  AS '姓名'
		 , a.c_id 		 AS '课程号'
		 , a.sc_score  AS '成绩'
FROM	 student stu
			 JOIN  (
						SELECT s1.s_id, s1.c_id, s1.sc_score
								 , @curRank := CASE
											WHEN @prevRank = s1.sc_score  THEN @curRank
											WHEN @prevRank := s1.sc_score THEN @curRank + 1
									 END AS 'rank'
						FROM  sc s1, (
										SELECT @curRank := 0, @prevRank := NULL
								 ) i
						WHERE EXISTS (
									 SELECT c1.c_id
									 FROM	  course c1
									 WHERE  EXISTS (
													 SELECT 1 
													 FROM   teacher t1
													 WHERE  t1.t_name = '张三'
																	 AND t1.t_id = c1.t_id
									 ) AND c1.c_id = s1.c_id
						)
						ORDER  BY s1.sc_score DESC
			 ) a
			 ON a.s_id = stu.s_id
WHERE  a.rank = 1

-- 35.
SELECT s1.s_id, s1.c_id, s1.sc_score
FROM	 sc s1
			 JOIN sc s2
			 ON s1.s_id = s2.s_id
					 AND s1.c_id != s2.c_id
					 AND s1.sc_score = s2.sc_score
GROUP  BY s1.s_id, s1.c_id, s1.sc_score

-- 36.
SELECT s1.s_id, s1.c_id, s1.sc_score
FROM	 sc s1
			 LEFT JOIN sc s2
			  ON s1.c_id = s2.c_id
					  AND s1.sc_score < s2.sc_score
GROUP  BY s1.s_id, s1.c_id, s1.sc_score
HAVING COUNT(s1.sc_score) < 2
ORDER  BY s1.c_id, s1.sc_score DESC

-- 37.
SELECT sc.c_id
		 , COUNT(1) AS 'count'
FROM	 sc
GROUP  BY sc.c_id
HAVING count > 5

-- 38.
SELECT sc.s_id
FROM	 sc
GROUP  BY sc.s_id
HAVING COUNT(sc.c_id) >= 2

-- 39.
SELECT sc.s_id
FROM	 sc, (
				 SELECT @count := (SELECT COUNT(1) FROM course)
		  ) a
GROUP  BY sc.s_id
HAVING COUNT(sc.c_id) = @count

-- 40.
SELECT stu.s_id AS '学号', stu.s_name AS '姓名'
		 , YEAR(NOW()) - YEAR(stu.s_age) AS 'age'
FROM	 student stu

-- 41.
SELECT stu.s_id AS '学号', stu.s_name AS '姓名'
		 , TIMESTAMPDIFF(YEAR, stu.s_age, NOW()) AS 'age'
FROM	 student stu

-- 42.
SELECT stu.s_id,stu.s_name,stu.s_age
FROM	 student stu
WHERE  WEEKOFYEAR(stu.s_age) = WEEKOFYEAR(NOW())

-- 43.
SELECT stu.s_id,stu.s_name,stu.s_age
FROM	 student stu
WHERE  WEEK(stu.s_age) = WEEK(DATE_ADD(NOW(),INTERVAL 1 WEEK))

-- 44.
SELECT stu.s_id,stu.s_name,stu.s_age
FROM	 student stu
WHERE  MONTH(stu.s_age) = MONTH(NOW())

-- 45.
SELECT stu.s_id,stu.s_name,stu.s_age
FROM	 student stu
WHERE  MONTH(stu.s_age) = MONTH(DATE_ADD(NOW(),INTERVAL 1 MONTH))