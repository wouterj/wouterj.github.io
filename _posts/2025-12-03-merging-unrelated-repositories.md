---
layout: post
title: Merging Unrelated Projects using Git
categories: article
tags: git

---
For a while, I've worked on a [new build tool](https://github.com/wouterj/symfony-docs-guides/tree/main/lib/symfony-extension)
for the Symfony documentation. The project started with a fresh `git init`,
but now it's time to merge it with our [existing build tool](https://github.com/symfony-tools/docs-builder/).
I want all contributors of the existing tool to receive credits for the
code they build, but I also don't want to ignore all iterations of the new
build tool project. During SymfonyCon 2025 Hackday last weekend, I wanted
to find a way to achieve this. And apparently, it is straightforward... in
Git terms at least.

First, we need to add the new project as a remote to the old project: we
can just point to the local repository! Then, instruct Git to merge even
though both branches don't share any common ancestors in the commit tree
using a special flag.

```bash
# add a remote, pointing at the new Git project on my local filesystem
$ git remote add local ~/projects/github.com/wouterj/docs-builder-new
$ git fetch local
$ git merge --allow-unrelated-histories local/main
```

Without common ancestors, Git will compare the full diff leading up the
current branch and the full diff leading up the branch from the local
remote. Contributors of both projects now get credited for their work.
Pretty cool, isn't it?

Using the `--allow-unrelated-histories` flag means you no longer have a
linear Git history; it consists of 2 separate branches at the start. **Use
it for the niche use-case**, and don't make this flag your common hammer
to fix Git merge errors.
