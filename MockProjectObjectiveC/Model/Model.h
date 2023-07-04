//
//  Model.h
//  DemoCallApi
//
//  Created by Chung on 28/06/2023.
//

#import <UIKit/UIKit.h>

#ifndef Model_h
#define Model_h


#endif /* Model_h */

@protocol SLMoviesDelegate <NSObject>

- (void)didLoadInitialMovies;

@end

@interface Model: NSObject

@property NSArray *results;
@property id <SLMoviesDelegate> delegate;

-(void) handleData;

@end
