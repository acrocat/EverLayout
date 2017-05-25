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

// MARK: - A special function to easily read data from an InputStream
internal extension Data {
    /// Read the data received in an input stream
    ///
    /// - Parameter input: InputStream to read
    init(reading input: InputStream) {
        self.init()
        input.open()
        
        let bufferSize = 2048
        let buffer = UnsafeMutablePointer<UInt8>.allocate(capacity: bufferSize)
        while input.hasBytesAvailable {
            let read = input.read(buffer, maxLength: bufferSize)
            if (read == 0) {
                break  // added
            }
            self.append(buffer, count: read)
        }
        buffer.deallocate(capacity: bufferSize)
    }
}

public class EverLayoutBridge: NSObject , StreamDelegate {
    static let shared : EverLayoutBridge = EverLayoutBridge()
    
    public static var connectedHost : CFString?
    public static var connectedPort : UInt32?
    public static var connected : Bool = false
    private static var attemptingConnection : Bool = false
    
    private static var inputStream : InputStream?
    private static var outputStream : OutputStream?
    
    private static var connectionLoop : Timer?
    
    private static let DEFAULT_IP : String = "127.0.0.1"
    private static let DEFAULT_PORT : String = "3000"
    
    static var readStream : Unmanaged<CFReadStream>?
    static var writeStream : Unmanaged<CFWriteStream>?
    
    /// Try to establish a socket connection with the EverLayout Bridge server app
    ///
    /// - Parameters:
    ///   - IP: Address to connect to
    ///   - port: Port to connect on
    public static func connectToLayoutServer (withIP IP : String? = nil , port : String? = nil)
    {
        let address = (IP ?? self.DEFAULT_IP) as CFString
        let port : UInt32 = UInt32(port ?? self.DEFAULT_PORT)!
        
        self.connectedHost = address
        self.connectedPort = port
        
        // Schedule the timer
        self.connectionLoop?.invalidate()
        self.connectionLoop = Timer.scheduledTimer(timeInterval: 2, target: self, selector: #selector(attemptConnectionToLayoutServer), userInfo: nil, repeats: true)
    }
    
    @objc private static func attemptConnectionToLayoutServer () {
        guard self.connected  == false , self.attemptingConnection == false , let connectedHost = self.connectedHost , let connectedPort = self.connectedPort else { return }
        
        self.attemptingConnection = true
        
        self.inputStream?.close()
        self.outputStream?.close()
        
        self.inputStream = nil
        self.outputStream = nil
        
        // Attempt to link the streams to this server
        CFStreamCreatePairWithSocketToHost(kCFAllocatorDefault, connectedHost, connectedPort, &readStream, &writeStream)
        
        self.inputStream = readStream!.takeRetainedValue()
        self.outputStream = writeStream!.takeRetainedValue()
        
        self.inputStream?.delegate = self.shared
        self.outputStream?.delegate = self.shared
        
        self.inputStream?.schedule(in: .current, forMode: .defaultRunLoopMode)
        self.outputStream?.schedule(in: .current, forMode: .defaultRunLoopMode)
        
        self.inputStream?.open()
        self.outputStream?.open()
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
//        self.socket?.emit("report", [
//                "message":message
//            ])
    }
    
    public func stream(_ aStream: Stream, handle eventCode: Stream.Event) {
        EverLayoutBridge.attemptingConnection = false
        
        if eventCode == Stream.Event.endEncountered {
            EverLayoutBridge.connected = false
            print("Lost connection to the bridge, attemping reconnection...")
        } else if eventCode == Stream.Event.openCompleted {
            if EverLayoutBridge.connected == false {
                EverLayoutBridge.connected = true
                print("Connected to layout server")
            }
        } else if eventCode == Stream.Event.hasBytesAvailable {
            // Data has been received
            if let aStream = aStream as? InputStream {
                let data = Data(reading: aStream)
                let jsonData = JSON(data: data)
                
                if let layoutName = jsonData.dictionary?["name"]?.string {
                    print(layoutName)
                    
                    EverLayoutBridge.postLayoutUpdate(layoutName: layoutName, layoutData: data)
                }
            }
        }
    }
}
