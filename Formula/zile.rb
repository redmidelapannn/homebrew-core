class Zile < Formula
  desc "Zile Is Lossy Emacs (ZILE)"
  homepage "https://www.gnu.org/software/zile/"
  url "https://ftpmirror.gnu.org/zile/zile-2.4.11.tar.gz"
  mirror "https://ftp.gnu.org/gnu/zile/zile-2.4.11.tar.gz"
  sha256 "1fd27bbddc61491b1fbb29a345d0d344734aa9e80cfa07b02892eedf831fa9cc"

  bottle do
    revision 2
    sha256 "77cb19ff4f69361ec71a413d19e9b33312a1f663d885b9ab06db27d2934c4b78" => :el_capitan
    sha256 "4f590e9a4f2bd99cc244be1f7ed9aa76f701aa29f83a768069a75ff236410043" => :yosemite
    sha256 "acfa3f5912355e51ebc0e3420ff775783f275374b6d23fa0b440222264220f22" => :mavericks
  end

  # https://github.com/mistydemeo/tigerbrew/issues/215
  fails_with :gcc_4_0 do
    cause "src/funcs.c:1128: error: #pragma GCC diagnostic not allowed inside functions"
  end

  fails_with :gcc do
    cause "src/funcs.c:1128: error: #pragma GCC diagnostic not allowed inside functions"
  end

  fails_with :llvm do
    cause "src/funcs.c:1128: error: #pragma GCC diagnostic not allowed inside functions"
  end

  depends_on "pkg-config" => :build
  depends_on "help2man" => :build
  depends_on "bdw-gc"

  def install
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make", "install"
  end
end
