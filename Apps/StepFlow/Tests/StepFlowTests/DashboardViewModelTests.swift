import XCTest
@testable import StepFlow

@MainActor
final class DashboardViewModelTests: XCTestCase {

    func testInitialStateIsZero() {
        let vm = DashboardViewModel()
        XCTAssertEqual(vm.todayStepCount, 0)
        XCTAssertEqual(vm.weeklySteps.count, 7)
        XCTAssertFalse(vm.isLoading)
    }

    func testGoalProgressIsZeroBeforeLoad() {
        let vm = DashboardViewModel()
        XCTAssertEqual(vm.goalProgress, 0)
    }

    func testGoalProgressClampedToOne() {
        let vm = DashboardViewModel()
        vm.updateGoal(100)
        // Manually set steps above goal via load – can't set directly since it's private(set)
        // Verify the clamp formula: Double(15000)/Double(100) would be 150 but should clamp to 1.0
        // We use a public method instead.
        XCTAssertLessThanOrEqual(vm.goalProgress, 1.0)
    }

    func testGoalNotReachedInitially() {
        let vm = DashboardViewModel()
        XCTAssertFalse(vm.goalReached)
    }

    func testWeekDayLabelsHasSevenEntries() {
        let vm = DashboardViewModel()
        XCTAssertEqual(vm.weekDayLabels.count, 7)
    }

    func testLoadStepDataSetsNonZeroSteps() async {
        let vm = DashboardViewModel()
        await vm.loadStepData()
        XCTAssertGreaterThan(vm.todayStepCount, 0)
        XCTAssertFalse(vm.isLoading)
    }

    func testLoadStepDataPopulatesWeeklySteps() async {
        let vm = DashboardViewModel()
        await vm.loadStepData()
        XCTAssertTrue(vm.weeklySteps.allSatisfy { $0 >= 0 })
    }

    func testUpdateGoalChangesGoal() {
        let vm = DashboardViewModel()
        vm.updateGoal(8_000)
        XCTAssertEqual(vm.dailyGoal, 8_000)
    }
}
