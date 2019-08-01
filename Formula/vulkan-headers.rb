class VulkanHeaders < Formula
  desc "Vulkan Header files and API registry"
  homepage "https://github.com/KhronosGroup/Vulkan-Headers"
  url "https://github.com/KhronosGroup/Vulkan-Headers/archive/v1.1.117.tar.gz"
  sha256 "fae9fe671de4c7d1b3445fa1516215f57869207394cfa20f8162f2bf8bd8ab6d"

  bottle do
    cellar :any_skip_relocation
    sha256 "659b081c02ab41a7aa86f34af849c9201fc180131c18fa0d5dcf955ae4de035d" => :mojave
    sha256 "659b081c02ab41a7aa86f34af849c9201fc180131c18fa0d5dcf955ae4de035d" => :high_sierra
    sha256 "3a5206e0bece256e38512cee4070ba0fe1cc307812d5fcf852773be52dd983c0" => :sierra
  end

  depends_on "cmake" => :build

  def install
    system "cmake", ".", *std_cmake_args
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <stdio.h>
      #include <vulkan/vulkan_core.h>

      int main() {
        printf("vulkan version %d", VK_VERSION_1_0);
        return 0;
      }
    EOS
    system ENV.cc, "test.c", "-o", "test"
    system "./test"
  end
end
