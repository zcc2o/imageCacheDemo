//
//  AppsModel.m
//  多图下载综合案例
//
//  Created by Laibu tech_2 on 2020/4/16.
//  Copyright © 2020 Laibu tech_2. All rights reserved.
//

#import "AppsModel.h"

@implementation AppsModel

+ (AppsModel *)modelWithDic:(NSDictionary *)dic {
    AppsModel *model = [[AppsModel alloc] init];
    model.name = dic[@"name"];
    model.icon = dic[@"icon"];
    model.download = dic[@"download"];
    return model;
}

@end
