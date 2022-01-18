//
//  CoreDataHelper.swift
//  Routehive
//
//  Created by Zeshan on 03/10/2018.
//  Copyright © 2018 UmairAFzal. All rights reserved.
//

import Foundation
import CoreData

class CoreDataHelper {
    
    class func clearLocalDB(completion: (_ success: Bool, _ error: Error?) -> Void) {
        let languagefetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Language")
        let languagedeleteRequest = NSBatchDeleteRequest(fetchRequest: languagefetchRequest)
        do {
            try kManagedContext.execute(languagedeleteRequest)
            kManagedContext.reset()
            
            completion(true, nil)
            
        } catch let error as NSError {
            completion(false, error)
        }
    }
    
    class func insertLanguage(usingDictionary languageDictionary: [String:
        String], completion: (_ success: Bool, _ error: Error?) -> Void) {
        
        var languages = [Language]()
        
        for (key, value) in languageDictionary {
            let language = Language(context: kManagedContext)
            language.key = key
            language.value = value
            languages.append(language)
        }
        
        do {
            try kManagedContext.save()
            completion(true, nil)
            
        } catch {
            completion(false, nil)
        }
    }
    
    class func fetchLanguage(withKeyPrefix key: String, completion: (_ result: [String:String]?, _ error: Error?) -> Void) {
        
        let request: NSFetchRequest<Language> = Language.fetchRequest()
        request.predicate = NSPredicate(format: "key BEGINSWITH '\(key)'")
        
        do {
            let result = try kManagedContext.fetch(request)
            var data = [String:String]()
            
            for value in result {
                data[value.key ?? ""] = value.value ?? ""
            }
            
            completion(data, nil)
            
        } catch {
            completion(nil, error)
        }
    }
    
    class func localDbEmpty(completion: (_ isEmpty: Bool, _ error: Error?) -> Void) {
        let request: NSFetchRequest<Language> = Language.fetchRequest()
        
        do {
            let count = try kManagedContext.count(for: request)
            completion(count > 0 ? false : true, nil)
            
        } catch {
            completion(false, error)
        }
    }
}

