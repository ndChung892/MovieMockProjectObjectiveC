//
//  Model.h
//  DemoCallApi
//
//  Created by Chung on 28/06/2023.
//

#import <UIKit/UIKit.h>
#import "Result.h"
#import "Favorites+CoreDataClass.h"
#import "Favorites+CoreDataProperties.h"

#ifndef Model_h
#define Model_h


#endif /* Model_h */


@interface Model: NSObject

@property (nonatomic, strong) NSNumber *page;
@property (nonatomic, strong) NSMutableArray *results;

- (id)initMoviesData:(NSDictionary *)resultDic;
- (id)initFavoritesData:(Favorites *)item;

@end
