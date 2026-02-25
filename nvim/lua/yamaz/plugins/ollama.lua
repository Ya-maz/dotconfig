return {
  "nomnivore/ollama.nvim",
  dependencies = {
    "nvim-lua/plenary.nvim",
  },

  -- Respond to "Weak mode" (from your yamaz.core.utils)
  -- If you want it disabled in weak mode, uncomment the line below:
  -- enabled = not require("yamaz.core.utils").is_weak_mode(),

  cmd = { "Ollama", "OllamaModel", "OllamaServe", "OllamaServeStop" },

  keys = {
    {
      "<leader>oo",
      ":Ollama<cr>",
      desc = "Ollama Menu",
      mode = { "n", "v" },
    },
    {
      "<leader>oa",
      ":Ollama Ask<cr>",
      desc = "Ollama Ask",
      mode = { "n", "v" },
    },
    {
      "<leader>oe",
      ":Ollama Explain<cr>",
      desc = "Ollama Explain",
      mode = { "n", "v" },
    },
    {
      "<leader>og",
      ":Ollama Generate<cr>",
      desc = "Ollama Generate",
      mode = { "n", "v" },
    },
  },

  opts = {
    model = "qwen3-coder:30b",
    url = "http://172.22.48.1:11434",
    serve = {
      on_start = false,
    },
    view = "vsplit", -- or "vsplit", "hsplit", "float"
  },
}
