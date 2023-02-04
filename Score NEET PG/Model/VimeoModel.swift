/* 
Copyright (c) 2022 Swift Models Generated from JSON powered by http://www.json4swift.com

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
*/

import Foundation
 
/* For support, please feel free to contact me at https://www.linkedin.com/in/syedabsar */

public class VimeoModel {
	public var files : Array<Files>?

/**
    Returns an array of models based on given dictionary.
    
    Sample usage:
    let json4Swift_Base_list = Json4Swift_Base.modelsFromDictionaryArray(someDictionaryArrayFromJSON)

    - parameter array:  NSArray from JSON dictionary.

    - returns: Array of Json4Swift_Base Instances.
*/
    public class func modelsFromDictionaryArray(array:NSArray) -> [VimeoModel]
    {
        var models:[VimeoModel] = []
        for item in array
        {
            models.append(VimeoModel(dictionary: item as! NSDictionary)!)
        }
        return models
    }

/**
    Constructs the object based on the given dictionary.
    
    Sample usage:
    let json4Swift_Base = Json4Swift_Base(someDictionaryFromJSON)

    - parameter dictionary:  NSDictionary from JSON.

    - returns: Json4Swift_Base Instance.
*/
	required public init?(dictionary: NSDictionary) {
        if (dictionary["files"] != nil) { files = Files.modelsFromDictionaryArray(array: dictionary["files"] as! NSArray) }
	}

}


    // MARK: - FILES
public class Files {
    public var quality : String?
    public var rendition : String?
    public var type : String?
    public var width : Int?
    public var height : Int?
    public var link : String?
    public var created_time : String?
    public var fps : Double?
    public var size : Int?
    public var md5 : String?
    public var public_name : String?
    public var size_short : String?

/**
    Returns an array of models based on given dictionary.
    
    Sample usage:
    let files_list = Files.modelsFromDictionaryArray(someDictionaryArrayFromJSON)

    - parameter array:  NSArray from JSON dictionary.

    - returns: Array of Files Instances.
*/
    public class func modelsFromDictionaryArray(array:NSArray) -> [Files]
    {
        var models:[Files] = []
        for item in array
        {
            models.append(Files(dictionary: item as! NSDictionary)!)
        }
        return models
    }

/**
    Constructs the object based on the given dictionary.
    
    Sample usage:
    let files = Files(someDictionaryFromJSON)

    - parameter dictionary:  NSDictionary from JSON.

    - returns: Files Instance.
*/
    required public init?(dictionary: NSDictionary) {

        quality = dictionary["quality"] as? String
        rendition = dictionary["rendition"] as? String
        type = dictionary["type"] as? String
        width = dictionary["width"] as? Int
        height = dictionary["height"] as? Int
        link = dictionary["link"] as? String
        created_time = dictionary["created_time"] as? String
        fps = dictionary["fps"] as? Double
        size = dictionary["size"] as? Int
        md5 = dictionary["md5"] as? String
        public_name = dictionary["public_name"] as? String
        size_short = dictionary["size_short"] as? String
    }

        
/**
    Returns the dictionary representation for the current instance.
    
    - returns: NSDictionary.
*/
    public func dictionaryRepresentation() -> NSDictionary {

        let dictionary = NSMutableDictionary()

        dictionary.setValue(self.quality, forKey: "quality")
        dictionary.setValue(self.rendition, forKey: "rendition")
        dictionary.setValue(self.type, forKey: "type")
        dictionary.setValue(self.width, forKey: "width")
        dictionary.setValue(self.height, forKey: "height")
        dictionary.setValue(self.link, forKey: "link")
        dictionary.setValue(self.created_time, forKey: "created_time")
        dictionary.setValue(self.fps, forKey: "fps")
        dictionary.setValue(self.size, forKey: "size")
        dictionary.setValue(self.md5, forKey: "md5")
        dictionary.setValue(self.public_name, forKey: "public_name")
        dictionary.setValue(self.size_short, forKey: "size_short")

        return dictionary
    }

}

