//
//  FolderViewController.m
//  EffortListen
//
//  Created by Tamqn on 3/22/16.
//  Copyright © 2016 Tamqn. All rights reserved.
//

#import "FolderViewController.h"
#import "FolderTableViewCell.h"
#import "ObjectsPaginator.h"
#import "Storage.h"
#import "FolderTableViewCell.h"
#import "BookViewController.h"
#import "FaceBookServicesManager.h"

@interface FolderViewController ()<NMPaginatorDelegate>
@property (nonatomic, strong) ObjectsPaginator *paginator;
@property (nonatomic, readwrite) BOOL isFetchData;
@end

@implementation FolderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.hidesBackButton = YES;
    SWRevealViewController *revealViewController = self.revealViewController;
    if ( revealViewController ) {
        [self.menuButton addTarget:self.revealViewController action:@selector(revealToggle:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    }
    
    // Do any additional setup after loading the view.
    self.title = NSLocalizedString(@"keyFolders", nil);
    [self rightButton];
    [self footerView];
    
    AdmodManager *adManager = [AdmodManager sharedInstance];
    [adManager showAdmodInViewController];
    
    self.isFetchData = YES;
    [self footerView];
}

- (void)footerView {
    UIView *header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 67)];
    self.tbView.tableFooterView = header;
    
    //update the header's frame and set it again
    CGRect newFrame = self.tbView.tableFooterView.frame;
    newFrame.size.height = newFrame.size.height;
    self.tbView.tableFooterView.frame = newFrame;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if (self.isFetchData) {
        self.isFetchData = NO;
        [SVProgressHUD showWithStatus:NSLocalizedString(@"keyLoading", nil)];
        [self performSelector:@selector(fetchData) withObject:nil afterDelay:0.1];
    }
}

- (void)fetchData {
    [[Storage instance].folderList removeAllObjects];
    self.paginator = [[ObjectsPaginator alloc] initWithPageSize:10 delegate:self];
    [self.paginator fetchFirstPage];
}

- (void)rightButton {
    UIButton *btnRight=[UIButton buttonWithType:UIButtonTypeCustom];
    [btnRight setFrame:CGRectMake(0, 0, 25, 25)];
    [btnRight setImage:[UIImage imageNamed:@"brightLight"] forState:UIControlStateNormal];
    [btnRight addTarget:self action:@selector(rightAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightBarButton=[[UIBarButtonItem alloc]initWithCustomView:btnRight];
    
    
    UIButton *btnRightFace=[UIButton buttonWithType:UIButtonTypeCustom];
    [btnRightFace setFrame:CGRectMake(0, 0, 25, 25)];
    [btnRightFace setImage:[UIImage imageNamed:@"faceBook"] forState:UIControlStateNormal];
    [btnRightFace addTarget:self action:@selector(likeFaceBook) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightFaceBarButton=[[UIBarButtonItem alloc]initWithCustomView:btnRightFace];
    
    [self.navigationItem setRightBarButtonItems:@[rightBarButton, rightFaceBarButton]];
}

- (void)rightAction {
    [self performSegueWithIdentifier:@"suggest" sender:nil];
}

- (void)likeFaceBook {
    NSData *data = [QMServicesManager.instance.currentUser.customData dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *jsonResponse = [NSJSONSerialization JSONObjectWithData:data
                                                                 options:kNilOptions
                                                                   error:nil];
    if (jsonResponse) {
        NSString *linkStore = [jsonResponse valueForKey:@"linkAppstore"];
        if (linkStore.length) {
            FBSDKLoginManager *loginmanager= [[FBSDKLoginManager alloc]init];
            [loginmanager logOut];
            FaceBookServicesManager *faceManager = [FaceBookServicesManager sharedInstance];
            [faceManager loginFaceBookWithPermission:@[@"public_profile", @"email", @"user_friends"] success:^(FaceBookInformation *faceInfo) {
                [faceManager shareLink:[jsonResponse valueForKey:@"linkAppstore"] inViewController:self];
            } fail:^(NSError *error) {
                NSLog(@"fail");
            } cancel:^{
                NSLog(@"cancel");
            }];
        }else{
            [SVProgressHUD showErrorWithStatus:NSLocalizedString(@"keyLinkStoreNoYet", nil)];
        }
    }else {
        [SVProgressHUD showErrorWithStatus:NSLocalizedString(@"keyLinkStoreNoYet", nil)];
    }
}

- (void)paginator:(id)paginator didReceiveResults:(NSArray *)results {
    [SVProgressHUD dismiss];
    [[Storage instance].folderList addObjectsFromArray:results];
    [self.tbView reloadData];
}

#pragma mark
#pragma mark Paginator

- (void)fetchNextPage {
    [SVProgressHUD showWithStatus:NSLocalizedString(@"keyLoading", nil)];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.paginator fetchNextPage];
    });
}

#pragma mark
#pragma mark UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    // when reaching bottom, load a new page
    if (scrollView.contentOffset.y == scrollView.contentSize.height - scrollView.bounds.size.height) {
        // ask next page only if we haven't reached last page
        if (![self.paginator reachedLastPage]) {
            // fetch next page of results
            [self fetchNextPage];
        }
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[Storage instance].folderList count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [self heightForBasicCellAtIndexPaths:indexPath tableView:tableView];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    FolderTableViewCell *cell = (FolderTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"FolderTableViewCell"];
    [self configureformTableViewCell:cell atIndexPath:indexPath tableView:tableView];
    return cell;
}

- (void)configureformTableViewCell:(FolderTableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath tableView:(UITableView*)tableView{
    // some code for initializing cell content
    QBCOCustomObject *object_custom = [Storage instance].folderList[indexPath.row];
    cell.name.text = object_custom.fields[@"name"];
    cell.numberBook.text = [NSString stringWithFormat:@"%ld", (long)[object_custom.fields[@"itemID"] count]];
}

#pragma mark - Table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    QBCOCustomObject *object_custom = [Storage instance].folderList[indexPath.row];
    [self performSegueWithIdentifier:@"bookSegue" sender:object_custom];
}

- (CGFloat)heightForBasicCellAtIndexPaths:(NSIndexPath *)indexPath tableView:(UITableView*)tableView{
    static FolderTableViewCell *sizingCell = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sizingCell = [tableView dequeueReusableCellWithIdentifier:@"FolderTableViewCell"];
    });
    
    [self configureformTableViewCell:sizingCell atIndexPath:indexPath tableView:tableView];
    return [self calculateHeightForConfiguredSizingCells:sizingCell];
}

- (CGFloat)calculateHeightForConfiguredSizingCells:(UITableViewCell *)sizingCell {
    [sizingCell setNeedsLayout];
    [sizingCell layoutIfNeeded];
    CGSize size = [sizingCell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
    if (size.height<50) {
        size.height = 50;
    }
    return size.height + 1.0f; // Add 1.0f for the cell separator height
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"bookSegue"]) {
        // Get reference to the destination view controller
        BookViewController *bookVC = [segue destinationViewController];
        bookVC.customObject = (QBCOCustomObject *)sender;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
