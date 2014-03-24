//
//  TableController.m
//  MASimpleMap
//
//  Created by Michael Ackley on 2/04/14.
//  Copyright (c) 2014 Michael Ackley. All rights reserved.
//

#import "TableController.h"

@interface TableController ()

@end

@implementation TableController


- (IBAction)backToMap:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.mapTable.delegate = self;
    self.mapTable.dataSource = self;
    
    NSLog(@"%@", self.mapDictionary);
    
    [self.mapTable reloadData];

}



- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return  50.0;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    return 6;

}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"mapCell"];
    
    if (indexPath.row == 0) {
        cell.detailTextLabel.text = [self.mapDictionary objectForKey:@"Name"];
        cell.textLabel.text =  @"Name";
        
    }
    if (indexPath.row == 1) {
        cell.detailTextLabel.text = [self.mapDictionary objectForKey:@"Address"];
        cell.textLabel.text =  @"Address";
        
    }
    if (indexPath.row == 2) {
        cell.detailTextLabel.text = [self.mapDictionary objectForKey:@"Distance"];
        cell.textLabel.text =  @"Distance";
    }
    if (indexPath.row == 3) {
        cell.detailTextLabel.text = [self.mapDictionary objectForKey:@"Phone"];
        cell.textLabel.text =  @"Phone";
        
    }
    if (indexPath.row == 4) {
        cell.detailTextLabel.text = [self.mapDictionary objectForKey:@"Website"];
        cell.textLabel.text =  @"Website";
        
    }
    if (indexPath.row == 5) {
        cell.detailTextLabel.text = @"Get Directions";
        cell.textLabel.text =  @"";

    }

    
    return cell;
}

#warning  Do something with the placemark! 
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == 5) {
        
        //  do something with the placemark
        //  MKPlacemark *place = [self.mapDictionary objectForKey:@"placemark"];
 
        
        
    }
   


    [tableView deselectRowAtIndexPath:indexPath animated:YES];



}








- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
