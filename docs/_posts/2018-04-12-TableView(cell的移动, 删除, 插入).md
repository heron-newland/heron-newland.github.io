---
layout: post
title:  "UITableViewCell的移动, 删除, 插入"
date:   2018-04-12 10:32:03
categories:
 - Skills
tags:
 - Swift
---

TableView单选和多选cell的操作方式。

##### 系统cell的操作方法

##### 步骤一: 开启选择

	self.tableView.editing = !self.tableView.editing;

##### 步骤二: 设置编辑样式为单选和多选样式

	- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
	    return UITableViewCellEditingStyleDelete | UITableViewCellEditingStyleInsert;
	}

##### 自定义cell的操作方法:
##### 步骤一: 开启选择

	self.tableView.editing = !self.tableView.editing;

##### 步骤二: 设置编辑样式为单选和多选样式

	- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
	    return UITableViewCellEditingStyleDelete | UITableViewCellEditingStyleInsert;
	}

##### 步骤三: 设置选中和费选中的图片

	- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	    HLLUngroupTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:productcustomtabelcellid forIndexPath:indexPath];
	    //    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
	    cell.selectionStyle = UITableViewCellSelectionStyleNone;
	    cell.custom = self.customModels[indexPath.row];
	    
	//    HLLUngroupTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
	    
	    for (UIView *sub in cell.subviews) {
	        if ([sub isKindOfClass:[UIControl class]]) {
	            for (UIImageView *imgView in sub.subviews) {
	                imgView.image = [UIImage imageNamed:@"queren"];
	            }
	        }
	    }
	    @weakify(self);
	    cell.checkInfo = ^{
	        @strongify(self);
	        self.customModels[indexPath.row].isOpen = !self.customModels[indexPath.row].isOpen;
	        [self.tableView reloadData];
	    };
	    cell.checkDetail = ^{
	        
	    };
	    cell.makeGroup = ^{
	        
	    };
	    
	    return cell;
	}
	
	- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
	    HLLUngroupTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
	    for (UIView *sub in cell.subviews) {
	        if ([sub isKindOfClass:[UIControl class]]) {
	            for (UIImageView *imgView in sub.subviews) {
	                imgView.image = [UIImage imageNamed:@"queren_red"];
	            }
	        }
	    }   
	}
	- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath{
	    HLLUngroupTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
	
	    for (UIView *sub in cell.subviews) {
	        if ([sub isKindOfClass:[UIControl class]]) {
	            for (UIImageView *imgView in sub.subviews) {
	                imgView.image = [UIImage imageNamed:@"queren"];
	            }
	        }
	    }
	}



备注: 为啥开启编辑没有动画呢?