-- 1.
SELECT Sname,Ssex,Class FROM student;
		
-- 2.
SELECT DISTINCT Depart FROM teacher;

-- 3.
SELECT * FROM student;

-- 4.
SELECT * FROM score WHERE Degree BETWEEN 60 and 80;

-- 5.
SELECT * FROM score WHERE Degree IN(85,86,88);

-- 6.
SELECT * FROM student WHERE Class = '95031' OR Ssex = '女';

-- 7.
SELECT * FROM student ORDER BY Class DESC;

-- 8.
SELECT * FROM score ORDER BY Cno ASC,Degree DESC;

-- 9.
SELECT COUNT(Sno) as '人数' FROM student WHERE Class = '95031';

-- 10.
SELECT
	Sno as '学生学号',
	Cno as '课程学号'
FROM 
	score
WHERE
	Degree = (SELECT Max(Degree) FROM score);
	
-- 10.1.
SELECT 
	Sno as '学生学号',
	Cno as '课程学号'
FROM 
	score
WHERE
	Degree != (SELECT MAX(Degree) FROM score);
	
-- 11.
SELECT 
	score.Cno as '课程号',
	course.Cname as '课程名',
	AVG(Degree) as '平均成绩'
FROM
	score,course
WHERE
	score.Cno = course.Cno
GROUP BY
	score.Cno;
	
-- 12.
SELECT 
	Cno as 'id',
	AVG(Degree) as 'avg'
FROM
	score
WHERE
	Cno LIKE '3%'
GROUP BY
	Cno
HAVING 
	COUNT(Cno) > 5;

-- 13.
SELECT
	Sno as 'stu_id',
	Degree as 'score'
FROM
	score
WHERE 
	Degree > 70
	AND
	Degree < 90;
	
-- 14.
SELECT
	Sname as '学生姓名',
	Cno as '课程号',
	Degree as '成绩'
FROM 
	student,
	score
WHERE
	student.Sno = score.Sno;
	
-- 15.
SELECT 
	s1.Sno as '学生号',
	c1.Cname as '课程名',
	s1.Degree as '成绩'
FROM
	score s1
JOIN
	course c1
ON
	s1.Cno = c1.Cno;
	
-- 16.
SELECT 
	stu.Sname as '学生姓名',
	c1.Cname as '课程名',
	sc.Degree as '成绩'
FROM 
	score sc
JOIN
	student stu
ON
	sc.Sno = stu.Sno
JOIN
	course c1
ON
	sc.Cno = c1.Cno;

-- 17.
SELECT 
	AVG(SCORE.Degree) as 'avg'
FROM
	score
JOIN
	student
ON
	score.Sno = student.Sno
	AND
	student.Class = '95033';
	
-- 18.
SELECT
	score.Sno as '学生号',
	score.Cno as '课程号',
-- 	SCORE.Degree as '成绩',
	grade.rrank as '评分'
FROM 
	score
JOIN
	grade
ON
	score.Degree BETWEEN grade.Low AND grade.Upp;
	
-- 19.
SELECT
	student.Sno as '学生号',	student.Sname as '学生姓名',
	student.Sbirthday as '出生年月',
	student.Ssex as '性别',
	student.Class as '班级',
	score.Cno as '课程号',
	score.Degree as '成绩'
FROM
	student
JOIN
	score
ON
	student.Sno = score.Sno
WHERE
	score.Cno = '3-105'
HAVING
	score.Degree > 
	(SELECT score.Degree FROM score WHERE score.Cno = '3-105' AND score.Sno = '109');
	
-- 20.
SELECT
	s1.Sno,
	s1.Cno,
	s1.Degree as '成绩'
FROM
	score s1
WHERE
	-- 筛选出多门课程的同学
	s1.Sno IN (SELECT Sno FROM score GROUP BY Sno HAVING COUNT(Sno) > 1)
HAVING
	-- 筛选非最高成绩
	s1.Degree < (SELECT MAX(Degree) FROM score s2 WHERE s2.Sno = s1.Sno)
ORDER BY
	s1.Sno;

-- 21.
SELECT
	score.Sno as '学生号',
	score.Cno as '课程号',
	score.Degree as '成绩'
FROM
	score
WHERE
	score.Cno = '3-105'
HAVING
	score.Degree > (SELECT Degree FROM score WHERE Sno = '109' AND Cno = '3-105');
	
-- 22.
SELECT
	Sno as '学生号',
	Sname as '学生姓名',
	Sbirthday as '出生年月'
FROM
	student
WHERE
	YEAR(Sbirthday) = (SELECT YEAR(Sbirthday) FROM student WHERE Sno = '108');
	
