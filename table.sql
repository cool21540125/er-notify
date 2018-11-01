/*
    author: Tony
    date: 2018/10/19
    developer: James
    manager: YK, Howard
    assist: Jason

    description: Line Message 及 網頁事件推播 的 Table

    ER-Model v0.1
    版本參考 edition.md
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
    ('fatal', '嚴重異常'),
    ('error', '中等錯誤'),
    ('warn', '輕微警告'),
    ('info', '一般訊息'),
    ('period', '定時資訊');


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
    (1, '董事會'),
    (2, '管理階層'),
    (3, '勞碌RD');


/* 4. USER ********************************** */
CREATE TABLE `users` (
    `uid`           INT AUTO_INCREMENT,
    `fk_gid`        INT,
    `username`      VARCHAR(32),
    PRIMARY KEY (`uid`),
    FOREIGN KEY (`fk_gid`)                  REFERENCES `groups` (`gid`)
);

INSERT INTO `users` (`fk_gid`, `username`) VALUES
    (1, 'Mrte'),
    (1, 'Soph'),
    (2, 'Frnk'),
    (3, 'Howr'),
    (3, 'Tony'),
    (3, 'Andy');


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
    (1, 'fatal'),
    (1, 'error'),
    (1, 'info'),
    (2, 'fatal'),
    (2, 'period'),
    (2, 'warn'),
    (3, 'info'),
    (3, 'period');

/* 6. 通知表 ********************************** */
CREATE TABLE `notify` (
    `fk_evtid`          INT                 NOT NULL,
    `fk_uid`            INT                 NOT NULL,
    `read`              BOOLEAN,
    PRIMARY KEY (`fk_evtid`, `fk_uid`),
    FOREIGN KEY (`fk_evtid`)                  REFERENCES `events` (`id`),
    FOREIGN KEY (`fk_uid`)                    REFERENCES `users` (`uid`)
);


-- ======================================================================

-- SELECT * FROM `groups`;
-- SELECT * FROM `users`;
-- SELECT * FROM `subscribe`;

-- SELECT 
--     uu.username `User`, uu.fk_gid `gid`, ss.fk_etype `event type`
-- FROM 
--     users uu JOIN subscribe ss ON uu.fk_gid = ss.fk_gid;
