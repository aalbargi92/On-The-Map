//
//  UdacityService.swift
//  On The Map
//
//  Created by Abdullah AlBargi on 24/10/2019.
//  Copyright © 2019 Abdullah AlBargi. All rights reserved.
//

import Foundation

class UdacityService {
    
    struct Auth {
        static var objectId = ""
        static var userId = ""
        static var user: UserBody?
    }
    
    enum Endpoints {
        static let base = "https://onthemap-api.udacity.com/v1"
        
        case signUp
        case login
        case logout
        case getUser(String)
        case getUsersLocations
        case addPost
        case putPost(String)
        
        var stringValue: String {
            switch self {
            case .signUp: return Endpoints.base + "/account/auth#!/signup?redirect_to:onthemap:signup"
            case .login: return Endpoints.base + "/session"
            case .logout: return Endpoints.base + "/session"
            case .getUser(let userId): return Endpoints.base + "/users/" + userId
            case .getUsersLocations: return Endpoints.base + "/StudentLocation?limit=100&order=-updatedAt"
            case .addPost: return Endpoints.base + "/StudentLocation"
            case .putPost(let objectId): return Endpoints.base + "/StudentLocation/" + objectId
            }
        }
        
        var url: URL {
            return URL(string: stringValue)!
        }
    }
    
    class func taskForGetRequest<ResponseType: Decodable>(url: URL, responseType: ResponseType.Type, completion: @escaping (ResponseType?, Error?) -> Void) {
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let data = data else {
                DispatchQueue.main.async {
                    completion(nil,  error)
                }
                return
            }
            
            let range = 5..<data.count
            let newData = url.path.contains("StudentLocation") ? data : data.subdata(in: range)
            
            let decoder = JSONDecoder()
            
