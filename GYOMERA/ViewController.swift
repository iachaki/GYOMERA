//
//  ViewController.swift
//  GYOMERA
//
//  Created by ia on 2015/08/26.
//  Copyright (c) 2015年 Life is tech. All rights reserved.
//

import UIKit
import AVFoundation


class ViewController: UIViewController {
    //定数がlet,変数がvar,引数が,メソッドがfunc
    
    
    //セッション
    var mySession : AVCaptureSession! //nillは基本❌”!”＊codeには書いてないけどstorybordにはあるよ！強め！
    //デバイス
    var myDevice : AVCaptureDevice!
    //画像のアウトプット
    var myImageOutput : AVCaptureStillImageOutput!
    
    //撮った写真
    var myImage: UIImage!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        //セッションの生成
        mySession = AVCaptureSession()
        
        //デバイス一覧の取得
        let devices = AVCaptureDevice.devices()
        
        //バックカメラをmy deviceに格納
        for device in devices{
            if(device.position == AVCaptureDevicePosition.Back){
                myDevice = device as! AVCaptureDevice
            }
        }
        //バックカメラからVideoInputを取得
        let videoInput = AVCaptureDeviceInput.deviceInputWithDevice(myDevice, error: nil) as! AVCaptureDeviceInput
        
        //セッションに追加
        mySession.addInput(videoInput)
        
        //出力先を生成
        myImageOutput = AVCaptureStillImageOutput()
        
        //セッションに追加
        mySession.addOutput(myImageOutput)
        
        //画像を表示するレイヤーを作成
        let myVideoLayer : AVCaptureVideoPreviewLayer = AVCaptureVideoPreviewLayer.layerWithSession(mySession) as! AVCaptureVideoPreviewLayer
        myVideoLayer.frame = self.view.bounds
        myVideoLayer.videoGravity = AVLayerVideoGravityResizeAspectFill
        
        //viewに追加
        self.view.layer.addSublayer(myVideoLayer)
        
        //セッション開始
        mySession.startRunning()
        
        //UIボタンを作成
        let myButton = UIButton(frame: CGRectMake(0, 0, 81, 87))
        let myButtonImage = UIImage(named: "CameraButton.png" )
        myButton.setBackgroundImage(myButtonImage!, forState: .Normal)
        myButton.layer.position = CGPoint(x: self.view.bounds.width/2, y: self.view.bounds.height-50)
        myButton.addTarget(self, action: "onClickMyButton:", forControlEvents: .TouchUpInside)
        //”onClickMyButton:”の”:”は引数があるときにつける！(sender:)
        
                //下のViewを作成
        let width = self.view.bounds.width
        let whiteView: UIView = UIView(frame: CGRectMake(0, 0,width,95))
       // whiteView.backgroundColor = UIColor(white: 1,)
        whiteView.layer.position = CGPoint(x: self.view.bounds.width/2, y: self.view.bounds.height-95/2)
        self.view.addSubview(whiteView)
        
        //UIボタンをViewに追加
        self.view.addSubview(myButton)
        

        
    }
    
      //ボタンイベント
       func onClickMyButton(sender: UIButton){
    
            //ビデオ出力に接続
            let myVideoConnection = myImageOutput.connectionWithMediaType(AVMediaTypeVideo)
    
            //接続から画像を取得
            self.myImageOutput.captureStillImageAsynchronouslyFromConnection(myVideoConnection, completionHandler: {(ImageDataBuffer, error) -> Void in
    
               //取得したImageDataのDataBufferをJpegに変換
                let myImageData : NSData = AVCaptureStillImageOutput.jpegStillImageNSDataRepresentation(ImageDataBuffer)
    
              //JpegからUIImageを作成
               self.myImage = UIImage(data: myImageData)!
                
              self.performSegueWithIdentifier("SegueCT", sender: nil)
        
                //アルバムに追加
               UIImageWriteToSavedPhotosAlbum(self.myImage, self, nil, nil)
    
    
            })
        }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?){
        if segue.identifier == "SegueCT" {
            var chooseTagViewController = segue.destinationViewController as! ChooseTagViewController
            chooseTagViewController.tagImage = myImage
        }
    }
    
    //     let myViewController : UIViewController = ChooseTagViewController()
    
    
    
    //self.presentViewController(ChooseTagViewController, animated: true, completion: nil)
    //performSegueWithIdentifier("SegueCT", sender: nil)
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}
