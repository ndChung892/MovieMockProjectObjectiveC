//
//  Reminders+CoreDataProperties.m
//  MockProjectObjectiveC
//
//  Created by Chung on 26/07/2023.
//
//

#import "Reminders+CoreDataProperties.h"

@implementation Reminders (CoreDataProperties)

+ (NSFetchRequest<Reminders *> *)fetchRequest {
	return [NSFetchRequest fetchRequestWithEntityName:@"Reminders"];
}

@dynamic iD;
@dynamic imgUrl;
@dynamic overview;
@dynamic rating;
@dynamic releaseDate;
@dynamic reminderTime;
@dynamic title;

@end
