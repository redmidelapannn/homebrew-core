class Enchant < Formula
  desc "Spellchecker wrapping library"
  homepage "https://abiword.github.io/enchant/"
  url "https://github.com/AbiWord/enchant/releases/download/v2.2.3/enchant-2.2.3.tar.gz"
  sha256 "abd8e915675cff54c0d4da5029d95c528362266557c61c7149d53fa069b8076d"

  bottle do
    rebuild 1
    sha256 "ccb2ab7d364d5a641d62cffe3798679bedfc203c200adf9d247fdc414324bd3c" => :high_sierra
    sha256 "40a1bb5261aadf988110d7b92862be810ddf78fb740ee1e57e5bae05f486ff73" => :sierra
    sha256 "d32d1e05447bc26227a45436edfaddb114acb45afec6c4aa4b1e94efca53deb9" => :el_capitan
  end

  depends_on "pkg-config" => :build
  depends_on "python@2" => :optional
  depends_on "glib"
  depends_on "aspell"

  # https://pythonhosted.org/pyenchant/
  resource "pyenchant" do
    url "https://files.pythonhosted.org/packages/9e/54/04d88a59efa33fefb88133ceb638cdf754319030c28aadc5a379d82140ed/pyenchant-2.0.0.tar.gz"
    sha256 "fc31cda72ace001da8fe5d42f11c26e514a91fa8c70468739216ddd8de64e2a0"
  end

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--enable-relocatable"

    system "make", "install"

    ln_s "enchant-2.pc", lib/"pkgconfig/enchant.pc"

    if build.with? "python"
      resource("pyenchant").stage do
        # Don't download and install distribute now
        inreplace "setup.py", "ez_setup.use_setuptools()", ""
        ENV["PYENCHANT_LIBRARY_PATH"] = lib/"libenchant-2.dylib"
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
    assert_equal enchant_result, shell_output("#{bin}/enchant-2 -l #{file}").chomp
  end
end
