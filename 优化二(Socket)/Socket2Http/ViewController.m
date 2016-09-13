//
//  ViewController.m
//  Socket2Http
//
//  Created by Mekor on 16/9/13.
//  Copyright © 2016年 李小争. All rights reserved.
//

#import "ViewController.h"
#import <sys/socket.h>
#import <netinet/in.h>
#import <arpa/inet.h>

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UIWebView *webView;

@property (assign, nonatomic) int clientSocket;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //连接到百度的服务器
    BOOL result = [self connectServer:@"220.181.7.233" port:80];
    
    if (!result) {
        NSLog(@"连接服务器失败");
        return;
    }
    
    
    //拼接http请求
    NSString *request = @"GET / HTTP/1.1\n"
    "Connection: Close\n"
    "Host: m.baidu.com\n"
    //告诉服务器客户端是mac
    "User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_10_2) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/40.0.2214.115 Safari/537.36\n\n";
    
    
    
    //发送http请求，获取http响应
    NSString *response = [self sendAndRecv:request];
    NSLog(@"--%@",response);
    
    NSRange range = [response rangeOfString:@"\r\n\r\n"];
    if (range.location != NSNotFound) {
        
        NSString *html = [response substringFromIndex:range.location+range.length];
        //在webView中显示获取到的html
        [self.webView loadHTMLString:html baseURL:[NSURL URLWithString:@"http://m.baidu.com"]];
    }

}

- (NSString *)sendAndRecv:(NSString *)msg {
    //3 向服务器发送消息
    //第一个参数  Socket的描述符
    //第二个参数  发送的消息
    //第三个参数  发送的消息的字节个数
    //第四个参数  一般填0
    //返回值  是发送字符串的字节个数 strlen获取字符串的字节个数
    const char *ch = msg.UTF8String;
    
    ssize_t sendLength = send(self.clientSocket, ch, strlen(ch), 0);
    NSLog(@"发送了%ld字节",sendLength);
    //4 接收服务器返回的消息
    uint8_t buffer[1024];
    
    ssize_t recvLen = -1;
    NSMutableData *mData = [NSMutableData data];
    while (recvLen != 0) {
        recvLen = recv(self.clientSocket, buffer, sizeof(buffer), 0);
        
        [mData appendBytes:buffer length:recvLen];
    }
    NSString *str = [[NSString alloc] initWithData:mData.copy encoding:NSUTF8StringEncoding];
    return str;
}


- (BOOL)connectServer:(NSString *)ip port:(int)port {
    //1 创建Socket
    //第一个参数  协议域 AF_INET 决定了要用IPv4的地址
    //第二个参数  Socket的类型，流式Socket
    //第三个参数  使用的协议，TCP协议
    int clientSocket = socket(AF_INET, SOCK_STREAM, IPPROTO_TCP);
    self.clientSocket = clientSocket;
    //2 连接服务器
    struct sockaddr_in addr;
    addr.sin_family = AF_INET;//指定IPv4的地址
    addr.sin_port = htons(port);//端口号
    addr.sin_addr.s_addr = inet_addr(ip.UTF8String);//IP地址
                                                    //第一个参数  Socket的描述符
                                                    //第二个参数  服务器地址，结构体指针
                                                    //第三个参数  结构体长度
                                                    //返回值  成功则返回0，失败返回非0
    int result = connect(clientSocket, (const struct sockaddr *)&addr, sizeof(addr));
    if (result == 0) {
        //连接失败
        return YES;
    } else {
        return NO;
    }
}

@end
