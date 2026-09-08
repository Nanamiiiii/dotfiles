return {
    "Civitasv/cmake-tools.nvim",
    event = { "BufReadPre", "BufNewFile" },
    config = true,
    opts = {
        cmake_build_directory = "build/${variant:buildType}",
    },
}
