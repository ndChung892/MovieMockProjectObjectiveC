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

-(void) handleData {
    [[NetworkManager sharedInstance] fetchMovieAPI:^(NSDictionary *response) {
        self.page = response[@"page"];
        
        NSArray *resultsArray = response[@"results"];
        NSMutableArray *moviesArray = [[NSMutableArray alloc] init];
        for(NSDictionary *resultDict in resultsArray) {
            Result *result = [[Result alloc]init];
            result.title = resultDict[@"title"];
            result.iD = resultDict[@"id"];
            result.overView = resultDict[@"overview"];
            result.releaseDate = resultDict[@"release_date"];
            result.rating = resultDict[@"vote_average"];
            result.imgURL = resultDict[@"poster_path"];
            [moviesArray addObject:result];
        }
        self.results = moviesArray;
        dispatch_async(dispatch_get_main_queue(), ^{;
            [self.delegate didLoadInitialMovies];
        });
    }];
}

@end
