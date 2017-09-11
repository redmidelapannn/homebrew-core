class Hello < Formula
  desc "Program providing model for GNU coding standards and practices"
  homepage "https://www.gnu.org/software/hello/"
  url "https://ftp.gnu.org/gnu/hello/hello-2.10.tar.gz"
  sha256 "31e066137a962676e89f69d1b65382de95a7ef7d914b8cb956f41ea72e0f516b"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "5978b53d1e833ef55d8d3a1ca5ff2fc7a386559ea2cb4383cc7ac094515c898f" => :sierra
    sha256 "9170809a8d4be0c8811d91a5c25cbc8415f4766d98fb53405254c7ee8e3ba339" => :el_capitan
  end

  conflicts_with "camlistore", :because => "both install `hello` binaries"

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
