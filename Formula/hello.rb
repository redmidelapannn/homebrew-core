class Hello < Formula
  desc "Program providing model for GNU coding standards and practices"
  homepage "https://www.gnu.org/software/hello/"
  url "https://ftp.gnu.org/gnu/hello/hello-2.10.tar.gz"
  sha256 "31e066137a962676e89f69d1b65382de95a7ef7d914b8cb956f41ea72e0f516b"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "2e8bf305797142dc82a78bed6cd9f5eafeb716f1cc9a377e833aa363f3254eab" => :catalina
    sha256 "e5ba0ad971b16bcb44628827cd41a53c983ae79f4bcd302b8f855a525e1f3a62" => :mojave
    sha256 "f4b168ee97c16ce026d3691ba227da04fdb77e8c601759b6341efc035a60dbe3" => :high_sierra
  end

  conflicts_with "perkeep", :because => "both install `hello` binaries"

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end
  test do
    assert_equal "brew", shell_output("#{bin}/hello --greeting=brew").chomp
  end
end
