        Menu("Move to Folder") {
            Button("New Folder") {
                let folderId = UUID()
                let folder = WorkspaceFolder(id: folderId, title: "New Folder", isExpanded: true)
                tabManager.folders.append(folder)
                tabManager.moveTabsToFolder(Set(targetIds), folderId: folderId)
                syncSelectionAfterMutation()
            }
            if !tabManager.folders.isEmpty {
                Divider()
                Button("Remove from Folder") {
                    tabManager.moveTabsToFolder(Set(targetIds), folderId: nil)
                    syncSelectionAfterMutation()
                }
                Divider()
                ForEach(tabManager.folders) { folder in
                    Button(folder.title) {
                        tabManager.moveTabsToFolder(Set(targetIds), folderId: folder.id)
                        syncSelectionAfterMutation()
                    }
                }
            }
        }
