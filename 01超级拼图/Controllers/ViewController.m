//
//  ViewController.m
//  01超级拼图
//
//  Created by mac on 2021/6/7.
//

#import "ViewController.h"
#import "CZQuestion.h"
@interface ViewController ()

@property(nonatomic,strong)NSArray *questions;//实现懒加载
@property(nonatomic,assign)int index;//setter方法将传入参数赋值给实例变量，仅设置变量时，assign适用于基本数据类型，并且是一个弱引用
@property (weak, nonatomic) IBOutlet UILabel *lblIndex;
@property (weak, nonatomic) IBOutlet UIButton *btnScore;
@property (weak, nonatomic) IBOutlet UILabel *lblTitle;
@property (weak, nonatomic) IBOutlet UIButton *btnIcon;
@property (weak, nonatomic) IBOutlet UIButton *btnNext;
@property (weak, nonatomic) IBOutlet UIView *answerView;
@property (weak, nonatomic) IBOutlet UIView *optionsView;//底下那个大框回答的按钮



//设置一个属性记录原始的frame 点击大图之前记录
@property(nonatomic,assign)CGRect iconFrame;
//一个方法内访问另一个方法是访问不到的，所以需要一个变量来引用
@property(weak,nonatomic)UIButton *cover;
- (IBAction)btnNextClick;
- (IBAction)bigImage:(id)sender;
//实现点击头像变大变小操作
- (IBAction)btnIconClick:(id)sender;
- (IBAction)btnTipClick;

@end

@implementation ViewController
//懒加载数据
-(NSArray *)questions{
    if (_questions==nil) {
        //加载数据
        //这个问题加载了半天，注意路径实在/根目录下
        NSString *path=[[NSBundle mainBundle]pathForResource:@"/questions" ofType:@"plist"];
        NSArray *arrayDict=[NSArray arrayWithContentsOfFile:path];
        NSMutableArray *arrayModel=[NSMutableArray array];
        
        //字典转为模型
        for (NSDictionary *dict in arrayDict) {
            CZQuestion *model=[CZQuestion questionWithDict:dict];
            [arrayModel addObject:model];
        }
        _questions=arrayModel;
    }
    return _questions;
}

//改变状态栏文字上方的颜色
-(UIStatusBarStyle)preferredStatusBarStyle{
    //return UIStatusBarStyleLightContent;//改成了浅色但是我底色是绿色不太好看
    //还是改回去
    return UIStatusBarStyleDarkContent;
    
}
//隐藏状态栏
/**
 -(BOOL)prefersStatusBarHidden{
     return YES;//就看不见了  但是我还是习惯于看见
 }
 */

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //默认初始化显示第一题
    self.index=-1;
    [self nextQuestion];
}





//点击提示按钮 首先减分 然后提示第一个正确的子
- (IBAction)btnTipClick {
    [self addScore:-1000];
    
    for(UIButton *btnAnswer in self.answerView.subviews){
        [self btnAnswerClick:btnAnswer];
        
    }
    
    //根据索引找出争取的数据   从模型中找出和这个字符相等的那个按钮点击一下
    CZQuestion *model=self.questions[self.index];
    NSString *firstChar=[model.answer substringToIndex:1];
    //找到对应的option点击一下
    for (UIButton *btnOpt in self.optionsView.subviews) {
        if([btnOpt.currentTitle isEqualToString:firstChar]){
            [self optionButtonClick:btnOpt];
            break;;
        }
    }
    
}

- (IBAction)btnIconClick:(id)sender {
    if(self.cover==nil){
        [self bigImage:nil];
    }else{
        [self smallImage];
    }
}

