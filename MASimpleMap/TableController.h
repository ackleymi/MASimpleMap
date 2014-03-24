//
//  TableController.h
//  MASimpleMap
//
//  Created by Michael Ackley on 2/04/14.
//  Copyright (c) 2014 Michael Ackley. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <Social/Social.h>
#import <Accounts/Accounts.h>

@interface TableController : UIViewController <UITableViewDataSource, UITableViewDelegate>

- (IBAction)backToMap:(id)sender;

@property (strong, nonatomic) IBOutlet UITableView *mapTable;

@property (nonatomic, strong) NSMutableDictionary *mapDictionary;


@end
