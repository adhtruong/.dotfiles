<%*
// Adjust cursor to allow insert from any place in a line
const editor = this.app.workspace.activeLeaf.view.editor;
const cursor = editor.getCursor();
editor.setCursor({line: cursor.line, ch: 0});
-%>
## <% tp.date.now("YYYY-MM-DD, ddd") %>

- <% tp.file.cursor(1) %>
