//
//  ViewController.m
//  新闻
//
//  Created by Mekor on 16/9/12.
//  Copyright © 2016年 李小争. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()<UIWebViewDelegate>
@property (nonatomic, weak)IBOutlet UIWebView *webVuew;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 网易新闻是怎么实现的
//    http://c.m.163.com/nc/article/C0OBRVC7051789DB/full.html
    
    
    NSURL *url = [NSURL URLWithString:@"http://c.m.163.com/nc/article/C0OBRVC7051789DB/full.html"];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    NSURLSessionTask *dataTask = [[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (error) {
            return;
        }
        
        NSDictionary *jsonData = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
        [self dealNewsDetail:jsonData];
        
    }];
    
    [dataTask resume];
}


-(void) dealNewsDetail:(NSDictionary *)jsonData{
    // 1. 取出所有的内容
    NSDictionary* allData = jsonData[@"C0OBRVC7051789DB"];
    //        print(allData!);
    
    // 2.取出body中的内容
    NSString * bodyHtml = allData[@"body"];
    
    // 3.取出标题
     NSString * title = allData[@"title"];
    
    // 4.取出发布时间
     NSString *ptime = allData[@"ptime"];
    
    // 5.取出来源
    NSString * source = allData[@"source"];
    
    // 6. 取出所有图片对象
    NSArray* img = allData[@"img"];
    
    // 7. 遍历
    for (int i = 0; i< img.count; i++) {
        NSDictionary *imgItem = img[i];
        
        // 取出占位标签
        NSString *ref = imgItem[@"ref"];
        // 取出图片标题
        NSString *imgTitle = imgItem[@"alt"];
        // 取出src
        NSString *src = imgItem[@"src"];
        NSString *imgHtml = [NSString stringWithFormat:@"<div class=\"all-img\"><img src=\"%@\"><div>%@</div></div>",src,imgTitle];
        // 替换body中的图片占位符
        bodyHtml = [bodyHtml stringByReplacingOccurrencesOfString:ref withString:imgHtml];
    }
    
    // 创建标题的HTML标签
    NSString * titleHtml = [NSString stringWithFormat:@"<div id=\"mainTitle\">%@</div>",title];
    // 创建子标题的HTML标签
    NSString * subTitleHtml = [NSString stringWithFormat:@"<div id=\"subTitle\"><span class=\"time\">%@</span><span>%@</span></div>",ptime,source];
    
    
    // 加载css的URL路径
    NSURL *css = [[NSBundle mainBundle] URLForResource:@"newsDetail" withExtension:@"css"];
    
    // 创建html标签
    NSString * cssHtml = [NSString stringWithFormat:@"<link href=\"%@\" rel=\"stylesheet\">",css];
    
    
    // 加载js的URL路径
    NSURL *js = [[NSBundle mainBundle] URLForResource:@"newsDetail" withExtension:@"js"];
    // 创建html标签
    NSString *jsHtml = [NSString stringWithFormat:@"<script src=\"%@\"></script>",js];
    
    // 拼接HTML
    NSString * html = [NSString stringWithFormat:@"<html><head>%@</head><body>%@%@%@%@</body></html>",cssHtml,titleHtml,subTitleHtml,bodyHtml,jsHtml];
    
    
    // 把对应的内容显示到webView中
    [self.webVuew loadHTMLString:html baseURL:nil];
}



#pragma mark - webViewDelegate
-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    // 1.取出请求字符串
    NSString *requestString = request.URL.absoluteString;
    
    // 2.判断处理
    NSString *URLHeader = @"mk:///";
    
    NSRange range = [requestString rangeOfString:URLHeader];
    
    NSUInteger location = range.location;
    
    if(location != NSNotFound){ // 包含了协议头
                                // 取出要操作的方法名称
        NSString * method = [requestString substringFromIndex:range.length];
        
        // 包装成SEL
        SEL sel = NSSelectorFromString(method);
        // 执行
        [self performSelector:sel];
    }
    
    return YES;

}

-(void)openCamera {
    NSLog(@"调用打开相机应用");
}
@end
