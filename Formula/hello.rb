class Hello < Formula
  desc "Program providing model for GNU coding standards and practices"
  homepage "https://www.gnu.org/software/hello/"
  url "https://ftp.gnu.org/gnu/hello/hello-2.10.tar.gz"
  sha256 "31e066137a962676e89f69d1b65382de95a7ef7d914b8cb956f41ea72e0f516b"
  revision 1

  bottle do
    cellar :any_skip_relocation
    sha256 "36ff4c0457d45865836fcad2a7e87a494702088ace95b3ed71dac82670b16a30" => :catalina
    sha256 "0da5fa49812b7ff4bc02dfc7ee71ecea0192beb1bc3545648a6a8856e01fed79" => :mojave
    sha256 "6e34af71ed8b45943aee47505a3ed1143ebad63ede5426702fa794d4a127c3f2" => :high_sierra
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
