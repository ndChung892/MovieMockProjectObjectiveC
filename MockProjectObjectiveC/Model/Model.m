//
//  Model.m
//  DemoCallApi
//
//  Created by Chung on 28/06/2023.
//

#import <Foundation/Foundation.h>
#import "NetworkManager.h"
#import "Model.h"

@implementation Model

-(void) handleData {
    [[NetworkManager sharedInstance] fetchMovieAPI:^(NSDictionary *response) {
        self.results = response[@"results"];
        dispatch_async(dispatch_get_main_queue(), ^{;
            [self.delegate didLoadInitialMovies];
        });
    }];
}

@end
