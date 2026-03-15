import Foundation

// MARK: - TabFolder

/// A named group of workspaces that can be expanded or collapsed in the vertical sidebar.
@MainActor
final class TabFolder: Identifiable, ObservableObject {
    let id: UUID

    /// Display name shown in the sidebar folder row.
    @Published var name: String

    /// Whether the folder is expanded (showing its tabs) or collapsed.
    @Published var isExpanded: Bool

    /// IDs of workspaces assigned to this folder.
    /// The display order within the folder follows the order of `TabManager.tabs`, not this array.
    /// This array serves as a membership set; order is preserved only for session persistence round-trips.
    @Published var tabIds: [UUID]

    init(id: UUID = UUID(), name: String, isExpanded: Bool = true, tabIds: [UUID] = []) {
        self.id = id
        self.name = name
        self.isExpanded = isExpanded
        self.tabIds = tabIds
    }
}
