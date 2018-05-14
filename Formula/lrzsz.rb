class Lrzsz < Formula
  desc "Tools for zmodem/xmodem/ymodem file transfer"
  homepage "https://www.ohse.de/uwe/software/lrzsz.html"
  url "https://www.ohse.de/uwe/releases/lrzsz-0.12.20.tar.gz"
  mirror "https://dl.bintray.com/homebrew/mirror/lrzsz-0.12.20.tar.gz"
  sha256 "c28b36b14bddb014d9e9c97c52459852f97bd405f89113f30bee45ed92728ff1"

  bottle do
    rebuild 1
    sha256 "a606886e5eab00cfae483e2788f358bbec013e7446ddd32c0a023c8eaeb1cf49" => :high_sierra
    sha256 "f1a4481fa9f4573693ff1f9a85e3ba3e2753e91db90041b47c28f03b614bb063" => :sierra
    sha256 "35f386a323e67cc7f5ceafea09bdfca8c48b9c6fde5f1564a5ac7a2a2aa04001" => :el_capitan
  end

  def install
    system "./configure", "--prefix=#{prefix}", "--mandir=#{man}"
    system "make"

    # there's a bug in lrzsz when using custom --prefix
    # must install the binaries manually first
    bin.install "src/lrz", "src/lsz"

    system "make", "install"
    bin.install_symlink "lrz" => "rz", "lsz" => "sz"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/lrb --help 2>&1")
  end
end
