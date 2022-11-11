//
//  URLSessionProtocol.swift
//  WeatherBrick
//
//  Created by Anton on 29.08.2022.
//  Copyright © 2022 VAndrJ. All rights reserved.
//

import Foundation

protocol URLSessionProtocol {
    func dataTask(with url: URL,
                  completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask
}
