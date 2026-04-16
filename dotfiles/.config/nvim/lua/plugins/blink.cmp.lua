return {
    'saghen/blink.cmp',
    build = 'cargo build --release',
    opts = {
      keymap = { preset = 'default' },
      fuzzy = { implementation = 'prefer_rust' },
    },
  }
