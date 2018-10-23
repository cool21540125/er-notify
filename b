/* 
create table t0(
    fk_evtid    int,
    username    varchar(32),
    `read`        boolean
);
create table t1(
    x1  varchar(32)
);
create table t2(
    fk_evtid  varchar(32),
    fk_gid  varchar(32),
    fk_etype varchar(32),
    username    varchar(32)
);
create table t3(
    x1      varchar(32),
    x2      varchar(32)
);
    DELETE FROM T2;
    DELETE FROM `notify`;
    DELETE FROM `events`;
*/

-- delete from events;
-- SELECT * FROM `events`;
-- SELECT * FROM `notify`;
