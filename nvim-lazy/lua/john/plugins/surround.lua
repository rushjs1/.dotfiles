-- HACK: dst = delete html tag
-- HACK: cst = change tag
-- HACK: ysit = add surrounding tag
-- HACK: ysiw = add surrounding
-- HACK: cs + char = change to whatever
-- HACK: highlight + S + t = change
return {
  "kylechui/nvim-surround",
  event = {
    "BufReadPre",
    "BufNewFile",
  },
  version = "*",
  config = true,
}
