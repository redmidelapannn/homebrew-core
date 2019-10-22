class Hspell < Formula
  desc "Free Hebrew linguistic project"
  homepage "http://hspell.ivrix.org.il/"
  url "http://hspell.ivrix.org.il/hspell-1.4.tar.gz"
  sha256 "7310f5d58740d21d6d215c1179658602ef7da97a816bc1497c8764be97aabea3"

  bottle do
    rebuild 1
    sha256 "97cdb5302fc45bcaac9adb8f1863d9dfd21f141b80d75e02b496bbb7a36ca97f" => :catalina
    sha256 "74cba40a2eebd633781a1716a3fa68c84f913b888e0a81250027151177caa800" => :mojave
    sha256 "e890453a9077621df3ea813623e7b6f89ca0d37ed3692d225d206c51d72ed19c" => :high_sierra
  end

  depends_on "autoconf" => :build

  # hspell was built for linux and compiles a .so shared library, to comply with macOS
  # standards this patch creates a .dylib instead
  patch :p0 do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/85fa66a9/hspell/1.3.patch"
    sha256 "63cc1bc753b1062d1144dcdd959a0a8f712b8872dce89e54ddff2d24f2ca2065"
  end

  def install
    ENV.deparallelize

    # autoconf needs to pick up on the patched configure.in and create a new ./configure
    # script
    system "autoconf"

    system "./configure", "--prefix=#{prefix}",
                          "--enable-shared",
                          "--enable-linginfo"
    system "make", "dolinginfo"
    system "make", "install"
  end

  test do
    File.open("test.txt", "w:ISO8859-8") do |f|
      f.write "שלום"
    end
    system "#{bin}/hspell", "-l", "test.txt"
  end
end
