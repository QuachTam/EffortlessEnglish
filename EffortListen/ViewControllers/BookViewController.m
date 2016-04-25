
//
//  BookViewController.m
//  EffortListen
//
//  Created by Tamqn on 3/23/16.
//  Copyright © 2016 Tamqn. All rights reserved.
//

#import "BookViewController.h"
#import "FolderTableViewCell.h"
#import "BookService.h"
#import "PlaySoundViewController.h"
#import "ReaderPDF.h"
#import "PlaySound.h"
#import "TQNDocument.h"

NSInteger TYPE_DATA_PM3 = 0;
NSInteger TYPE_DATA_PDF = 1;

@interface BookViewController ()
@property (nonatomic, strong) NSArray *bookList;
@end

@implementation BookViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = NSLocalizedString(@"keyFiles", nil);
    self.bookList = [NSArray new];
    [SVProgressHUD showWithStatus:NSLocalizedString(@"keyLoading", nil)];
    BookService *service = [BookService instance];
    [service getListItem:self.customObject.fields[@"itemID"] success:^(NSArray * _Nullable objects) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [SVProgressHUD dismiss];
        });
        self.bookList = objects;
        [self.tbView reloadData];
    } fail:^(QBResponse * _Nonnull response) {
        [SVProgressHUD showErrorWithStatus:NSLocalizedString(@"keyServerError", nil)];
    }];
    [self backButton];
    AdmodManager *adManager = [AdmodManager sharedInstance];
    [adManager showAdmodInViewController];
    [self footerView];
    
    TrackerManager *managerManager = [TrackerManager instance];
    [managerManager trackerScreenViewWithName:@"BookViewController"];
}

- (void)footerView {
    UIView *header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 67)];
    self.tbView.tableFooterView = header;
    
    //update the header's frame and set it again
    CGRect newFrame = self.tbView.tableFooterView.frame;
    newFrame.size.height = newFrame.size.height;
    self.tbView.tableFooterView.frame = newFrame;
}



- (void)backButton {
    UIButton *btnBack=[UIButton buttonWithType:UIButtonTypeCustom];
    [btnBack setFrame:CGRectMake(0, 0, 25, 25)];
    [btnBack setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    [btnBack addTarget:self action:@selector(backView) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backBarButton=[[UIBarButtonItem alloc]initWithCustomView:btnBack];
    [self.navigationItem setLeftBarButtonItem:backBarButton];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [UIViewController attemptRotationToDeviceOrientation];
    
    //Once the view has loaded then we can register to begin recieving controls and we can become the first responder
    [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
    [self becomeFirstResponder];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    //End recieving events
    [[UIApplication sharedApplication] endReceivingRemoteControlEvents];
    [self resignFirstResponder];
}

//Make sure we can recieve remote control events
- (BOOL)canBecomeFirstResponder {
    return YES;
}

- (void)remoteControlReceivedWithEvent:(UIEvent *)event {
    //if it is a remote control event handle it correctly
    PlaySound *play = [PlaySound instance];
    if (event.type == UIEventTypeRemoteControl) {
        if (event.subtype == UIEventSubtypeRemoteControlPlay) {
            [play play];
        } else if (event.subtype == UIEventSubtypeRemoteControlPause) {
            [play pause];
        }
    }
}

- (void)backView {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.bookList.count;
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
    QBCOCustomObject *object_custom = [self.bookList objectAtIndex:indexPath.row];
    cell.name.text = object_custom.fields[@"name"];
    cell.buttonRun.tag = indexPath.row;
    NSNumber *type = object_custom.fields[@"type"];
    if ([type integerValue] != TYPE_DATA_PDF) {
        [cell.buttonRun setImage:[UIImage imageNamed:@"play"] forState:UIControlStateNormal];
        [cell.buttonRun addTarget:self action:@selector(playSound:) forControlEvents:UIControlEventTouchUpInside];
    }else{
        [cell.buttonRun setImage:[UIImage imageNamed:@"bookShow"] forState:UIControlStateNormal];
        [cell.buttonRun addTarget:self action:@selector(showBook:) forControlEvents:UIControlEventTouchUpInside];
    }
}

#pragma mark - Table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    QBCOCustomObject *object_custom = [self.bookList objectAtIndex:indexPath.row];
    if ([object_custom.fields[@"type"] integerValue]!=TYPE_DATA_PDF) {
        [self performSegueWithIdentifier:@"playSound" sender:indexPath];
    }
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
    if ([[segue identifier] isEqualToString:@"playSound"]) {
        // Get reference to the destination view controller
        UINavigationController *nv = [segue destinationViewController];
        PlaySoundViewController *bookVC = [nv.viewControllers objectAtIndex:0];
            
        NSIndexPath *indexPath = (NSIndexPath*)sender;
        bookVC.currentIndexBook = indexPath.row;
        bookVC.bookList = self.bookList;
    }
}

- (void)showBook:(id)sender {
    TQNDocument *document = [TQNDocument instance];
    QBCOCustomObject *object_custom = [self.bookList objectAtIndex:[sender tag]];
    if ([document checkFileExist:@"PDF_FILES" fileName:[NSString stringWithFormat:@"%ld.pdf", (long)[object_custom.fields[@"bookID"]integerValue]]]) {
        NSString *documentFile = [document getFileInDirectory:@"PDF_FILES" fileName:[NSString stringWithFormat:@"%ld.pdf", (long)[object_custom.fields[@"bookID"]integerValue]]];
        [SVProgressHUD dismiss];
        [self readerPDFWithDocumentFile:documentFile];
    }else{
        [SVProgressHUD showWithStatus:NSLocalizedString(@"keyDownloading", nil)];
        BookService *serviceBook = [BookService instance];
        [serviceBook downloadFileWith:[object_custom.fields[@"bookID"]integerValue] statusBlock:^(QBRequestStatus *status) {
//            if(status.percentOfCompletion < 1.0f){
//                [SVProgressHUD showProgress:status.percentOfCompletion status:NSLocalizedString(@"keyDownloading", nil)];
//            } else {
//                [SVProgressHUD dismiss];
//            }
        } success:^(BOOL isSuccess) {
            [SVProgressHUD dismiss];
            if (isSuccess) {
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 1.0), dispatch_get_main_queue(), ^{
                     NSString *documentFile = [document getFileInDirectory:@"PDF_FILES" fileName:[NSString stringWithFormat:@"%ld.pdf", (long)[object_custom.fields[@"bookID"]integerValue]]];
                    [self readerPDFWithDocumentFile:documentFile];
                });
            }else{
                [CommonFeature showAlertTitle:NSLocalizedString(@"keyEffortListen", nil) Message:NSLocalizedString(@"keyLoadFileError", nil) duration:2.0 showIn:self blockDismissView:nil];
            }
        }];
    }
}

- (void)readerPDFWithDocumentFile:(NSString *)documentFile {
    ReaderPDF *reader = [ReaderPDF instance];
    [reader ShowReaderDoccumentWithName:documentFile inVC:self];
}

- (void)playSound:(id)sender {
    AdmodManager *adManager = [AdmodManager sharedInstance];
    adManager.interstitialDidDismissScreen = ^{
        QBCOCustomObject *object_custom = [self.bookList objectAtIndex:[sender tag]];
        BookService *service = [BookService instance];
        [service requestBlobWithID:[object_custom.fields[@"contentID"] integerValue] success:^(QBCBlob *blob) {
            if (blob) {
                PlaySound *play = [PlaySound instance];
                [play showVideoWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height-44)];
                [play playWithURLString:blob.privateUrl];                
            }
        }];
    };
    [adManager createAndLoadInterstitial];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
