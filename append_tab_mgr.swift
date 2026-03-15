    func moveTabsToFolder(_ ids: Set<UUID>, folderId: UUID?) {
        for id in ids {
            if let tab = tabs.first(where: { $0.id == id }) {
                tab.folderId = folderId
            }
        }
        
        var grouped: [UUID?: [Workspace]] = [:]
        for tab in tabs {
            grouped[tab.folderId, default: []].append(tab)
        }
        
        var newTabs: [Workspace] = []
        for folder in folders {
            if let folderTabs = grouped[folder.id] {
                newTabs.append(contentsOf: folderTabs)
            }
        }
        if let ungrouped = grouped[nil] {
            newTabs.append(contentsOf: ungrouped)
        }
        
        tabs = newTabs
    }
