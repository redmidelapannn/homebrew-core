class Stow < Formula
  desc "Organize software neatly under a single directory tree (e.g. /usr/local)"
  homepage "https://www.gnu.org/software/stow/"
  url "https://ftpmirror.gnu.org/stow/stow-2.2.2.tar.gz"
  mirror "https://ftp.gnu.org/gnu/stow/stow-2.2.2.tar.gz"
  sha256 "e2f77649301b215b9adbc2f074523bedebad366812690b9dc94457af5cf273df"

  bottle do
    cellar :any_skip_relocation
    revision 1
    sha256 "facd50b63e7b0b21ea46cce490b2d72b281339e4cd725a2dd41136a9ccbb783b" => :el_capitan
    sha256 "bdd46f8dbbc3fa50c0029b2e6925ced0cded08b56a329f142c65a8ccedceb649" => :yosemite
    sha256 "7f654ad8edfdf5913bf7308ce14daeae8de5f1359c75b7789a8b4decaf76ee34" => :mavericks
  end

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"test").mkpath
    system "#{bin}/stow", "-nvS", "test"
  end
end
