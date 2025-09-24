// swift-tools-version: 5.10
import PackageDescription

// Swift Package that builds llama.cpp from source (CPU/Accelerate by default).
// Note: Enabling GPU backends (Metal/CUDA/SYCL/etc.) requires codegen/build steps
// normally performed by CMake. This manifest intentionally targets CPU+Accelerate
// for a portable, SPM-only build. For Metal acceleration on Apple platforms,
// consider using the provided CMake toolchain or prebuilt XCFramework.

let package = Package(
    name: "llamaforked",
    platforms: [
        .iOS(.v16),
        .macOS(.v13),
        .tvOS(.v16),
        .visionOS(.v1)
    ],
    products: [
        .library(name: "llamaforked", targets: ["llamaforked"])
    ],
    targets: [
        .target(
            name: "llamaforked",
            path: ".",
            // Compile from source: minimal core directories
            sources: [
                "src",
                "ggml/src",
            ],
            publicHeadersPath: "include",
            exclude: [
                // Non-targeted directories
                "ci", "cmake", "docs", "examples", "gguf-py", "grammars", "kompute",
                "licenses", "media", "models", "pocs", "scripts", "tests", "tools",
                "vendor", "common",
                // Exclude GPU backends and generated/unsupported files for SPM-only build
                "ggml/src/ggml-cuda.cu",
                "ggml/src/ggml-cuda.cpp",
                "ggml/src/ggml-cuda.h",
                "ggml/src/ggml-opencl.c",
                "ggml/src/ggml-opencl.h",
                "ggml/src/ggml-kompute.cpp",
                "ggml/src/ggml-kompute.hpp",
                "ggml/src/ggml-sycl.cpp",
                "ggml/src/ggml-sycl.h",
                "ggml/src/ggml-rocm.cpp",
                "ggml/src/ggml-rocm.h",
                "ggml/src/ggml-cann.cpp",
                "ggml/src/ggml-cann.h",
                "ggml/src/ggml-metal.m",
                "ggml/src/ggml-metal.metal",
                "ggml/src/ggml-dzn.cpp",
                "ggml/src/ggml-dzn.h",
                // Optional frontends/tools
                "src/llama-cuda.cpp",
                "src/llama-rpc.cpp",
                "src/llama-vision.cpp"
            ],
            cSettings: [
                // Enable Accelerate on Apple platforms
                .define("GGML_USE_ACCELERATE", to: "1", .when(platforms: [.iOS, .macOS, .tvOS, .visionOS])),
                // Ensure K-quants enabled as in upstream defaults
                .define("GGML_USE_K_QUANTS", to: "1"),
                // Explicitly disable Metal in this SPM-only build
                .define("GGML_METAL", to: "0", .when(platforms: [.iOS, .macOS, .tvOS, .visionOS])),
            ],
            cxxSettings: [
                .headerSearchPath("include"),
                .headerSearchPath("ggml/include"),
                .unsafeFlags(["-std=gnu++20"]) // match project C++ standard
            ],
            linkerSettings: [
                .linkedFramework("Accelerate")
            ]
        )
    ]
)


