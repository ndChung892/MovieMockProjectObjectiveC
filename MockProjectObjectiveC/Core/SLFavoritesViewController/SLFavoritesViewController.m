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

#pragma mark - SLFavoritesViewController
@interface SLFavoritesViewController () <UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic) Model *model;
@property (nonatomic, strong) NSArray *originalData;
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
    UINavigationController *navigationController = self.navigationController;
    UITextField *searchTextField = [[UITextField alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(navigationController.navigationBar.frame), CGRectGetWidth(self.view.frame), 40)];
    searchTextField.placeholder = @"Search";
    searchTextField.borderStyle = UITextBorderStyleRoundedRect;
    searchTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    searchTextField.delegate = self;
    [navigationController.view addSubview:searchTextField];
    [navigationController.view addSubview:self.tableView];
    searchTextField.translatesAutoresizingMaskIntoConstraints = NO;
    
    // Layout constraint
    [NSLayoutConstraint activateConstraints:@[
        [searchTextField.topAnchor constraintEqualToAnchor:navigationController.navigationBar.bottomAnchor constant:8],
        [searchTextField.leadingAnchor constraintEqualToAnchor:navigationController.view.leadingAnchor constant:0],
        [searchTextField.trailingAnchor constraintEqualToAnchor:navigationController.view.trailingAnchor constant:0],
        [self.tableView.topAnchor constraintEqualToAnchor:searchTextField.bottomAnchor],
        [self.tableView.leadingAnchor constraintEqualToAnchor:navigationController.view.leadingAnchor],
        [self.tableView.trailingAnchor constraintEqualToAnchor:navigationController.view.trailingAnchor],
        [self.tableView.bottomAnchor constraintEqualToAnchor:navigationController.view.bottomAnchor],
    ]];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    [self.model.results removeAllObjects];
    [[CoreDataManager sharedInstance] getAllItems:^(NSArray<Favorites *> *items) {
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

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
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
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewCellEditingStyleDelete;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    [[CoreDataManager sharedInstance]removeItem: self.model.results[indexPath.row]];
    [self.model.results removeObject:self.model.results[indexPath.row]];
    
    [self.tableView reloadData];
}

- (UISwipeActionsConfiguration *)tableView:(UITableView *)tableView trailingSwipeActionsConfigurationForRowAtIndexPath:(NSIndexPath *)indexPath {
    // Create deleteAction
    UIContextualAction *deleteAction = [UIContextualAction contextualActionWithStyle:UIContextualActionStyleDestructive title:@"Del" handler:^(UIContextualAction * _Nonnull action, __kindof UIView * _Nonnull sourceView, void (^ _Nonnull completionHandler)(BOOL)) {
        // Confirm Delete
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"" message:@"Confirm to Delete" preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:@"Delete" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
            // Delete
            [[CoreDataManager sharedInstance] removeItem:self.model.results[indexPath.row]];
            [self.model.results removeObjectAtIndex:indexPath.row];
            
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
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SLFavoritesTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellFavoritesTableView" forIndexPath:indexPath];
    cell.result = self.model.results[indexPath.row];
    cell.isFavorite = YES;
    [cell configCell];
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.model.results.count;
}


@end
