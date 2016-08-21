class Rfcdiff < Formula
  desc "Compare RFC Internet Draft versions"
  homepage "https://tools.ietf.org/tools/rfcdiff/"
  url "https://tools.ietf.org/tools/rfcdiff/rfcdiff-1.45.tgz"
  sha256 "82e449b7ee887074302b2050e41fc60d4b3bbec8c20e05ce2d7fab81b332771e"

  bottle do
    cellar :any_skip_relocation
    sha256 "8593bb4adb10b4fc08e89033b7878546880990fb419494c84c764ea415349caa" => :el_capitan
    sha256 "7dd93d9a49fad2c8dbd0b62b119bc543c7119802e6cee9c351985aa657aaaf5a" => :yosemite
    sha256 "52feb6a991bad5465640b7fde29eb12bb1c4c0dae1d8ca1066f0e8808a04b7da" => :mavericks
  end

  depends_on "wdiff"
  depends_on "gawk" => :recommended
  depends_on "txt2man" => :build
  depends_on "gnu-sed" => :build

  resource "rfc42" do
    url "https://tools.ietf.org/rfc/rfc42.txt"
    sha256 "ba2c826790cae67eb7b4f4ff0f8fe608f620d29f789969c06abbc8da696c8e35"
  end

  resource "rfc43" do
    url "https://tools.ietf.org/rfc/rfc43.txt"
    sha256 "b6fc6c8e185ef122f3a2b025f9e66a5f4242bdec789d2e467c07bbcfef4deebb"
  end

  def install
    ENV.prepend_path "PATH", "#{Formula["gnu-sed"].opt_libexec}/gnubin"

    # replace hard-coded paths
    inreplace "Makefile.common", "/usr/share/man/man1", man1

    bin.mkpath
    man1.mkpath

    system "make", "-f", "Makefile.common",
                   "tool=rfcdiff",
                   "sources=rfcdiff.pyht",
                   "prefix=#{prefix}",
                   "install"
  end

  test do
    testpath.install resource("rfc42"), resource("rfc43")
    system "#{bin}/rfcdiff", "rfc42.txt", "rfc43.txt"
  end
end
