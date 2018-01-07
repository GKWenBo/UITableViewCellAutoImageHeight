# UITableViewCellAutoImageHeight

### 一、问题描述
> 最近在做公司项目的时候，遇到了前端上传多张图片到七牛服务器后，前端在列表展示图片适配的问题。一开始我设置的固定高度，因为图片尺寸不是固定的，会出现不同程度的拉伸情况，用户体验也很不好。通过设置图片视图**contentMode**这个属性，虽然能保证图片不被拉伸，但图片会出现显示不全的问题。

### 二、解决思路
#### 1、后台返回每张图片的宽高，根据比例去计算图片的高度
#### 2、获取到image，image有size这个属性，可以拿到宽高，根据比例去计算图片的高度
### 三、最终采用方案
第一种方案是可以实现图片的适配问题，我采用了第二种。图片都是网络加载的，要想拿到image，就必须要将图片下载下来，这样就可以获取到图片的尺寸。下面贴出我实现的关键步骤吧。
#### 1、工程导入[SDWebImage](https://github.com/rs/SDWebImage)和[Masonry](https://github.com/SnapKit/Masonry),导入相关头文件。
#### 2、SDWebImage下载图片，并计算出图片高度，将高度缓存到字典。自定义cell用Masonry设置好上下左右约束，也可以是xib。
```
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
ImageViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kIdentifier forIndexPath:indexPath];
cell.selectionStyle = UITableViewCellSelectionStyleNone;
NSString *url = self.imageUrlArray[indexPath.row];
[cell.autoImageView sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:nil options:SDWebImageRetryFailed completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
if (image.size.height) {
/**  < 图片宽度 >  */
CGFloat imageW = [UIScreen mainScreen].bounds.size.width - 2 * 15;
/**  <根据比例 计算图片高度 >  */
CGFloat ratio = image.size.height / image.size.width;
/**  < 图片高度 + 间距 >  */
CGFloat imageH = ratio * imageW + 15;
/**  < 缓存图片高度 没有缓存则缓存 刷新indexPath >  */
if (![[self.heightDict allKeys] containsObject:@(indexPath.row)]) {
[self.heightDict setObject:@(imageH) forKey:@(indexPath.row)];
[self.tableView beginUpdates];
[self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
[self.tableView endUpdates];
}
}
}];
return cell;
}
```
**注意**
- 字典key也可以是图片地址url
- 因为图片下载是异步的，要在下载完成图片之后，如果字典没有缓存当前indexPath高度，需要手动去刷新一次indexPath(最开始的时候，我没有根据key去判断是否需要刷新，当cell滑动的时候，会不停的调用**cellForRowAtIndexPath**这个方法，会不停的刷新，这样也非常耗费性能)。
#### 3、cell高度代理方法返回缓存的图片高度
```
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
return [[self.heightDict objectForKey:@(indexPath.row)] floatValue];
}
```
到这里，就已经实现了图片自适应高度的需求了，具体详情，请看测试[UITableViewCellAutoImageHeight](https://github.com/wenmobo/UITableViewCellAutoImageHeight)。实现这个需求，自己也折腾了一段时间，上面的方法现在也能满足项目的需求，但是在UI效果上感觉还是有一些不完美之处。如果大神有更好的实现方案和优化方法，希望能多多交流学习。如果以后有更好的实现方案，我也会在这篇文章中记录下来。

### 四、结语
> 2017年还剩两天，这篇文章也是今年写的最后一篇文章吧，写文章的初衷也是为了记录自己学习成长的点滴，同时也希望能够帮助到需要的人。2017就要结束了，自己的期望也未达到，希望在即将到来的2018年，自己更加努力，能够实现自己的期望与目标。奋斗吧，少年！
