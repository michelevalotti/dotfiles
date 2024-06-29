local wk = require("which-key")
wk.register({
  f = {
    f = { "Find File" },
    b = { "Find Buffer" },
    h = { "Find Help Tag" },
    g = { "Find Grep" },
    o = { "Find Recent File" },
    j = { "Find jump list" },
    B = { "Find telescope builtin picker" },
  },
  ["b"] = { "Toggle Breakpoint" },
  ["p"] = { "Switch to Previous Buffer" },
  d = {
    k = { "Debugger Continue" },
    K = { "Debugger Restart" },
    l = { "Debugger Run Last Session" },
    o = { "Debugger Step Over" },
    i = { "Debugger Step Into" },
    t = { "Debugger Terminate" },
    f = { "Debugger Open Scopes in Floating Window" },
    s = { "Debugger Open Scopes in Sidebar (bottom)" },
    h = { "Debugger Open Hover Window" },
    b = { "Find Debugger Breakpoints" },
    r = { "Find Debugger Frames" },
    C = { "Find Debugger Commands" },
    c = { "Open Debugger Console" },
    n = { "Start additional debugging session" },
    S = { "List running sessions" },
    F = { "Focus on current active session" },
  },
  h = {
    s = { "Stage Hunk" },
    r = { "Reset Hunk" },
    S = { "Stage Buffer" },
    u = { "Undo Stage Hunk" },
    R = { "Reset Buffer" },
    p = { "Preview Hunk" },
    b = { "Blame Line" },
    d = { "Diff This" },
    D = { "Diff This ~" },
  },
  t = {
    b = { "Toggle Current Line Blame Gitsigns" },
    d = { "Toggle Deleted Gitsigns" },
  },
  l = {
    r = { "Telescope list references" },
    d = { "Telescope list buffer diagnostics" },
    a = { "Telescope list all diagnostics" },
    o = { "Telescope buffer symbols" },
    p = { "Telescope peek definition" },
  },
  o = {
    D = { "toggle Oil float current buffer dir" },
    d = { "toggle Oil current buffer dir" },
    B = { "toggle Oil float project base dir" },
    b = { "toggle Oil project base dir" },
    P = { "toggle Oil float dir on last exit" },
    p = { "toggle Oil dir on last exit" },
  },
  g = {
    b = { "Telescope git branches" },
    c = { "Telescope git buffer commits" },
    C = { "Telescope git commits" },
    F = { "Telescope git tracked files" },
    s = { "Telescope git status" },
    S = { "Telescope git stash" },
  },
  c = {
    p = { "copy full path of current buffer into system clipboard" }
  },
  ["\\"] = { "New empty buffer to the right" },
  ["-"] = { "New empty buffer below" },
  s = {
    d = { "select session to delete" },
    m = { "make session with name" },
    s = { "select session to load" },
  }
}, { prefix = "<leader>"})
wk.register({
  c = {
    v = { "Change Terminal direction to Vertical" },
    h = { "Change Terminal direction to Horizontal" },
    f = { "Change Terminal direction to Float" },
  },
  t = {
    s = { "Show list of opened Terminals" },
  },
}, { prefix = "\\"})
wk.register({
  ["<C-h>"] = { "Move window focus left" },
  ["<C-j>"] = { "Move window focus down" },
  ["<C-k>"] = { "Move window focus up" },
  ["<C-l>"] = { "Move window focus right" },
  ["<S-h>"] = { "Move to prev buffer" },
  ["<S-l>"] = { "Move to next buffer" },
  ["K"] = { "show docs" },
  ["<A-n>"] = { "navigate to next highlighted reference" },
  ["<A-p>"] = { "navigate to prev highlighted reference" },
  g = {
    d = { "Go to definition" },
    R = { "lsp rename all symbols in project" },
    F = { "lsp format buffer (or visual selection)" },
  },
  ["]"] = {
    c = { "next git hunk" },
  },
  ["["] = {
    c = { "prev git hunk" },
  },
})
