//
//  BDDragableTableView.h
//  suishenbaodian
//
//  Created by fengqingsong on 2018/6/1.
//  Copyright © 2018年 MY. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol BDDragableTableViewDelegate <NSObject>

@required
/** 交换数据源 */
- (void)BDDragableTableViewExchangeData:(NSIndexPath *)sourceIndexPath targetIndexPath:(NSIndexPath *)targetIndexPath;

@optional
/** 是否允许长按拖拽 */
- (BOOL)BDDragableTableViewCanDrag:(NSIndexPath *)indexPath;
/** 是否允许交换 */
- (BOOL)BDDragableTableViewCanMove:(NSIndexPath *)indexPath;

@end

@interface BDDragableTableView : UITableView
@property (nonatomic, weak) id<BDDragableTableViewDelegate> bd_dragDelegate;
@end
