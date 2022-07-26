//
//  Sort.swift
//  Test
//
//  Created by wei on 2021/7/28.
//

import Foundation
open class Sort : NSObject
{
    
    func reverseString(_ s : inout [Character])
    {
        var j = s.count-1
        for i in 0..<s.count
        {
            while i<j {
                let temp = s[i]
                s[j] = temp
                j-=1
                break
            }
        }
    }
}
