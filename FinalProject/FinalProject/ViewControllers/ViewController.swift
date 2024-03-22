//
//  ViewController.swift
//  FinalProject
//
//  Created by CDMStudent on 3/12/24.
//

import UIKit
import AVFoundation


protocol ImageCaptureDelegate: AnyObject {
    func didCaptureImage(_ image: UIImage)
}

class ViewController: UIViewController , AVCaptureVideoDataOutputSampleBufferDelegate{
    
    weak var delegate: ImageCaptureDelegate?
    
    let captureSession =  AVCaptureSession()
    var previewLayer:CALayer!
    var takePhoto = false
    var captureDevice:AVCaptureDevice!
    
    var capturedImage: UIImage?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        prepareCamera()
    }
    func prepareCamera(){
        captureSession.sessionPreset = AVCaptureSession.Preset.photo
        
         let availableDevices = AVCaptureDevice.DiscoverySession(deviceTypes: [.builtInWideAngleCamera], mediaType: AVMediaType.video, position: .back).devices
            
         if let captureDevice = availableDevices.first{
             self.captureDevice = captureDevice
                         beginSession()
                       }
//           if availableDevices.isEmpty{
//               let captureDevice = availableDevices.first!
//               beginSession()
//
     
//
    }
    
    func beginSession(){
        
        do{
            let captureDeviceInput = try AVCaptureDeviceInput(device: captureDevice)
            captureSession.addInput(captureDeviceInput)
        }catch{
            print(error.localizedDescription)
        }
//         let previewLayer = AVCaptureVideoPreviewLayer(session: captureSession){
//            self.previewLayer = previewLayer
//            self.view.layer.addSublayer(self.previewLayer)
//            self.previewLayer.frame = self.view.layer.frame
//            captureSession.startRunning()
        let previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
            self.previewLayer = previewLayer
        if let previewLayer = self.previewLayer {
            self.view.layer.addSublayer(previewLayer)
            previewLayer.frame = self.view.layer.frame
            captureSession.startRunning()
            
            let dataOutput = AVCaptureVideoDataOutput()
            dataOutput.videoSettings = [String(kCVPixelBufferPixelFormatTypeKey): NSNumber(value: kCVPixelFormatType_32BGRA)]
            dataOutput.alwaysDiscardsLateVideoFrames = true
            if captureSession.canAddOutput(dataOutput) {
                captureSession.addOutput(dataOutput)
            }
            captureSession.commitConfiguration()
            
            let queue = DispatchQueue(label: "finalProject.CameraAccess.captureQueue")
            dataOutput.setSampleBufferDelegate( self , queue: queue )
            
            
        }
        
    }
    
    
    
    @IBAction func clickTakePhoto(_ sender: Any) {
        takePhoto = true
    }
    
    
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        
        if takePhoto{
            takePhoto = false
            if let image = self.getImageFromSampleBuffer(buffer: sampleBuffer){
                DispatchQueue.main.async {
                    
                    
                    let photoVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "PhotoVC") as! AddItemViewController
                    
                    //  photoVC.takenPhoto = image
                    photoVC.itemImages = [image]
                    
                    DispatchQueue.main.async{
                        self.present(photoVC, animated: true, completion: {
                            self.stopCaptureSession()
                        })
                    }
                    
                    
                    //            if let image = self.getImageFromSampleBuffer(buffer: sampleBuffer) {
                    //                    DispatchQueue.main.async {
                    //                        self.delegate?.didCaptureImage(image)
                    //                        self.dismiss(animated: true, completion: nil)
                    //                        self.stopCaptureSession()
                    //                    }
                    
                    
                    
                    
                    //
                    //                                      if let addItemViewController = self.presentedViewController as? AddItemViewController {
                    //                                          addItemViewController.itemImages = [image]
                    //                                          self.delegate?.didCaptureImage(image)
                    //                                                 } else if let addItemViewController = self.navigationController?.topViewController as? AddItemViewController {
                    //                                                    addItemViewController.itemImages = [image]
                    //                                                   }
                    //               self.dismiss(animated: true, completion: {self.stopCaptureSession()})
                    
                    
                    
                }
            }
            
        }
    }
    
    func getImageFromSampleBuffer(buffer:CMSampleBuffer) -> UIImage? {
        if let pixelBuffer = CMSampleBufferGetImageBuffer(buffer){
            let ciImage = CIImage(cvPixelBuffer: pixelBuffer)
            let context = CIContext()
            let imageRect = CGRect(x: 0, y: 0, width: CVPixelBufferGetWidth(pixelBuffer), height: CVPixelBufferGetHeight(pixelBuffer))
            
            if let image = context.createCGImage(ciImage, from: imageRect){
                return UIImage(cgImage: image, scale: UIScreen.main.scale, orientation: .right)
            }
        }
        return nil
    }
    
    
    func stopCaptureSession (){
        self.captureSession.stopRunning()
        
        if let inputs = captureSession.inputs as? [AVCaptureDeviceInput]{
            for input in inputs{
                self.captureSession.removeInput((input))
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let destinationVC = segue.destination as? AddItemViewController else {
            return
        }
                if let destinationVC = segue.destination as? AddItemViewController {
                    destinationVC.itemImages = [capturedImage]
                }
            }
        
    
}

