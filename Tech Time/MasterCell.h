//
//  MasterCell.h
//  Splitting Up is Easy To Do
//
//  Created by XiaoYifan on 2/12/15.
//  Copyright (c) 2015 XiaoYifan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MasterCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *itemTitle;

@property (weak, nonatomic) IBOutlet UILabel *itemDate;

@property (weak, nonatomic) IBOutlet UILabel *itemSnippet;


@end
