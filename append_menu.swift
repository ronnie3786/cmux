        Menu("Move to Folder") {
            Button("New Folder") {
                let folderId = UUID()
                let folder = WorkspaceFolder(id: folderId, title: "New Folder", isExpanded: true)
                tabManager.folders.append(folder)
                for id in targetIds {
                    if let tab = tabManager.tabs.first(where: { $0.id == id }) {
                        tab.folderId = folderId
                    }
                }
                syncSelectionAfterMutation()
            }
            if !tabManager.folders.isEmpty {
                Divider()
                Button("Remove from Folder") {
                    for id in targetIds {
                        if let tab = tabManager.tabs.first(where: { $0.id == id }) {
                            tab.folderId = nil
                        }
                    }
                    syncSelectionAfterMutation()
                }
                Divider()
                ForEach(tabManager.folders) { folder in
                    Button(folder.title) {
                        for id in targetIds {
                            if let tab = tabManager.tabs.first(where: { $0.id == id }) {
                                tab.folderId = folder.id
                            }
                        }
                        syncSelectionAfterMutation()
                    }
                }
            }
        }
