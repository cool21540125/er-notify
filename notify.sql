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
DROP TRIGGER IF EXISTS `notifyq`;
DROP VIEW IF EXISTS `all_notify_view`;

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
    ('AA', 'AA類型事件, AA 被 AA 了...'),
    ('BB', 'BB類型事件, BB 被 BB 了...'),
    ('CC', 'CC類型事件, CC 被 CC 了...'),
    ('DD', 'DD類型事件, DD 被 DD 了...'),
    ('EE', 'EE類型事件, EE 被 EE 了...'),
    ('FF', 'FF類型事件, FF 被 FF 了...'),
    ('GG', 'GG類型事件, GG 被 GG 了...');


/* 2. 推播事件 ********************************** */
CREATE TABLE `events` (
    `id`                INT                 NOT NULL AUTO_INCREMENT,
    -- `id`                INT                 NOT NULL,
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
    (1, 'factory manager'),
    (2, 'supervisor'),
    (3, 'line manager'),
    (4, 'group leader'),
    (5, 'worker');


/* 4. USER ********************************** */
CREATE TABLE `users` (
    `uid`           INT AUTO_INCREMENT,
    `fk_gid`        INT,
    `username`      VARCHAR(32),
    PRIMARY KEY (`uid`),
    FOREIGN KEY (`fk_gid`)                  REFERENCES `groups` (`gid`)
);

INSERT INTO `users` (`fk_gid`, `username`) VALUES
    (1, 'Martee'),
    (2, 'Neko'),
    (2, 'Sophie'),
    (3, 'Frank'),
    (4, 'Howard'),
    (5, 'Tony'),
    (5, 'Jason'),
    (3, 'Lyle'),
    (4, 'Andy'),
    (5, 'John'),
    (5, 'Kevin');


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
    (1, 'AA'),
    (2, 'AA'),
    (2, 'BB'),
    (5, 'DD');

/* 6. 通知表 ********************************** */
CREATE TABLE `notify` (
    `fk_evtid`          INT                 NOT NULL,
    `username`          VARCHAR(32)         NOT NULL,
    `read`              BOOLEAN,
    PRIMARY KEY (`fk_evtid`, `username`),
    FOREIGN KEY (`fk_evtid`)                  REFERENCES `events` (`id`)
);
/* 
    drop table notify;
    delete from notify;
    DESC NOTIFY;
    insert into notify (`fk_evtid`, `username`) values (1, 'Tony');
    select * from notify;
*/


/* TEST TABLE 
    drop table d1;
    create table t1 (
        `fk_evtid`          INT,
        `username`          VARCHAR(32),
        `read`              BOOLEAN
    );
    select * from d1;
*/
/* notify Trigger ********************************** */

