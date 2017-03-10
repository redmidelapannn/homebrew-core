class Quilt < Formula
  desc "Work with series of patches"
  homepage "https://savannah.nongnu.org/projects/quilt"
  url "https://download.savannah.gnu.org/releases/quilt/quilt-0.65.tar.gz"
  sha256 "f6cbc788e5cbbb381a3c6eab5b9efce67c776a8662a7795c7432fd27aa096819"

  head "https://git.savannah.gnu.org/git/quilt.git"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "b59b21d68982c1e5b6f18ad6fd96e2ed10244d8197579b16fa87548e32f432c2" => :sierra
    sha256 "b59b21d68982c1e5b6f18ad6fd96e2ed10244d8197579b16fa87548e32f432c2" => :el_capitan
    sha256 "b59b21d68982c1e5b6f18ad6fd96e2ed10244d8197579b16fa87548e32f432c2" => :yosemite
  end

  depends_on "gnu-sed"
  depends_on "coreutils"

  def install
    system "./configure", "--prefix=#{prefix}",
                          "--with-sed=#{HOMEBREW_PREFIX}/bin/gsed",
                          "--without-getopt"
    system "make"
    system "make", "install", "emacsdir=#{elisp}"
  end

  test do
    (testpath/"patches").mkpath
    (testpath/"test.txt").write "Hello, World!"
    system bin/"quilt", "new", "test.patch"
    system bin/"quilt", "add", "test.txt"
    rm "test.txt"
    (testpath/"test.txt").write "Hi!"
    system bin/"quilt", "refresh"
    assert_match(/-Hello, World!/, File.read("patches/test.patch"))
    assert_match(/\+Hi!/, File.read("patches/test.patch"))
  end
end