- (IBAction)bigImage:(id)sender {
    self.iconFrame=self.btnIcon.frame;
    
    UIButton *btnCover=[[UIButton alloc] init];
    btnCover.frame=self.view.bounds;
    btnCover.backgroundColor=[UIColor blackColor];
    //设置透明
    btnCover.alpha=0.0;
    //为阴影注册单击事件
    [btnCover addTarget:self action:@selector(smallImage) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btnCover];
    //把头像放到最上面就可以a
    [self.view bringSubviewToFront:_btnIcon];
    //在大图里面引用
    self.cover=btnCover;
    
    //通过动画的方式放大头像
    CGFloat iconW=self.view.frame.size.width;
    CGFloat iconh=iconW;
    CGFloat iconX=0;
    CGFloat iconY=(self.view.frame.size.height-iconh)*0.5;
    //设置动画
    [UIView animateWithDuration:0.7 animations:^{
        btnCover.alpha=0.6;
        self.btnIcon.frame=CGRectMake(iconX, iconY, iconW, iconh);
    }];
    
    //设置图片的frame
   
    
}
//阴影的单机方法
-(void)smallImage{
   // NSLog(@"我是变小");
   
    
   
    [UIView animateWithDuration:0.7 animations:^{
            //头像大小还原
            self.btnIcon.frame=self.iconFrame;
            self.cover.alpha=0;
        } completion:^(BOOL finished) {
            if(finished){
                //移除
                [self.cover removeFromSuperview];
                //当头像变成小图的时候设置，为了后续点击头像判断操作
                self.cover=nil;
            }
        }];
}

- (IBAction)btnNextClick {
    [self nextQuestion];
}
-(void)nextQuestion{
    //1.让索引
    self.index++;
    if(self.index==self.questions.count-1){
       // NSLog(@"已经是最后一张了")
        //1.创建Controller
        UIAlertController *alertSheet = [UIAlertController alertControllerWithTitle:@"操作提示" message:@"恭喜过关" preferredStyle:UIAlertControllerStyleActionSheet];
        /*
         参数说明：
         Title:弹框的标题
         message:弹框的消息内容
         preferredStyle:弹框样式：UIAlertControllerStyleActionSheet
         */
        
        //2.添加按钮动作
        UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
           // NSLog(@"点击了项目1");
            self.index=-1;
            [self nextQuestion];
        }];