-- 23.
SELECT
	stu.Sno as '学生号',
	stu.Sname as '学生姓名',
	stu.Class as '班级',
	stu.Ssex as '性别',
	stu.Sbirthday as '出生年月',
	c1.Cname as '课程名',
	t1.Tname as '任教老师',
	s1.Degree as '成绩'
FROM
	teacher t1
JOIN
	course c1
ON
	c1.Tno = t1.Tno
	AND
	t1.Tname = '张旭'
JOIN
	score s1
ON
	s1.Cno = c1.Cno
JOIN
	student stu
ON
	stu.Sno = s1.Sno
	
-- 24.
SELECT
	t1.Tno as '教师号',
	t1.Tname as '教师名称',
	c1.Cname as '课程名'
FROM
	teacher t1
JOIN
	course c1
ON
	c1.Cno IN (SELECT score.Cno FROM score GROUP BY Cno HAVING COUNT(*) > 5)
	AND
	c1.Tno = t1.Tno;
	
-- 25.
SELECT
	student.Sno as '学生号',
	student.Sname as '学生姓名',
	student.Ssex as '性别',
	student.Class as '班级',
	student.Sbirthday as '出生年月',
	course.Cno as '课程号',
	course.Cname as '课程名',
	score.Degree as '成绩'
FROM
	student
JOIN
	score
ON
	(student.Class = '95033' OR student.Class = '95031')
	AND
	score.Sno = student.Sno
JOIN
	course
ON
	course.Cno = score.Cno;
	
-- 26.
SELECT
	Cno
FROM 
	score
GROUP BY
	Cno
HAVING
	MAX(score.Degree) > 85;
	
-- 27.
SELECT
	score.Sno as '学生号',
	score.Cno as '课程号',
	score.Degree as '成绩'
FROM
	score
WHERE
	score.Cno IN (SELECT course.Cno FROM course WHERE course.Tno IN
									(SELECT teacher.Tno FROM teacher WHERE teacher.Depart = '计算机系'))
ORDER BY
	score.Sno;

-- 28.
-- 计算机系中不与电子工程系重复的教师信息
SELECT
	teacher.Tname as '教师姓名',
	teacher.Prof as '教师职称'
FROM
	teacher
WHERE
	teacher.Prof NOT IN 
											(SELECT Prof FROM teacher WHERE teacher.Depart = '计算机系' AND teacher.Prof IN 
											(SELECT teacher.Prof FROM teacher WHERE teacher.Depart = '电子工程系'));

-- 计算机与电子工程系所有统计中不重复的教师信息
SELECT
	teacher.Tname as '教师名称',
	teacher.Prof as '教师职称'
FROM
	teacher
WHERE
	teacher.Prof IN 
		(	SELECT
				teacher.Prof
			FROM 
				teacher
			WHERE 
				teacher.Depart = '计算机系' OR teacher.Depart = '电子工程系'
			GROUP BY
				teacher.Prof HAVING COUNT(*) = 1)
				
-- 29.
-- 个人认为这题目需要筛选掉符合成绩要求但自己也是3-245的最低分（代码注释部分）
SELECT
	s1.Sno,
	s1.Cno,
	s1.Degree 
FROM
	score s1 
WHERE
	s1.Cno = '3-105' 
HAVING
	s1.Degree > ( SELECT MIN( Degree ) FROM score s2 WHERE s2.Cno = '3-245' ) 
-- 	AND s1.Sno NOT IN (
-- 	SELECT
-- 		Sno 
-- 	FROM
-- 		score 
-- 	WHERE
-- 		Cno = '3-245' 
-- 		AND Degree =(
-- 		SELECT
-- 			MIN( Degree ) 
-- 		FROM
-- 			score s2 
-- 		WHERE
-- 			s2.Cno = '3-245' 
-- 		));

-- 30.
-- 第一种
-- 既3-105也3-245的同学，3-105成绩比3-245高的
SELECT
	a.Cno AS '课程号',
	a.Sno AS '学生号',
	a.Degree AS '成绩'
FROM
	(SELECT Cno,Sno,Degree FROM score WHERE Cno = '3-245') as a
JOIN
	(SELECT Cno,Sno,Degree FROM score WHERE Cno = '3-105') as b
ON
	a.Sno = b.Sno
	AND
	b.Degree > a.Degree;

-- 第二种
-- 只要选修了3-105的学生，成绩必须全部大于3-245的
SELECT
	s1.Cno AS '课程号',
	s1.Sno AS '学生号',
	s1.Degree AS '成绩'
FROM
	score s1
WHERE
	s1.Cno = '3-105'
	AND
	s1.Degree > ALL(SELECT s2.Degree FROM score s2 WHERE s2.Cno = '3-245')
	
-- 31.
SELECT
	student.Sname AS '姓名',
	student.Ssex AS '性别',
	student.Sbirthday AS '出生年月'
