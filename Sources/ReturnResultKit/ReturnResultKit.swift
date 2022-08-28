//
//  ReturnResult.swift
//
//  Created by hoseung Lee on 2022/08/28.
//
import Foundation

public typealias SimplePromise<Output, Failure: Error> = (Result<Output, Failure>) -> Void

/// Result Type을 반환값으로 사용할 수 있는 레퍼 속성
public struct ReturnResult<Output, Failure> where Failure: Error {

  private var result: (@escaping SimplePromise<Output, Failure>) -> Void

  /// SimplePromise 생성자
  /// - Parameter promise: promise 클로져 안에서 promise를 호출하고 success 또는 failure를 작성할 수 있습니다.
  /// ```swift
  /// func fetchImage(name: String) -> ReturnResult<Data, Error> {
  ///   return ReturnResult<Data, Error> { [unowned self] promise in
  ///     let url = imageService.makeURL(name: name)
  ///     urlSession.dataTask(with: url) { data, response, error in
  ///     if let error = error {
  ///       promise(.failure(error))
  ///       return
  ///     }
  ///     if let data = data {
  ///       promise(.success(data))
  ///       return
  ///     }
  ///   }
  ///   .resume()
  ///   }
  /// }
  ///```
  public init(promise: @escaping (@escaping SimplePromise<Output, Failure>) -> Void) {
    result = promise
  }

  /// map 연산자를 이용해서 다른 ReturnResult 타입을 전달할 수 있습니다.
  /// - Parameter transform: swift 의 map처럼 사용하실 수 있습니다.
  /// - Returns: 변환된 ReturnResult 타입
  public func map<NewOutput>(_ transform: @escaping (Output) -> NewOutput) -> ReturnResult<NewOutput, Failure> {
    ReturnResult<NewOutput, Failure> { newPromise in
      result { newResult in
        switch newResult {
          case .success(let newOutput):
            newPromise(.success(transform(newOutput)))
          case .failure(let error):
            newPromise(.failure(error))
        }
      }
    }
  }

  /// 저장된 값을 sink를 통해서 가져올 수 있습니다.
  /// - Parameter result: result는 success, failure 두 타입이 있습니다.
  public func sink(result: @escaping SimplePromise<Output, Failure>) {
    self.result(result)
  }
}
