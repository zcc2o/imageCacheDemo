//
//  ViewController.m
//  多图下载综合案例
//
//  Created by Laibu tech_2 on 2020/4/16.
//  Copyright © 2020 Laibu tech_2. All rights reserved.
//

#import "ViewController.h"
#import "AppsModel.h"
#import "Start.h"
@interface ViewController ()
@property (nonatomic, strong) NSMutableDictionary *imageDics;
@property (nonatomic, copy) NSArray *dataArray;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *cellIdentifier = @"app";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    __weak AppsModel *model = self.dataArray[indexPath.row];
    cell.textLabel.text = model.name;
    cell.detailTextLabel.text = model.download;
    __weak typeof(self)weakSelf = self;
    NSString *cachePath = [self getCacheImagePath];
    NSString *picName = model.icon.lastPathComponent;
    NSString *fullPath = [cachePath stringByAppendingPathComponent:picName];
    if ([self.imageDics objectForKey:model.icon]) {
        cell.imageView.image = [self.imageDics objectForKey:model.icon];
    } else {
        // 判断本地有没有
        NSData *picData = [NSData dataWithContentsOfFile:fullPath];
        if (picData) {
            cell.imageView.image = [UIImage imageWithData:picData];
            [self.imageDics setObject:[UIImage imageWithData:picData] forKey:model.icon];
        } else {
            dispatch_async(dispatch_get_global_queue(0, 0), ^{
                UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:model.icon]]];
                dispatch_async(dispatch_get_main_queue(), ^{
                    NSLog(@"%@", cell);
                    cell.imageView.image = image;
                    [weakSelf.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
                    [weakSelf.imageDics setObject:image forKey:model.icon];
                    NSData *imageData = UIImagePNGRepresentation(image);
                    [imageData writeToFile:fullPath atomically:YES];
                });
            });
        }
    }
    return cell;
}

- (NSString *)getCacheImagePath {
    NSString *imageCachePath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES).lastObject stringByAppendingPathComponent:@"cacheImage"];
    if (![[NSFileManager defaultManager] fileExistsAtPath:imageCachePath]) {
        [[NSFileManager defaultManager] createDirectoryAtPath:imageCachePath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    return imageCachePath;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60;
}

- (NSArray *)dataArray {
    if (!_dataArray) {
        NSArray *dicArray = [NSArray arrayWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"apps" ofType:@"plist"]];
        NSMutableArray *modelsArrayM = [NSMutableArray array];
        for (NSDictionary *modelDic in dicArray) {
            AppsModel *model = [AppsModel modelWithDic:modelDic];
            [modelsArrayM addObject:model];
        }
        _dataArray = [NSArray arrayWithArray:modelsArrayM];
    }
    return _dataArray;
}

- (NSMutableDictionary *)imageDics {
    if (!_imageDics) {
        _imageDics = [NSMutableDictionary dictionaryWithCapacity:0];
    }
    return _imageDics;
}

@end
