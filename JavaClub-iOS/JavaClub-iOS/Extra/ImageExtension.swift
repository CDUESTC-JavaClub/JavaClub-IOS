//
//  NSImageExtension.swift
//
//  Created by Roy on 2021/7/28.
//

#if canImport(SwiftUI)

import SwiftUI

extension Image {
    
    func centerCropped(height: CGFloat) -> some View {
        GeometryReader { geo in
            self
                .resizable()
                .scaledToFill()
                .frame(width: geo.size.width, height: height)
                .clipped()
        }
    }
}

#endif

#if canImport(Cocoa)

import Cocoa

// MARK: NSImage
extension NSImage {
    
    /// Generates an `CGImage` from this `NSImage`.
    public var cgImage: CGImage? {
        guard
            let imageData = self.tiffRepresentation,
            let sourceData = CGImageSourceCreateWithData(imageData as CFData, nil)
        else { return nil }
        
        return CGImageSourceCreateImageAtIndex(sourceData, 0, nil)
    }

    /// Generates a `CIImage` for this `NSImage`.
    public var ciImage: CIImage? {
        guard
            let data = self.tiffRepresentation,
            let bitmap = NSBitmapImageRep(data: data)
        else { return nil }
        
        let ci = CIImage(bitmapImageRep: bitmap)
        
        return ci
    }
    
    
    /**
     * Generates an `NSImage` from a `CIImage`.
     * - Parameter ciImage: The `CIImage` you wanna convert from.
     * - Returns: An `NSImage`.
     */
    static func fromCIImage(_ ciImage: CIImage) -> NSImage {
        let rep = NSCIImageRep(ciImage: ciImage)
        let nsImage = NSImage(size: rep.size)
        nsImage.addRepresentation(rep)
        
        return nsImage
    }
}


// MARK: CGImage
extension CGImage {
    
    /// Generates an `NSImage` from this `CGImage`.
    public var nsImage: NSImage {
        let size = CGSize(width: width, height: height)
        
        return NSImage(cgImage: self, size: size)
    }
    
    /// Generates a `CIImage` from this `CGImage`.
    public var ciImage: CIImage {
        return CIImage(cgImage: self)
    }
}


// MARK: CIImage
extension CIImage {
    
    /// Generates an `NSImage` from this `CIImage`.
    public var nsImage: NSImage {
        let rep = NSCIImageRep(ciImage: self)
        let nsImage = NSImage(size: rep.size)
        nsImage.addRepresentation(rep)
        
        return nsImage
    }
    
    /// Generates a `CGImage` from this `CIImage`.
    public var cgImage: CGImage? {
        let context = CIContext(options: nil)
        
        return context.createCGImage(self, from: extent)
    }
}

#endif
