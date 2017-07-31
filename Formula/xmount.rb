class Xmount < Formula
  desc "Convert between multiple input & output disk image types"
  homepage "https://www.pinguin.lu/xmount/"
  url "https://code.pinguin.lu/diffusion/XMOUNT/xmount.git",
      :tag => "v0.7.5",
      :revision => "432ae6609af67f457e812378e6d2c7a1aacce777"

  bottle do
    rebuild 1
    sha256 "a097e3ffd8db4360f0f1194ca41c4e895ac05325c48122d4b26d5f6cfc9ee3c7" => :sierra
    sha256 "84cf95930ec0ca4c09f7ca2f5f72b6e15397eafd2398f32e78f37a6ec9971945" => :el_capitan
    sha256 "bbbdca7f38bb9768cd7e4e837060091babbd9c6330708fd2c8696e7d49b5f0e3" => :yosemite
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
