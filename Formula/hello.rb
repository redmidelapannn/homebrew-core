class Hello < Formula
  desc "Program providing model for GNU coding standards and practices"
  homepage "https://www.gnu.org/software/hello/"
  url "https://ftp.gnu.org/gnu/hello/hello-2.10.tar.gz"
  sha256 "31e066137a962676e89f69d1b65382de95a7ef7d914b8cb956f41ea72e0f516b"
  revision 1

  bottle do
    cellar :any_skip_relocation
    sha256 "a049f8ea49c0102df2b67a59d3db3fc150a8183a5ade6b4863af8ad65801c9d2" => :catalina
    sha256 "c3b4eba2f536e1b420abb68b2750ff85f548431826211ab3ee5a1221c65f47c8" => :mojave
    sha256 "28e0d58287135872b94faa01290c65e977142e12c2efe5ab6495c66bffd7170e" => :high_sierra
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