//        UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//            NSLog(@"点击了项目2");
//        }];
        UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            NSLog(@"点击了取消");
        }];
        //3.添加动作
        [alertSheet addAction:action1];
       // [alertSheet addAction:action2];
        [alertSheet addAction:cancel];
        
        //4.显示sheet
        [self presentViewController:alertSheet animated:YES completion:nil];


    }
    //2.根据索引获得当前对象的模型数据
    CZQuestion *model=self.questions[self.index];
    
    //3.根据模型设置数据
    [self settingData:model];
    //4.动态创建答案按钮
    [self makeAnswerButton:model];
    //5.动态创建待选按钮
    [self makeOptionButton:model];
    
   
}
//加载数据，把模型数据设置到界面的控件上
-(void)settingData:(CZQuestion *)model
{
    self.lblIndex.text=[NSString stringWithFormat:@"%d /%ld",(self.index+1),self.questions.count];
    self.lblTitle.text=model.title;
    [self.btnIcon setImage:[UIImage imageNamed:model.icon] forState:UIControlStateNormal];
    //
    self.btnNext.enabled=(self.index!=self.questions.count-1);
}
-(void)makeAnswerButton:(CZQuestion *)model{
    
    /**
     在动态获得之前，我们要清除掉之前的自按钮
     */
//    while (self.answerView.subviews.firstObject) {
//        [self.answerView.subviews.firstObject removeFromSuperview];
//    }
    //让数组中的每一个对象调用这个方法
    [self.answerView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    //动态创建答案按钮
    NSInteger len=model.answer.length;
    CGFloat margin=10;//假设每个那妞之间的距离都是10
    CGFloat answerW=35;
    CGFloat answerH=35;
    CGFloat answerY=0;
    CGFloat marginLeft=(self.answerView.frame.size.width-(len*answerW)-(len-1)*margin)/2;
    
    
    for (int i=0; i<len; i++) {
        UIButton *btnAnswer=[[UIButton alloc]init];
        [btnAnswer setBackgroundImage:[UIImage imageNamed:@"1"] forState:UIControlStateNormal];
        [btnAnswer setBackgroundImage:[UIImage imageNamed:@"2"] forState:UIControlStateHighlighted];
        
        CGFloat answerX=marginLeft+i*(answerW+margin);
        btnAnswer.frame=CGRectMake(answerX, answerY, answerW, answerH);
        
        [btnAnswer setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [self.answerView addSubview:btnAnswer];
        //给答案按钮注册单击事件，因为需要消除在上面的文字
        [btnAnswer addTarget:self action:@selector(btnAnswerClick:) forControlEvents:UIControlEventTouchUpInside];
    }
      
}
//参数sender表示当前答案按钮
-(void)btnAnswerClick:(UIButton *)sender{
    self.optionsView.userInteractionEnabled=YES;
    [self setAnswerButtonsTitleColor:[UIColor blackColor]];
    for (UIButton *optBtn in self.optionsView.subviews) {
//        if([sender.currentTitle isEqualToString:optBtn.currentTitle]){
//            optBtn.hidden=NO;
//            break;
//        }
        if(sender.tag==optBtn.tag){
            optBtn.hidden=NO;
            break;;
        }
    }
    [sender setTitle:nil forState:UIControlStateNormal];
}


-(void)makeOptionButton:(CZQuestion *)model{
    //首先设置可用
    self.optionsView.userInteractionEnabled=YES;
    
    //1 清楚上一步的anniu
    [self.optionsView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    //2 获取文字
        NSArray *word =model.options;
   // NSLog(@"%@",word);
    CGFloat optionW=35;
    CGFloat optionH=35;
    CGFloat margin=10;
    //制定每行有多少anniu
    int colums=7;
    CGFloat marginLeft=(self.optionsView.frame.size.width-colums*optionW-(colums-1)*margin)/2;
    //3 循环创建按钮
    for (int i=0; i<word.count; i++) {
       
        
        UIButton *btnOpt=[[UIButton alloc]init];
        //创建option的时候给一个唯一的tag值  万一有重复的文字，就靠着这个唯一的tag来确定位置
        btnOpt.tag=i;//然后在待选按钮单击事件的时候把tag也设置给答案
        
        //设置背景图 文字 按钮frame 把按钮添加到optionView中
        [btnOpt setBackgroundImage:[UIImage imageNamed:@"btnBackground"] forState:UIControlStateNormal];
        [btnOpt setBackgroundImage:[UIImage imageNamed:@"question_hight"] forState:UIControlStateHighlighted];
        //设置文字
        [btnOpt setTitle:word[i] forState:UIControlStateNormal];
        [btnOpt setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        //计算行索引。列索引
        int colIdx=i%colums;
        int rowIdx=i/colums;
        CGFloat optionX=marginLeft+colIdx*(optionW+margin);
        CGFloat optionY=0+rowIdx*(optionH+margin);
        
        btnOpt.frame=CGRectMake(optionX, optionY, optionW, optionH);
        //把按钮添加到大的optionsView里面
        [self.optionsView addSubview:btnOpt];
        
        //为每一个答案按钮注册单击事件
        [btnOpt addTarget:self action:@selector(optionButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
}
-(void)optionButtonClick:(UIButton *)sender{
    //隐藏按钮 然后把当前文字显示到第一个上面
    sender.hidden=YES;
    NSString *text=sender.currentTitle;
    
  
    for(UIButton *ansuweBtn in self.answerView.subviews){
        if(ansuweBtn.currentTitle==nil){
            [ansuweBtn setTitle:text forState:UIControlStateNormal];
            ansuweBtn.tag=sender.tag;
            break;
        }
    }
    
    //判断答案是否填满。如果填满 就禁止底下的按钮与用户交互
    BOOL isFull=YES;
    
    //用来保存用户答案
    NSMutableString *userInput=[NSMutableString string];
    for (UIButton *btnAnswer in self.answerView.subviews) {
        if(btnAnswer.currentTitle==nil){
            isFull=NO;
            break;
        }else{
            [userInput appendString: btnAnswer.currentTitle];
        }
    }
    if(isFull){
        self.optionsView.userInteractionEnabled=NO;
        //获取争取答案
        CZQuestion *model=self.questions[self.index];
        if([model.answer isEqualToString:userInput]){
            //正确调用加粉方法
            [self addScore:100];
            
            [self setAnswerButtonsTitleColor:[UIColor blueColor]];
            [self performSelector:@selector(nextQuestion) withObject:nil afterDelay:0.5];
        }else{
            [self setAnswerButtonsTitleColor:[UIColor redColor]];
        }
    }
}
-(void)addScore:(int)score{
    NSString *str=self.btnScore.currentTitle;
    int  currentScore=str.intValue;
    currentScore=currentScore+score;
    [self.btnScore setTitle:[NSString stringWithFormat:@"%d" ,currentScore] forState:UIControlStateNormal];
    
}
-(void)setAnswerButtonsTitleColor:(UIColor *)color{
    for (UIButton *btnAnswer in self.answerView.subviews) {
        [btnAnswer setTitleColor:color forState:UIControlStateNormal];
    }
}

@end
