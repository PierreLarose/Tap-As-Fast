//
//  ViewController.m
//  Tap As Fast
//
//  Created by E_RATIO on 7/7/16.
//  Copyright © 2016 E_RATIO. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController
-(AVAudioPlayer *)setUpAudioPlayerWithFile:(NSString *) file type:(NSString *) type {
    NSString *path = [[NSBundle mainBundle] pathForResource:file ofType:type];
    NSURL *url = [NSURL fileURLWithPath:path];
    
    NSError *error;
    
    AVAudioPlayer *audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL: url error:&error];
    
    if (!audioPlayer) {
        NSLog(@"%@",[error description]);
    }
    
   return audioPlayer;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg_tile.png"]];
    scoreLabel.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"field_score.png"]];
    timerLabel.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"field_time.png"]];
    
    buttonBeep = [self setUpAudioPlayerWithFile:@"ButtonTap" type:@"wav"];
    secondBeep = [self setUpAudioPlayerWithFile:@"SecondBeep" type:@"wav"];
    backgroundMusic = [self setUpAudioPlayerWithFile:@"HallOfTheMountainKing" type:@"mp3"];
    
    [self setUpGame];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)buttonPressed:(id)sender{
    count++;
    
    scoreLabel.text = [NSString stringWithFormat:@"Score:\n%li", (long)count];
    
    [buttonBeep play];

}

-(void)setUpGame {
    seconds = 30;
    count = 0;
    
    timerLabel.text = [NSString stringWithFormat:@"Time: %li",(long)seconds];
    scoreLabel.text = [NSString stringWithFormat:@"Score: \n%li",(long)count];
    
    timer = [NSTimer scheduledTimerWithTimeInterval:1.0f
                                             target:self
                                           selector:@selector(subtractTime) userInfo:nil repeats:YES];
    
    
    [backgroundMusic setVolume:0.1];
    [backgroundMusic play];
}

-(void)subtractTime {
    
    seconds--;
    timerLabel.text = [NSString stringWithFormat:@"Time: %li",(long)seconds];
    
    [secondBeep play];
    
    if(seconds == 0) {
        [timer invalidate];
        
        UIAlertController * alert=   [UIAlertController
                                      alertControllerWithTitle:@"Time is Up!"
                                      message:[NSString stringWithFormat:@"You scored %li points", (long)count]
                                      preferredStyle:UIAlertControllerStyleAlert];
        
        
        UIAlertAction* cancel = [UIAlertAction
                                 actionWithTitle:@"Play Again!"
                                 style:UIAlertActionStyleDefault
                                 handler:^(UIAlertAction * action)
                                 {
                                     [self setUpGame];
                                     [alert dismissViewControllerAnimated:YES completion:nil];
                                     
                                 }];
        
        [alert addAction:cancel];
        
        [self presentViewController:alert animated:YES completion:nil];
    }
}

@end
