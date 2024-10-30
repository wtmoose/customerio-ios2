// Generated using Sourcery 2.0.3 — https://github.com/krzysztofzablocki/Sourcery
// DO NOT EDIT
// swiftlint:disable all

import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif
#if canImport(UserNotifications)
import UserNotifications
#endif
import CioInternalCommon2

/**
 ######################################################
 Documentation
 ######################################################

 This automatically generated file you are viewing contains mock classes that you can use in your test suite.

 * How do you generate a new mock class?

 1. Mocks are generated from Swift protocols. So, you must make one.

 ```
 protocol FriendsRepository {
     func acceptFriendRequest<Attributes: Encodable>(attributes: Attributes, _ onComplete: @escaping () -> Void)
 }

 class AppFriendsRepository: FriendsRepository {
     ...
 }
 ```

 2. Have your new protocol extend `AutoMockable`:

 ```
 protocol FriendsRepository: AutoMockable {
     func acceptFriendRequest<Attributes: Encodable>(
         // sourcery:Type=Encodable
         attributes: Attributes,
         _ onComplete: @escaping () -> Void)
 }
 ```

 > Notice the use of `// sourcery:Type=Encodable` for the generic type parameter. Without this, the mock would
 fail to compile: `functionNameReceiveArguments = (Attributes)` because `Attributes` is unknown to this `var`.
 Instead, we give the parameter a different type to use for the mock. `Encodable` works in this case.
 It will require a cast in the test function code, however.

 3. Run the command `make generate` on your machine. The new mock should be added to this file.

 * How do you use the mocks in your test class?

 ```
 class ExampleViewModelTest: XCTestCase {
     var viewModel: ExampleViewModel!
     var exampleRepositoryMock: ExampleRepositoryMock!
     override func setUp() {
         exampleRepositoryMock = ExampleRepositoryMock()
         viewModel = AppExampleViewModel(exampleRepository: exampleRepositoryMock)
     }
 }
 ```

 Or, you may need to inject the mock in a different way using the DI.shared graph:

 ```
 class ExampleTest: XCTestCase {
     var exampleViewModelMock: ExampleViewModelMock!
     var example: Example!
     override func setUp() {
         exampleViewModelMock = ExampleViewModelMock()
         DI.shared.override(.exampleViewModel, value: exampleViewModelMock, forType: ExampleViewModel.self)
         example = Example()
     }
 }

 ```

 */

/**
 Class to easily create a mocked version of the `DeviceAttributesProvider` class.
 This class is equipped with functions and properties ready for you to mock!

 Note: This file is automatically generated. This means the mocks should always be up-to-date and has a consistent API.
 See the SDK documentation to learn the basics behind using the mock classes in the SDK.
 */
class DeviceAttributesProviderMock: DeviceAttributesProvider, Mock {
    /// If *any* interactions done on mock. `true` if any method or property getter/setter called.
    var mockCalled: Bool = false //

    init() {
        Mocks.shared.add(mock: self)
    }

    public func resetMock() {
        getDefaultDeviceAttributesCallsCount = 0
        getDefaultDeviceAttributesReceivedArguments = nil
        getDefaultDeviceAttributesReceivedInvocations = []

        mockCalled = false // do last as resetting properties above can make this true
    }

    // MARK: - getDefaultDeviceAttributes

    /// Number of times the function was called.
    @Atomic private(set) var getDefaultDeviceAttributesCallsCount = 0
    /// `true` if the function was ever called.
    var getDefaultDeviceAttributesCalled: Bool {
        getDefaultDeviceAttributesCallsCount > 0
    }

    /// The arguments from the *last* time the function was called.
    @Atomic private(set) var getDefaultDeviceAttributesReceivedArguments: (([String: Any]) -> Void)?
    /// Arguments from *all* of the times that the function was called.
    @Atomic private(set) var getDefaultDeviceAttributesReceivedInvocations: [([String: Any]) -> Void] = []
    /**
     Set closure to get called when function gets called. Great way to test logic or return a value for the function.
     */
    var getDefaultDeviceAttributesClosure: ((@escaping ([String: Any]) -> Void) -> Void)?

    /// Mocked function for `getDefaultDeviceAttributes(onComplete: @escaping ([String: Any]) -> Void)`. Your opportunity to return a mocked value and check result of mock in test code.
    func getDefaultDeviceAttributes(onComplete: @escaping ([String: Any]) -> Void) {
        mockCalled = true
        getDefaultDeviceAttributesCallsCount += 1
        getDefaultDeviceAttributesReceivedArguments = onComplete
        getDefaultDeviceAttributesReceivedInvocations.append(onComplete)
        getDefaultDeviceAttributesClosure?(onComplete)
    }
}

// swiftlint:enable all
