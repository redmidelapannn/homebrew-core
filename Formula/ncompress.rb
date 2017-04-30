class Ncompress < Formula
  desc "Fast, simple LZW file compressor"
  homepage "https://github.com/vapier/ncompress"
  url "https://github.com/vapier/ncompress/archive/v4.2.4.4.tar.gz"
  sha256 "2670439935e7639c3a767087da99810e45bc3997d0638b3094396043571e5aec"
  head "https://github.com/vapier/ncompress.git"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "a680afdda38993d23f754c655264dfc99fa9a71c3490f4f505a32a4d685282ce" => :sierra
    sha256 "6cba9f49e71e71505dcfb9d2b2925ecb2f38b6092fd318cdcc1028683fb002cc" => :el_capitan
    sha256 "a3199a233a210544251731f3ec60ea5be88238a971ab249f1fce00d9e4eb831e" => :yosemite
  end

  keg_only :provided_by_osx

  def install
    system "make", "install", "BINDIR=#{bin}", "MANDIR=#{man1}"
  end

  test do
    Pathname.new("hello").write "Hello, world!"
    system "#{bin}/compress", "-f", "hello"
    assert_match "Hello, world!", shell_output("#{bin}/compress -cd hello.Z")
  end
end
