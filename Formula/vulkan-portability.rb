class VulkanPortability < Formula
  desc "Header files for the Vulkan Portability extension"
  homepage "https://github.com/KhronosGroup/Vulkan-Portability"
  url "https://github.com/KhronosGroup/Vulkan-Portability/archive/v0.2.tar.gz"
  sha256 "2508a2dd0e111cb7d4636a54d454e7172ab33c48cba0e6e86e6fdb7cf48becb5"

  bottle do
    cellar :any_skip_relocation
    sha256 "aa19c491dcca62db6bd6bd722f4e0d13b45f2aa88607d7ad4406beebdecd2d23" => :mojave
    sha256 "aa19c491dcca62db6bd6bd722f4e0d13b45f2aa88607d7ad4406beebdecd2d23" => :high_sierra
    sha256 "59b4732986e80478fee87789395d290b6df8ca1f228dde1e6db133b2babb68af" => :sierra
  end

  depends_on "vulkan-headers" => :test

  def install
    include.install "include"
    (pkgshare/"sample").install Dir["src/*"]
    (pkgshare/"doc").install Dir["doc/specs/*"]
  end

  test do
    cp_r "#{pkgshare}/sample/", testpath.to_s
    cd "sample"
    inreplace "Makefile", "../include", include.to_s
    inreplace "Makefile", "/usr/include", Formula["vulkan-headers"].include.to_s
  end
end
