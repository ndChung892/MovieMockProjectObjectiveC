//
//  SLFavoritesViewController.m
//  MockProjectObjectiveC
//
//  Created by Chung on 21/06/2023.
//

#import "SLFavoritesViewController.h"
#import "AppDelegate.h"
#import "CoreDataManager.h"
#import "SLFavoritesTableViewCell.h"
#import "Favorites+CoreDataClass.h"
#import "Favorites+CoreDataProperties.h"
#import "SLDetailMoviesViewController.h"
#import "NotificationConstant.h"

#pragma mark - SLFavoritesViewController
@interface SLFavoritesViewController () <UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, SLDetailMoviesViewControllerDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic) Model *model;
@property (nonatomic, strong) NSArray *originalData;

@property (nonatomic, strong) SLDetailMoviesViewController *detailVC;
@end

@implementation SLFavoritesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setTitle:@"Favorites"];
    self.model = [[Model alloc]init];
    [self setupView];

}

- (void)setupView {
    // Setup tableView
    self.view.backgroundColor = [UIColor systemBackgroundColor];
    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds];
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        self.tableView.translatesAutoresizingMaskIntoConstraints = NO;
        self.tableView.backgroundColor = [UIColor systemBackgroundColor];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"SLFavoritesTableViewCell" bundle:nil] forCellReuseIdentifier:@"cellFavoritesTableView"];
    
    // Setup searchTextField
    UITextField *searchTextField = [[UITextField alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.navigationController.navigationBar.frame), CGRectGetWidth(self.view.frame), 40)];
    searchTextField.placeholder = @"Search";
    searchTextField.borderStyle = UITextBorderStyleRoundedRect;
    searchTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    searchTextField.delegate = self;
    [self.view addSubview:searchTextField];
    [self.view addSubview:self.tableView];
    searchTextField.translatesAutoresizingMaskIntoConstraints = NO;
    
    // Layout constraint
    [NSLayoutConstraint activateConstraints:@[
        [searchTextField.topAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.topAnchor constant:8],
        [searchTextField.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor constant:0],
        [searchTextField.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor constant:0],
        [self.tableView.topAnchor constraintEqualToAnchor:searchTextField.bottomAnchor],
        [self.tableView.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor],
        [self.tableView.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor],
        [self.tableView.bottomAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.bottomAnchor],
    ]];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    
    self.detailVC = [[SLDetailMoviesViewController alloc]initWithNibName:@"SLDetailMoviesViewController" bundle:nil];
    self.detailVC.delegate = self;
    [self.model.results removeAllObjects];
    [[CoreDataManager sharedInstance] getAllFavorites:^(NSArray<Favorites *> *items) {
        if(items) {
            for(Favorites *item in items) {
                (void)[self.model initFavoritesData:item];
            }
           self.originalData = [self.model.results copy];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
        });
    }];
}

#pragma mark - TextField Delegate
- (void)performSearchWithText:(NSString *)searchText {
    if (searchText.length > 0) {
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF.title CONTAINS[c] %@", searchText];
        self.model.results = [NSMutableArray arrayWithArray:[self.originalData filteredArrayUsingPredicate:predicate]];
    } else {
        self.model.results = (NSMutableArray *)self.originalData;
    }
    [self.tableView reloadData];
}

- (BOOL)textField:(UITextField *)textField
shouldChangeCharactersInRange:(NSRange)range
replacementString:(NSString *)string {
    NSString *searchText = [textField.text stringByReplacingCharactersInRange:range withString:string];
        if (searchText.length == 0) {
            self.model.results = [self.originalData mutableCopy];
        } else {
            [self performSearchWithText:searchText];
        }
        [self.tableView reloadData];
        return YES;
}

- (BOOL)textFieldShouldClear:(UITextField *)textField {
    textField.text = @"";
        [self performSearchWithText:@""];
        return NO;
}

#pragma mark - TableView Delegate
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView
           editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewCellEditingStyleDelete;
}


- (UISwipeActionsConfiguration *)tableView:(UITableView *)tableView
trailingSwipeActionsConfigurationForRowAtIndexPath:(NSIndexPath *)indexPath {
    // Create deleteAction
    Result *resultDeleted = self.model.results[indexPath.row];
    UIContextualAction *deleteAction = [UIContextualAction contextualActionWithStyle:UIContextualActionStyleDestructive title:@"Del" handler:^(UIContextualAction * _Nonnull action, __kindof UIView * _Nonnull sourceView, void (^ _Nonnull completionHandler)(BOOL)) {
        // Confirm Delete
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"" message:@"Confirm to Delete" preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:@"Delete" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
            // Delete
            [[CoreDataManager sharedInstance] removeFavorites:self.model.results[indexPath.row]];
            [self.model.results removeObjectAtIndex:indexPath.row];
            NSDictionary *userInfo = @{@"id": resultDeleted.iD};
            [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_FAVORTIE_DID_CHANGE object:nil userInfo:userInfo];
            
            [self.tableView reloadData];
        }];
        // Cancel Action
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil];
        
        [alert addAction:confirmAction];
        [alert addAction:cancelAction];
        
        [self presentViewController:alert animated:YES completion:nil];
        
        completionHandler(YES);
    }];
    
    UISwipeActionsConfiguration *configuration = [UISwipeActionsConfiguration configurationWithActions:@[deleteAction]];
    return configuration;
}

#pragma mark - TableView Datasource
- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SLFavoritesTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellFavoritesTableView" forIndexPath:indexPath];
    [cell configCell:self.model.results[indexPath.row]];
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section {
    return self.model.results.count;
}

- (void)favoriteDidChange:(BOOL)isFavorite withResult:(Result *)result {
    NSDictionary *userInfo = @{
        @"id":result.iD,
        @"isFavorite": [NSNumber numberWithBool:isFavorite]
    };
    [[NSNotificationCenter defaultCenter] postNotificationName:@"haha" object:nil userInfo:userInfo];
}

- (void)tableView:(UITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    self.detailVC.result = self.model.results[indexPath.row];
    [self.navigationController pushViewController:self.detailVC animated:YES];
    
}
@end