FROM
	student
UNION ALL
SELECT
	teacher.Tname AS '姓名',
	teacher.Tsex AS '性别',
	teacher.Tbirthday AS '出生年月'
FROM
	teacher
	
-- 32.
SELECT
	student.Sname AS '姓名',
	student.Ssex AS '性别',
	student.Sbirthday AS '出生年月'
FROM
	student
WHERE
	student.Ssex = '女'
UNION
SELECT
	teacher.Tname AS '姓名',
	teacher.Tsex AS '性别',
	teacher.Tbirthday AS '性别'
FROM
	teacher
WHERE
	teacher.Tsex = '女'
	
-- 33.
-- 第一种方法
SELECT
	s1.Sno AS '学生号',
	s1.Cno AS '课程号',
	s1.Degree AS '成绩',
	a.avg AS '平均分' 
FROM
	score s1
	JOIN ( SELECT Cno, AVG( Degree ) AS avg FROM score GROUP BY Cno ) AS a ON s1.Cno = a.Cno 
	AND s1.Degree < a.avg
	
-- 第二种方法
SELECT
	s1.Sno,
	s1.Cno,
	s1.Degree 
FROM
	score s1 
WHERE
	s1.Degree < ( SELECT AVG( Degree ) FROM score s2 WHERE s2.Cno = s1.Cno )

-- 34.
-- 注意这里是任课教师，需要参考成绩表
SELECT
	teacher.Tname AS '教师名称',
	teacher.Depart AS '系部' 
FROM
	teacher 
WHERE
	teacher.Tno IN 
		( SELECT course.Tno FROM course WHERE Cno IN 
			( SELECT score.Cno FROM score GROUP BY score.Cno ) );
			
-- 35.
SELECT
	teacher.Tname AS '教师名称',
	teacher.Depart AS '系部' 
FROM
	teacher 
WHERE
	teacher.Tno NOT IN
		( SELECT course.Tno FROM course WHERE course.Cno IN
			( SELECT score.Cno FROM score GROUP BY score.Cno ) );
			
-- 36.
SELECT 
	student.Class AS '班级号', 
	COUNT( 1 ) AS '人数' 
FROM 
	student 
WHERE 
	student.Ssex = '男' 
GROUP BY 
	student.Class 
HAVING 
	人数 >= 2
	
-- 37.
-- 尽量避免使用NOT
SELECT
	student.Sno AS '学生号',
	student.Sname AS '学生姓名'
FROM
	student
WHERE
	student.Sname REGEXP '^[^王]';
	
-- 38.
SELECT
	student.Sname AS '学生姓名',
	YEAR(NOW()) - YEAR(student.Sbirthday) AS '年龄'
FROM
	student
	
-- 39
SELECT
	MIN(student.Sbirthday) AS '最大',
	MAX(student.Sbirthday) AS '最小'
FROM
	student
	
-- 40.
SELECT
	student.Sno AS '学生号',
	student.Sname AS '学生姓名',
	student.Ssex AS '性别',
	student.Class AS '班级',
	student.Sbirthday AS '出生年月'
FROM
	student
ORDER BY
	student.Sbirthday ASC,
	student.Class DESC
	
-- 41.
SELECT
	teacher.Tname AS '教师姓名',
	teacher.Tsex AS '性别',
	course.Cname AS '课程'
FROM
	teacher,
	course
WHERE
	teacher.Tno = course.Tno
HAVING
	teacher.Tsex = '男'
	
-- 42.
SELECT
	score.Sno AS '学生号',
	score.Cno AS '课程号',
	score.Degree AS '成绩'
FROM
	score
WHERE
	score.Degree IN (SELECT MAX(Degree) FROM score);
	
-- 43.
SELECT
	student.Sname
FROM
	student
WHERE
	student.Ssex IN
		(SELECT student.Ssex FROM student WHERE student.Sname = '李军')
HAVING
	student.Sname != '李军'
	
-- 44.
SELECT
	student.Sname
FROM
	student
WHERE
	student.Ssex IN
		(SELECT student.Ssex FROM student WHERE student.Sname = '李军')
	AND
	student.Class IN
		(SELECT student.Class FROM student WHERE student.Sname = '李军')
HAVING
	student.Sname != '李军';
	
-- 45.
SELECT
	c.Sno AS '学生号',
	c.Sname AS '学生姓名',
	c.Ssex AS '性别',
	a.Cno AS '课程号',
	a.Cname AS '课程名',
	b.Degree AS '成绩'
FROM
	course a
JOIN
	score b
ON
	a.Cno = b.Cno
JOIN
	student c
ON
	c.Sno = b.Sno
HAVING
	c.Ssex = '男'
	AND
	a.Cname = '计算机导论'