-- source D:/proj/sql_trigger/tgr.sql

USE `notify`;

DROP TRIGGER IF EXISTS `notifyq`;
-- delete from `notify`;
-- delete from `events`;

DELIMITER $$

-- Trigger1 - 事件發生後, 增加通知記錄
CREATE TRIGGER `notifyq` AFTER INSERT ON `events`
    FOR EACH ROW 
    Block1: BEGIN
        DECLARE v1_gid          INT;
        DECLARE v1_etype        VARCHAR(16);
        DECLARE done1           INT DEFAULT 0;
        DECLARE cur1_subscribe CURSOR FOR (SELECT `fk_gid`, `fk_etype` FROM `subscribe` WHERE `fk_etype` = NEW.fk_etype);
        DECLARE CONTINUE HANDLER FOR NOT FOUND SET done1 = 1;

        OPEN cur1_subscribe;
        get_uid: LOOP
            FETCH cur1_subscribe INTO v1_gid, v1_etype;
            IF done1 = 1 THEN
                LEAVE get_uid;
            END IF;
            -- insert into t3 (`x1`, `x2`) VALUES (NEW.id, NEW.fk_etype);
            -- insert into t3 (`x1`, `x2`) VALUES (v1_gid, v1_etype);
            SET @gid = v1_gid;

            IF v1_etype = NEW.fk_etype THEN
                Block2: BEGIN
                    DECLARE v2_gid          INT;
                    DECLARE v2_username     VARCHAR(32);
                    DECLARE done2           INT DEFAULT 0;
                    DECLARE cur2_users CURSOR FOR (SELECT `fk_gid`, `username` FROM `users` WHERE `fk_gid` = @gid);
                    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done2 = 1;

                    OPEN cur2_users;
                    get_username: LOOP
                        FETCH cur2_users INTO v2_gid, v2_username;
                        IF done2 = 1 THEN
                            LEAVE get_username;
                        END IF;
                        -- insert into t3 (`x1`, `x2`) VALUES (v2_gid, v2_username);

                        IF v1_gid = v2_gid THEN
                            INSERT INTO `notify` (`fk_evtid`, `username`, `read`) VALUES (NEW.ID, v2_username, 0);
                            -- INSERT INTO `t0` (`fk_evtid`, `username`, `read`) VALUES (NEW.ID, v2_username, 0);
                            -- insert into t1(`x1`) values (v2_gid);
                            -- insert into t2(`fk_evtid`, `fk_gid`, `fk_etype`, `username`) values (NEW.ID, v1_gid, v1_etype, v2_username);
                        END IF;
                    END LOOP get_username;
                    CLOSE cur2_users;
                END Block2;
            END IF;
        END LOOP get_uid;
        CLOSE cur1_subscribe;
    END Block1; 
$$
DELIMITER ;

-- SHOW TRIGGERS FROM `notify`\G;

-- 觸發事件 ***************************************************************************************************

INSERT INTO `events` (`fk_etype`, `dt`, `content`) VALUES ('A', CURRENT_TIMESTAMP(), '新客戶台雞店到手!');
INSERT INTO `events` (`fk_etype`, `dt`, `content`) VALUES ('B', CURRENT_TIMESTAMP(), 'Andy跑去廁所2小時了!');
INSERT INTO `events` (`fk_etype`, `dt`, `content`) VALUES ('B', CURRENT_TIMESTAMP(), 'Howr欺騙公司外籍勞工');
INSERT INTO `events` (`fk_etype`, `dt`, `content`) VALUES ('A', CURRENT_TIMESTAMP(), '與廉墊關係惡化');
INSERT INTO `events` (`fk_etype`, `dt`, `content`) VALUES ('C', CURRENT_TIMESTAMP(), '工業8.7最新消息指出...');
INSERT INTO `events` (`fk_etype`, `dt`, `content`) VALUES ('D', CURRENT_TIMESTAMP(), '公司投資的金融商品暴漲300%');
INSERT INTO `events` (`fk_etype`, `dt`, `content`) VALUES ('E', CURRENT_TIMESTAMP(), '產品延誤~~ 年底會好嗎?');

-- 觸發事件 ***************************************************************************************************

-- select * from events;
-- select * from subscribe;
-- select * from users order by fk_gid;
-- select * from notify;
