    private func promptRenameFolder() {
        let alert = NSAlert()
        alert.messageText = "Rename Folder"
        alert.informativeText = "Enter a name for this folder."
        let input = NSTextField(string: folder.title)
        input.placeholderString = "Folder name"
        input.frame = NSRect(x: 0, y: 0, width: 240, height: 22)
        alert.accessoryView = input
        alert.addButton(withTitle: "Rename")
        alert.addButton(withTitle: "Cancel")
        let alertWindow = alert.window
        alertWindow.initialFirstResponder = input
        DispatchQueue.main.async {
            input.currentEditor()?.selectAll(nil)
        }
        let response = alert.runModal()
        if response == .alertFirstButtonReturn {
            let name = input.stringValue.trimmingCharacters(in: .whitespacesAndNewlines)
            if !name.isEmpty, let index = tabManager.folders.firstIndex(where: { $0.id == folder.id }) {
                tabManager.folders[index].title = name
            }
        }
    }
