//
//  PlaySoundViewController.m
//  EffortListen
//
//  Created by Tamqn on 3/23/16.
//  Copyright © 2016 Tamqn. All rights reserved.
//

#import "PlaySoundViewController.h"
#import "FolderTableViewCell.h"
#import "ReaderViewController.h"
#import "PlaySound.h"
#import "ReaderPDF.h"
#import "TQNDocument.h"
#import "BookService.h"

@interface PlaySoundViewController ()<ReaderViewControllerDelegate>
@property (nonatomic, readwrite) NSInteger selectedIndexPath;

@end

@implementation PlaySoundViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = NSLocalizedString(@"keyReadBook", nil);
    
    self.selectedIndexPath = self.currentIndexBook;
    [self setUpselectedCellIndexPath];
    AdmodManager *adManager = [AdmodManager sharedInstance];
    [adManager showAdmodInViewController];
    [self footerView];
}

- (void)endObserverSound {
    PlaySound *play = [PlaySound instance];
    play.didCompletePlay = nil;
}

- (void)startObserverSound {
    PlaySound *play = [PlaySound instance];
    play.didCompletePlay = ^{
        if (self.selectedIndexPath<self.bookList.count) {
            NSIndexPath* oldCellIndexPath= [NSIndexPath indexPathForRow:self.selectedIndexPath inSection:0];
            NSIndexPath* selectedCellIndexPath= [NSIndexPath indexPathForRow:self.selectedIndexPath+1 inSection:0];
            [self playSoundWithIndexPath:selectedCellIndexPath oldIndexPath:oldCellIndexPath];
        }
    };
}

- (void)previousTrack {
    if (self.selectedIndexPath>0) {
        NSIndexPath* oldCellIndexPath= [NSIndexPath indexPathForRow:self.selectedIndexPath inSection:0];
        NSIndexPath* selectedCellIndexPath= [NSIndexPath indexPathForRow:self.selectedIndexPath-1 inSection:0];
        [self playSoundWithIndexPath:selectedCellIndexPath oldIndexPath:oldCellIndexPath];
    }
}

- (void)playSoundWithIndexPath:(NSIndexPath *)newIndexPath oldIndexPath:(NSIndexPath*)oldIndexPath {
    UITableViewCell *oldCell = [self.tbView cellForRowAtIndexPath:oldIndexPath];
    oldCell.accessoryType = UITableViewCellAccessoryNone;

    [self tableView:self.tbView didSelectRowAtIndexPath:newIndexPath];
    [self.tbView selectRowAtIndexPath:newIndexPath animated:YES scrollPosition:UITableViewScrollPositionNone];
}

- (void)footerView {
    UIView *header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 67)];
    self.tbView.tableFooterView = header;
    
    //update the header's frame and set it again
    CGRect newFrame = self.tbView.tableFooterView.frame;
    newFrame.size.height = newFrame.size.height;
    self.tbView.tableFooterView.frame = newFrame;
}

- (void)getBlobWithID:(NSInteger)ID success:(void(^)(QBCBlob *blob))success fail:(void(^)(void))fail{
    [QBRequest blobWithID:ID successBlock:^(QBResponse * _Nonnull response, QBCBlob * _Nullable blob) {
        if (success) {
            success(blob);
        }
    } errorBlock:^(QBResponse * _Nonnull response) {
        if (fail) {
            fail();
        }
    }];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    //Once the view has loaded then we can register to begin recieving controls and we can become the first responder
    [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
    [self becomeFirstResponder];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    //End recieving events
    [[UIApplication sharedApplication] endReceivingRemoteControlEvents];
    [self resignFirstResponder];
    
    PlaySound *play = [PlaySound instance];
    play.didCompletePlay = nil;
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
        } else if (event.subtype == UIEventSubtypeRemoteControlNextTrack) {
            PlaySound *play = [PlaySound instance];
            if (play.didCompletePlay) {
                play.didCompletePlay();
            }
        } else if (event.subtype == UIEventSubtypeRemoteControlPreviousTrack){
            [self previousTrack];
        }
    }
}

