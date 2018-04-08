class Libdnet < Formula
  desc "Portable low-level networking library"
  homepage "https://github.com/dugsong/libdnet"
  url "https://storage.googleapis.com/google-code-archive-downloads/v2/code.google.com/libdnet/libdnet-1.12.tgz"
  sha256 "83b33039787cf99990e977cef7f18a5d5e7aaffc4505548a83d31bd3515eb026"

  bottle do
    cellar :any
    rebuild 3
    sha256 "ad601d92673a36e76e6245a241684e75af1bc117ac46bebfe1f526dea9c4dec2" => :high_sierra
    sha256 "7a6503355caf884f1d4c630f56c151e6fd6ad198ce521ad73e99f19e62b4f7b3" => :sierra
    sha256 "cd18e926e2dd7eb5dfa1679ba49ac26eb00b3d4815de58d6f61ea4805e6cfb4f" => :el_capitan
  end

  option "without-python", "Build without python support"

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "python@2"

  def install
    # autoreconf to get '.dylib' extension on shared lib
    ENV.append_path "ACLOCAL_PATH", "config"
    system "autoreconf", "-ivf"

    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--mandir=#{man}",
                          "--with-python"
    system "make", "install"
  end

  test do
    system "#{bin}/dnet-config", "--version"
  end
end
