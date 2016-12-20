class Vcdimager < Formula
  desc "(Super) video CD authoring solution"
  homepage "https://www.gnu.org/software/vcdimager/"
  url "https://ftpmirror.gnu.org/vcdimager/vcdimager-0.7.24.tar.gz"
  mirror "https://ftp.gnu.org/gnu/vcdimager/vcdimager-0.7.24.tar.gz"
  sha256 "075d7a67353ff3004745da781435698b6bc4a053838d0d4a3ce0516d7d974694"
  revision 1

  bottle do
    cellar :any
    rebuild 1
    sha256 "3b0714793a9c6bbde9ad6c9d3c9d76be62cdb3f388607ce1705c25aeba8dd789" => :sierra
    sha256 "fecca017dab5a2268f5715c1067659f6256c7de0dd4d6fb00dfbddc17caddc47" => :el_capitan
    sha256 "93c34df77a5fc3d95d96969d8458cc995924c3945bbb3bf2e5ff9f6840576fbf" => :yosemite
  end

  depends_on "pkg-config" => :build
  depends_on "libcdio"
  depends_on "popt"

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}", "--mandir=#{man}"
    system "make", "install"
  end

  test do
    system bin/"vcdimager", "--help"
  end
end
