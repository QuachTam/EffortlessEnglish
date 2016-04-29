//
//  FolderEntity+CoreDataProperties.h
//  EffortListen
//
//  Created by tamqn on 4/26/16.
//  Copyright © 2016 Tamqn. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "FolderEntity.h"

NS_ASSUME_NONNULL_BEGIN

@interface FolderEntity (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *uuid;
@property (nullable, nonatomic, retain) NSString *name;
@property (nullable, nonatomic, retain) NSSet<NSManagedObject *> *itemEntity;

@end

@interface FolderEntity (CoreDataGeneratedAccessors)

- (void)addItemEntityObject:(NSManagedObject *)value;
- (void)removeItemEntityObject:(NSManagedObject *)value;
- (void)addItemEntity:(NSSet<NSManagedObject *> *)values;
- (void)removeItemEntity:(NSSet<NSManagedObject *> *)values;

@end

NS_ASSUME_NONNULL_END
