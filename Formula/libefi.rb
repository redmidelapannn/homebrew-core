class Libefi < Formula
  desc "Base EFI runtime library"
  homepage "https://github.com/rickmark/gnu-efi"
  url "https://github.com/rickmark/gnu-efi/archive/v1.0.tar.gz"
  sha256 "7eadece64bd593885d2d76bd5e69910ad1b246e98387df915fa15d029bf0ab45"

  bottle do
    cellar :any_skip_relocation
    sha256 "7e292e5c6cac6993dcf05f7e9241b622b673f529dff63db7e852694406c64c3b" => :high_sierra
    sha256 "7e228498a328ec59c786f7b7498e0b6e4074abbe63d5401f2153205597df4923" => :sierra
    sha256 "7b972b4b0ca753bf39d4d5eb5dc9ec5ccdf4d3409eaa37408ff99c0a8e807a3c" => :el_capitan
  end

  depends_on "gcc" => :build

  def install
    system "make"

    include.install Dir["inc/*.h"]

    (include/"protocol").mkdir
    (include/"protocol").install Dir["inc/protocol/*.h"]

    (include/"x86_64").mkdir
    (include/"x86_64").install Dir["inc/x86_64/*.h"]

    lib.install "x86_64/lib/libefi.a"
    lib.install "x86_64/gnuefi/crt0-efi-x86_64.o"
    lib.install "x86_64/gnuefi/libgnuefi.a"
  end

  test do
  end
end
