//
//  ChooseTagViewController.swift
//  GYOMERA
//
//  Created by ia on 2015/08/26.
//  Copyright (c) 2015年 Life is tech. All rights reserved.
//

import UIKit

class ChooseTagViewController: UIViewController {
    
    @IBOutlet var imageView : UIImageView!
    @IBOutlet var label : UILabel!
    
    
    var tagImage:UIImage!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //imageViewにtagImageを表示
        imageView.image = tagImage
        
    }
    
    @IBAction func LoadingTag() {
        
        SVProgressHUD.showWithStatus("ANALYZING")
        
        dispatch_async_global {
            // 何か時間のかかる処理(APIの呼び出しなど)
            //sdkを初期化
            var sdk: ReKognitionSDK = ReKognitionSDK(APIKey: "v2vjbcH2wnRjPpck", APISecret: "zCVsd3h4u4GMCqUb")
            var sceneResults: RKSceneUnderstandingResults = sdk.RKSceneUnderstanding(self.imageView.image)
            
            self.dispatch_async_main {
                    SVProgressHUD.showSuccessWithStatus("FINISH!")
                    // 成功時の処理を行う(APIのレスポンスを利用して描画処理など)
                
                    var scenes = sceneResults.matched_scenes
                    NSLog("scenes : %@",scenes)
                    
                    self.label.text = String(stringInterpolationSegment: scenes)
            }
        }
    
    }
    
    //便利関数
    func dispatch_async_main(block: () -> ()) {
        dispatch_async(dispatch_get_main_queue(), block)
    }
    
    func dispatch_async_global(block: () -> ()) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), block)
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    /*
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    // Get the new view controller using segue.destinationViewController.
    // Pass the selected object to the new view controller.
    }
    */
    
}
