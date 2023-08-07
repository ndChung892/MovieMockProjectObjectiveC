//
//  SLSettingsViewController.m
//  MockProjectObjectiveC
//
//  Created by Chung on 21/06/2023.
//

#import "SLSettingsViewController.h"
#import "SLShowAllRemindersViewController.h"
#import "SWRevealViewController.h"
#import "SLFilterSeekbarTableViewCell.h"

#pragma mark - SLSettingViewController

@interface SLSettingsViewController () <UITableViewDelegate, UITableViewDataSource, UIPickerViewDelegate, UIPickerViewDataSource>

@property (nonatomic, strong) NSMutableArray<Filter *> *filterOptions;
@property (nonatomic, strong) Filter *selectedFilterOption;

@property (nonatomic, strong) NSMutableArray<Sort *> *sortOptions;

@property (nonatomic, strong) Sort *selectedSortOption;

@property (nonatomic) UITableView *tableView;
@property (nonatomic, strong) NSArray *options;
@property (nonatomic) NSString *selectedOption;

@property (nonatomic, strong) NSDate *selectedDate;

@property (nonatomic, strong) UIPickerView *yearPicker;
@property (nonatomic, strong) NSArray<NSString *> *yearsArray;

@property (nonatomic) float sliderValue;
@end

@implementation SLSettingsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setTitle:@"Setting"];
    [self setupTableView];
    [self setupPickerView];
    [self.view setBackgroundColor:[UIColor systemBackgroundColor]];
    [self initData];
    self.selectedDate = [self defaultReleaseYear:2000];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleSliderValueChanged:) name:@"SettingCellSeekBarValueNotification" object:nil];
}

-(void)handleSliderValueChanged:(NSNotification *)notification {
    NSNumber *sliderValueNumber = notification.userInfo[@"sliderValue"];
    self.sliderValue = [sliderValueNumber floatValue];
}

- (NSDate *)defaultReleaseYear:(NSInteger)year {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [[NSDateComponents alloc] init];
    components.year = year;
    components.month = 1;
    components.day = 1;
    components.hour = 0;
    components.minute = 0;
    components.second = 0;
    NSDate *date = [calendar dateFromComponents:components];
    return date;
}

- (void)initData {
    // Filter
    self.filterOptions = [[NSMutableArray alloc] init];
    Filter *popularOption = [[Filter alloc] init];
    popularOption.title = @"Popular Movies";
    popularOption.isSelected = YES;
    [self.filterOptions addObject:popularOption];
    
    Filter *topRatedOption = [[Filter alloc] init];
    topRatedOption.title = @"Top Rated Movies";
    [self.filterOptions addObject:topRatedOption];
    
    Filter *upcommingOption = [[Filter alloc] init];
    upcommingOption.title = @"Upcomming Movies";
    [self.filterOptions addObject:upcommingOption];
    
    Filter *nowplayingOption = [[Filter alloc] init];
    nowplayingOption.title = @"Nowplaying Movies";
    [self.filterOptions addObject:nowplayingOption];
    
    Filter *seekbarOption = [[Filter alloc] init];
    seekbarOption.title = @"Seekbar Option";
    seekbarOption.isSeekbarOption = YES;
    seekbarOption.seekbarValue = 5.0; // default value seekbar
    seekbarOption.seekbarValueString = @"5";
    [self.filterOptions addObject:seekbarOption];
    
    Filter *datePickerOption = [[Filter alloc] init];
    datePickerOption.title = @"Date Picker Option";
    datePickerOption.isReleaseYearOption = YES;
    datePickerOption.releaseYear = [self defaultReleaseYear:2000]; // default release Year
    self.selectedFilterOption = self.filterOptions[0];
    [self.filterOptions addObject:datePickerOption];
    
    // Sort
    Sort *releaseDateSort = [[Sort alloc] init];
    self.sortOptions = [[NSMutableArray alloc] init];
    releaseDateSort.title = @"Release Date";
    releaseDateSort.isSelected = YES;
    [self.sortOptions addObject:releaseDateSort];
    
    Sort *ratingSort = [[Sort alloc] init];
    ratingSort.title = @"Rating";
    [self.sortOptions addObject:ratingSort];
}

