//
//  APIConfig.h
//  SeVideo
//
//  Created by 耿双 on 2019/8/15.
//  Copyright © 2019 GS. All rights reserved.
//
/**
 * 接口类
 */

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface APIConfig : NSObject

//信息类服务器地址

//丝瓜
//http://api.sg00.xyz/api/
//草莓
//http://cmadmin.caomeisp666.com/api/videotopic/97?
//向日葵
//http://8zs71v.xrk666.com//api/videoindex?

//#define SERVER_HOST @"http://api.sg00.xyz/api/"
#define SERVER_HOST @"http://cmadmin.caomeisp666.com/api/"

#define SERVER_PATH_HOST @"http://sg01.sg01.sg01.xyz//api/"

//List
#define API_Index @"videoindex"

//like
#define API_MayLike @"videomaylike"

//广告
#define API_ADV @"adinfo/BANNER"

//btns
#define API_Sorts @"videosort"

//explore
#define API_Explore @"/videoexplore"

//发现搜索
#define API_SearchHot @"/videoSearchHot"

//发现搜索
#define API_Search @"videosort/"

//分类
#define API_Category @"videosort/"

//播放
//http://api.sg00.xyz/api/videoplay/9462?uuid=28457D83-2624-4A66-BDDC-F692D0213C23&device=1
#define API_Play @"videoplay/"

//标签
#define API_Topic @"videotopic/"

//历史
#define API_History @"userseen"
//http://sg01.sg01.sg01.xyz//api/userseen

//删除历史
#define API_DeleteHistory @"userseenreset/"



@end

NS_ASSUME_NONNULL_END
