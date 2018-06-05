# BDDragableTableView
长按cell可以排序的tableView

## 使用

1. tableView继承自BDDragableTableView

2. 设置tableView的代理bd_dragDelegate，并实现代理方法

```
- (void)BDDragableTableViewExchangeData:(NSIndexPath *)sourceIndexPath targetIndexPath:(NSIndexPath *)targetIndexPath {
    //修改数据源
    [self.array exchangeObjectAtIndex:sourceIndexPath.row withObjectAtIndex:targetIndexPath.row];
}

- (BOOL)BDDragableTableViewCanDrag:(NSIndexPath *)indexPath {
    //是否允许长按拖拽 
}


- (BOOL)BDDragableTableViewCanMove:(NSIndexPath *)indexPath {
    //是否允许交换
}

```
## 演示
![](https://world521.github.io/assets/img/drag_table.gif)
