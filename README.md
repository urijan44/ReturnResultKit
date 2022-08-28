# ReturnResultKit

# Introduce

Return Result Kit은 Return Type을 반환값으로 사용할 수 있는 라이브러리입니다.

# Example
- 비동기 코드에서 결과값을 ReturnResult를 통해서 꺼내올 수 있습니다.

```swift
func fetchImage(name: String) -> ReturnResult<Data, Error> {
  return ReturnResult<Data, Error> { [unowned self] promise in
    let url = imageService.makeURL(name: name)
    urlSession.dataTask(with: url) { data, response, error in
      if let error = error {
        promise(.failure(error))
        return
      }
     if let data = data {
        promise(.success(data))
        return
      }
    }
    .resume()
  }
}
```

sink 인스턴스 메서드를 통해 성공값과 실패했을 때 에러값을 가져올 수 있습니다.
```swift
let fetchResult = configuration.fetchImage(name: "영화사진")
fetchResult
  .sink { [unowned imageView] result in
  switch result {
    case .success(let image):
      Task {
        imageView.image = image
      }
    case .failure(let error):
      print("ERROR:" , error.localizedDescription)
  }
}
```

map 인스턴스 메서드를 통해 타입이 다른 ReturnResult를 생성할 수 있습니다.
```swift
fetchResult
  .map { data in
    UIImage(data: data)
  }
  // ReturnResult<UIImage, Error>
  .sink { [unowned imageView] result in
    switch result {
      case .success(let image):
        Task {
          imageView.image = image
        }
      case .failure(let error):
        print("ERROR:" , error.localizedDescription)
  }
}
```
