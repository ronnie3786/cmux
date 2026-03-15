import SwiftUI

/// Header row for a folder in the vertical sidebar.
/// Displays a disclosure triangle, folder icon, folder name,
/// a count badge, and a context menu for management.
struct SidebarFolderHeaderView: View {
    @ObservedObject var folder: TabFolder
    let tabManager: TabManager
    @Binding var draggedTabId: UUID?
    @State private var isHovering = false
    @State private var isRenaming = false
    @State private var renameText = ""
    @State private var isDropTargeted = false

    var body: some View {
        HStack(spacing: 4) {
            // Disclosure triangle
            Button {
                withAnimation(.easeInOut(duration: 0.15)) {
                    folder.isExpanded.toggle()
                }
            } label: {
                Image(systemName: "chevron.right")
                    .font(.system(size: 9, weight: .bold))
                    .foregroundColor(.secondary)
                    .rotationEffect(.degrees(folder.isExpanded ? 90 : 0))
                    .animation(.easeInOut(duration: 0.15), value: folder.isExpanded)
                    .frame(width: 16, height: 16)
            }
            .buttonStyle(.plain)

            // Folder icon
            Image(systemName: folder.isExpanded ? "folder.fill" : "folder")
                .font(.system(size: 11))
                .foregroundColor(.secondary)

            // Name or rename field
            if isRenaming {
                TextField("", text: $renameText, onCommit: {
                    commitRename()
                })
                .textFieldStyle(.plain)
                .font(.system(size: 12, weight: .semibold))
                .onExitCommand {
                    isRenaming = false
                }
            } else {
                Text(folder.name)
                    .font(.system(size: 12, weight: .semibold))
                    .foregroundColor(.primary)
                    .lineLimit(1)
                    .truncationMode(.tail)
            }

            Spacer()

            // Workspace count badge
            let count = folder.workspaceIds.count
            if count > 0 {
                Text("\(count)")
                    .font(.system(size: 10, weight: .medium))
                    .foregroundColor(.secondary)
                    .padding(.horizontal, 5)
                    .padding(.vertical, 1)
                    .background(
                        Capsule()
                            .fill(Color.secondary.opacity(0.15))
                    )
            }
        }
        .padding(.horizontal, 10)
        .padding(.vertical, 6)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: 5)
                .fill(isDropTargeted ? cmuxAccentColor().opacity(0.2) : (isHovering ? Color.primary.opacity(0.05) : Color.clear))
        )
        .onHover { hovering in
            isHovering = hovering
        }
        .onDrop(of: SidebarTabDragPayload.dropContentTypes, isTargeted: $isDropTargeted) { providers in
            handleDrop(providers: providers)
        }
        .contextMenu {
            folderContextMenu
        }
        .accessibilityElement(children: .combine)
        .accessibilityLabel(Text(folder.name))
        .accessibilityHint(Text(folder.isExpanded
            ? String(localized: "folder.expanded.hint", defaultValue: "Double-click to collapse")
            : String(localized: "folder.collapsed.hint", defaultValue: "Double-click to expand")
        ))
    }

    @ViewBuilder
    private var folderContextMenu: some View {
        Button(String(localized: "contextMenu.renameFolder", defaultValue: "Rename Folder…")) {
            renameText = folder.name
            isRenaming = true
        }

        Button(String(localized: "contextMenu.expandCollapseFolder", defaultValue: folder.isExpanded ? "Collapse Folder" : "Expand Folder")) {
            folder.isExpanded.toggle()
        }

        Divider()

        if !folder.workspaceIds.isEmpty {
            Button(String(localized: "contextMenu.removeAllFromFolder", defaultValue: "Remove All from Folder")) {
                for wsId in folder.workspaceIds {
                    tabManager.removeWorkspaceFromFolder(workspaceId: wsId)
                }
            }
        }

        Button(String(localized: "contextMenu.deleteFolder", defaultValue: "Delete Folder")) {
            tabManager.deleteFolder(folderId: folder.id)
        }
    }

    private func commitRename() {
        let trimmed = renameText.trimmingCharacters(in: .whitespacesAndNewlines)
        if !trimmed.isEmpty {
            tabManager.renameFolder(folderId: folder.id, name: trimmed)
        }
        isRenaming = false
    }

    private func handleDrop(providers: [NSItemProvider]) -> Bool {
        guard let draggedId = draggedTabId else { return false }
        // Verify the dragged workspace exists
        guard tabManager.tabs.contains(where: { $0.id == draggedId }) else { return false }
        tabManager.moveWorkspaceToFolder(workspaceId: draggedId, folderId: folder.id)
        return true
    }
}
