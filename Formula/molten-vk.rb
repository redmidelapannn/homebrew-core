class MoltenVk < Formula
  desc "Implementation of the Vulkan graphics and compute API on top of Metal"
  homepage "https://github.com/KhronosGroup/MoltenVK"
  url "https://github.com/KhronosGroup/MoltenVK/archive/v1.0.23.tar.gz"
  sha256 "b66bd16dc6b3e7410fea5b4f50e7a3700bdcf7c8b55be09013a70de2f90d82ec"

  depends_on "cmake" => :build
  # Requires IOSurface/IOSurfaceRef.h.
  depends_on :macos => :sierra

  # MoltenVK depends on very specific revisions of its dependencies.
  # For each resource the path to the file describing the expected
  # revision is listed.
  resource "cereal" do
    # ExternalRevisions/cereal_repo_revision
    url "https://github.com/USCiLab/cereal.git",
        :revision => "51cbda5f30e56c801c07fe3d3aba5d7fb9e6cca4"
  end

  resource "glslang" do
    # ExternalRevisions/glslang_repo_revision
    url "https://github.com/KhronosGroup/glslang.git",
        :revision => "91ac4290bcf2cb930b4fb0981f09c00c0b6797e1"
  end

  resource "spirv-cross" do
    # ExternalRevisions/SPIRV-Cross_repo_revision
    url "https://github.com/KhronosGroup/SPIRV-Cross.git",
        :revision => "c9210427b9ab547d41f1af804dedae581b382965"
  end

  resource "vulkan-headers" do
    # ExternalRevisions/Vulkan-Headers_repo_revision
    url "https://github.com/KhronosGroup/Vulkan-Headers.git",
        :revision => "2fd5a24ec4a6df303b2155b3f85b6b8c1d56f6c0"
  end

  resource "vulkan-tools" do
    # ExternalRevisions/Vulkan-Tools_repo_revision
    url "https://github.com/KhronosGroup/Vulkan-Tools.git",
        :revision => "f2c941819838c349fe0cc8eb2dddac294fe012e9"
  end

  resource "spirv-tools" do
    # External/glslang/known_good.json
    url "https://github.com/KhronosGroup/SPIRV-Tools.git",
        :revision => "9bfe0eb25e3dfdf4f3fd86ab6c0cda009c9bd661"
  end

  resource "spirv-headers" do
    # External/glslang/known_good.json
    url "https://github.com/KhronosGroup/SPIRV-Headers.git",
        :revision => "d5b2e1255f706ce1f88812217e9a554f299848af"
  end

  def install
    (buildpath/"External/cereal").install resource("cereal")
    (buildpath/"External/glslang").install resource("glslang")
    (buildpath/"External/glslang/External/spirv-tools").install resource("spirv-tools")
    (buildpath/"External/glslang/External/spirv-tools/external/SPIRV-Headers").install resource("spirv-headers")
    (buildpath/"External/SPIRV-Cross").install resource("spirv-cross")
    (buildpath/"External/Vulkan-Headers").install resource("vulkan-headers")
    (buildpath/"External/Vulkan-Tools").install resource("vulkan-tools")

    cd "External/Vulkan-Headers" do
      system "cmake", ".", *std_cmake_args
      system "make", "install"
    end

    mkdir "External/glslang/build" do
      # Required due to files being generated during build.
      system "cmake", "..", *std_cmake_args
      system "make", "-C", "External/spirv-tools/source"
    end

    xcodebuild "-project", "MoltenVKPackaging.xcodeproj",
               "-scheme", "MoltenVK Package (Release) (macOS only)",
               "build"

    frameworks.install "Package/Release/MoltenVK/macOS/MoltenVK.framework"
    lib.install "Package/Release/MoltenVK/macOS/libMoltenVK.dylib"
    frameworks.install "Package/Release/MoltenVKShaderConverter/MoltenVKGLSLToSPIRVConverter/macOS/MoltenVKGLSLToSPIRVConverter.framework"
    frameworks.install "Package/Release/MoltenVKShaderConverter/MoltenVKSPIRVToMSLConverter/macOS/MoltenVKSPIRVToMSLConverter.framework"
    bin.install "Package/Release/MoltenVKShaderConverter/Tools/MoltenVKShaderConverter"
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include <vulkan/vulkan.h>

      int main(void)
      {
        const char *extensionNames[] = { "VK_KHR_surface" };

        VkInstanceCreateInfo instanceCreateInfo = {
          VK_STRUCTURE_TYPE_INSTANCE_CREATE_INFO, NULL,
          0, NULL,
          0, NULL,
          1, extensionNames,
        };

        VkInstance inst;
        vkCreateInstance(&instanceCreateInfo, NULL, &inst);

        return 0;
      }
    EOS
    system ENV.cc, "-o", "test", "test.cpp", "-L#{lib}", "-lMoltenVK"
    system "./test"
  end
end
