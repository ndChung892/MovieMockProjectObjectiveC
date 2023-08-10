//
//  Model.m
//  DemoCallApi
//
//  Created by Chung on 28/06/2023.
//

#import <Foundation/Foundation.h>
#import "CoreDataManager.h"

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
    Result *result = [[Result alloc] init];
    if (self) {
        result.iD = resultDic[@"id"];
        result.title = resultDic[@"title"];
        result.overView = resultDic[@"overview"];
        result.releaseDate = resultDic[@"release_date"];
        result.rating = resultDic[@"vote_average"];
        result.imgURL = resultDic[@"poster_path"];
        result.isFavorite = [self isAvailableInCoreData: result.iD];
        [self.results addObject:result];
    }
    return self;
}

- (BOOL)isAvailableInCoreData: (NSNumber *) iD {
    return [[CoreDataManager sharedInstance] interateFavorites:iD];
}

- (id)initFavoritesData:(Favorites *)item {
    self = [super init];
    if (self) {
        Result *result = [[Result alloc] init];
        result.title = item.title;
        result.overView = item.overview;
        result.iD = [NSNumber numberWithInt:(int)item.iD];
        result.rating = [NSNumber numberWithFloat:item.rating];
        result.releaseDate = item.releaseDate;
        result.imgURL = item.imgUrl;
        result.isFavorite = YES;
        [self.results addObject:result];
    }
    return self;
}

- (id)initResult:(Result *)result {
    self = [super init];
    if(self) {
        [self.results addObject:result];
    }
    return self;
}
@end
