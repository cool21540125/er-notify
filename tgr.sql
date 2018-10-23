-- source D:/proj/sql_trigger/tgr.sql

USE `notify`;

DROP TRIGGER `notifyq`;
-- delete from `t0`;
-- delete from `t1`;
-- delete from `t2`;
-- delete from `t3`;
-- delete from `notify`;
-- delete from `events`;

DELIMITER $$
CREATE TRIGGER `notifyq` AFTER INSERT ON `events`
FOR EACH ROW 
Block1: BEGIN
    -- for each "fk_gid" in subscribe
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


/* 觸發事件 */
-- INSERT INTO `events` (`id`, `fk_etype`, `dt`, `content`) VALUES (1, 'AA', CURRENT_TIMESTAMP(), '警報時間超過4小時');
-- INSERT INTO `events` (`id`, `fk_etype`, `dt`, `content`) VALUES (2, 'BB', CURRENT_TIMESTAMP(), '警報時間超過4小時');
-- INSERT INTO `events` (`id`, `fk_etype`, `dt`, `content`) VALUES (3, 'CC', CURRENT_TIMESTAMP(), '警報時間超過4小時');
-- INSERT INTO `events` (`id`, `fk_etype`, `dt`, `content`) VALUES (4, 'DD', CURRENT_TIMESTAMP(), '警報時間超過4小時');

INSERT INTO `events` (`fk_etype`, `dt`, `content`) VALUES ('AA', CURRENT_TIMESTAMP(), '警報時間超過4小時');
-- INSERT INTO `events` (`fk_etype`, `dt`, `content`) VALUES ('BB', CURRENT_TIMESTAMP(), '警報時間超過4小時');
-- INSERT INTO `events` (`fk_etype`, `dt`, `content`) VALUES ('CC', CURRENT_TIMESTAMP(), '警報時間超過4小時');
INSERT INTO `events` (`fk_etype`, `dt`, `content`) VALUES ('DD', CURRENT_TIMESTAMP(), '警報時間超過4小時');
select * from events;
select * from subscribe;
select * from users order by fk_gid;
select * from notify;
-- select '-';
-- SELECT * FROM t1;
-- select '--';
-- SELECT * FROM t2;
-- select '---';
-- select * from t3;

