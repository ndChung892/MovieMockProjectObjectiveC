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

@interface SLSettingsViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) NSMutableArray<Filter *> *filterOptions;
@property (nonatomic, strong) Filter *selectedFilterOption;

@property (nonatomic, strong) NSMutableArray<Sort *> *sortOptions;

@property (nonatomic, strong) Sort *selectedSortOption;

@property (nonatomic) UITableView *tableView;
@property (nonatomic, strong) NSArray *options;
@property (nonatomic) NSString *selectedOption;
@end

@implementation SLSettingsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setTitle:@"Setting"];
    [self initView];
    // Do any additional setup after loading the view from its nib.
//    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
//        self.tableView.dataSource = self;
//        self.tableView.delegate = self;
//        [self.view addSubview:self.tableView];
        
//        // Khởi tạo danh sách các option trong session "Filter"
//        self.filterOptions = [[NSMutableArray alloc] init];
//
//    Filter *option1 = [[Filter alloc] init];
//        option1.title = @"Option 1";
//        option1.isSelected = YES;
//        [self.filterOptions addObject:option1];
//
//    Filter *option2 = [[Filter alloc] init];
//        option2.title = @"Option 2";
//        [self.filterOptions addObject:option2];
//
//    Filter *option3 = [[Filter alloc] init];
//        option3.title = @"Option 3";
//        [self.filterOptions addObject:option3];
//
//    Filter *option4 = [[Filter alloc] init];
//        option4.title = @"Option 4";
//        [self.filterOptions addObject:option4];
//
//    Filter *seekbarOption = [[Filter alloc] init];
//        seekbarOption.title = @"Seekbar Option";
//        seekbarOption.isSeekbarOption = YES;
//        seekbarOption.seekbarValue = 5.0; // default value seekbar
//        seekbarOption.seekbarValueString = @"5";
//        [self.filterOptions addObject:seekbarOption];
//
//    Filter *datePickerOption = [[Filter alloc] init];
//        datePickerOption.title = @"Date Picker Option";
//        [self.filterOptions addObject:datePickerOption];
        
        // Đăng ký các cell tùy chỉnh và cell thông thường
//        [self.tableView registerClass:[FilterOptionTableViewCell class] forCellReuseIdentifier:@"FilterOptionCell"];
    self.options = [[NSMutableArray alloc]init];
    self.options = @[@"Popular Movies", @"Top Rated Movies", @"Upcomming Movies", @"NowPlaying Movies"];
    self.selectedOption = @"Popular Movies";
    self.sortOptions = [[NSMutableArray alloc] init];
        
//        Sort *releaseDateSort = [[Sort alloc] init];
//    releaseDateSort.title = @"Release Date";
//    releaseDateSort.isSelected = YES;
//        [self.sortOptions addObject:releaseDateSort];
//
//        Sort *ratingSort = [[Sort alloc] init];
//    ratingSort.title = @"Rating";
//        [self.sortOptions addObject:ratingSort];
//
//    [self.tableView registerClass:[SLFilterSeekbarTableViewCell class] forCellReuseIdentifier:@"FilterOptionCell"];
//
//    [self.tableView registerClass:UITableViewCell.class forCellReuseIdentifier:@"NormalCell"];
    
}

- (void)initView {
    self.tableView = [[UITableView alloc]initWithFrame:self.view.bounds];
    [self.tableView registerClass:UITableViewCell.class forCellReuseIdentifier:@"OptionCell"];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:self.tableView];
    [NSLayoutConstraint activateConstraints:@[
        [self.tableView.topAnchor constraintEqualToAnchor:self.view.topAnchor],
        [self.tableView.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor],
        [self.tableView.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor],
        [self.tableView.bottomAnchor constraintEqualToAnchor:self.view.bottomAnchor],
    ]];
}

#pragma mark - TableView Delegate


#pragma mark - TableView DataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//    if (section == 0) {
//        return self.filterOptions.count;
//    } else {
//        return self.sortOptions.count;
//    }
    return self.options.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"OptionCell" forIndexPath:indexPath];
    cell.textLabel.text = self.options[indexPath.row];
    if ([self.options[indexPath.row] isEqualToString:self.selectedOption]) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    } else {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    return cell;
//    if (indexPath.section == 0) {
//        Filter *option = self.filterOptions[indexPath.row];
//        if (option.isSeekbarOption) {
//            SLFilterSeekbarTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FilterOptionCell" forIndexPath:indexPath];
//            [cell configureCellWithFilterOption:option];
//            return cell;
//        } else {
//            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"NormalCell" forIndexPath:indexPath];
//            cell.textLabel.text = option.title;
//            cell.accessoryType = (option == self.selectedFilterOption) ? UITableViewCellAccessoryCheckmark : UITableViewCellAccessoryNone;
//            return cell;
//        }
//    } else {
//        Sort *option = self.sortOptions[indexPath.row];
//        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SortOptionCell" forIndexPath:indexPath];
//        cell.textLabel.text = option.title;
//        cell.accessoryType = (option == self.selectedSortOption) ? UITableViewCellAccessoryCheckmark : UITableViewCellAccessoryNone;
//        return cell;
//    }
//    return [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"DefaultCell"];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    self.selectedOption = self.options[indexPath.row];
    NSDictionary *userInfo = @{@"selectedOption": self.selectedOption};
    [[NSNotificationCenter defaultCenter] postNotificationName:@"SelectedOptionNotification" object:nil userInfo:userInfo];
    [self.tableView reloadData];
//    if (indexPath.section == 0) {
//            // Xử lý sự kiện khi người dùng chọn một option trong session "Filter"
//            // ...
//        } else {
//            // Xử lý sự kiện khi người dùng chọn một option trong session "Sort"
//            Sort *selectedOption = self.sortOptions[indexPath.row];
//
//            // Đánh dấu option đã chọn và cập nhật dữ liệu
//            // Loại bỏ dấu tích của option hiện tại (nếu có) và đánh dấu dấu tích cho option mới
//            if (self.selectedSortOption) {
//                NSInteger previousSelectedIndex = [self.sortOptions indexOfObject:self.selectedSortOption];
//                NSIndexPath *previousSelectedIndexPath = [NSIndexPath indexPathForRow:previousSelectedIndex inSection:1];
//                UITableViewCell *previousSelectedCell = [tableView cellForRowAtIndexPath:previousSelectedIndexPath];
//                previousSelectedCell.accessoryType = UITableViewCellAccessoryNone;
//            }
//            UITableViewCell *selectedCell = [tableView cellForRowAtIndexPath:indexPath];
//            selectedCell.accessoryType = UITableViewCellAccessoryCheckmark;
//
//            self.selectedSortOption = selectedOption;
//
//            // Lấy dữ liệu từ option đã chọn và thực hiện các xử lý tương ứng
//            if (selectedOption == self.sortOptions[0]) {
//                // Xử lý khi chọn Sort Option 1
//                NSString *optionValue = selectedOption.title;
//                NSLog(@"Sort Release Date: %@", optionValue);
//            } else if (selectedOption == self.sortOptions[1]) {
//                // Xử lý khi chọn Sort Option 2
//                NSString *optionValue = selectedOption.title;
//                NSLog(@"Sort Rating: %@", optionValue);
//            }
//        }
}

//- (void)dealloc {
//    [[NSNotificationCenter defaultCenter]removeObserver:self];
//}

@end
