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

enum ELReportEmphasis : String
{
    case warning = "WARNING"
    case error = "ERROR"
}

enum ELReportOptions
{
    case logReports
    case sendReportsToEverLayoutBridge
//    case showReportSeverityOnAppDisplay
}

struct ELReport
{
    let message : String
    let emphasis : ELReportEmphasis
    
    var description : String {
        return "\(self.emphasis.rawValue) - \(self.message)"
    }
}

class ELReporter: NSObject
{
    @objc public static let `default`: ELReporter = ELReporter(config: [
            .logReports , .sendReportsToEverLayoutBridge
        ])
    
    private var isErrorRendering : Bool = false
    private var configuration : [ELReportOptions] = []
    
    /// Init with config options
    ///
    /// - Parameter config: Array of config options
    convenience init (config : [ELReportOptions])
    {
        self.init()
        
        self.configuration = config
    }
    
    /// Report a warning
    ///
    /// - Parameter message: warning message
    @objc public func warning (message : String)
    {
        self.dispatchReport(ELReport(message: message, emphasis: .warning))
    }
    
    /// Report an error
    ///
    /// - Parameter message: error message
    @objc public func error (message : String)
    {
        self.dispatchReport(ELReport(message: message, emphasis: .error))
    }
    
    /// Determine which reporting methods should be used based on configuration and then call them
    ///
    /// - Parameter report: The report to send
    private func dispatchReport (_ report : ELReport)
    {
        if self.configuration.contains(.logReports) { self.log(report: report) }
        if self.configuration.contains(.sendReportsToEverLayoutBridge) { self.send(report: report) }
//        if self.configuration.contains(.showReportSeverityOnAppDisplay) { self.render(report: report) }
    }
    
    /// Will print the message to the Xcode log
    ///
    /// - Parameters:
    ///   - report : Message and emphasis
    private func log (report: ELReport)
    {   
        print(report.description)
    }
    
    /// Attempts to send the message to the companion app
    ///
    /// - Parameters:
    ///   - report : Message and emphasis
    private func send (report : ELReport)
    {
        EverLayoutBridge.sendReport(message: report.description)
    }
    
    /// Will display the message on the device display
    ///
    /// - Parameters:
    ///   - report : Message and emphasis
    private func render (report: ELReport)
    {
        if self.isErrorRendering { return }
        
        self.isErrorRendering = true
        
        // Get the view of the rootViewController
        if let view = UIApplication.shared.keyWindow?.rootViewController?.view
        {
            // Add a border to the view to signify that there is a report
            view.layer.borderWidth = 5
            view.layer.borderColor = UIColor.red.cgColor
            
            let deadlineTime = DispatchTime.now() + .seconds(2)
            DispatchQueue.main.asyncAfter(deadline: deadlineTime) {
                [weak self] in
                self?.isErrorRendering = false
                view.layer.borderWidth = 0
            }
        }
    }
}
