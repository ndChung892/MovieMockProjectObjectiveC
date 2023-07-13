//
//  SLFavoritesViewController.m
//  MockProjectObjectiveC
//
//  Created by Chung on 21/06/2023.
//

#import "SLFavoritesViewController.h"
#import "AppDelegate.h"
#import "Result.h"
#import "Favorites+CoreDataClass.h"
#import "Favorites+CoreDataProperties.h"

#pragma mark - SLFavoritesViewController

@interface SLFavoritesViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic) NSMutableArray<Result *> *favoriteArr;

@end

@implementation SLFavoritesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setTitle:@"Favorites"];
    self.context = [[(AppDelegate *)[UIApplication sharedApplication].delegate persistentContainer]viewContext];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.translatesAutoresizingMaskIntoConstraints = NO;
    self.tableView.frame = self.view.bounds;
    
    [self.tableView registerClass:UITableViewCell.class forCellReuseIdentifier:@"cell"];
    [self.view addSubview:self.tableView];
}


#pragma mark - TableView Delegate

#pragma mark - TableView Datasource
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [UITableViewCell alloc];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

#pragma mark - Core data
- (void)getAllItems {
    NSFetchRequest *fetchRequest = [Favorites fetchRequest];
    NSError *error = nil;
    
    NSArray<Favorites *> *fetchedItems = [self.context executeFetchRequest:fetchRequest error:&error];
    
    if (error) {
        NSLog(@"Lỗi khi lấy dữ liệu: %@", error);
    } else {
        self.favoriteArr = [fetchedItems mutableCopy];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
        });
    }
}

- (void)createItem:(NSString *)name {
    //    ToDoListItem *newItem = [[ToDoListItem alloc]initWithContext:self.context];
    Favorites *newItem = (Favorites *)[NSEntityDescription insertNewObjectForEntityForName:@"ToDoListItem" inManagedObjectContext:self.context];
    newItem.id = name;
    newItem.title = [NSDate date];
    NSError *error = nil;
    if (![self.context save:&error]) {
        NSLog(@"Lỗi khi lưu dữ liệu: %@", error);
    } else {
        [self getAllItems];
        NSLog(@"%@", self.favoriteArr);
    }
}

- (void)deleteItem:(Favorites *)item {
    [self.context deleteObject:item];
    NSError *error = nil;
    if (![self.context save:&error]) {
        NSLog(@"Lỗi khi lưu dữ liệu: %@", error);
    } else {
        [self getAllItems];
    }
}

@end
