
-- Table 建完後再用這個

USE `notify`;

DROP VIEW IF EXISTS `all_notify`;

CREATE VIEW `all_notify` AS
    SELECT 
        ee.fk_etype `severity`, 
        ee.id `evtid`,
        ee.content `content`, 
        ee.dt `dt`, 
        uu.uid, 
        uu.username `user`, 
        nt.read `read`
    FROM `notify` nt 
        JOIN `users` uu   ON  nt.fk_uid = uu.uid
        JOIN `events` ee  ON  nt.fk_evtid = ee.id;


-- 使用範例

SELECT * FROM `all_notify`;
SELECT * FROM `all_notify` WHERE `read` = 0;
SELECT * FROM `all_notify` WHERE `read` = 1;

