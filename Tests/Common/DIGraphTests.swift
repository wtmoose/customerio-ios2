@testable import CioInternalCommon2
import Foundation
import SharedTests
import XCTest

class DIGraphTests: BaseDIGraphTest {
    func testDependencyGraphComplete() {
        runTest_expectDiGraphResolvesAllDependenciesWithoutError()
    }
}