            do {
                let response = try decoder.decode(ResponseType.self, from: newData)
                DispatchQueue.main.async {
                    completion(response, nil)
                }
            } catch {
                do {
                    let errorResponse = try decoder.decode(UdacityResponse.self, from: newData)
                    DispatchQueue.main.async {
                        completion(nil, errorResponse)
                    }
                } catch {
                    DispatchQueue.main.async {
                        completion(nil, error)
                    }
                }
            }
        }
        task.resume()
    }
    
    class func taskForPostRequest<ResponseType: Decodable, RequestType: Encodable>(url: URL, body: RequestType, responseType: ResponseType.Type, completion: @escaping (ResponseType?, Error?) -> Void) {
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try! JSONEncoder().encode(body)
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard let data = data else {
                DispatchQueue.main.async {
                    completion(nil, error)
                }
                return
            }
            
            let range = url.path.contains("StudentLocation") ? 0..<1 : 5..<data.count
            let newData = url.path.contains("StudentLocation") ? data : data.subdata(in: range)
            
            let decoder = JSONDecoder()
            
            do {
                let response = try decoder.decode(ResponseType.self, from: newData)
                DispatchQueue.main.async {
                    completion(response, nil)
                }
            } catch {
                do {
                    let errorResponse = try decoder.decode(UdacityResponse.self, from: newData)
                    DispatchQueue.main.async {
                        completion(nil, errorResponse)
                    }
                } catch {
                    DispatchQueue.main.async {
                        completion(nil, error)
                    }
                }
            }
        }
        task.resume()
    }
    
    class func taskForPutRequest<ResponseType: Decodable, RequestType: Encodable>(url: URL, body: RequestType, responseType: ResponseType.Type, completion: @escaping (ResponseType?, Error?) -> Void) {
        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try! JSONEncoder().encode(body)
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard let data = data else {
                DispatchQueue.main.async {
                    completion(nil, error)
                }
                return
            }
            
            let range = url.path.contains("StudentLocation") ? 0..<1 : 5..<data.count
            let newData = url.path.contains("StudentLocation") ? data : data.subdata(in: range)
            
            let decoder = JSONDecoder()
            
            do {
                let response = try decoder.decode(ResponseType.self, from: newData)
                DispatchQueue.main.async {
                    completion(response, nil)
                }
            } catch {
                do {
                    let errorResponse = try decoder.decode(UdacityResponse.self, from: newData)
                    DispatchQueue.main.async {
                        completion(nil, errorResponse)
                    }
                } catch {
                    DispatchQueue.main.async {
                        completion(nil, error)
                    }
                }
            }
        }
        task.resume()
    }
    
    // MARK: - Login
    class func login(username: String, password: String, completion: @escaping (Bool, Error?) -> Void) {
        let loginRequest = LoginRequest(udacity: LoginBody(username: username, password: password))
        taskForPostRequest(url: Endpoints.login.url, body: loginRequest, responseType: LoginResponse.self) { (response, error) in
            if let response = response {
                Auth.userId = response.account.key
                completion(true, nil)
            } else {
                completion(false, error)
            }
        }
    }
    
    // MARK: - Logout
    class func logout(completion: @escaping (Bool, Error?) -> Void) {
        var request = URLRequest(url: Endpoints.logout.url)
        request.httpMethod = "DELETE"
        var xsrfCookie: HTTPCookie? = nil
        let sharedCookieStorage = HTTPCookieStorage.shared
        for cookie in sharedCookieStorage.cookies! {
          if cookie.name == "XSRF-TOKEN" { xsrfCookie = cookie }
        }
        if let xsrfCookie = xsrfCookie {
          request.setValue(xsrfCookie.value, forHTTPHeaderField: "X-XSRF-TOKEN")
        }
        let session = URLSession.shared
        let task = session.dataTask(with: request) { data, response, error in
          guard let data = data else {
              DispatchQueue.main.async {
                  completion(false, error)
              }
              return
          }
            
          let range = 5..<data.count
          let newData = data.subdata(in: range)
            
          let decoder = JSONDecoder()
          
          do {
              let _ = try decoder.decode(LogoutResponse.self, from: newData)
              DispatchQueue.main.async {
                  completion(true, nil)
              }
          } catch {
              do {
                  let errorResponse = try decoder.decode(UdacityResponse.self, from: newData)
                  DispatchQueue.main.async {
                      completion(false, errorResponse)
                  }
              } catch {
                  DispatchQueue.main.async {
                      completion(false, error)
                  }
              }
          }
        }
        task.resume()
    }
    
    //MARK: - Get User
    class func getUser(completion: @escaping (Bool, Error?) -> Void) {
        taskForGetRequest(url: Endpoints.getUser(Auth.userId).url, responseType: UserBody.self) { (response, error) in
            if let response = response {
                Auth.user = response
                completion(true, nil)
            } else {
                completion(false, error)
            }
        }
    }
    
    // MARK: - Get Users Locations
    class func getUsers(completion: @escaping ([StudentLocation], Error?) -> Void) {
        taskForGetRequest(url: Endpoints.getUsersLocations.url, responseType: ParseResponse.self) { (response, error) in
            if let response = response {
                completion(response.results, nil)
            } else {
                completion([], error)
            }
        }
    }
    
    // MARK: - Add Student Location
    class func addStudentLocation(studentLocation: StudentLocation, completion: @escaping (Bool, Error?) -> Void) {
        taskForPostRequest(url: Endpoints.addPost.url, body: studentLocation, responseType: AddUserResponse.self) { (response, error) in
            if let response = response {
                Auth.objectId = response.objectId
                completion(true, nil)
            } else {
                completion(false, error)
            }
        }
    }
    
    // MARK: - Update Student Location
    class func updateStudentLocation(studentLocation: StudentLocation, completion: @escaping (Bool, Error?) -> Void) {
        taskForPutRequest(url: Endpoints.putPost(Auth.objectId).url, body: studentLocation, responseType: UpdateUserResponse.self) { (response, error) in
            if response != nil {
                completion(true, nil)
            } else {
                completion(false, error)
            }
        }
    }
}
