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
