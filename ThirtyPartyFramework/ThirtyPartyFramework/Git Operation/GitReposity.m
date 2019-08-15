//
//  GitReposity.m
//  QueAndAnsProject
//
//  Created by 罗孟歌 on 2019/7/1.
//  Copyright © 2019 we. All rights reserved.
//

#import "GitReposity.h"

@implementation GitReposity


/**
 git init
 */
- (void)test{
    
}


/**
 git clone
 */
- (void)test1{
    /*
     git clone 实际上是一个封装了几个其他命令的命令。它创建了一个新目录，切换到新的目录，然后git init来初始化一个空的git仓库，
     ，然后为你指定的URL添加一个（默认名称为origin的）远程仓库（git remote add），再针对远程仓库执行git fetch，最后通过git checkout将远程仓库的最新提交检出到本地的工作目录。
     
     */
}


/**
 git add
 */
- (void)test2{
    /*
     git add命令将内容从工作目录添加到暂存区，以备下次提交。当git commit命令执行时，默认情况下它只会检查暂存区域，因此git add是用来确定
     下一次提交时快照的样子的。
     */
}

/**
 git status
 */
- (void)test3{
    /*
     git status命令将为你展示工作区及暂存区域中不同文件的状态。这其中包含了已修改但未暂存，或已经暂存但没有提交的文件
     */
}


/**
 git diff
 */
- (void)test4{
    /*
     当需要查看任意两棵树的差异时你可以使用git diff命令，此命令可以查看你工作环境与你的暂存区的差异（git diff默认的做法）.
     你暂存区域与你最后提交之间的差异（git diff --staged），或者比较两个提交记录的差异（git diff master branchB）.
     */
}


/**
 git commit
 */
- (void)test5{
    /*
     git commit命令将所有通过git add暂存的文件内容在数据库中创建一个持久的快照
     */
}


/**
 git reset
 */
- (void)test6{
    /*
     git reset命令主要用来根据你传递给动作的参数来执行撤销操作。
     */
}


/**
 git rm
 */
- (void)test7{
    /*
     git rm是git用来从工作区，或者暂存区移除文件的命令
     */
}


/**
 git mv
 */
- (void)test8{
    /*
     git mv命令是一个便利命令，用于移动一个文件并且在新文件上执行’git add‘及在老文件上执行’git rm‘命令
     */
}

/**
 git clean
 */
- (void)test9{
    /*
     git clean是一个用来从工作区中移除不想要的文件的命令。可以是编译的临时文件或者合并冲突的文件
     */
}

/**
 git branch
 */
- (void)test10{
    /*
     git branch命令实际上是某种程度上的分支管理工具。它可以列出你所有的分支。创建新分支，删除分支及重命名分支。
     */
}

/**
 git checkout
 */
- (void)test11{
    /*
     git checkout命令用来切换分支，或者检出内容到工作目录
     */
}

/**
 git merge
 */
- (void)test12{
    /*
     git merge工具用来合并一个或者多个分支到你已经检出的分支中。然后它将当前分支指针移动到合并结果上。
     */
}


/**
 git log
 */
- (void)test13{
    /*
     git log命令用来展示一个项目的可达历史记录，从最近的提交快照起。
     */
}

/**
 git stash
 */
- (void)test14{
    /*
     git stash用来临时地保存一些还没有提交的工作，以便在分支上不需要提交未完成工作就可以清理工作目录
     */
}

/**
 git tag
 */
- (void)test15{
    /*
     git tag命令用来为代码历史记录中的某一个点指定一个永久的书签，一般来说它用于发布相关事项
     */
}

/**
 git fetch
 */
- (void)test16{
    /*
     git fetch命令与一个远程的仓库交互，并且将远程仓库有但是在当前仓库的没有的所有信息拉取下来然后存储在你
     本地数据库中
     */
}

/**
 git pull
 */
- (void)test17{
    /*
     git pull命令基本上就是git fetch和git merge命令的组合体，Git从你指定的远程仓库中抓取内容，然后马上尝试将其合并进
     你所在的分支中
     */
}

/**
 git push
 */
- (void)test18{
    /*
     git push命令用来与另一个仓库通信，计算你本地数据库与远程仓库的差异，然后将差异推送到另一个仓库中。它需要有另一个仓库
     的写权限，因此这通常是需要验证的。
     */
}

/**
 git remote
 */
- (void)test19{
    /*
     git remote命令是一个是你远程仓库记录的管理工具
     */
}

#pragma mark - git分支管理

- (void)test20{
    
    /*
     git的分支实质上仅是包含所指对象检验和（长度为40的SHA-1值字符串）的文件，所以它的创建和销毁都异常高效
     
     git checkout -b iss53 ====  git branch iss53 git checkout iss53
     
     
     
     git checkout -b hotfix//创建并切换到新分支
     git checkout master
     git mereg hotfix//删除新分支
     
     
     git branch -d hotfix
     
     fast-forward,当你试图合并两个分支时，如果顺着一个分支走下去能够达到另一个分支，那么git在合并两个分支的时候，
     只会简单的将指针向前推进，因为这种情况下的合并操作没有需要解决的分歧----这就叫做快进。
     
     
     git checkout master
     
     git merge iss53
     
     git branch -d iss53
     
     
     遇到冲突时的分支合并：
     <<<<<<< HEAD:index.html
     当前分支的代码
     ========
     要合并的分支的代码
     >>>>>>>iss53:index.html
     
     在你解决了所有文件中的冲突以后，对每个文件使用git add命令来将其标记为冲突已解决。一旦暂存这些原本有冲突的文件，git就会将它们标记
     为冲突已解决
     
     git status来确认所有的合并冲突都已被解决。如果你对结果感到满意，并且确定之前有冲突的文件都已经暂存了，这时你可以输入git commit来完成合并提交
     
     
     git branch :会得到当前分支的一个列表
     git branch -v:查看每一个分支的最后一次提交
     git branch --merges:查看哪些分支已经合并到当前分支
     git branch --no-merged:查看所有包含未合并分支的分支
     -d:删除
     -D：强制删除
     
     
     git ls-remote:来显式地获得远程引用的完整列表
     
     */
}



@end
