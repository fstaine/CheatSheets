# SQL

## Select All 'A' which have no value in 'B'

```sql
SELECT *
FROM "organization"
WHERE ("organization"."national_id" = '48079437900010' OR "organization"."national_id" = '54175055000108')
     AND NOT EXISTS (SELECT * FROM "mailbox_sent_email" WHERE "organization"."ref" = "mailbox_sent_email"."to_org_ref" AND "mailbox_sent_email"."email_types" = 'ORDER_SENDING')
```

# PostresSQL

## Publish / Subscribe

```sql
-- Publisher:
-- Enable role 'rds_replication'
-- Params to update: rds.logical_replication=1
CREATE PUBLICATION x_publication FOR TABLE t1, t2;

-- Subscriber
-- Params to update: max_logical_replication_workers=20, max_worker_processes=13
create subscription x_subscription 
	connection 'host=database.rds.com port=5432 dbname=x user=x_admin password=<password>'
	publication x_publication;
```
