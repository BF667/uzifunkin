#!/bin/bash
# FNF: Uzi Funkin Engine - Windows Cross-Compile Builder
# Use this script on Linux/Mac to build a Windows .exe

echo "============================================"
echo "  FNF: Uzi Funkin Engine - Windows Builder"
echo "  Low-End Optimized Engine Build"
echo "============================================"
echo ""

# Check if lime is available
if ! command -v lime &> /dev/null; then
    echo "[ERROR] Lime not found! Make sure you have Haxe and Lime installed."
    echo "Run: haxelib install lime"
    exit 1
fi

# Ask for build type
echo "Select build type:"
echo "[1] Release Build (Optimized .exe - Recommended for distribution)"
echo "[2] Debug Build (With debug tools - For development)"
echo "[3] Release Build with Low-End Defaults (Pre-configured for potato PCs)"
echo ""
read -p "Enter choice (1/2/3): " BUILD_TYPE

case $BUILD_TYPE in
    1)
        echo ""
        echo "[BUILD] Starting Release Build for Windows x64..."
        echo ""
        lime build windows -release
        BUILD_DIR="export/release/windows/bin"
        ;;
    2)
        echo ""
        echo "[BUILD] Starting Debug Build for Windows x64..."
        echo ""
        lime build windows -debug
        BUILD_DIR="export/debug/windows/bin"
        ;;
    3)
        echo ""
        echo "[BUILD] Starting Release Build for Windows x64 (Low-End Defaults)..."
        echo ""
        lime build windows -release -DLOW_END_DEFAULT
        BUILD_DIR="export/release/windows/bin"
        ;;
    *)
        echo "[ERROR] Invalid choice. Exiting."
        exit 1
        ;;
esac

if [ $? -ne 0 ]; then
    echo ""
    echo "[ERROR] Build failed! Check the error messages above."
    exit 1
fi

echo ""
echo "============================================"
echo "  BUILD SUCCESSFUL!"
echo "============================================"
echo ""

# Find the executable
if [ -f "$BUILD_DIR/UziFunkin.exe" ]; then
    echo "Executable: $BUILD_DIR/UziFunkin.exe"
elif [ -f "$BUILD_DIR/Funkin.exe" ]; then
    echo "Executable: $BUILD_DIR/Funkin.exe"
else
    echo "Executable location: $BUILD_DIR/"
fi

echo ""
echo "Output directory: $BUILD_DIR/"
echo ""
echo "Build complete! You can find your .exe in the output directory."
