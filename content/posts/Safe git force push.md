---
title: "Safe git force push"
date: 2022-11-16
draft: false
tags: ["git", "tip"]
---
You've likely been in this situation before. You make some minor code fixes, do `git commit --ammend` to add them to the current commit, and do `git push --force`. Then, you happily open pull request and see that you've deleted you're colleagues commit.😩
<!--more-->
This doesn't happen so often, but when it does, it's a bummer. Happily, the solution is simple.

~~git push --force~~

Don't use force push, use `--force-with-lease` instead!
```bash
git push --force-with-lease
```
>This option allows you to say that you expect the history you are updating is what you rebased and want to replace. If the remote ref still points at the commit you specified, you can be sure that no other people did anything to the ref. It is like taking a "lease" on the ref without explicitly locking it, and the remote ref is updated only if the "lease" is still valid. --force-with-lease alone, without specifying the details, will protect all remote refs that are going to be updated by requiring their current value to be the same as the remote-tracking branch we have for them.
>-- git push --help

Relevant links:
* [Idiot proof git aliases](https://softwaredoug.com/blog/2022/11/09/idiot-proof-git-aliases.html)
* [Stackoverflow: git push --force-with-lease vs. --force](https://stackoverflow.com/questions/52823692/git-push-force-with-lease-vs-force)