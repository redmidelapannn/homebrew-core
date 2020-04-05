class Wsjcpp < Formula
  desc "Yet one... C++ Package Manager"
  homepage "https://github.com/wsjcpp/wsjcpp"
  url "https://github.com/wsjcpp/wsjcpp/archive/v0.1.1.tar.gz"
  sha256 "cf484645f3d857201a4e3302abbfd32bb1a61534cef262a0882902df4d99e58c"
  head "https://github.com/wsjcpp/wsjcpp.git", :branch => "master"

  bottle do
    cellar :any
    sha256 "146139b839d148f1119b9104bb303e97e5e50e5623a14777c103d7bd7364edcf" => :catalina
    sha256 "6b1607b1df5cd799e9b22c5ca00bfa7d002da00be123ad37310f29d6c161998e" => :mojave
    sha256 "b5bd82fdb34ed1aef49ae9334d45b6b1532d6977b2fe1320d6118a79efa3322c" => :high_sierra
  end

  depends_on "cmake"
  depends_on "curl-openssl"
  depends_on "pkg-config"
  depends_on :xcode

  def install
    bin.mkpath
    system "cmake", "-DCMAKE_INSTALL_PREFIX:PATH=#{prefix}", "."
    system "make"
    bin.install "wsjcpp"
    # system "cp", "./wsjcpp", "#{bin}/wsjcpp"
    bin.install_symlink
  end

  test do
    system bin/"wsjcpp", "version"
  end
end
