//
//  Filter.h
//  MockProjectObjectiveC
//
//  Created by Chung on 28/07/2023.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#ifndef Filter_h
#define Filter_h


#endif /* Filter_h */

@interface Filter : NSObject

@property (nonatomic, copy) NSString *title;
@property (nonatomic, assign) BOOL isSelected;
@property (nonatomic, assign) BOOL isSeekbarOption;

@property (nonatomic, assign) float seekbarValue;
@property (nonatomic, copy) NSString *seekbarValueString;

@property (nonatomic, assign) BOOL isReleaseYearOption;
@property (nonatomic, assign) NSDate *releaseYear;
@end
