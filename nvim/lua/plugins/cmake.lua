return {
    'Civitasv/cmake-tools.nvim',
    dependencies = {
        'akinsho/toggleterm.nvim',
    },
    event = { "BufReadPre", "BufNewFile" },
    config = true,
    opts = {
        cmake_build_directory = "build/${variant:buildType}",
    }
}
