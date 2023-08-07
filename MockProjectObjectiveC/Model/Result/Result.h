//
//  Result.h
//  MockProjectObjectiveC
//
//  Created by Chung on 04/07/2023.
//
#import <UIKit/UIKit.h>

#ifndef Result_h
#define Result_h


#endif /* Result_h */

@interface Result : NSObject

@property (nonatomic, strong) NSNumber *iD;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *overView;
@property (nonatomic, copy) NSString *releaseDate;
@property (nonatomic, copy) NSNumber *rating;
@property (nonatomic, copy) NSString *imgURL;
@property (nonatomic, assign) BOOL isFavorite;

@end
