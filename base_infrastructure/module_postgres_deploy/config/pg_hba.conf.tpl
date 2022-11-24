#TYPE   DB      USR     ADDRESS          METHOD
local   all     all     trust
hostssl all     all     0.0.0.0/0        cert clientcert=verify-full
host    all     all     0.0.0.0/0        scram-sha-256 # reject