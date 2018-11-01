-- source D:/proj/sql_trigger/tgr.sql
USE `notify`;
DROP TRIGGER IF EXISTS `notifyq`;
-- delete from `notify`;
-- delete from `events`;

-- Trigger1 - 事件發生後, 增加通知記錄
DELIMITER $$
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

            SET @gid = v1_gid;

            IF v1_etype = NEW.fk_etype THEN
                Block2: BEGIN
                    DECLARE v2_gid          INT;
                    DECLARE v2_fk_uid       INT;
                    DECLARE done2           INT DEFAULT 0;
                    DECLARE cur2_users CURSOR FOR (SELECT `fk_gid`, `uid` FROM `users` WHERE `fk_gid` = @gid);
                    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done2 = 1;

                    OPEN cur2_users;
                    get_user: LOOP
                        FETCH cur2_users INTO v2_gid, v2_fk_uid;
                        IF done2 = 1 THEN
                            LEAVE get_user;
                        END IF;

                        IF v1_gid = v2_gid THEN
                            INSERT INTO `notify` (`fk_evtid`, `fk_uid`, `read`) VALUES (NEW.ID, v2_fk_uid, 0);
                        END IF;

                    END LOOP get_user;
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
INSERT INTO `events` (`fk_etype`, `dt`, `content`) VALUES ('fatal',  CURRENT_TIMESTAMP(),    '嚴重錯誤阿!!! XXX怎麼了!');
INSERT INTO `events` (`fk_etype`, `dt`, `content`) VALUES ('error',  CURRENT_TIMESTAMP(),    '錯誤錯誤!! AAAAA');
INSERT INTO `events` (`fk_etype`, `dt`, `content`) VALUES ('error',  CURRENT_TIMESTAMP(),    '錯誤錯誤!! BBBBB');
INSERT INTO `events` (`fk_etype`, `dt`, `content`) VALUES ('fatal',  CURRENT_TIMESTAMP(),    '嚴重錯誤阿!!! OOO怎麼了');
INSERT INTO `events` (`fk_etype`, `dt`, `content`) VALUES ('warn',   CURRENT_TIMESTAMP(),    '警告!!');
INSERT INTO `events` (`fk_etype`, `dt`, `content`) VALUES ('info',   CURRENT_TIMESTAMP(),    '系統資訊:xxxxxxxxxxx');
INSERT INTO `events` (`fk_etype`, `dt`, `content`) VALUES ('period', CURRENT_TIMESTAMP(),    '定時通知定時通知');
