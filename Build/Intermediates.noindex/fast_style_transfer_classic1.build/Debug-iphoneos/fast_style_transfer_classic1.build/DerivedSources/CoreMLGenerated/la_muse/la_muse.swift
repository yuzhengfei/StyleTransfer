//
// la_muse.swift
//
// This file was automatically generated and should not be edited.
//

import CoreML


/// Model Prediction Input Type
@available(macOS 10.13, iOS 11.0, tvOS 11.0, watchOS 4.0, *)
class la_museInput : MLFeatureProvider {

    /// img_placeholder__0 as color (kCVPixelFormatType_32BGRA) image buffer, 883 pixels wide by 720 pixels high
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
class la_museOutput : MLFeatureProvider {

    /// Source provided by CoreML

    private let provider : MLFeatureProvider


    /// add_37__0 as color (kCVPixelFormatType_32BGRA) image buffer, 884 pixels wide by 720 pixels high
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
class la_muse {
    var model: MLModel

/// URL of model assuming it was installed in the same bundle as this class
    class var urlOfModelInThisBundle : URL {
        let bundle = Bundle(for: la_muse.self)
        return bundle.url(forResource: "la_muse", withExtension:"mlmodelc")!
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
           - input: the input to the prediction as la_museInput
        - throws: an NSError object that describes the problem
        - returns: the result of the prediction as la_museOutput
    */
    func prediction(input: la_museInput) throws -> la_museOutput {
        return try self.prediction(input: input, options: MLPredictionOptions())
    }

    /**
        Make a prediction using the structured interface
        - parameters:
           - input: the input to the prediction as la_museInput
           - options: prediction options 
        - throws: an NSError object that describes the problem
        - returns: the result of the prediction as la_museOutput
    */
    func prediction(input: la_museInput, options: MLPredictionOptions) throws -> la_museOutput {
        let outFeatures = try model.prediction(from: input, options:options)
        return la_museOutput(features: outFeatures)
    }

    /**
        Make a prediction using the convenience interface
        - parameters:
            - img_placeholder__0 as color (kCVPixelFormatType_32BGRA) image buffer, 883 pixels wide by 720 pixels high
        - throws: an NSError object that describes the problem
        - returns: the result of the prediction as la_museOutput
    */
    func prediction(img_placeholder__0: CVPixelBuffer) throws -> la_museOutput {
        let input_ = la_museInput(img_placeholder__0: img_placeholder__0)
        return try self.prediction(input: input_)
    }

    /**
        Make a batch prediction using the structured interface
        - parameters:
           - inputs: the inputs to the prediction as [la_museInput]
           - options: prediction options 
        - throws: an NSError object that describes the problem
        - returns: the result of the prediction as [la_museOutput]
    */
    @available(macOS 10.14, iOS 12.0, tvOS 12.0, watchOS 5.0, *)
    func predictions(inputs: [la_museInput], options: MLPredictionOptions = MLPredictionOptions()) throws -> [la_museOutput] {
        let batchIn = MLArrayBatchProvider(array: inputs)
        let batchOut = try model.predictions(from: batchIn, options: options)
        var results : [la_museOutput] = []
        results.reserveCapacity(inputs.count)
        for i in 0..<batchOut.count {
            let outProvider = batchOut.features(at: i)
            let result =  la_museOutput(features: outProvider)
            results.append(result)
        }
        return results
    }
}
