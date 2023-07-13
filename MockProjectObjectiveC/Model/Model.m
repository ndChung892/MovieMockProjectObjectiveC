//
//  Model.m
//  DemoCallApi
//
//  Created by Chung on 28/06/2023.
//

#import <Foundation/Foundation.h>
#import "NetworkManager.h"
#import "Model.h"
#import "Result.h"

@implementation Model

- (instancetype)init {
    self = [super init];
    if (self) {
        self.results = [[NSMutableArray alloc] init];
    }
    return self;
}

- (id)initMoviesData:(NSDictionary *)resultDic {
    self = [super init];
    Result *result = [[Result alloc]init];
    if (self) {
        
        result.iD = resultDic[@"id"];
        result.title = resultDic[@"title"];
        result.overView = resultDic[@"overview"];
        result.releaseDate = resultDic[@"release_date"];
        result.rating = resultDic[@"vote_average"];
        result.imgURL = resultDic[@"poster_path"];
        [self.results addObject:result];
    }
    return self;
}

@end
