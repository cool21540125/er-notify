


select 
    uu.username, gg.groupname
from 
    groups gg
    join users uu on gg.gid = uu.fk_gid;