#pragma mark - Table view data source

- (void)setUpselectedCellIndexPath{
    if (self.selectedIndexPath>=0 && self.selectedIndexPath < self.bookList.count) {
        NSIndexPath* selectedCellIndexPath= [NSIndexPath indexPathForRow:self.selectedIndexPath inSection:0];
        [self tableView:self.tbView didSelectRowAtIndexPath:selectedCellIndexPath];
        [self.tbView selectRowAtIndexPath:selectedCellIndexPath animated:YES scrollPosition:UITableViewScrollPositionNone];
        [self.tbView cellForRowAtIndexPath:selectedCellIndexPath].accessoryType = UITableViewCellAccessoryCheckmark;
    }
}

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
    if(indexPath.row == self.selectedIndexPath) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }else {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath   *)indexPath {
    [self endObserverSound];
    
    QBCOCustomObject *object_custom = [self.bookList objectAtIndex:indexPath.row];
    [tableView cellForRowAtIndexPath:indexPath].accessoryType = UITableViewCellAccessoryCheckmark;
    self.selectedIndexPath = indexPath.row;
    [SVProgressHUD showWithStatus:NSLocalizedString(@"keyLoading", nil)];
    [self getBlobWithID:[object_custom.fields[@"contentID"] integerValue] success:^(QBCBlob *blob) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [SVProgressHUD dismiss];
        });
        PlaySound *play = [PlaySound instance];
        play.dimissCompleteBlock =^{
            [play showVideoWithFrame:CGRectMake(0, 64, self.view.frame.size.width, 100)];
            [play playWithURLString:blob.privateUrl];
            [self startObserverSound];
        };
        if (play.isAvailable) {
            [play dismiss];
        }else{
            [play showVideoWithFrame:CGRectMake(0, 64, self.view.frame.size.width, 100)];
            [play playWithURLString:blob.privateUrl];
            [self startObserverSound];
        }
    } fail:^{
        [SVProgressHUD showErrorWithStatus:NSLocalizedString(@"keyServerError", nil)];
    }];
}

-(void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView cellForRowAtIndexPath:indexPath].accessoryType = UITableViewCellAccessoryNone;
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

- (IBAction)cancelAction:(id)sender {
    PlaySound *play = [PlaySound instance];
    [play stop];
    play.dimissCompleteBlock = ^{
        [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    };
    [play dismiss];
}

- (IBAction)readBookAction:(id)sender {
    TQNDocument *document = [TQNDocument instance];
    QBCOCustomObject *object_custom = [self.bookList objectAtIndex:self.selectedIndexPath];
    if ([document checkFileExist:@"PDF_FILES" fileName:[NSString stringWithFormat:@"%ld.pdf", (long)[object_custom.fields[@"bookID"]integerValue]]]) {
        NSString *documentFile = [document getFileInDirectory:@"PDF_FILES" fileName:[NSString stringWithFormat:@"%ld.pdf", (long)[object_custom.fields[@"bookID"]integerValue]]];
        [SVProgressHUD dismiss];
        ReaderPDF *reader = [ReaderPDF instance];
        [reader ShowReaderDoccumentWithName:documentFile inVC:self];
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
            if (isSuccess) {
                [SVProgressHUD dismiss];
                // Delay execution of my block for 10 seconds.
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 1.0), dispatch_get_main_queue(), ^{
                    NSString *documentFile = [document getFileInDirectory:@"PDF_FILES" fileName:[NSString stringWithFormat:@"%ld.pdf", (long)[object_custom.fields[@"bookID"]integerValue]]];
                    ReaderPDF *reader = [ReaderPDF instance];
                    [reader ShowReaderDoccumentWithName:documentFile inVC:self];
                });
            }else{
                [CommonFeature showAlertTitle:NSLocalizedString(@"keyEffortListen", nil) Message:NSLocalizedString(@"keyLoadFileError", nil) duration:2.0 showIn:self blockDismissView:nil];
            }
        }];
    }
}


@end
