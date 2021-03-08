# Git

### Fetch a remote (origin) branch (develop:) into local branch (:develop) without checkout
```
git fetch origin develop:develop
```

### Change the date of the previous commit
```
GIT_COMMITTER_DATE="Fri April 3 17:09 2020 +0200" git commit --amend
```

### Move a branch (develop) back to another commit (origin/develop)
```
git branch -f develop origin/develop
```

### Find commits with a given "string" in their title
```
git log --pretty='format:%cd %h %s' | grep -i "string"
```

### Get the files that are not in the index
```
git clean -n
```
The `-n` only show the files but do not apply the modifications

### Remove files (filenames) from the tracked files
```
git rm --cached <filenames>
```

### Revert the deletion of a file (filename)
Get the commit where the deletion occurs
```
git log -- <filename>
```

Checkout the file from the commit previous to this deletion
```
git checkout <deletion commit hash>~1 -- <filename>
```

### Get all the changes on a specific file
```
git log -p <filename>
```

### Clean inexistant branches
Remove remote branches which doesn't exists on remote
```
git fetch -p
```

List branches which are merged into the current branch and remove the already merged
```
git branch --merged
git branch -d <feature/already-merged>
```

Clean merged branches, except thoses containing 'master' or 'dev' in their name
```
git branch --merged develop | grep -i -v -E "master|dev" | xargs git branch -d
```
