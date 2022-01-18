//
// Created by jetbrains on 29.10.21.
//

import Foundation
import Yams
import Combine

extension Date {
    func dateToString() -> String {
        let format = DateFormatter()
        format.dateFormat = "MMM dd, yyyy"
        return format.string(from: self)
    }
}

let url = URL(string: "https://raw.githubusercontent.com/Lascorbe/CocoaConferences/master/_data/conferences.yml")

public class ConferencesLoader: ObservableObject {
    @Published var conferences = [Conference]()
    var result: AnyCancellable?

    public init() {
        loadConferences(completion: {
            conferences in
            self.conferences = conferences
        })
    }

    func loadConferences(completion: @escaping ([Conference]) -> Void) {
        result = URLSession.shared.dataTaskPublisher(for: url!)
                // Make the DataTaskPublisher output equivalent to the YAMLDecoder input
                .map {$0.data}
                // Decode the remote YAML file
                .decode(type: [Conference].self, decoder: YAMLDecoder())
                // Specify a scheduler on which the current publisher will receive elements
                .receive(on: RunLoop.main)
                // Erase the publisher's actual type and convert it to AnyPublisher
                .eraseToAnyPublisher()
                // Attach a subscriber to the publisher.
                // receiveCompletion: a close to execute on completion. Use it to handle errors.
                // receiveValue: a closure to execute when receiving a value.
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