class VulkanLoader < Formula
  desc "Vulkan Loader"
  homepage "https://github.com/KhronosGroup/Vulkan-Loader"
  url "https://github.com/KhronosGroup/Vulkan-Loader/archive/v1.1.107.tar.gz"
  sha256 "4a20b7887612999d0190c7c405cde84d1e5367984755b6605359addc38c28f1f"

  bottle do
    cellar :any
    sha256 "363e786721dbadd3d53549ae50698d5064f0d833d4a1d008de793abca1c2287d" => :mojave
    sha256 "62f99c80d91c52e82aaa67dec3f00b654adf570b00b0444bd9be1340ae83bdd0" => :high_sierra
    sha256 "b3133477f0718a5e1de731f69d0065a699120a16e27a984067ee4f29c8756808" => :sierra
  end

  depends_on "cmake" => :build
  depends_on "python" => :build
  depends_on "vulkan-headers"

  def install
    headers_dir = Formula["vulkan-headers"].prefix
    system "cmake", ".", "-DVULKAN_HEADERS_INSTALL_DIR=#{headers_dir}", *std_cmake_args
    system "make", "install"
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include <vulkan/vulkan.h>
      int main(void) {
        VkInstanceCreateInfo instanceCreateInfo = {
          VK_STRUCTURE_TYPE_INSTANCE_CREATE_INFO, NULL,
          0, NULL,
          0, NULL,
          0, NULL,
        };
        VkInstance inst;
        vkCreateInstance(&instanceCreateInfo, NULL, &inst);
        // result may be VK_ERROR_INCOMPATIBLE_DRIVER
        return 0;
      }
    EOS
    system ENV.cc, "-o", "test", "test.cpp", "-I#{include}", "-I#{libexec/"include"}", "-L#{lib}", "-lvulkan"
    system "./test"
  end
end
