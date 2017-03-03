//
//  ViewController.m
//  JPImageDownloader
//
//  Created by ovopark_iOS on 16/8/2.
//  Copyright © 2016年 JaryPan. All rights reserved.
//

#import "ViewController.h"
#import "JPImageDownloader.h"

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UILabel *diskSizeLabel;
@property (weak, nonatomic) IBOutlet UILabel *memorySizeLable;

@property (strong, nonatomic) NSArray *images;
@property (nonatomic) NSInteger index;

@property (strong, nonatomic) UIActivityIndicatorView *aiv;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.images = @[@"http://img.taopic.com/uploads/allimg/120511/159289-12051123214590.jpg", @"http://pic49.nipic.com/file/20140928/4949133_154724315000_2.jpg", @"http://img2.3lian.com/2014/f2/20/d/71.jpg", @"http://pic15.nipic.com/20110708/2628625_091940476113_2.jpg"];
}

- (IBAction)diskSizeButtonAction:(id)sender {
    __weak typeof(self) weakSelf = self;
    
    [JPImageDownloader calculateDiskCaches:^(NSUInteger totalSize, NSUInteger fileCount) {
        if (totalSize < 1024*1024) {
            weakSelf.diskSizeLabel.text = [NSString stringWithFormat:@"文件个数：%lu\n总大小：%.2f KB", fileCount, totalSize/1024.0];
        } else {weakSelf.diskSizeLabel.text = [NSString stringWithFormat:@"文件个数：%lu\n总大小：%.2f M", fileCount, totalSize/1024.0/1024.0];
        }
    }];
}
- (IBAction)memorySizeButtonAction:(id)sender {
    __weak typeof(self) weakSelf = self;
    
    [JPImageDownloader calculateMemoryCaches:^(NSUInteger totalSize, NSUInteger fileCount) {
        if (totalSize < 1024*1024) {
            weakSelf.memorySizeLable.text = [NSString stringWithFormat:@"文件个数：%lu\n总大小：%.2f KB", fileCount, totalSize/1024.0];
        } else {weakSelf.memorySizeLable.text = [NSString stringWithFormat:@"文件个数：%lu\n总大小：%.2f M", fileCount, totalSize/1024.0/1024.0];
        }
    }];
}

- (IBAction)startDownloadImage:(id)sender {
    [self startAnimating];
    
    __weak typeof(self) weakSelf = self;
    
    [JPImageDownloader imageWithUrlString:self.images[self.index] completionHandler:^(UIImage * _Nullable image, NSError * _Nullable error, JPImageCacheType cacheType, NSURL * _Nullable imageURL) {
        [weakSelf stopAnimating];
        
        weakSelf.imageView.image = image;
        weakSelf.index++;
        if (weakSelf.index == 4) {
            weakSelf.index = 0;
        }
    }];
    
    NSLog(@"%lu", [[JPImageCaches sharedCaches] diskCachesCount]);
}

- (void)startAnimating
{
    if (!self.aiv) {
        self.aiv = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
        self.aiv.center = self.imageView.center;
        self.aiv.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhite;
        [self.imageView addSubview:self.aiv];
    }
    [self.aiv startAnimating];
}
- (void)stopAnimating
{
    [self.aiv stopAnimating];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
