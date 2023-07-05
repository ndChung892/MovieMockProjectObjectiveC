//
//  Model.h
//  DemoCallApi
//
//  Created by Chung on 28/06/2023.
//

#import <UIKit/UIKit.h>
#import "Result.h"

#ifndef Model_h
#define Model_h


#endif /* Model_h */

@protocol SLMoviesDelegate <NSObject>

- (void)didLoadInitialMovies;

@end

@interface Model: NSObject

@property (nonatomic, strong) NSNumber *page;
@property (nonatomic, strong) NSArray<Result *> *results;
@property (nonatomic, weak) id <SLMoviesDelegate> delegate;

-(void) handleData;

@end
