import Foundation
import SwiftUI

/// A named folder that groups workspaces in the sidebar.
@MainActor
final class TabFolder: Identifiable, ObservableObject {
    let id: UUID
    @Published var name: String
    @Published var isExpanded: Bool
    @Published var workspaceIds: [UUID]

    init(
        id: UUID = UUID(),
        name: String,
        isExpanded: Bool = true,
        workspaceIds: [UUID] = []
    ) {
        self.id = id
        self.name = name
        self.isExpanded = isExpanded
        self.workspaceIds = workspaceIds
    }

    func contains(workspaceId: UUID) -> Bool {
        workspaceIds.contains(workspaceId)
    }

    func addWorkspace(_ workspaceId: UUID) {
        guard !workspaceIds.contains(workspaceId) else { return }
        workspaceIds.append(workspaceId)
    }

    func removeWorkspace(_ workspaceId: UUID) {
        workspaceIds.removeAll { $0 == workspaceId }
    }

    /// Remove workspace IDs that no longer exist in the tab list.
    func pruneStaleWorkspaces(validIds: Set<UUID>) {
        workspaceIds.removeAll { !validIds.contains($0) }
    }
}

// MARK: - Session Persistence Snapshot

struct SessionTabFolderSnapshot: Codable, Sendable {
    var id: String
    var name: String
    var isExpanded: Bool
    var workspaceIndices: [Int]
}
