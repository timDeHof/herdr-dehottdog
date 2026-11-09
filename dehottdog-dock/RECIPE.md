# dehottdog-dock

Herdr with no sidebars. The terminals use the whole width of the window. Spaces, Agents and the Files/Changes panel sit side by side in a dock along the bottom, above the status bar. The Files and Changes buttons in the tab bar open their panel in the dock.

## What you see

Top to bottom:

1. **Tab bar**, 42px: the `tabs` mod (tabs as pills, the + menu, Files and Changes buttons). Dragging it moves the window. On macOS the window buttons sit over its left end at `[12, 14]`, and the tabs start after them.
2. **Work area**, takes the remaining height, 8px padding. It shows the active tab's panes as cards: 10px corners, `background` fill, 1px `border` edge, 1px `accent` edge on the focused pane, 8px between panes. Each pane has a 30px header on top drawn by the `pane` mod, shown only while the pointer is on the pane. A tab's only pane gets a card too.
3. **Dock**, 220px (120 to 520px), `chrome` background, a 1px `border` divider between its columns. Left to right:
   - Spaces, 1 share of the width: the `spaces` mod.
   - Agents, 1 share: the `agents` mod.
   - Files/Changes panel, 2 shares, hidden until opened from the tab bar. A stack of the `files` and `changes` mods. While it is hidden, Spaces and Agents split the dock in half.
4. **Status bar**, 28px, `chrome` background: the `workspace-status` mod.

The root is a column on `canvas`, no system title bar, `[14, 12]` terminal padding. The layout sets no theme, fonts or text size, so the person's `settings.json` decides them.

## How it behaves

- **Agent statuses** (Herdr's `agents` mod, sorted by priority by default, or grouped by space from the clock button):
  - blocked: listed under "Needs you" with a "Needs you" pill in the theme's `blocked` color.
  - done: listed under "Done" with a filled dot in `done`. It stays under Done while you look at it, then becomes idle.
  - working: listed under "Working" with a ring spinner in `working`.
  - idle: listed under "Idle" with a hollow ring in `idle`.
- Clicking an agent focuses its pane. Clicking a space shows it.
- Files in the tab bar shows the Files panel in the dock, and its button turns `selected`. Clicking it again hides the panel. Changes works the same way. Pressing one while the other is open switches the panel. The `tabs` mod remembers the choice per space.
- Dragging the dock's top edge resizes it between 120 and 520px. Dragging between dock columns resizes them.
- Pane headers appear on hover and are drawn over the terminal, so the terminal never resizes.

## Built from

- One layout file, `layouts/dehottdog-dock.json`, written by hand (not cloned). Herdr 0.1.14.
- Node tree: `root` (column) > `tabs` (block), `main` (block, `{"tab": "active"}` with a pane frame), `dock` (row: `spaces`, `agents`, `panel` (column) > `panel-body` (stack of `files`, `changes`, active `files`)), `status` (block).
- Shipped mods only: `tabs`, `pane`, `spaces`, `agents`, `files`, `changes`, `workspace-status`.
- `"preview": "layouts/dehottdog-dock.svg"` on the root. Art: `layouts/dehottdog-dock.svg`, a 320×200 sketch of the window for the settings screen, in fixed dark colors.

## Watch out

- The Files and Changes buttons work only because the panel's nodes have the ids `panel` and `panel-body`. The shipped `tabs` mod looks those ids up and runs `layout.select {"stack":"panel-body"}` and `layout.show {"id":"panel"}` (`mods/tabs/main.js`, the `panelButton` function). With any other ids the buttons do nothing. Keep these names.
- The panel shows Files or Changes, never both at once. That is how the shipped buttons work.
- There is no `workspace-chrome`, so there is no Settings or Add machine button and no search button. Open them from the command palette (`cmd-shift-p`).
- There is no node with id `sidebar`. `cmd-b` (toggle sidebar) does nothing here, and `spaces` and `agents` never draw their narrow rails.
- The preview SVG doesn't follow the theme or light mode.
- The `traffic_lights` position applies on macOS. On Linux and Windows, the `tabs` mod draws the window buttons at its right end.

## Done when

- `herdr-app do layout.switch '{"name":"dehottdog-dock"}'` shows the tab bar, the panes at full width, and a dock with Spaces and Agents above the status bar.
- `herdr-app status` reports `"errors": []`, and there is no `layouts/dehottdog-dock.error`.
- Files in the tab bar opens the Files panel as the dock's third column and highlights the button. Changes switches it to Changes. Clicking the lit button hides the panel.
- `layout.resize {"id":"dock","px":120}` shrinks the dock and the panes grow.
- Settings → Look shows the dehottdog-dock picture on its layout card.
- An agent going working, blocked and done shows the spinner, "Needs you" pill and dot in the dock's Agents column.
