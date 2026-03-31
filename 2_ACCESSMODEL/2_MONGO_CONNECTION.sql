BEGIN
  -- 1. Crearea listei de control acces (ACL) pentru localhost
  DBMS_NETWORK_ACL_ADMIN.append_host_ace (
    host       => 'localhost', 
    lower_port => 8084,
    upper_port => 8084,
    ace        => xs$ace_type(privilege_list => xs$name_list('http'),
                              principal_name => 'FDBO', -- UTILIZATORUL TAU
                              principal_type => xs_acl.ptype_db));
                              
  -- 2. Permisiune si pentru IP-ul de loopback (uneori e nevoie de ambele)
  DBMS_NETWORK_ACL_ADMIN.append_host_ace (
    host       => '127.0.0.1', 
    lower_port => 8084,
    upper_port => 8084,
    ace        => xs$ace_type(privilege_list => xs$name_list('http'),
                              principal_name => 'FDBO',
                              principal_type => xs_acl.ptype_db));
END;
/
COMMIT;