- (void)setupTableView {
    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:self.tableView];
    [NSLayoutConstraint activateConstraints:@[
        [self.tableView.topAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.topAnchor],
        [self.tableView.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor],
        [self.tableView.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor],
        [self.tableView.bottomAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.bottomAnchor],
    ]];
    // Register Cell
    [self.tableView registerNib:[UINib
                                 nibWithNibName:@"SLFilterSeekbarTableViewCell"
                                 bundle:nil]forCellReuseIdentifier:@"FilterOptionCell"];
    
    [self.tableView
     registerClass:UITableViewCell.class
     forCellReuseIdentifier:@"NormalCell"];
    
    [self.tableView registerNib:[UINib
                                 nibWithNibName:@"SLFilterReleaseDateTableViewCell"
                                 bundle:nil]forCellReuseIdentifier:@"ReleaseYearCell"];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
}

- (void)setupPickerView {
    self.yearPicker = [[UIPickerView alloc] init];
    self.yearPicker.delegate = self;
    self.yearPicker.dataSource = self;
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *currentYearComponents = [calendar components:NSCalendarUnitYear fromDate:[NSDate date]];
    NSInteger currentYear = [currentYearComponents year];
    
    NSMutableArray<NSString *> *years = [NSMutableArray array];
    for (NSInteger year = 1900; year <= currentYear; year++) {
        [years addObject:[NSString stringWithFormat:@"%ld", (long)year]];
    }
    self.yearsArray = [NSArray arrayWithArray:years];
    
    NSInteger defaultYear = 2000;
    NSInteger indexOfDefaultYear = [self.yearsArray indexOfObject:[NSString stringWithFormat:@"%ld", (long)defaultYear]];
    // Set Default Value when display
    if (indexOfDefaultYear != NSNotFound) {
        [self.yearPicker selectRow:indexOfDefaultYear inComponent:0 animated:NO];
    }
    
}

#pragma mark - TableView Delegate
- (void)tableView:(UITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        Filter *selectedOption = self.filterOptions[indexPath.row];
        if (!selectedOption.isReleaseYearOption && !selectedOption.isSeekbarOption){
            // Check if the cell is selected after that
            if (self.selectedFilterOption) {
                // If Yes, find the indexPath of this cell in array filterOptions
                NSInteger previousSelectedIndex = [self.filterOptions indexOfObject:self.selectedFilterOption];
                
                // Declare indexPath of previouscell
                NSIndexPath *previousSelectedIndexPath = [NSIndexPath indexPathForRow:previousSelectedIndex inSection:0];
                
                // Declare the previous cell
                UITableViewCell *previousSelectedCell = [tableView cellForRowAtIndexPath:previousSelectedIndexPath];
                
                // Set the status of previous cell to unselect (cancel checkmark)
                previousSelectedCell.accessoryType = UITableViewCellAccessoryNone;
            }
            
            // Declare the current select cell
            UITableViewCell *selectedCell = [tableView cellForRowAtIndexPath:indexPath];
            
            // Setup status of cell to selected cell (display checkmark)
            selectedCell.accessoryType = UITableViewCellAccessoryCheckmark;
            
            // Update selectedFilterOption to current cell
            self.selectedFilterOption = selectedOption;
            
            // Check the filter option
            NSString *optionValue;
            if (selectedOption == self.filterOptions[0]) {
                optionValue = @"popular";
            } else if (selectedOption == self.filterOptions[1]) {
                optionValue = @"top_rated";
            } else if (selectedOption == self.filterOptions[2]) {
                optionValue = @"upcoming";
            } else if (selectedOption == self.filterOptions[3]) {
                optionValue = @"now_playing";
            }
            NSDictionary *userInfo = @{@"optionValue": optionValue};
            [[NSNotificationCenter defaultCenter]postNotificationName:@"SettingDidSelectFilterOption" object:nil userInfo:userInfo];
            NSLog(@"Filter Option: %@", optionValue);
        } else if (selectedOption.isReleaseYearOption) {
            [self showYearPicker:indexPath];
        } else if (selectedOption.isSeekbarOption) {
            
        }
    } else {
        Sort *selectedOption = self.sortOptions[indexPath.row];
        if (self.selectedSortOption) {
            NSInteger previousSelectedIndex = [self.sortOptions indexOfObject:self.selectedSortOption];
            NSIndexPath *previousSelectedIndexPath = [NSIndexPath indexPathForRow:previousSelectedIndex inSection:1];
            UITableViewCell *previousSelectedCell = [tableView cellForRowAtIndexPath:previousSelectedIndexPath];
            previousSelectedCell.accessoryType = UITableViewCellAccessoryNone;
        }
        UITableViewCell *selectedCell = [tableView cellForRowAtIndexPath:indexPath];
        selectedCell.accessoryType = UITableViewCellAccessoryCheckmark;
        NSString *optionValue;
        self.selectedSortOption = selectedOption;
        if (selectedOption == self.sortOptions[0]) {
             optionValue= selectedOption.title;
        } else if (selectedOption == self.sortOptions[1]) {
            optionValue = selectedOption.title;
        }
        NSDictionary *userInfo = @{@"SelectedSortOption": optionValue};
        [[NSNotificationCenter defaultCenter] postNotificationName:@"SettingDidSelectSortOptionNotification" object:nil userInfo:userInfo];
    }
}

