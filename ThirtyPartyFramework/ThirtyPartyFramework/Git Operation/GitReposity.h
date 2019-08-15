//
//  GitReposity.h
//  QueAndAnsProject
//
//  Created by 罗孟歌 on 2019/7/1.
//  Copyright © 2019 we. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface GitReposity : NSObject
/*
 本地删除远程develop分支
 
 git checkout develop                      //将远程分支clone到本地
 git checkout master                       //切换到主分支
 git branch -d develop                     //删除本地develop分支
 git push origin -d develop                //删除远程develop分支
 git branch -r                             //查看远程分支
 
 
 本地创建develop分支
 
 git checkout -b develop                   //创建并切换到develop分支
 git push --set-upstream origin develop    //--set-upstream 和远程分支关联.
 
 
 重命名本地分支
 git branch -m v1.3.0  v1.4.0              //git branch -m 旧分支名  新分支名
 
 git stash                   //但是你还不想提交你正在进行中的工作；所以你储藏这些变更
 git stash apply             //你可以重新应用你刚刚实施的储藏
 git stash apply stash@{2}   //你想应用更早的储藏，你可以通过名字指定它
 
 git add .和git add -A的区别
 
 git add . : 添加已修改的内容至暂存区（不含删除的文件）
 git add -A : 添加本地所有修改的内容至暂存区（包含删除的文件）
 建议使用 git add -A 命令
 
 
 */
@end

NS_ASSUME_NONNULL_END
