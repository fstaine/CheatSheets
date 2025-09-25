# Git

### Create a branch and checkout
```
git checkout -b <branchname>
```

### Fetch a remote (origin) branch (develop:) into local branch (:develop) without checkout
```
git fetch origin develop:develop
```

### Change the date of the previous commit
```
GIT_COMMITTER_DATE="Fri April 3 17:09 2020 +0200" git commit --amend
```

### Move a branch if remote was rebased
```
git reset --hard origin/feature/XXX
```

### Move a branch (develop) back to another commit (origin/develop)
```
git branch -f develop origin/develop
```

### Rebase feature B without Feature A

```
                            H---I---J topicB
                           /
                  E---F---G  topicA
                 /
    A---B---C---D  master
```
then the command

```
git rebase --onto master topicA topicB
```
would result in:

```
                 H'--I'--J'  topicB
                /
                | E---F---G  topicA
                |/
    A---B---C---D  master
```
[Source](https://git-scm.com/docs/git-rebase)

### Find commits with a given "string" in their title
```
git log --pretty='format:%cd %h %s' | grep -i "string"
```

### Find the commits with given (serach string) in it.
Show full commit diff:
```
git log -S'search string' -p
```

Show commit diff:
```
git log -S'search string' --oneline --name-status
```
You can also do a regex search by using -G instead of -S.

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

### Delete a tag
```sh
git tag -d <tagname> # Delete local tag
git push --delete origin <tagname> # Delete a remote tag
```


### Get all the changes on a specific file
```
git log --follow -- <filename>
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
git branch --merged develop | grep -i -v -E "master|develop" | xargs git branch -d
```

### Get the content of a file at a specific revision
```
git show <revision>:<filename> > <output>
```

### Cherry-pick a list of commits
```
#To cherry-pick all the commits from commit A to commit B (where A is older than B), run:
git cherry-pick A^..B

# If you want to ignore A itself, run:
git cherry-pick A..B
```
