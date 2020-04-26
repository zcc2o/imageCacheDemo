//
//  AppsModel.h
//  多图下载综合案例
//
//  Created by Laibu tech_2 on 2020/4/16.
//  Copyright © 2020 Laibu tech_2. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface AppsModel : NSObject

@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *icon;
@property (nonatomic, copy) NSString *download;

+ (AppsModel *)modelWithDic:(NSDictionary *)dic;

@end

NS_ASSUME_NONNULL_END
