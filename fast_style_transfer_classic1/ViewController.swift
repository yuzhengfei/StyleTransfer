//
//  ViewController.swift
//  fast_style_transfer_classic1
//
//  Created by Zhengfei,Yu on 2019/3/10.
//  Copyright © 2019年 mutouren. All rights reserved.
//

import UIKit
import MobileCoreServices
import Photos
import CoreML

class ViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    @IBOutlet weak var loadingView: UIView!
    
    @IBOutlet var buttons: [UIButton]!
    
    @IBOutlet weak var imageView: UIImageView!
    
    private var inputImage = UIImage(named: "chicago")!
    
    private var models: Array<MLModel> = [
        classic1_out_wave().model,
        udnie().model,
        rain_princess().model
//        la_muse().model
    ]
    
//    private let model = classic1_out_wave.model
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadingView.alpha = 0
        for btn in buttons {
            btn.imageView?.contentMode = .scaleAspectFill
        }
    }
    
    // MARK: - Actions
    @IBAction func saveResult(_ sender: Any) {
        guard let image = imageView.image else {
            return
        }
        PHPhotoLibrary.shared().performChanges({
            PHAssetChangeRequest.creationRequestForAsset(from: image)
        }, completionHandler: { [weak self] (success, error) in
            var message = "保存成功！"
            if !success {
                message = "保存失败，请重试！"
            }
            let alertController = UIAlertController(title: "提醒", message: message, preferredStyle: .alert)
            let okAction = UIAlertAction(title: "确认", style: .default, handler: { action in
                if success {
                    if let url = URL(string: "photos-redirect://") {
                        UIApplication.shared.open(url, options: [:], completionHandler: nil)
                    }
                }
            })
            let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)
            alertController.addAction(okAction)
            alertController.addAction(cancelAction)
            self?.present(alertController, animated: true, completion: nil)
        })
    }
    
    @IBAction func takePhoto(_ sender: Any) {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let cameraAction = UIAlertAction(title: "Camera", style: .default) { (action) in
            self.showImagePicker(camera: true)
        }
        alert.addAction(cameraAction)
        
        let libraryAction = UIAlertAction(title: "Photo Library", style: .default) { (action) in
            self.showImagePicker(camera: false)
        }
        alert.addAction(libraryAction)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (action) in
        }
        alert.addAction(cancelAction)
        
        if UIDevice.current.userInterfaceIdiom == .pad {
            alert.popoverPresentationController?.sourceView = self.view
        }
        
        present(alert, animated: true, completion: nil)
    }
    
    private func showImagePicker(camera: Bool) {
        let imagePicker = UIImagePickerController()
        if camera {
            imagePicker.sourceType = .camera
            imagePicker.showsCameraControls = true
        } else {
            imagePicker.sourceType = .photoLibrary
        }
        
        imagePicker.delegate = self
        
        imagePicker.mediaTypes = [kUTTypeImage as String]
        imagePicker.allowsEditing = true
        
        present(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func styleButtonTouched(_ sender: UIButton) {
        let image = inputImage.cgImage
        
//        let model: MLModel = getStyleModel(tag: sender.tag)
        let model = self.models[sender.tag]
        toggleLoading(show: true)
        DispatchQueue.global(qos: .userInteractive).async {
            let input: MLFeatureProvider = self.getFeatureProvider(tag: sender.tag, cgImage: image!)
            let stylized = self.stylizeImage(model: model, input: input)
            DispatchQueue.main.async {
                self.toggleLoading(show: false)
                self.imageView.image = UIImage(cgImage: stylized)
            }
        }
    }
    
    // 加载风格模型
    private func getStyleModel(tag: Int) -> MLModel{
        var model: MLModel
        switch tag {
        case 0:
            model = classic1_out_wave().model
            break
        case 1:
            model = udnie().model
            break
        case 2:
            model = rain_princess().model
            break
        case 3:
            model = la_muse().model
            break
        default:
            model = classic1_out_wave().model
        }
        return model
    }
    
    // 获取MLFeatureProvider: input
    private func getFeatureProvider(tag: Int, cgImage: CGImage!) -> MLFeatureProvider {
        var input: MLFeatureProvider
        switch tag {
        case 0:
            input = StyleTransferInput(input: pixelBuffer(cgImage: cgImage, width: 512, height: 512))  //classic1_out_wave
            break
        case 1:
            input = StyleTransferInput(input: pixelBuffer(cgImage: cgImage, width: 883, height: 720))
            break
        case 2:
            input = StyleTransferInput(input: pixelBuffer(cgImage: cgImage, width: 883, height: 720))
            break
        case 3:
            input = StyleTransferInput(input: pixelBuffer(cgImage: cgImage, width: 883, height: 720))
            break
        default:
            input = StyleTransferInput(input: pixelBuffer(cgImage: cgImage, width: 512, height: 512))  //classic1_out_wave
        }
        return input
    }
    
    private func toggleLoading(show: Bool) {
        navigationItem.leftBarButtonItem?.isEnabled = !show
        navigationItem.rightBarButtonItem?.isEnabled = !show
        
        UIView.animate(withDuration: 0.25) { [weak self] in
            if show {
                self?.loadingView.alpha = 0.85
            } else {
                self?.loadingView.alpha = 0
            }
        }
    }
    
    // MARK: - Processing
    private func stylizeImage(model: MLModel, input: MLFeatureProvider) -> CGImage {
        let outFeatures = try! model.prediction(from: input)
        let output = outFeatures.featureValue(for: "add_37__0")!.imageBufferValue!
        CVPixelBufferLockBaseAddress(output, .readOnly)
        let width = CVPixelBufferGetWidth(output)
        let height = CVPixelBufferGetHeight(output)
        let data = CVPixelBufferGetBaseAddress(output)!
        
        let outContext = CGContext(data: data,
                                   width: width,
                                   height: height,
                                   bitsPerComponent: 8,
                                   bytesPerRow: CVPixelBufferGetBytesPerRow(output),
                                   space: CGColorSpaceCreateDeviceRGB(),
                                   bitmapInfo: CGImageByteOrderInfo.order32Little.rawValue | CGImageAlphaInfo.noneSkipFirst.rawValue)!
        let outImage = outContext.makeImage()!
        CVPixelBufferUnlockBaseAddress(output, .readOnly)
        
        return outImage
    }
    
    private func pixelBuffer(cgImage: CGImage, width: Int, height: Int) -> CVPixelBuffer {
        var pixelBuffer: CVPixelBuffer? = nil
        let status = CVPixelBufferCreate(kCFAllocatorDefault, width, height, kCVPixelFormatType_32BGRA , nil, &pixelBuffer)
        if status != kCVReturnSuccess {
            fatalError("Cannot create pixel buffer for image")
        }
        
        CVPixelBufferLockBaseAddress(pixelBuffer!, CVPixelBufferLockFlags.init(rawValue: 0))
        let data = CVPixelBufferGetBaseAddress(pixelBuffer!)
        let rgbColorSpace = CGColorSpaceCreateDeviceRGB()
        let bitmapInfo = CGBitmapInfo(rawValue: CGBitmapInfo.byteOrder32Little.rawValue | CGImageAlphaInfo.noneSkipFirst.rawValue)
        let context = CGContext(data: data, width: width, height: height, bitsPerComponent: 8, bytesPerRow: CVPixelBufferGetBytesPerRow(pixelBuffer!), space: rgbColorSpace, bitmapInfo: bitmapInfo.rawValue)
        
        context?.draw(cgImage, in: CGRect(x: 0, y: 0, width: width, height: height))
        CVPixelBufferUnlockBaseAddress(pixelBuffer!, CVPixelBufferLockFlags(rawValue: 0))
        
        return pixelBuffer!
    }
    
    // MARK: - UIImagePickerControllerDelegate
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerEditedImage] as? UIImage {
            inputImage = image
            imageView.image = image
        }
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}

