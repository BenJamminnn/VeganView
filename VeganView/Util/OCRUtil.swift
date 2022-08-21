//
//  OCRUtil.swift
//  VeganVision
//
//  Created by Ben Gabay on 8/21/22.
//

import Foundation
import Vision
import UIKit

enum ScanError: Error {
    case imageMissing
    case noResults
    case scanError
    
    func description() -> String {
        switch self {
        case .imageMissing:
            return "No input image found"
        case .noResults:
            return "No Results found in image"
        case .scanError:
            return "Error performing Vision Scan"
        }
    }
}

class OCRUtil {

    static func recognizeText(image: UIImage?, completion: @escaping ([String]?, ScanError?) -> Void) {
        guard let cgImage = image?.cgImage else {
            // No Image
            completion(nil, .imageMissing)
            return
        }

        // Handler
        let handler = VNImageRequestHandler(cgImage: cgImage, options: [:])

        // Request
        let request = VNRecognizeTextRequest { request, error in
            guard let observations = request.results as? [VNRecognizedTextObservation], error == nil else {
                completion(nil, .noResults)
                return
            }
            
            let text = observations.compactMap { observation in
                return observation.topCandidates(1).first?.string
            }
            print("Text 1: ", text)
            
            if text.isEmpty {
                completion(nil, .noResults)
            }
            completion(text, nil)
        }

        do {
            try handler.perform([request])
        } catch {
            completion(nil, .scanError)
        }
    }
    
    
}
