//  EverLayout
//
//  Copyright (c) 2017 Dale Webster
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.

import UIKit

// All the protocols that describe how a view should behave when mapping properties

protocol FrameMappable {
    func mapFrame (_ frame : String)
    
    func getMappedFrame () -> String?
}

protocol BackgroundColorMappable {
    func mapBackgroundColor (_ color : String)
    
    func getMappedBackgroundColor () -> String?
}

protocol HiddenMappable {
    func mapHidden (_ hidden : String)
    
    func getMappedHidden () -> String?
}

protocol CornerRadiusMappable {
    func mapCornerRadius (_ cornerRadius : String)
    
    func getMappedCornerRadius () -> String?
}

protocol BorderWidthMappable {
    func mapBorderWidth (_ borderWidth : String)
    
    func getMappedBorderWidth () -> String?
}

protocol BorderColorMappable {
    func mapBorderColor (_ borderColor : String)
    
    func getMappedBorderColor () -> String?
}

protocol AlphaMappable {
    func mapAlpha (_ alpha : String)
    
    func getMappedAlpha () -> String?
}

protocol ClipBoundsMappable {
    func mapClipToBounds (_ clipToBounds : String)
    
    func getMappedClipToBounds () -> String?
}

protocol ContentModeMappable {
    func mapContentMode (_ contentMode : String)
    
    func getMappedContentMode () -> String?
}

protocol TextMappable {
    func mapText (_ text : String)
    
    func getMappedText () -> String?
}

protocol TextColorMappable {
    func mapTextColor (_ color : String)
    
    func getMappedTextColor () -> String?
}

protocol LineBreakModeMappable {
    func mapLineBreakMode (_ lineBreakMode : String)
    
    func getMappedLineBreakMode () -> String?
}

protocol TextAlignmentMappable {
    func mapTextAlignment (_ textAlignment : String)
    
    func getMappedTextAlignment () -> String?
}

protocol NumberOfLinesMappable {
    func mapNumberOfLines (_ numberOfLines : String)
    
    func getMappedNumberOfLines () -> String?
}

protocol FontSizeMappable {
    func mapFontSize (_ fontSize : String)
    
    func getMappedFontSize () -> String?
}

protocol BackgroundImageMappable {
    func mapBackgroundImage (_ image : String)
}

protocol ImageMappable {
    func mapImage (_ image : String)
}

protocol ContentInsetMappable {
    func mapContentInset (_ contentInset : String)
    
    func getMappedContentInset () -> String?
}

protocol ContentOffsetMappable {
    func mapContentOffset (_ contentOffset : String)
    
    func getMappedContentOffset () -> String?
}

protocol PlaceholderMappable {
    func mapPlaceholder (_ placeholder : String)
    
    func getMappedPlaceholder () -> String?
}

protocol TranslucentMappable {
    func mapIsTranslucent (_ translucent : String)
    
    func getMappedIsTranslucent () -> String?
}

protocol TintColorMappable {
    func mapTintColor (_ tintColor : String)
    
    func getMappedTintColor () -> String?
}

