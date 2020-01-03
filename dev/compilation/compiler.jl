using PackageCompilerX
create_sysimage(:CImGui, sysimage_path=joinpath(@__DIR__, "CImGuiSysImage.so"),
        precompile_execution_file = joinpath(@__DIR__, "precompile.jl"))
