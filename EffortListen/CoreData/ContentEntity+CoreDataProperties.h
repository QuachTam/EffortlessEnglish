//
//  ContentEntity+CoreDataProperties.h
//  EffortListen
//
//  Created by tamqn on 4/26/16.
//  Copyright © 2016 Tamqn. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "ContentEntity.h"

NS_ASSUME_NONNULL_BEGIN

@interface ContentEntity (CoreDataProperties)

@property (nullable, nonatomic, retain) ItemEntity *item;

@end

NS_ASSUME_NONNULL_END
