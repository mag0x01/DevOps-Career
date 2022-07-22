# Homework


## [Create a Repo](https://git-scm.com/book/en/v2/Git-Basics-Getting-a-Git-Repository)

- Create a new repository in GitLab (aka Project) and synchronize it locally
  - by initializing it remotely and cloning it locally
  - or by creating it empty on the remote and pushing a locally initialized repo to the remote

## [GitIgnore](https://git-scm.com/docs/gitignore)

- Create three directiories under your new repo named `Folder1`, `Folder2`, and `Folder3`.
- Create a file under `Folder2` named `File2` and two more under `Folder3` named `File31` and `File32`.
- Find a way to avoid accidentally commiting `File2` to the repo.
- Now do the same for the directory `Folder3`.
- Commit and push your  changes to the remote  repository.

## [GitKeep](https://medium.com/@kinduff/hey-git-please-keep-those-folders-eb0ed37621c8)

- Find a way to push the empty directory `Folder1` to the remote repository

## [Branching and Merging](https://git-scm.com/book/en/v2/Git-Branching-Basic-Branching-and-Merging)

### Fast Forward merge

- Create a new branch called **topic** based on **master**
- Create a new file called `File1.txt` then commit it
- Switch to master and merge the **topic** onto **master**
- Check the commits with `git log`

### No FF merge

- While still on **master**, create and commit a new file called `File2.txt`
- Checkout **topic** and commit some changes to `File1.txt`
- Move back on **master** and merge **topic** again into **master**
- Check the commits with `git log` and notice what's new this time

### [Merging with conflicts](https://www.atlassian.com/git/tutorials/using-branches/merge-conflicts)

- While still on **master** commit some random changes to `File1.txt`
- Checkout **topic** and commit some other random changes to `File1.txt`
- Move back on **master** and merge **topic** again into **master**
- Resolve the conflict by accepting incoming changes (override **master** with **topic**)
- Commit the updated file
- Check the commits with `git log` and notice what's new this time

## [Pull/Merge Requests](https://docs.gitlab.com/ee/user/project/merge_requests/)

- While still on **master** push your changes on remote
- Checkout **topic** and run `git rebase master` to bring all the missing changes from **master** to **topic**
- Commit some random changes to `File1.txt`
- Push **topic** on remote
- Go to your GitLab Project page and navigate to the *Merge requests* section
- Create a new Merge Request from **topic** to **master** while inspecting all the different options that you have
- Press the green Merge button to take the changes from **topic** to **master**
