CREATE DATABASE IF NOT EXISTS TEST1;

USE TEST1;

-- 学生表
CREATE TABLE IF NOT EXISTS STUDENT (
	Sno char(3) NOT NULL,
	Sname char(8) NOT NULL,
	Ssex char(2) NOT NULL,
	Sbirthday datetime,
	Class char(5),
	PRIMARY KEY(Sno)
);

-- 教师表
CREATE TABLE IF NOT EXISTS TEACHER (
	Tno char(3) NOT NULL,
	Tname char(4) NOT NULL,
	Tsex char(2) NOT NULL,
	Tbirthday datetime,
	Prof char(6),
	Depart varchar(10) NOT NULL,
	PRIMARY KEY(Tno)
);

-- 课程表
CREATE TABLE IF NOT EXISTS COURSE (
	Cno char(5) NOT NULL,
	Cname varchar(10) NOT NULL,
	Tno char(3) NOT NULL,
	PRIMARY KEY(Cno),
	CONSTRAINT fk_course_tno_tea_tno FOREIGN KEY(Tno) REFERENCES TEACHER(Tno)
);

-- 成绩表
CREATE TABLE IF NOT EXISTS SCORE (
	Sno char(3) NOT NULL,
	Cno char(5) NOT NULL,
	Degree Decimal(4,1),
	CONSTRAINT fk_score_sno_stu_sno FOREIGN KEY(Sno) REFERENCES STUDENT(Sno),
	CONSTRAINT fk_score_cno_course_cno FOREIGN KEY(Cno) REFERENCES COURSE(Cno)
);

-- 插入学生表
INSERT INTO STUDENT
	(Sno,Sname,Ssex,Sbirthday,Class) 
VALUES
	('108','曾华','男','1977-09-01','95033'),
	('105','匡明','男','1975-10-02','95031'),
	('107','王丽','女','1976-01-23','95033'),
	('101','李军','男','1976-02-20','95033'),
	('109','王芳','女','1975-02-10','95031'),
	('103','陆军','男','1974-06-03','95031');

-- 插入课程表
INSERT INTO COURSE
	(Cno,Cname,Tno) 
VALUES 
	('3-105','计算机导论','825'),
	('3-245','操作系统','804'),
	('6-166','数字电路','856'),
	('9-888','高等数学','831');

-- 插入成绩表
INSERT INTO SCORE
	(Sno,Cno,Degree) 
VALUES 
	('103','3-245',86),
	('105','3-245',75),
	('109','3-245',68),
	('103','3-105',92),
	('105','3-105',88),
	('109','3-105',76),
	('101','3-105',64),
	('107','3-105',91),
	('108','3-105',78),
	('101','6-166',85),
	('107','6-166',79),
	('108','6-166',81);

-- 插入教师表
INSERT INTO TEACHER 
	(Tno,Tname,Tsex,Tbirthday,Prof,Depart) 
VALUES
	('804','李诚','男','1958-12-02','副教授','计算机系'),
	('856','张旭','男','1969-03-12','讲师','电子工程系'),
	('825','王萍','女','1972-05-05','助教','计算机系'),
	('831','刘冰','女','1977-08-14','助教','电子工程系');