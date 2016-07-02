class Vcdimager < Formula
  desc "(Super) video CD authoring solution"
  homepage "https://www.gnu.org/software/vcdimager/"
  url "https://ftpmirror.gnu.org/vcdimager/vcdimager-0.7.24.tar.gz"
  mirror "https://ftp.gnu.org/gnu/vcdimager/vcdimager-0.7.24.tar.gz"
  sha256 "075d7a67353ff3004745da781435698b6bc4a053838d0d4a3ce0516d7d974694"

  bottle do
    cellar :any
    revision 1
    sha256 "e05b9f346a48ef75614a5bd3e118753dec4302b58f5963efab0f65a455c6ed7a" => :el_capitan
    sha256 "64e1b3e6f10ebf96d64dc56bad12493a8b85131824ff304289fc1327fc720c3b" => :yosemite
    sha256 "c90f773f1060af04e638cd3eafba16f6d8f55bba9b3c12bb09614f050b0cca37" => :mavericks
  end

  depends_on "pkg-config" => :build
  depends_on "libcdio"
  depends_on "popt"

  def install
    ENV.libxml2

    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}", "--mandir=#{man}"
    system "make", "install"
  end

  test do
    system bin/"vcdimager", "--help"
  end
end
