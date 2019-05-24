class Sdb < Formula
  desc "Ondisk/memory hashtable based on CDB"
  homepage "https://github.com/radare/sdb"
  url "https://github.com/radare/sdb/archive/1.4.0.tar.gz"
  sha256 "958bd2283392d9dabb01e9417618d0163b76aa1a9bffd30360d97ed7e2425e0d"
  head "https://github.com/radare/sdb.git"

  bottle do
    cellar :any
    sha256 "863aea9679becb97cc5d9f64bbb714a226149db7f5a7b09143ad05517f9aed72" => :mojave
    sha256 "c25fed7f1923890c98ed5da6adb178feff0208d55f7c51bff55a1552d61339cb" => :high_sierra
    sha256 "c0be2ac314a7655b4b0b0f2928c1bacd3b568948dda7682386dee9c797d0a401" => :sierra
  end

  depends_on "pkg-config" => :build
  depends_on "vala" => :build
  depends_on "glib"

  def install
    system "make"
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    system bin/"sdb", testpath/"d", "hello=world"
    assert_equal "world", shell_output("#{bin}/sdb #{testpath}/d hello").strip
  end
end
