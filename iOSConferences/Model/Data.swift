//
// Created by jsmith on 27.02.20.
// Copyright (c) 2020 JetBrains. All rights reserved.
//

import Foundation
import Yams
import Combine

let url = URL(string: "https://raw.githubusercontent.com/Lascorbe/CocoaConferences/master/_data/conferences.yml")

public class ConferencesLoader: ObservableObject {
    @Published var conferences = [Conference]()
    var result: AnyCancellable?

    public init() {
        loadConferences() { conferences in
            self.conferences = conferences
        }
    }

    func loadConferences(completion: @escaping ([Conference]) -> Void) {
        result = URLSession.shared.dataTaskPublisher(for: url!)
                                  .decode(type: [Conference].self, decoder: YAMLDecoder())
                                  .receive(on: RunLoop.main)
                                  .eraseToAnyPublisher()
                                  .sink(receiveCompletion: { completion in
                                      switch completion {
                                      case .finished:
                                          break
                                      case .failure(let error):
                                          print(error.localizedDescription)
                                      }
                                  }, receiveValue: { conferences in
                                      completion(conferences)
                                  })
    }

}

extension Date {
    func dateToString() -> String {
        let format = DateFormatter()
        format.dateFormat = "MMM dd, yyyy"
        return format.string(from: self)
    }
}


extension YAMLDecoder: TopLevelDecoder {
    public func decode<T: Decodable>(_ type: T.Type, from data: Input) throws -> T {
        try decode(type, from: String(data: data.data, encoding: .utf8)!)
    }

    public typealias Input = URLSession.DataTaskPublisher.Output
}
