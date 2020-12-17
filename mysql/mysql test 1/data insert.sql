CREATE DATABASE IF NOT EXISTS TEST1;

USE TEST1;

-- ѧ����
CREATE TABLE IF NOT EXISTS STUDENT (
	Sno char(3) NOT NULL,
	Sname char(8) NOT NULL,
	Ssex char(2) NOT NULL,
	Sbirthday datetime,
	Class char(5),
	PRIMARY KEY(Sno)
);

-- ��ʦ��
CREATE TABLE IF NOT EXISTS TEACHER (
	Tno char(3) NOT NULL,
	Tname char(4) NOT NULL,
	Tsex char(2) NOT NULL,
	Tbirthday datetime,
	Prof char(6),
	Depart varchar(10) NOT NULL,
	PRIMARY KEY(Tno)
);

-- �γ̱�
CREATE TABLE IF NOT EXISTS COURSE (
	Cno char(5) NOT NULL,
	Cname varchar(10) NOT NULL,
	Tno char(3) NOT NULL,
	PRIMARY KEY(Cno),
	CONSTRAINT fk_course_tno_tea_tno FOREIGN KEY(Tno) REFERENCES TEACHER(Tno)
);

-- �ɼ���
CREATE TABLE IF NOT EXISTS SCORE (
	Sno char(3) NOT NULL,
	Cno char(5) NOT NULL,
	Degree Decimal(4,1),
	CONSTRAINT fk_score_sno_stu_sno FOREIGN KEY(Sno) REFERENCES STUDENT(Sno),
	CONSTRAINT fk_score_cno_course_cno FOREIGN KEY(Cno) REFERENCES COURSE(Cno)
);

-- ����ѧ����
INSERT INTO STUDENT
	(Sno,Sname,Ssex,Sbirthday,Class) 
VALUES
	('108','����','��','1977-09-01','95033'),
	('105','����','��','1975-10-02','95031'),
	('107','����','Ů','1976-01-23','95033'),
	('101','���','��','1976-02-20','95033'),
	('109','����','Ů','1975-02-10','95031'),
	('103','½��','��','1974-06-03','95031');

-- ����γ̱�
INSERT INTO COURSE
	(Cno,Cname,Tno) 
VALUES 
	('3-105','���������','825'),
	('3-245','����ϵͳ','804'),
	('6-166','���ֵ�·','856'),
	('9-888','�ߵ���ѧ','831');

-- ����ɼ���
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

-- �����ʦ��
INSERT INTO TEACHER 
	(Tno,Tname,Tsex,Tbirthday,Prof,Depart) 
VALUES
	('804','���','��','1958-12-02','������','�����ϵ'),
	('856','����','��','1969-03-12','��ʦ','���ӹ���ϵ'),
	('825','��Ƽ','Ů','1972-05-05','����','�����ϵ'),
	('831','����','Ů','1977-08-14','����','���ӹ���ϵ');