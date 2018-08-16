import Foundation

extension URLSession {
    private enum Error: Swift.Error {
        case failedWithError(String)
    }
    
    func dataTask(
        with url: URL,
        resultQueue: DispatchQueue,
        resultHandler: @escaping (AsyncResult<Data>) -> Void) -> URLSessionDataTask
    {
        return self.dataTask(
            with: URLRequest(url: url),
            resultQueue: resultQueue,
            resultHandler: resultHandler
        )
    }
    
    func dataTask(
        with request: URLRequest,
        resultQueue: DispatchQueue,
        resultHandler: @escaping (AsyncResult<Data>) -> Void) -> URLSessionDataTask
    {
        return self.dataTask(with: request) { (data, response, error) in
            do {
                guard error == nil else { throw error! }
                guard let httpResponse = response as? HTTPURLResponse else {
                    throw Error.failedWithError("Failed to access response as httpResponse")
                }
                guard (200...299).contains(httpResponse.statusCode) else {
                    throw Error.failedWithError("Non-200 http status code received: \(httpResponse.statusCode)")
                }
                guard let data = data else {
                    throw Error.failedWithError("Failed to access data in response.")
                }
                resultQueue.async { resultHandler( .success(data) ) }
                
            } catch {
                resultQueue.async { resultHandler( .failure(error) ) }
            }
        }
    }
}
