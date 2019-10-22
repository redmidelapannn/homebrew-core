class Renameutils < Formula
  desc "Tools for file renaming"
  homepage "https://www.nongnu.org/renameutils/"
  url "https://download.savannah.gnu.org/releases/renameutils/renameutils-0.12.0.tar.gz"
  sha256 "cbd2f002027ccf5a923135c3f529c6d17fabbca7d85506a394ca37694a9eb4a3"
  revision 2

  bottle do
    cellar :any
    rebuild 1
    sha256 "079db2e7ea82e06bc63b80b4fde81aa96d1a5535dd372517e36471d481dd4a23" => :catalina
    sha256 "b421c481996bfdd22da2a3de6ef33a48505b3468f7f94c11d98880a3d448eca3" => :mojave
    sha256 "a7c21f3a61c0c98152acf84f9e8fab37625a8137f436391b62a0c48dbe07d9e4" => :high_sierra
  end

  depends_on "coreutils"
  depends_on "readline" # Use instead of system libedit

  conflicts_with "ipmiutil", :because => "both install `icmd` binaries"

  # Use the GNU versions of certain system utilities. See:
  # https://trac.macports.org/ticket/24525
  # Patches rewritten at version 0.12.0 to handle file changes.
  # The fourth patch is new and fixes a Makefile syntax error that causes
  # make install to fail.  Reported upstream via email and fixed in HEAD.
  # Remove patch #4 at version > 0.12.0.  The first three should persist.
  patch do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/85fa66a9/renameutils/0.12.0.patch"
    sha256 "ed964edbaf388db40a787ffd5ca34d525b24c23d3589c68dc9aedd8b45160cd9"
  end

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--with-packager=Homebrew"
    system "make"
    ENV.deparallelize # parallel install fails
    system "make", "install"
  end

  test do
    (testpath/"test.txt").write "Hello World!"
    pipe_output("#{bin}/icp test.txt", ".2\n")
    assert_equal File.read("test.txt"), File.read("test.txt.2")
  end
end
