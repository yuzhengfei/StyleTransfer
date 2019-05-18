//
// classic1_out_wave.swift
//
// This file was automatically generated and should not be edited.
//

import CoreML


/// Model Prediction Input Type
@available(macOS 10.13, iOS 11.0, tvOS 11.0, watchOS 4.0, *)
class classic1_out_waveInput : MLFeatureProvider {

    /// img_placeholder__0 as color (kCVPixelFormatType_32BGRA) image buffer, 512 pixels wide by 512 pixels high
    var img_placeholder__0: CVPixelBuffer

    var featureNames: Set<String> {
        get {
            return ["img_placeholder__0"]
        }
    }
    
    func featureValue(for featureName: String) -> MLFeatureValue? {
        if (featureName == "img_placeholder__0") {
            return MLFeatureValue(pixelBuffer: img_placeholder__0)
        }
        return nil
    }
    
    init(img_placeholder__0: CVPixelBuffer) {
        self.img_placeholder__0 = img_placeholder__0
    }
}

/// Model Prediction Output Type
@available(macOS 10.13, iOS 11.0, tvOS 11.0, watchOS 4.0, *)
class classic1_out_waveOutput : MLFeatureProvider {

    /// Source provided by CoreML

    private let provider : MLFeatureProvider


    /// add_37__0 as color (kCVPixelFormatType_32BGRA) image buffer, 512 pixels wide by 512 pixels high
    lazy var add_37__0: CVPixelBuffer = {
        [unowned self] in return self.provider.featureValue(for: "add_37__0")!.imageBufferValue
    }()!

    var featureNames: Set<String> {
        return self.provider.featureNames
    }
    
    func featureValue(for featureName: String) -> MLFeatureValue? {
        return self.provider.featureValue(for: featureName)
    }

    init(add_37__0: CVPixelBuffer) {
        self.provider = try! MLDictionaryFeatureProvider(dictionary: ["add_37__0" : MLFeatureValue(pixelBuffer: add_37__0)])
    }

    init(features: MLFeatureProvider) {
        self.provider = features
    }
}


/// Class for model loading and prediction
@available(macOS 10.13, iOS 11.0, tvOS 11.0, watchOS 4.0, *)
class classic1_out_wave {
    var model: MLModel

/// URL of model assuming it was installed in the same bundle as this class
    class var urlOfModelInThisBundle : URL {
        let bundle = Bundle(for: classic1_out_wave.self)
        return bundle.url(forResource: "classic1_out_wave", withExtension:"mlmodelc")!
    }

    /**
        Construct a model with explicit path to mlmodelc file
        - parameters:
           - url: the file url of the model
           - throws: an NSError object that describes the problem
    */
    init(contentsOf url: URL) throws {
        self.model = try MLModel(contentsOf: url)
    }

    /// Construct a model that automatically loads the model from the app's bundle
    convenience init() {
        try! self.init(contentsOf: type(of:self).urlOfModelInThisBundle)
    }

    /**
        Construct a model with configuration
        - parameters:
           - configuration: the desired model configuration
           - throws: an NSError object that describes the problem
    */
    @available(macOS 10.14, iOS 12.0, tvOS 12.0, watchOS 5.0, *)
    convenience init(configuration: MLModelConfiguration) throws {
        try self.init(contentsOf: type(of:self).urlOfModelInThisBundle, configuration: configuration)
    }

    /**
        Construct a model with explicit path to mlmodelc file and configuration
        - parameters:
           - url: the file url of the model
           - configuration: the desired model configuration
           - throws: an NSError object that describes the problem
    */
    @available(macOS 10.14, iOS 12.0, tvOS 12.0, watchOS 5.0, *)
    init(contentsOf url: URL, configuration: MLModelConfiguration) throws {
        self.model = try MLModel(contentsOf: url, configuration: configuration)
    }

    /**
        Make a prediction using the structured interface
        - parameters:
           - input: the input to the prediction as classic1_out_waveInput
        - throws: an NSError object that describes the problem
        - returns: the result of the prediction as classic1_out_waveOutput
    */
    func prediction(input: classic1_out_waveInput) throws -> classic1_out_waveOutput {
        return try self.prediction(input: input, options: MLPredictionOptions())
    }

    /**
        Make a prediction using the structured interface
        - parameters:
           - input: the input to the prediction as classic1_out_waveInput
           - options: prediction options 
        - throws: an NSError object that describes the problem
        - returns: the result of the prediction as classic1_out_waveOutput
    */
    func prediction(input: classic1_out_waveInput, options: MLPredictionOptions) throws -> classic1_out_waveOutput {
        let outFeatures = try model.prediction(from: input, options:options)
        return classic1_out_waveOutput(features: outFeatures)
    }

    /**
        Make a prediction using the convenience interface
        - parameters:
            - img_placeholder__0 as color (kCVPixelFormatType_32BGRA) image buffer, 512 pixels wide by 512 pixels high
        - throws: an NSError object that describes the problem
        - returns: the result of the prediction as classic1_out_waveOutput
    */
    func prediction(img_placeholder__0: CVPixelBuffer) throws -> classic1_out_waveOutput {
        let input_ = classic1_out_waveInput(img_placeholder__0: img_placeholder__0)
        return try self.prediction(input: input_)
    }

    /**
        Make a batch prediction using the structured interface
        - parameters:
           - inputs: the inputs to the prediction as [classic1_out_waveInput]
           - options: prediction options 
        - throws: an NSError object that describes the problem
        - returns: the result of the prediction as [classic1_out_waveOutput]
    */
    @available(macOS 10.14, iOS 12.0, tvOS 12.0, watchOS 5.0, *)
    func predictions(inputs: [classic1_out_waveInput], options: MLPredictionOptions = MLPredictionOptions()) throws -> [classic1_out_waveOutput] {
        let batchIn = MLArrayBatchProvider(array: inputs)
        let batchOut = try model.predictions(from: batchIn, options: options)
        var results : [classic1_out_waveOutput] = []
        results.reserveCapacity(inputs.count)
        for i in 0..<batchOut.count {
            let outProvider = batchOut.features(at: i)
            let result =  classic1_out_waveOutput(features: outProvider)
            results.append(result)
        }
        return results
    }
}
