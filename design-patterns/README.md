### Design patterns

 - Adapter: separate interface & implementation
 - Dependency Injection
 - Command pattern: Let the caller parametrize the execution


## How to design ?

# IMAP / REST API:

For the same "usecase", two implementations could have differents process to open / close the connexion and handle state.

* Is it good practice to try to abstrract the behavior if there might be 4-5 differents implementations, or should it be kept more optimized for each method ? (~100s of connexion must be made every ~minutes)

```ts
class OutlookEmailAdapter {

    getEmail(token, emailId) {

    }

    getEmailContent(token, emailId) {

    }
}
```

```ts
class ImapEmailAdapter {
    open(oathParams) {

    }

    close() {

    }

    getEmail(emailId) {

    }

    getEmailContent(emailId) {

    }
}
```

* The `ImapEmailAdapter` must be used for only 1 mailbox, and thus must be recreated on each call, it's would have two types of dependencies like `S3Client` (stateless) and `connexionParameters` (statefull). Is it possible to only have stateless params ?

Proposition:

```ts

class Context {
    constructor(imapConnection)
}

interface ImapEmailAdapter {
    open(oathParams): Promise<Context> 

    close(ctx: Context)

    getEmail(ctx: Context, emailId: string)

    getEmailContent(ctx: Context, emailId: string)
}
```

```ts
class Usecase {
    s3Client: S3Client;
    imapEmailAdapter: ImapEmailAdapter

    execute() {
        ctx = imapEmailAdapter.open()
        try {
            // [...]
            content = getEmailContent(ctx, '1234')
            s3Client.store(content)
        } finally {
            this.imapEmailAdapter.close(ctx);
        }
    }
}
```
