# SQL

## Select All 'A' which have no value in 'B'

```sql
SELECT *
FROM "organization"
WHERE ("organization"."national_id" = '48079437900010' OR "organization"."national_id" = '54175055000108')
     AND NOT EXISTS (SELECT * FROM "mailbox_sent_email" WHERE "organization"."ref" = "mailbox_sent_email"."to_org_ref" AND "mailbox_sent_email"."email_types" = 'ORDER_SENDING')
```
