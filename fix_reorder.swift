    @discardableResult
    func reorderWorkspace(tabId: UUID, toIndex targetIndex: Int) -> Bool {
        guard let currentIndex = tabs.firstIndex(where: { $0.id == tabId }) else { return false }
        if tabs.count <= 1 { return true }
        let clamped = max(0, min(targetIndex, tabs.count - 1))
        if currentIndex == clamped { return true }
        let workspace = tabs.remove(at: currentIndex)
        tabs.insert(workspace, at: clamped)
        if clamped > 0, clamped < tabs.count - 1 {
            let prev = tabs[clamped - 1].folderId
            let next = tabs[clamped + 1].folderId
            if prev == next {
                workspace.folderId = prev
            } else if clamped > currentIndex {
                workspace.folderId = prev
            } else {
                workspace.folderId = next
            }
        } else if clamped == 0 {
            workspace.folderId = tabs.count > 1 ? tabs[1].folderId : nil
        } else if clamped == tabs.count - 1 {
            workspace.folderId = tabs.count > 1 ? tabs[clamped - 1].folderId : nil
        }
        return true
    }
