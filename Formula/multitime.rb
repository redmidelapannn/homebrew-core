class Multitime < Formula
  desc "Time command execution over multiple executions"
  homepage "https://tratt.net/laurie/src/multitime/"
  url "https://tratt.net/laurie/src/multitime/releases/multitime-1.4.tar.gz"
  sha256 "dd85c431c022d0b992f3a8816a1a3dfb414454a229c0ec22514761bf72d3ce47"

  bottle do
    cellar :any_skip_relocation
    sha256 "9ab9336ac73a7b31b87c7f98a35e8b12c9e9eda535bedcd8381001ecfd71279a" => :mojave
    sha256 "de94d068012f2c6e039c282f0731de909383dea89c19f101edd8639d42ca1725" => :high_sierra
    sha256 "624e71a6d124bd31b2935b91a6350685227309715a2d7b102321430e7321dd94" => :sierra
  end

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "#{bin}/multitime", "true"
  end
end
