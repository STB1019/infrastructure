#TYPE   DB      USR     ADDRESS     MASK                METHOD
local   all     all     127.0.0.1   255.255.255.255     trust
host    all     all     0.0.0.0     0.0.0.0             scram-sha-256 # reject
hostssl all     all     0.0.0.0     0.0.0.0             ident