class Xmount < Formula
  desc "Convert between multiple input & output disk image types"
  homepage "https://www.pinguin.lu/xmount/"
  url "https://code.pinguin.lu/diffusion/XMOUNT/xmount.git",
      :tag      => "v0.7.6",
      :revision => "d0f67c46632a69ff1b608e90ed2fba8344ab7f3d"
  revision 2

  bottle do
    sha256 "decf743ba1d1e07d72ee64015ddae2b1c5dbac190e4c822f129b838862677fdf" => :mojave
    sha256 "8aa3b50dbbbf7eecadd2fd53b53767e110680c81bcba51b24b3a566ae0b2a24c" => :high_sierra
    sha256 "5f27b27ffee1b45ebc3167aa0081a05866d6303e16d61e3e611e1a02d2396870" => :sierra
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "afflib"
  depends_on "libewf"
  depends_on "openssl"
  depends_on :osxfuse

  def install
    ENV.prepend_path "PKG_CONFIG_PATH", Formula["openssl"].opt_lib/"pkgconfig"

    Dir.chdir "trunk" do
      system "cmake", ".", *std_cmake_args
      system "make", "install"
    end
  end

  test do
    system bin/"xmount", "--version"
  end
end
