//
//  ItemEntity+CoreDataProperties.m
//  EffortListen
//
//  Created by tamqn on 4/26/16.
//  Copyright © 2016 Tamqn. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "ItemEntity+CoreDataProperties.h"

@implementation ItemEntity (CoreDataProperties)

@dynamic uuid;
@dynamic name;
@dynamic type;
@dynamic isDownload;
@dynamic folder;
@dynamic content;
@dynamic book;

@end