/*
    author: Tony
    date: 2018/10/19
    developer: James
    manager: YK, Howard
    assist: Jason

    description: Line Message 及 網頁事件推播 的 Table
*/

/* ************************************************************************* */
USE `mysql`

DROP DATABASE `notify`;

CREATE DATABASE IF NOT EXISTS `notify` CHARACTER SET `utf8` COLLATE `utf8_unicode_ci`;

CREATE USER IF NOT EXISTS 'admin'@'%' IDENTIFIED BY 'pomeswrd';
GRANT ALL ON `notify`.`*` TO 'admin'@'%';

/* ************************************************************************* */
USE `notify`;

DROP TABLE IF EXISTS `notify`;
DROP TABLE IF EXISTS `subscribe`;
DROP TABLE IF EXISTS `events`;
DROP TABLE IF EXISTS `users`;
DROP TABLE IF EXISTS `groups`;
DROP TABLE IF EXISTS `event_type`;

/* ************************************************************************* */

/* 1. 事件類型 ********************************** */
CREATE TABLE `event_type` (
    `etype`             VARCHAR(16)         NOT NULL,
    `desc`              VARCHAR(64)         NOT NULL,
    PRIMARY KEY (`etype`)
);

/* YK 協助整理
    etype 的所有事件類型(盡量每種事件類型可以互斥, 並無上下階層之劃分)
*/
INSERT INTO `event_type` (`etype`, `desc`) VALUES 
    ('A', '天災'),
    ('B', '阿共亂射'),
    ('C', '老美哭妖'),
    ('D', '不倫戀情'),
    ('E', '呆灣價值'),
    ('F', '天下大小事');


/* 2. 推播事件 ********************************** */
CREATE TABLE `events` (
    `id`                INT                 NOT NULL AUTO_INCREMENT,
    `fk_etype`          VARCHAR(16)         NOT NULL,
    `dt`                DATETIME            NOT NULL,
    `content`           VARCHAR(64)         NOT NULL,
    PRIMARY KEY (`id`),
    FOREIGN KEY (`fk_etype`)               REFERENCES `event_type` (`etype`)
);

/* 等候觸發器建立後, 再來建立事件 */


/* 3. GROUPS ********************************** */
CREATE TABLE `groups` (
    `gid`           INT,
    `groupname`     VARCHAR(16),
    PRIMARY KEY (`gid`)
);

INSERT INTO `groups` (`gid`, `groupname`) VALUES
    (1, '統治階層'),
    (2, '權力操弄'),
    (3, '工作單位'),
    (4, '洗腦單位');


/* 4. USER ********************************** */
CREATE TABLE `users` (
    `uid`           INT AUTO_INCREMENT,
    `fk_gid`        INT,
    `username`      VARCHAR(32),
    PRIMARY KEY (`uid`),
    FOREIGN KEY (`fk_gid`)                  REFERENCES `groups` (`gid`)
);

INSERT INTO `users` (`fk_gid`, `username`) VALUES
    (1, '菜無感'),
    (1, '馬阿狗'),
    (1, '幹話德'),
    (1, '花錢媽'),
    (2, '幹話德'),
    (2, '花錢媽'),
    (2, '玩世姦'),
    (3, '鐵血哲'),
    (3, '胡老賊'),
    (3, '剪綵倫'),
    (4, '玩世姦'),
    (4, '冥視電台'),
    (4, '陰森電台');


/* 5. 訂閱表 ********************************** */
CREATE TABLE `subscribe` (
    `id`                INT                 NOT NULL AUTO_INCREMENT,
    `fk_gid`            INT                 NOT NULL,
    `fk_etype`          VARCHAR(16)         NOT NULL,
    PRIMARY KEY (`id`),
    FOREIGN KEY (`fk_gid`)                  REFERENCES `groups` (`gid`),
    FOREIGN KEY (`fk_etype`)                REFERENCES `event_type` (`etype`)
);

INSERT INTO `subscribe` (`fk_gid`, `fk_etype`) VALUES 
    (1, 'A'),
    (1, 'B'),
    (1, 'C'),
    (1, 'E'),
    (2, 'B'),
    (2, 'C'),
    (2, 'D'),
    (3, 'A'),
    (3, 'F'),
    (4, 'A'),
    (4, 'B'),
    (4, 'C'),
    (4, 'D'),
    (4, 'E'),
    (4, 'F');

/* 6. 通知表 ********************************** */
CREATE TABLE `notify` (
    `fk_evtid`          INT                 NOT NULL,
    `username`          VARCHAR(32)         NOT NULL,
    `read`              BOOLEAN,
    PRIMARY KEY (`fk_evtid`, `username`),
    FOREIGN KEY (`fk_evtid`)                  REFERENCES `events` (`id`)
);


-- ======================================================================

SELECT * FROM `groups`;
SELECT * FROM `users`;
SELECT * FROM `subscribe`;

SELECT 
    uu.username `User`, uu.fk_gid `gid`, ss.fk_etype `event type`
FROM 
    users uu JOIN subscribe ss ON uu.fk_gid = ss.fk_gid;
