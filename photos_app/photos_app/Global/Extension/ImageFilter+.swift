//
//  ImageFilter+.swift
//  photos_app
//
//  Created by 천성우 on 2/11/25.
//

import UIKit

struct FilterParameters: Codable {
    var exposure: Float = 0.0
    var brightness: Float = 0.0
    var contrast: Float = 1.0
    var saturation: Float = 1.0
    var temperature: Float = 5000.0
    var sharpness: Float = 1.0
    var highlight: Float = 1.0
    var shadow: Float = 0.0
    var clarity: Float = 0.0
    var vignette: Float = 0.0
    var noiseReduction: Float = 0.0
}

class ImageFilter {
    func applyFilters(to image: UIImage, with parameters: FilterParameters) -> UIImage {
        guard let inputCGImage = image.cgImage else { return image }
        let width = inputCGImage.width
        let height = inputCGImage.height
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let context = CGContext(
            data: nil,
            width: width,
            height: height,
            bitsPerComponent: 8,
            bytesPerRow: 4 * width,
            space: colorSpace,
            bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue
        )
                
        guard let cgContext = context else { return image }
        
        cgContext.draw(inputCGImage, in: CGRect(x: 0, y: 0, width: width, height: height))
        
        guard let pixelBuffer = cgContext.data else { return image }
        let buffer = pixelBuffer.bindMemory(to: UInt8.self, capacity: width * height * 4)
        
        for y in 0..<height {
            for x in 0..<width {
                let pixelIndex = (y * width + x) * 4
                var r = Float(buffer[pixelIndex])
                var g = Float(buffer[pixelIndex + 1])
                var b = Float(buffer[pixelIndex + 2])
                
                (r, g, b) = applyExposure(r: r, g: g, b: b, exposure: parameters.exposure)
                (r, g, b) = applyBrightness(r: r, g: g, b: b, brightness: parameters.brightness)
                (r, g, b) = applyContrast(r: r, g: g, b: b, contrast: parameters.contrast)
                (r, g, b) = applySaturation(r: r, g: g, b: b, saturation: parameters.saturation)
                (r, g, b) = applyTemperature(r: r, g: g, b: b, temperature: parameters.temperature)
                
                let vignetteFactor = calculateVignette(x: x, y: y, width: width, height: height, vignette: parameters.vignette)
                r *= vignetteFactor
                g *= vignetteFactor
                b *= vignetteFactor
                
                r = clamp(value: r)
                g = clamp(value: g)
                b = clamp(value: b)
                
                buffer[pixelIndex] = UInt8(r)
                buffer[pixelIndex + 1] = UInt8(g)
                buffer[pixelIndex + 2] = UInt8(b)
            }
        }
        
        let outputCGImage = cgContext.makeImage()!
        return UIImage(cgImage: outputCGImage)
    }
    
    private func applyExposure(r: Float, g: Float, b: Float, exposure: Float) -> (Float, Float, Float) {
        let factor = pow(2.0, exposure)
        return (r * factor, g * factor, b * factor)
    }
    
    private func applyBrightness(r: Float, g: Float, b: Float, brightness: Float) -> (Float, Float, Float) {
        return (r + brightness * 255, g + brightness * 255, b + brightness * 255)
    }
    
    private func applyContrast(r: Float, g: Float, b: Float, contrast: Float) -> (Float, Float, Float) {
        let factor = (259 * (contrast + 255)) / (255 * (259 - contrast))
        return (
            factor * (r - 128) + 128,
            factor * (g - 128) + 128,
            factor * (b - 128) + 128
        )
    }
    
    private func applySaturation(r: Float, g: Float, b: Float, saturation: Float) -> (Float, Float, Float) {
        let gray = 0.3 * r + 0.59 * g + 0.11 * b
        return (
            gray + (r - gray) * saturation,
            gray + (g - gray) * saturation,
            gray + (b - gray) * saturation
        )
    }
    
    private func applyTemperature(r: Float, g: Float, b: Float, temperature: Float) -> (Float, Float, Float) {
        let kelvin = (temperature - 5000) / 5000
        return (
            r + kelvin * 255,
            g,
            b - kelvin * 255
        )
    }
    
    private func calculateVignette(x: Int, y: Int, width: Int, height: Int, vignette: Float) -> Float {
        let dx = Float(x - width / 2) / Float(width / 2)
        let dy = Float(y - height / 2) / Float(height / 2)
        let distance = sqrt(dx * dx + dy * dy)
        return 1.0 - vignette * distance
    }
    
    private func clamp(value: Float) -> Float {
        return max(0, min(255, value))
    }
}

func loadFilterParameters(from fileName: String) -> FilterParameters? {
    guard let url = Bundle.main.url(forResource: fileName, withExtension: "json") else {
        print("JSON file '\(fileName).json' not found")
        return nil
    }
    
    do {
        let data = try Data(contentsOf: url)
        let decoder = JSONDecoder()
        let filterParameters = try decoder.decode(FilterParameters.self, from: data)
        return filterParameters
    } catch {
        print("Error decoding JSON: \(error)")
        return nil
    }
}
