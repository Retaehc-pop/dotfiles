return {
  'Civitasv/cmake-tools.nvim',
  dependencies = {
    'nvim-lua/plenary.nvim',
    'nvim-telescope/telescope.nvim',
  },
  ft = { 'c', 'cpp', 'cmake' },
  opts = {
    cmake_build_directory = 'build',
    cmake_generate_options = { '-DCMAKE_EXPORT_COMPILE_COMMANDS=ON' },
  },
}
