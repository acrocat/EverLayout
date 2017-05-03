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
import SocketIO

public class EverLayoutBridge: NSObject
{
    static var socket : SocketIOClient?
    
    private static let DEFAULT_IP : String = "http://localhost"
    private static let DEFAULT_PORT : String = "3000"
    
    /// Try to establish a socket connection with the EverLayout Bridge server app
    ///
    /// - Parameters:
    ///   - IP: Address to connect to
    ///   - port: Port to connect on
    public static func connectToLayoutServer (withIP IP : String? = nil , port : String? = nil)
    {
        let address = "\(IP ?? self.DEFAULT_IP):\(port ?? self.DEFAULT_PORT)"
        
        self.socket = SocketIOClient(socketURL: URL(string: address)!)
        
        self.socket?.on("connection") { (data, ack) in
            print("Connected")
        }
        
        self.socket?.on("layout-update") { (data, ack) in
            let data = self.parseData(data)
            
            if let layoutName = data.dictionary?["layoutName"]?.string , let layoutData = data.dictionary?["layout"]
            {
                let layoutName : NSString = layoutName as NSString
                
                if let rawData = layoutData.rawData as? Data
                {
                    self.postLayoutUpdate(layoutName: layoutName.deletingPathExtension, layoutData: rawData)
                }
            }
        }
        
        self.socket?.connect()
    }
    
    /// Get useful info from the data received
    ///
    /// - Parameter data: raw data
    /// - Returns: JSON Data
    private static func parseData (_ data : [Any]) -> JSON {
        return JSON(data.first as Any)
    }
    
    /// Uses NotificationCenter to send update messages to loaded layouts in the app
    ///
    /// - Parameters:
    ///   - layoutName: Name of the layout that has been updated
    ///   - layoutData: The new layout data
    private static func postLayoutUpdate (layoutName : String , layoutData : Data) {
        let notificationName : Notification.Name = Notification.Name("layout-update__\(layoutName)")
        
        NotificationCenter.default.post(name: notificationName, object: layoutData)
    }
    
    /// Report a message to the bridge
    ///
    /// - Parameter message: message to report
    public static func sendReport (message : String) {
        self.socket?.emit("report", [
                "message":message
            ])
    }
}
