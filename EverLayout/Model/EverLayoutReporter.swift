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

enum EverLayoutReportEmphasis : String
{
    case info = "INFO"
    case warning = "WARNING"
    case error = "ERROR"
}

enum EverLayoutReporterConfigurationOptions : Int
{
    // Printing
    case printWarnings = 0
    case printInfo = 1
    case printErrors = 2
    
    // Broadcasting
    case broadcastWarnings = 3
    case broadcastInfo = 4
    case broadcastErrors = 5
    
    // Rendering
    case renderWarnings = 6
    case renderInfo = 7
    case renderErrors = 8
}

struct EverLayoutReport
{
    let message : String
    let emphasis : EverLayoutReportEmphasis
}

class EverLayoutReporter: NSObject
{
    public static let `default`: EverLayoutReporter = EverLayoutReporter()
    
    private(set) public var configuration : [EverLayoutReporterConfigurationOptions : Bool] = [:]
    private var _configValue : UInt16 = 0
    
    convenience init  (config : [EverLayoutReporterConfigurationOptions : Bool])
    {
        self.init()
        
        self.configuration = config
    }
    
    public func info (message : String)
    {
        
    }
    
    public func warning (message : String)
    {
        self.dispatchReport(EverLayoutReport(message: message, emphasis: .warning))
    }
    
    public func error (message : String)
    {}
    
    private func dispatchReport (_ report : EverLayoutReport)
    {
        self.log(report: report)
        self.broadcast(report: report)
        self.render(report: report)
    }
    
    /// Will print the message to the Xcode log
    ///
    /// - Parameters:
    ///   - report : Message and emphasis
    private func log (report: EverLayoutReport)
    {   
        print("\(report.emphasis.rawValue):- \(report.message)")
    }
    
    /// Attempts to send the message to the companion app
    ///
    /// - Parameters:
    ///   - report : Message and emphasis
    private func broadcast (report : EverLayoutReport)
    {}
    
    /// Will display the message on the device display
    ///
    /// - Parameters:
    ///   - report : Message and emphasis
    private func render (report: EverLayoutReport)
    {}
}
