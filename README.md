AsyncImageView
==============

AsyncImageView can load image asyncronously via network.

You can just implement as follows.

```antlr-objc:
- (void)viewDidLoad {
    [super viewDidLoad];
    
    AsyncImageView* asyncImageView = [[AsyncImageView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
    [self.view addSubview:asyncImageView];
    [asyncImageView setImageWithUrl:@"http://sample.com/hoge.png"];
}
```
