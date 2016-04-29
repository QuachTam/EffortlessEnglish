//
//  ItemEntity+CoreDataProperties.h
//  EffortListen
//
//  Created by tamqn on 4/26/16.
//  Copyright © 2016 Tamqn. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "ItemEntity.h"

NS_ASSUME_NONNULL_BEGIN

@interface ItemEntity (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *uuid;
@property (nullable, nonatomic, retain) NSString *name;
@property (nullable, nonatomic, retain) NSNumber *type;
@property (nullable, nonatomic, retain) NSNumber *isDownload;
@property (nullable, nonatomic, retain) FolderEntity *folder;
@property (nullable, nonatomic, retain) NSManagedObject *content;
@property (nullable, nonatomic, retain) NSManagedObject *book;

@end

NS_ASSUME_NONNULL_END
