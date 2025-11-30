protocol ScheduleViewControllerDelegate: AnyObject {
    func didSelectSchedule(_ selectedDays: Set<Week>)
}
