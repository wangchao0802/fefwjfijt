//
//  ViewController.m
//  CreateJXH
//
//  Created by clark.wang on 2017/10/19.
//  Copyright © 2017年 clark.wang. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet UIButton *getContentButton;
@property (weak, nonatomic) IBOutlet UIWebView *webView;

@property (weak, nonatomic) IBOutlet UIButton *generContent;

@property (strong, nonatomic)  NSString *originText;
@property (strong, nonatomic)  NSString *lastText;

@property (strong, nonatomic)  NSString *originURL;
@property (strong, nonatomic)  NSString *endURL;

@property (strong, nonatomic)  NSString *sku;

@property (weak, nonatomic) IBOutlet UILabel *skuLabel;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}
- (IBAction)getContent:(id)sender {
    self.skuLabel.text = @"";
    
    UIPasteboard * pad = [UIPasteboard generalPasteboard];
    self.textView.text = pad.string;
    self.originText = pad.string;
    [self getUrl];
    
    if ([self.endURL length] >0) {
        NSString *ss = self.endURL;
        NSRange range = [ss rangeOfString:@"https" options:NSCaseInsensitiveSearch];
        if (range.length >0) {
            ss = [ss stringByReplacingOccurrencesOfString:@"https" withString:@"http"];
        }
        NSURLRequest *nsurlRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:ss]];
        [self.webView loadRequest:nsurlRequest];
    }
    else
    {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"" message:self.endURL preferredStyle:UIAlertControllerStyleAlert];
        [alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            NSLog(@"点击确认");
        }]];
    }
}

-(void)getUrl
{
    self.originURL = self.originText;
    while (1) {
        NSRange  range = [self.originURL rangeOfString:@"http" options:NSCaseInsensitiveSearch];
        if (range.length >0) {
            self.endURL = [self.originURL substringFromIndex:range.location];
            self.originURL = [self.originURL substringFromIndex:(range.location+range.length)];
            NSLog(@"originUrl>>>> %@",self.originURL);
        }
        else
        {
            NSCharacterSet  *set = [NSCharacterSet whitespaceAndNewlineCharacterSet];
            self.endURL = [self.endURL stringByTrimmingCharactersInSet:set];
            NSRange range =  [self.endURL rangeOfCharacterFromSet:set];
            if (range.length >0)
            {
                self.endURL =  [self.endURL substringToIndex:range.location];
            }
            break;
        }
    }

}

- (IBAction)generateContent:(id)sender {
    
    NSString *lastUrl = [UIPasteboard generalPasteboard].string;
    self.lastText = [self.originText stringByReplacingOccurrencesOfString:self.endURL withString:lastUrl];
    self.textView.text = [NSString stringWithFormat:@"originUrl:%@\n >>>>>>>>>>>>>>>>\n newUrl:%@\n >>>>>>>>>>>>>>>>\n %@",self.endURL,lastUrl,self.lastText] ;
    [UIPasteboard generalPasteboard].string = self.lastText;
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request
     navigationType:(UIWebViewNavigationType)navigationType
{
    NSLog(@"shouldStartLoadWithRequest>>>>>>%@",request.URL);
    NSString *urlStr = request.URL.absoluteString;
    NSRange rangBegin = [urlStr rangeOfString:@"sku="];
    if (rangBegin.length >0) {
        NSString * sss = [urlStr substringFromIndex:rangBegin.location];
        NSRange rangEnd = [sss rangeOfString:@"&"];
        self.sku = [sss substringWithRange:NSMakeRange(4, rangEnd.location-4)];
        self.skuLabel.text = self.sku;
        if (self.sku) {
            [UIPasteboard generalPasteboard].string = self.sku;
          UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"" message:@"success" preferredStyle:UIAlertControllerStyleAlert];
            [alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                NSLog(@"点击确认");
            }]];
        }
    }
    
    return YES;
}
- (void)webViewDidStartLoad:(UIWebView *)webView
{
    NSLog(@"shouldStartLoadWithRequest>>>>>>%@",webView.request.URL);

}
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    
}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    
}


@end
