//
//  BDDragableTableView.m
//  suishenbaodian
//
//  Created by fengqingsong on 2018/6/1.
//  Copyright © 2018年 MY. All rights reserved.
//

#import "BDDragableTableView.h"

@interface BDDragableTableView()
@property (nonatomic, strong) UILongPressGestureRecognizer *longPress;
@property (nonatomic, strong) NSIndexPath *sourceIndexPath;
@property (nonatomic, strong) UIView *snapshotView;
@end

@implementation BDDragableTableView

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style {
    if (self = [super initWithFrame:frame style:style]) {
        [self bd_addGesture];
    }
    return self;
}

- (void)bd_addGesture {
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(cellDragRecognizer:)];
    self.longPress = longPress;
    [self addGestureRecognizer:longPress];
}

- (void)cellDragRecognizer:(UILongPressGestureRecognizer *)longPress {
    NSAssert(self.bd_dragDelegate, @"如若使用 BDDragableTableView ，必须设置其 bd_dragDelegate ，并实现代理方法");
    
    CGPoint location = [longPress locationInView:self];
    NSIndexPath *indexPath = [self indexPathForRowAtPoint:location];
    
    switch (longPress.state) {
        case UIGestureRecognizerStateBegan: {
            [self longPressDragBegin:location indexPath:indexPath];
            break;
        }
        case UIGestureRecognizerStateChanged: {
            [self longPressDragChanged:location indexPath:indexPath];
            break;
        }
        default: {
            [self longPressDragEnded:location indexPath:indexPath];
            break;
        }
    }
}

- (void)longPressDragBegin:(CGPoint)location indexPath:(NSIndexPath *)indexPath {
    if ([self.bd_dragDelegate respondsToSelector:@selector(BDDragableTableViewCanDrag:)]) {
        if (![self.bd_dragDelegate BDDragableTableViewCanDrag:indexPath]) {
            return;
        }
    }
    
    self.sourceIndexPath = indexPath;
    
    UITableViewCell *cell = [self cellForRowAtIndexPath:indexPath];
    UIView *snapView = [self snapshotTargetView:cell];
    snapView.center = cell.center;
    snapView.alpha =  0.0;
    self.snapshotView = snapView;
    [self addSubview:snapView];
    
    [UIView animateWithDuration:0.1 animations:^{
        snapView.alpha = 0.5;
        snapView.transform = CGAffineTransformMakeScale(1.05, 1.05);
        snapView.center = CGPointMake(snapView.center.x, location.y);
        cell.alpha = 0;
    }];
}

- (void)longPressDragChanged:(CGPoint)location indexPath:(NSIndexPath *)indexPath {
    if (!self.sourceIndexPath) {
        return;
    }
    
    self.snapshotView.center = CGPointMake(self.snapshotView.center.x, location.y);
    
    if ([self.bd_dragDelegate respondsToSelector:@selector(BDDragableTableViewCanMove:)]) {
        if (![self.bd_dragDelegate BDDragableTableViewCanMove:indexPath]) {
            return;
        }
    }
    
    UITableViewCell *cell = [self cellForRowAtIndexPath:indexPath];
    cell.alpha = 0;
    if (indexPath && ![indexPath isEqual:self.sourceIndexPath]) {
        if ([self.bd_dragDelegate respondsToSelector:@selector(BDDragableTableViewExchangeData:targetIndexPath:)]) {
            [self.bd_dragDelegate BDDragableTableViewExchangeData:self.sourceIndexPath targetIndexPath:indexPath];
            [self moveRowAtIndexPath:self.sourceIndexPath toIndexPath:indexPath];
            self.sourceIndexPath = indexPath;
        }
    }
}

- (void)longPressDragEnded:(CGPoint)location indexPath:(NSIndexPath *)indexPath {
    if (!self.sourceIndexPath) {
        return;
    }
    
    UITableViewCell *cell = [self cellForRowAtIndexPath:self.sourceIndexPath];
    [UIView animateWithDuration:0.1 animations:^{
        self.snapshotView.center = cell.center;
        self.snapshotView.transform = CGAffineTransformIdentity;
        self.snapshotView.alpha = 0;
        cell.alpha = 1;
    } completion:^(BOOL finished) {
        [self.snapshotView removeFromSuperview];
        self.snapshotView = nil;
        self.sourceIndexPath = nil;
    }];
}

- (UIView *)snapshotTargetView:(UIView *)targetView {
    UIGraphicsBeginImageContextWithOptions(targetView.bounds.size, NO, 0);
    [targetView.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *snapshotImg = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    UIImageView *snapshot = [[UIImageView alloc] initWithImage:snapshotImg];
    snapshot.bounds = CGRectMake(0, 0, snapshotImg.size.width, snapshotImg.size.height);
    snapshot.layer.shadowOffset = CGSizeMake(-5, 0);
    snapshot.layer.shadowRadius = 5.0;
    snapshot.layer.shadowOpacity = 0.4;
    return snapshot;
}


@end
