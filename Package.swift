// swift-tools-version:5.5

import PackageDescription

let package = Package(
    name: "llamaforked",
    platforms: [
        .macOS(.v12),
        .iOS(.v14),
        .watchOS(.v4),
        .tvOS(.v14)
    ],
    products: [
        .library(name: "llamaforked", targets: ["llamaforked"]),
    ],
    targets: [
        .target(
            name: "llamaforked",
            path: ".",
            exclude: [
               "cmake",
            //    "examples",
               "scripts",
               "models",
               "tests",
               "CMakeLists.txt",
               "ggml-cuda.cu",
               "ggml-cuda.h",
               "Makefile"
            ],
            sources: [
                "ggml.c",
                "llama.cpp",
                "ggml-alloc.c",
                "ggml-backend.c",
                "ggml-quants.c",
                "ggml-metal.m",
                "cym-test.cpp",
                "examples/llava/llava-cli.cpp",
                "examples/llava/clip.cpp", "examples/llava/llava.cpp", 
                "common/common.cpp", "common/sampling.cpp", "common/grammar-parser.cpp",
                "whisper.cpp"
            ],
            resources: [
                .process("ggml-metal.metal")
            ],
            publicHeadersPath: "spm-headers",
            cSettings: [
                .unsafeFlags(["-Wno-shorten-64-to-32", "-O3", "-DNDEBUG"]),
                .define("GGML_USE_ACCELERATE"),
                .unsafeFlags(["-fno-objc-arc"]),
                // .define("GGML_USE_METAL"),
                // NOTE: NEW_LAPACK will required iOS version 16.4+
                // We should consider add this in the future when we drop support for iOS 14
                // (ref: ref: https://developer.apple.com/documentation/accelerate/1513264-cblas_sgemm?language=objc)
                // .define("ACCELERATE_NEW_LAPACK"),
                // .define("ACCELERATE_LAPACK_ILP64")
            ],
            linkerSettings: [
                .linkedFramework("Accelerate")
            ]
        )
    ],
    cxxLanguageStandard: .cxx11
)
