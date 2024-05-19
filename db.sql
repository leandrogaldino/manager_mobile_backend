CREATE DATABASE IF NOT EXISTS `manager` DEFAULT CHARACTER SET utf8;
USE `manager`;

CREATE TABLE IF NOT EXISTS `person` (
  `id` INT PRIMARY KEY,
  `document` VARCHAR(18) NOT NULL,
  `name` VARCHAR(255) NOT NULL,
  `istechnician` INT NOT NULL,
  `iscustomer` INT NOT NULL,
  `accesscode` VARCHAR(10)
);

CREATE TABLE IF NOT EXISTS `compressor` (
  `id` INT PRIMARY KEY,
  `personid` INT NOT NULL,
  `name` VARCHAR(50) NOT NULL,
  FOREIGN KEY (`personid`) REFERENCES `person`(`id`) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS `compressorcoalescent` (
	`id` INT PRIMARY KEY,
  `compressorid` INT,
  `name` varchar(50) NOT NULL,
  FOREIGN KEY (`compressorid`) REFERENCES `compressor`(`id`) ON DELETE CASCADE
);



CREATE TABLE IF NOT EXISTS `evaluation` (
  `id` INT PRIMARY KEY AUTO_INCREMENT,
  `creation` DATE NOT NULL,
  `customerid` INT NOT NULL,
  `compressorid` INT NOT NULL,
  `starttime` TIME,
  `endtime` TIME,
  `horimeter` INT NOT NULL,
  `airfilter` INT NOT NULL,
  `oilfilter` INT NOT NULL,
  `separator` INT NOT NULL,
  `oiltype` INT NOT NULL,
  `oil` INT NOT NULL,
  `technicaladvice` TEXT,
  `responsible` VARCHAR(50) NOT NULL,
  `signaturepath` TEXT NOT NULL,
  FOREIGN KEY (`customerid`) REFERENCES `person`(`id`),
  FOREIGN KEY (`compressorid`) REFERENCES `compressor`(`id`)
);

CREATE TABLE IF NOT EXISTS `evaluationcoalescent` (
  `id` INT PRIMARY KEY AUTO_INCREMENT,
  `evaluationid`INT,
  `compressorcoalescentid` INT,
  `nextchange` DATE NOT NULL,
  FOREIGN KEY (`compressorcoalescentid`) REFERENCES `compressorcoalescent`(`id`),
  FOREIGN KEY (`evaluationid`) REFERENCES `evaluation`(`id`) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS `evaluationtechnician` (
  `id` INT PRIMARY KEY AUTO_INCREMENT,
  `evaluationid` INT NOT NULL,
  `personid` INT NOT NULL,
  FOREIGN KEY (`evaluationid`) REFERENCES `evaluation`(`id`) ON DELETE CASCADE,
  FOREIGN KEY (`personid`) REFERENCES `person`(`id`),
  UNIQUE (`personid`, `evaluationid`)
);

CREATE TABLE IF NOT EXISTS `evaluationphoto` (
  `id` INT PRIMARY KEY AUTO_INCREMENT,
  `evaluationid` INT NOT NULL,
  `photopath` TEXT NOT NULL,
  FOREIGN KEY (`evaluationid`) REFERENCES `evaluation`(`id`) ON DELETE CASCADE
);

INSERT INTO person (`id`, `document`, `name`, `istechnician`, `iscustomer`, `accesscode`) VALUES (1, '11.111.111/1111-11', 'Cliente 1', 0, 0, 'abc');
INSERT INTO person (`id`, `document`, `name`, `istechnician`, `iscustomer`, `accesscode`) VALUES (2, '22.222.222/2222-22', 'Cliente 2', 1, 1, NULL);
INSERT INTO person (`id`, `document`, `name`, `istechnician`, `iscustomer`, `accesscode`) VALUES (3, '33.333.333/3333-33', 'Cliente 3', 0, 1, NULL);
INSERT INTO person (`id`, `document`, `name`, `istechnician`, `iscustomer`, `accesscode`) VALUES (4, '44.444.444/4444-44', 'Cliente 4', 1, 0, NULL);
INSERT INTO person (`id`, `document`, `name`, `istechnician`, `iscustomer`, `accesscode`) VALUES (5, '55.555.555/5555-55', 'Cliente 5', 0, 0, NULL);
INSERT INTO person (`id`, `document`, `name`, `istechnician`, `iscustomer`, `accesscode`) VALUES (6, '66.666.666/6666-66', 'Cliente 6', 1, 1, NULL);
INSERT INTO person (`id`, `document`, `name`, `istechnician`, `iscustomer`, `accesscode`) VALUES (7, '77.777.777/7777-77', 'Cliente 7', 0, 1, NULL);
INSERT INTO person (`id`, `document`, `name`, `istechnician`, `iscustomer`, `accesscode`) VALUES (8, '88.888.888/8888-88', 'Cliente 8', 1, 0, NULL);
INSERT INTO person (`id`, `document`, `name`, `istechnician`, `iscustomer`, `accesscode`) VALUES (9, '99.999.999/9999-99', 'Cliente 9', 0, 0, NULL);
INSERT INTO person (`id`, `document`, `name`, `istechnician`, `iscustomer`, `accesscode`) VALUES (10, '10.000.000/0000-00', 'Cliente 10', 1, 1, NULL);

INSERT INTO compressor (`id`, `personid`, `name`) VALUES (1, 1, 'Compressor 1 Pessoa 1');
INSERT INTO compressor (`id`, `personid`, `name`) VALUES (2, 1, 'Compressor 2 Pessoa 1');
INSERT INTO compressor (`id`, `personid`, `name`) VALUES (3, 2, 'Compressor 3 Pessoa 2');
INSERT INTO compressor (`id`, `personid`, `name`) VALUES (4, 2, 'Compressor 4 Pessoa 2');
INSERT INTO compressor (`id`, `personid`, `name`) VALUES (5, 2, 'Compressor 5 Pessoa 2');


INSERT INTO compressorcoalescent (`id`, `compressorid`, `name`) VALUES (1, 1, 'Coalescent 1 Compressor 1');
INSERT INTO compressorcoalescent (`id`, `compressorid`, `name`) VALUES (2, 1, 'Coalescent 2 Compressor 1');
INSERT INTO compressorcoalescent (`id`, `compressorid`, `name`) VALUES (3, 1, 'Coalescent 3 Compressor 1');

INSERT INTO compressorcoalescent (`id`, `compressorid`, `name`) VALUES (4, 2, 'Coalescent 4 Compressor 2');
INSERT INTO compressorcoalescent (`id`, `compressorid`, `name`) VALUES (5, 2, 'Coalescent 5 Compressor 2');
INSERT INTO compressorcoalescent (`id`, `compressorid`, `name`) VALUES (6, 2, 'Coalescent 6 Compressor 2');

INSERT INTO compressorcoalescent (`id`, `compressorid`, `name`) VALUES (7, 3, 'Coalescent 7 Compressor 3');
INSERT INTO compressorcoalescent (`id`, `compressorid`, `name`) VALUES (8, 3, 'Coalescent 8 Compressor 3');
INSERT INTO compressorcoalescent (`id`, `compressorid`, `name`) VALUES (9, 3, 'Coalescent 9 Compressor 3');

INSERT INTO compressorcoalescent (`id`, `compressorid`, `name`) VALUES (10, 4, 'Coalescent 10 Compressor 4');
INSERT INTO compressorcoalescent (`id`, `compressorid`, `name`) VALUES (11, 4, 'Coalescent 11 Compressor 4');
INSERT INTO compressorcoalescent (`id`, `compressorid`, `name`) VALUES (12, 4, 'Coalescent 12 Compressor 4');

INSERT INTO compressorcoalescent (`id`, `compressorid`, `name`) VALUES (13, 5, 'Coalescent 13 Compressor 5');
INSERT INTO compressorcoalescent (`id`, `compressorid`, `name`) VALUES (14, 5, 'Coalescent 14 Compressor 5');
INSERT INTO compressorcoalescent (`id`, `compressorid`, `name`) VALUES (15, 5, 'Coalescent 15 Compressor 5');

/*
INSERT INTO evaluation VALUES (NULL, '2024-02-01', 2, 3, '16:30:02', '17:02:36', 12744, 544, 544, 2544, 1, 2544, 'Compressor em funcionamento.', 'Fulano', 'www.gcp/manager/sign1');
INSERT INTO evaluation VALUES (NULL, '2024-02-02', 2, 3, '16:30:02', '17:02:36', 12744, 544, 544, 2544, 1, 2544, 'Compressor em funcionamento.', 'Fulano', 'www.gcp/manager/sign1');
INSERT INTO evaluation VALUES (NULL, '2024-02-03', 2, 3, '16:30:02', '17:02:36', 12744, 544, 544, 2544, 1, 2544, 'Compressor em funcionamento.', 'Fulano', 'www.gcp/manager/sign1');
INSERT INTO evaluation VALUES (NULL, '2024-02-04', 2, 3, '16:30:02', '17:02:36', 12744, 544, 544, 2544, 1, 2544, 'Compressor em funcionamento.', 'Fulano', 'www.gcp/manager/sign1');
INSERT INTO evaluation VALUES (NULL, '2024-02-05', 2, 3, '16:30:02', '17:02:36', 12744, 544, 544, 2544, 1, 2544, 'Compressor em funcionamento.', 'Fulano', 'www.gcp/manager/sign1');
INSERT INTO evaluation VALUES (NULL, '2024-02-06', 2, 3, '16:30:02', '17:02:36', 12744, 544, 544, 2544, 1, 2544, 'Compressor em funcionamento.', 'Fulano', 'www.gcp/manager/sign1');
INSERT INTO evaluation VALUES (NULL, '2024-02-07', 2, 3, '16:30:02', '17:02:36', 12744, 544, 544, 2544, 1, 2544, 'Compressor em funcionamento.', 'Fulano', 'www.gcp/manager/sign1');
INSERT INTO evaluation VALUES (NULL, '2024-02-08', 2, 3, '16:30:02', '17:02:36', 12744, 544, 544, 2544, 1, 2544, 'Compressor em funcionamento.', 'Fulano', 'www.gcp/manager/sign1');
INSERT INTO evaluation VALUES (NULL, '2024-02-09', 2, 3, '16:30:02', '17:02:36', 12744, 544, 544, 2544, 1, 2544, 'Compressor em funcionamento.', 'Fulano', 'www.gcp/manager/sign1');
INSERT INTO evaluation VALUES (NULL, '2024-02-10', 2, 3, '16:30:02', '17:02:36', 12744, 544, 544, 2544, 1, 2544, 'Compressor em funcionamento.', 'Fulano', 'www.gcp/manager/sign1');


INSERT INTO evaluationtechnician VALUES (NULL, 2, 1);
INSERT INTO evaluationtechnician VALUES (NULL, 4, 2);
INSERT INTO evaluationtechnician VALUES (NULL, 4, 3);
INSERT INTO evaluationtechnician VALUES (NULL, 4, 4);
INSERT INTO evaluationtechnician VALUES (NULL, 4, 5);
INSERT INTO evaluationtechnician VALUES (NULL, 4, 6);
INSERT INTO evaluationtechnician VALUES (NULL, 4, 7);
INSERT INTO evaluationtechnician VALUES (NULL, 4, 8);
INSERT INTO evaluationtechnician VALUES (NULL, 4, 9);
INSERT INTO evaluationtechnician VALUES (NULL, 4, 10);

INSERT INTO evaluationcoalescent VALUES (NULL, 7, 1, '2024-04-20');
INSERT INTO evaluationcoalescent VALUES (NULL, 8, 2, '2024-04-20');
INSERT INTO evaluationcoalescent VALUES (NULL, 9, 3, '2024-04-20');
INSERT INTO evaluationcoalescent VALUES (NULL, 9, 4, '2024-04-20');
INSERT INTO evaluationcoalescent VALUES (NULL, 9, 5, '2024-04-20');
INSERT INTO evaluationcoalescent VALUES (NULL, 9, 6, '2024-04-20');
INSERT INTO evaluationcoalescent VALUES (NULL, 9, 7, '2024-04-20');
INSERT INTO evaluationcoalescent VALUES (NULL, 9, 8, '2024-04-20');
INSERT INTO evaluationcoalescent VALUES (NULL, 9, 9, '2024-04-20');
INSERT INTO evaluationcoalescent VALUES (NULL, 9, 10, '2024-04-20');

INSERT INTO evaluationphoto VALUES(NULL, 1, 'https://storage.cloud.google.com/manager-mobile/photo1.jpg');
INSERT INTO evaluationphoto VALUES(NULL, 2, 'https://storage.cloud.google.com/manager-mobile/photo2.jpg');
INSERT INTO evaluationphoto VALUES(NULL, 3, 'https://storage.cloud.google.com/manager-mobile/photo3.jpg');
INSERT INTO evaluationphoto VALUES(NULL, 4, 'https://storage.cloud.google.com/manager-mobile/photo4.jpg');
INSERT INTO evaluationphoto VALUES(NULL, 5, 'https://storage.cloud.google.com/manager-mobile/photo5.jpg');
INSERT INTO evaluationphoto VALUES(NULL, 6, 'https://storage.cloud.google.com/manager-mobile/photo6.jpg');
INSERT INTO evaluationphoto VALUES(NULL, 7, 'https://storage.cloud.google.com/manager-mobile/photo7.jpg');
INSERT INTO evaluationphoto VALUES(NULL, 8, 'https://storage.cloud.google.com/manager-mobile/photo8.jpg');
INSERT INTO evaluationphoto VALUES(NULL, 9, 'https://storage.cloud.google.com/manager-mobile/photo9.jpg');
INSERT INTO evaluationphoto VALUES(NULL, 10, 'https://storage.cloud.google.com/manager-mobile/photo10.jpg');
*/