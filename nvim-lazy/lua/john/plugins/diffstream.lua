return {
  "rushjs1/diffstream.nvim",
  config = function()
    require("diffstream").setup({
      --[[ feedback = {
        runners = {
          {
            name = "Codex",
            runner = {
              "/Applications/ChatGPT.app/Contents/Resources/codex",
              "exec",
              "--sandbox",
              "workspace-write",
              "-",
            },
          },
          {
            name = "Pi",
            runner = {
              "/Users/johnrush/Library/pnpm/bin/pi",
              "--print",
            },
          },
          {
            name = "Claude Code",
            runner = {
              "/Users/johnrush/.local/bin/claude",
              "--print",
              "--permission-mode",
              "acceptEdits",
            },
          },
        },
      }, ]]
    })
  end,
}
