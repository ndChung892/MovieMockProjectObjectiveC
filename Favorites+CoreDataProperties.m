//
//  Favorites+CoreDataProperties.m
//  MockProjectObjectiveC
//
//  Created by Chung on 13/07/2023.
//
//

#import "Favorites+CoreDataProperties.h"

@implementation Favorites (CoreDataProperties)

+ (NSFetchRequest<Favorites *> *)fetchRequest {
	return [NSFetchRequest fetchRequestWithEntityName:@"Favorites"];
}

@dynamic iD;
@dynamic imgUrl;
@dynamic overview;
@dynamic rating;
@dynamic releaseDate;
@dynamic title;

@end
