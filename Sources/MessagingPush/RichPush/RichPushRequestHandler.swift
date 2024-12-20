import CioInternalCommon2
import Foundation

class RichPushRequestHandler {
    static let shared = RichPushRequestHandler()

    @Atomic private var requests: [String: RichPushRequest] = [:]

    private init() {}

    func startRequest(
        push: PushNotification,
        completionHandler: @escaping (PushNotification) -> Void
    ) {
        let requestId = push.pushId

        let existingRequest = requests[requestId]
        if existingRequest != nil { return }

        let diGraph = DIGraphShared.shared
        let httpClient = diGraph.httpClient

        let newRequest = RichPushRequest(
            push: push,
            httpClient: httpClient,
            completionHandler: completionHandler
        )
        requests[requestId] = newRequest

        newRequest.start()
    }

    func stopAll() {
        requests.forEach {
            $0.value.finishImmediately()
        }

        requests = [:]
    }
}