#pragma mark - TableView DataSource

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return self.filterOptions.count;
    } else {
        return self.sortOptions.count;
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSString *)tableView:(UITableView *)tableView
titleForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return @"Filter";
    } else {
        return @"Sort";
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        Filter *option = self.filterOptions[indexPath.row];
        if (option.isSeekbarOption) {
            SLFilterSeekbarTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FilterOptionCell" forIndexPath:indexPath];
            return cell;
        } else if (option.isReleaseYearOption) {
            SLFilterReleaseDateTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ReleaseYearCell" forIndexPath:indexPath];
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateFormat:@"yyyy"];
            [cell configCell:[dateFormatter stringFromDate:self.selectedDate]];
            return cell;
            
        } else {
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"NormalCell" forIndexPath:indexPath];
            cell.textLabel.text = option.title;
            cell.accessoryType = (option == self.selectedFilterOption) ? UITableViewCellAccessoryCheckmark : UITableViewCellAccessoryNone;
            return cell;
        }
    } else {
        Sort *option = self.sortOptions[indexPath.row];
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"NormalCell" forIndexPath:indexPath];
        cell.textLabel.text = option.title;
        
        cell.accessoryType = (option == self.selectedSortOption) ? UITableViewCellAccessoryCheckmark : UITableViewCellAccessoryNone;
        return cell;
    }
}

#pragma mark - UIPickerViewDelegate & UIPickerViewDataSource

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView
numberOfRowsInComponent:(NSInteger)component {
    return self.yearsArray.count;
}

- (NSString *)pickerView:(UIPickerView *)pickerView
             titleForRow:(NSInteger)row
            forComponent:(NSInteger)component {
    return self.yearsArray[row];
}

- (void)pickerView:(UIPickerView *)pickerView
      didSelectRow:(NSInteger)row
       inComponent:(NSInteger)component {
    
    // Set display year by the previous year
    NSInteger indexOfDefaultYear = [self.yearsArray indexOfObject:[NSString stringWithFormat:@"%ld", (long)self.selectedDate]];
    if (indexOfDefaultYear != NSNotFound) {
        [self.yearPicker selectRow:indexOfDefaultYear inComponent:0 animated:NO];
    }
}

#pragma mark - Show YearPicker
- (void)showYearPicker:(NSIndexPath *)indexPath {
    // Text field to display Picker View
    UITextField *textField = [[UITextField alloc]init];
    textField.inputView = self.yearPicker;
    [textField becomeFirstResponder];
    
    // Declare UIAlertController
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    [alertController addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil]];
    [alertController addAction:[UIAlertAction actionWithTitle:@"Done" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSInteger selectedYearIndex = [self.yearPicker selectedRowInComponent:0];
            NSString *selectedYearString = self.yearsArray[selectedYearIndex];
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
            [dateFormatter setDateFormat:@"yyyy"];
            self.selectedDate = [dateFormatter dateFromString:selectedYearString];
        
        // Update display data
        [self.tableView reloadRowsAtIndexPaths:@[indexPath]withRowAnimation:UITableViewRowAnimationNone];
        NSDictionary *userInfo = @{@"releaseDate": self.selectedDate};
        // Post Notification for Release Date
        [[NSNotificationCenter defaultCenter]postNotificationName:@"SettingDidSelectReleaseDateFilter" object:nil userInfo:userInfo];
    }]];
    
    [alertController.view addSubview:textField];
    [self presentViewController:alertController animated:YES completion:nil];
}

- (CGFloat)tableView:(UITableView *)tableView
heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        Filter *option = self.filterOptions[indexPath.row];
        if (option.isSeekbarOption) {
            return 100;
        }
    }
    return UITableViewAutomaticDimension;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}
@end
