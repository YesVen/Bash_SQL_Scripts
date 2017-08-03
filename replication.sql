-- # On master
FLUSH TABLES WITH READ LOCK;
GRANT REPLICATION SLAVE ON *.* TO 'replication'@'%.mathworks.com';
SHOW MASTER STATUS;
UNLOCK TABLES;


-- On slave
SHOW SLAVE STATUS;
STOP SLAVE;
START SLAVE;
CHANGE MASTER TO MASTER_HOST='jmddbpreprod.mathworks.com', MASTER_USER='replication', 
MASTER_PASSWORD='copymeple@se', 
MASTER_LOG_FILE='batjmddbpreprod01-bin.000981',
MASTER_LOG_POS=107; 
