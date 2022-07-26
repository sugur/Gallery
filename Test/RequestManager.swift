//
//  RequestManager.swift
//  Test
//
//  Created by wei on 2022/5/8.
//

import Foundation



open class RequestManager : NSObject , URLSessionDataDelegate {
    public func urlSession(_ session: URLSession, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
        var err: OSStatus
        var disposition: Foundation.URLSession.AuthChallengeDisposition = Foundation.URLSession.AuthChallengeDisposition.performDefaultHandling
        var trustResult: SecTrustResultType = .invalid
        var credential: URLCredential? = nil
        let serverTrust: SecTrust = challenge.protectionSpace.serverTrust!
        err = SecTrustEvaluate(serverTrust, &trustResult)
        if err == errSecSuccess && (trustResult == .proceed || trustResult == .unspecified) {
            disposition = Foundation.URLSession.AuthChallengeDisposition.useCredential
            credential = URLCredential(trust: serverTrust)
            if credential == nil
            {
                MyLog("RequestManager.swift - didReceive challenge: credential == nil")
            }
        } else {
            disposition = Foundation.URLSession.AuthChallengeDisposition.cancelAuthenticationChallenge
        }
        completionHandler(disposition, credential)
  
    }
  
    private let baseURL = URL(string: "https://api.imgur.com/3")!
    private let clientID = "63911e965ccb361"
    
    enum GallerySearchSortingType: String {
        case time
        case viral
        case top
    }
    
    private func buildRequest(url: URL) -> URLRequest {
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "GET"
        urlRequest.setValue("Client-ID \(clientID)", forHTTPHeaderField: "Authorization")
        urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        return urlRequest
    }
    
    private static var __once: () = {
        Static.instance = RequestManager()
        
        
    }()
    
    //Singleton
    struct Static {
        static var onceToken: Int = 0
        static var instance: RequestManager? = nil
    }
    // singleton
    class var instance: RequestManager {
        _ = RequestManager.__once
        return Static.instance!
    }

     func SearchGalleryRequest(page: Int, sort: GallerySearchSortingType, query: String) -> (success:Bool, errorCode:String?,[Gallery]?)
    {
        let baseURL = baseURL.appendingPathComponent("/gallery/search")
            .appendingPathComponent(sort.rawValue)
            .appendingPathComponent(String(page))
        let parameters: [String : CustomStringConvertible] = ["q": query]
        
        guard var components = URLComponents(url: baseURL, resolvingAgainstBaseURL: false) else {
            return (false, String("-1"),[])
        }
        components.queryItems = parameters.keys.map { key in
            URLQueryItem(name: key, value: parameters[key]?.description)
        }
        guard let url = components.url else {
            return (false, String("-1"),[])
        }

        let result = httpRequest(url)
    
        return (false, String(result.1),result.0)
    }
    
    
    fileprivate func httpRequest(_ url: URL) -> ([Gallery], Int)
    {
        
        let request = buildRequest(url: url)
        var items: [Gallery] = []
        var errorCode :Int = 0
        MyLog("RequestManager.swift - httpRequest: allHTTPHeaderFields: \(String(describing: request.allHTTPHeaderFields))")
        var error: NSError? = nil
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config, delegate: self, delegateQueue: OperationQueue())
        let semaphore = DispatchSemaphore.init(value: 0)
        let task = session.dataTask(with: request as URLRequest, completionHandler: {replyData, response, errorData -> Void in
            if errorData == nil {
                let result = NSString(data: replyData!, encoding: String.Encoding.utf8.rawValue)!
                
                MyLog("RequestManager.swift - httpRequest: \(url)\n with result: \(result), ")
                
                var replyObj: Any?
                do {
                    let replyObj = try JSONDecoder().decode(GallerySearchResult.self, from: replyData!)
                    MyLog("gallery \(replyObj.galleries.count)")
                    items = replyObj.galleries
                } catch let error1 as NSError {
                    error = error1
                    replyObj = nil
                }
                
                if error != nil
                {
 
                    let replyString = NSString(data: replyData!, encoding: String.Encoding.utf8.rawValue)
                    MyLog("RequestManager.swift - httpRequest: in Reply: Error json Error: \(String(describing: error))\n  replyString = \(String(describing: replyString))")
                }
            }
            else {
                errorCode = ((errorData! as NSError).code)
                MyLog("RequestManager.swift - httpRequest: HTTPRequestError: \(String(describing: errorData))")
            }
            semaphore.signal()
        })
        task.resume()
        _ = semaphore.wait(timeout: .distantFuture)
        return (items, errorCode)
    }
    
    
    //MARK: - Private Functionslet  (responseDoc, errorCode)  =
//    func registration(_ user: User) -> (status: Bool, error: String?,statuscode:String?)
//    {
//
//    }
//
    
}
