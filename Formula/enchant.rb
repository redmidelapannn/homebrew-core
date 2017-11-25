class Enchant < Formula
  desc "Spellchecker wrapping library"
  homepage "https://abiword.github.io/enchant/"
  url "https://www.abisource.com/downloads/enchant/1.6.0/enchant-1.6.0.tar.gz"
  sha256 "2fac9e7be7e9424b2c5570d8affe568db39f7572c10ed48d4e13cddf03f7097f"

  bottle do
    rebuild 1
    sha256 "1d6b94b25b3e5f2c1662255c95c342db6eac75bfb8f4100c222bb2af7c37516f" => :high_sierra
    sha256 "9b7199ee42133942213f21202d34186dd54b29d8d5bec5a30caf5655fa6bd131" => :sierra
    sha256 "93985e57434c24837328233653b4e3bd67660f0da8cb581c5e47aa12b6595d91" => :el_capitan
  end

  depends_on "pkg-config" => :build
  depends_on :python => :optional
  depends_on "glib"
  depends_on "aspell"

  # https://pythonhosted.org/pyenchant/
  resource "pyenchant" do
    url "https://files.pythonhosted.org/packages/source/p/pyenchant/pyenchant-1.6.5.tar.gz"
    sha256 "623f332a9fbb70ae6c9c2d0d4e7f7bae5922d36ba0fe34be8e32df32ebbb4f84"
  end

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--disable-ispell",
                          "--disable-myspell"
    system "make", "install"

    if build.with? "python"
      resource("pyenchant").stage do
        # Don't download and install distribute now
        inreplace "setup.py", "distribute_setup.use_setuptools()", ""
        ENV["PYENCHANT_LIBRARY_PATH"] = lib/"libenchant.dylib"
        system "python", "setup.py", "install", "--prefix=#{prefix}",
                              "--single-version-externally-managed",
                              "--record=installed.txt"
      end
    end
  end

  test do
    text = "Teh quikc brwon fox iumpz ovr teh lAzy d0g"
    enchant_result = text.sub("fox ", "").split.join("\n")
    file = "test.txt"
    (testpath/file).write text
    assert_equal enchant_result, shell_output("#{bin}/enchant -l #{file}").chomp
  end
end
