//
//  ViewController.m
//  UITextView自适应文字
//
//  Created by ZXW on 2017/3/22.
//  Copyright © 2017年 ZXW. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()<UITextViewDelegate>

@property(nonatomic,strong)UITextView *textView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    _textView = [[UITextView alloc]initWithFrame:CGRectMake(10, self.view.frame.size.height-35, self.view.frame.size.width-20, 33)];
    _textView.layer.borderWidth = 0.5;
    _textView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    _textView.delegate = self;
    _textView.font = [UIFont systemFontOfSize:15];
    _textView.returnKeyType = UIReturnKeySend;
    [self.view addSubview:_textView];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(kewboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHidden:) name:UIKeyboardWillHideNotification object:nil];
    
    [_textView becomeFirstResponder];
    
    _textView.text = @"";
    [self textViewDidChange:_textView];
    
}


-(void)kewboardWillShow:(NSNotification*)notification{
    
    CGRect rect = [[[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGFloat time = [[[notification userInfo] objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
    
    [UIView animateWithDuration:time animations:^{
        
        CGRect textViewFrame  = _textView.frame;
        
        textViewFrame.origin.y = rect.origin.y - 2 - _textView.frame.size.height;
        _textView.frame = textViewFrame;
        
    }];
    
}

-(void)keyboardWillHidden:(NSNotification*)notification{
    
//    CGRect rect = [[[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGFloat time = [[[notification userInfo] objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
    
    [UIView animateWithDuration:time animations:^{
        
        _textView.frame = CGRectMake(10, self.view.frame.size.height-_textView.frame.size.height-2, self.view.frame.size.width-20, _textView.frame.size.height);
        
    }];
    
}


- (void)textViewDidChange:(UITextView *)textView{
    
    CGFloat height = 0;
    CGFloat minHeight = 33; //最小的高度
    CGFloat maxHeight = 68; //最大的高度
    
    NSLog(@"%f",textView.contentSize.height);
    
    if (textView.contentSize.height<minHeight) {
        height = minHeight;
    }else if (textView.contentSize.height>maxHeight){
        height = maxHeight;
    }else{
        height = textView.contentSize.height;
    }
    
    //高度改变后的差值
    CGFloat h = height - _textView.frame.size.height;
    
    //改变frame
    _textView.frame = CGRectMake(10, _textView.frame.origin.y-h, _textView.frame.size.width, height);
    
    //加上这句话就不会出现闪一下的问题了
    [self.textView scrollRangeToVisible:NSMakeRange(self.textView.text.length-1, 1)];
    
}


-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    
    if ([text isEqualToString:@"\n"]) {
        textView.text = nil;
        //恢复原来的frame
        _textView.frame = CGRectMake(10, CGRectGetMaxY(_textView.frame)-33, _textView.frame.size.width, 33);
        return NO;
    }
    return YES;
}



-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    [self.view endEditing:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
