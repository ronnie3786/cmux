private struct FolderHeaderView: View {
    let folder: WorkspaceFolder
    @ObservedObject var tabManager: TabManager

    var body: some View {
        HStack(spacing: 4) {
            Button(action: {
                if let index = tabManager.folders.firstIndex(where: { $0.id == folder.id }) {
                    tabManager.folders[index].isExpanded.toggle()
                }
            }) {
                Image(systemName: folder.isExpanded ? "chevron.down" : "chevron.right")
                    .font(.system(size: 9, weight: .bold))
                    .foregroundColor(.secondary)
                    .frame(width: 16, height: 16)
                    .contentShape(Rectangle())
            }
            .buttonStyle(.plain)

            Text(folder.title)
                .font(.system(size: 11, weight: .semibold))
                .foregroundColor(.secondary)
                .lineLimit(1)
                .contentShape(Rectangle())
                .onTapGesture {
                    if let index = tabManager.folders.firstIndex(where: { $0.id == folder.id }) {
                        tabManager.folders[index].isExpanded.toggle()
                    }
                }

            Spacer()
        }
        .padding(.leading, 8)
        .padding(.trailing, 8)
        .padding(.top, 12)
        .padding(.bottom, 4)
        .contentShape(Rectangle())
        .contextMenu {
            Button("Rename Folder") {
                // Rename could be done similarly to workspace rename if we want
            }
            Button("Delete Folder") {
                for tab in tabManager.tabs where tab.folderId == folder.id {
                    tab.folderId = nil
                }
                tabManager.folders.removeAll { $0.id == folder.id }
            }
        }
    }
}
