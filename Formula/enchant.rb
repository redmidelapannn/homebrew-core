class Enchant < Formula
  desc "Spellchecker wrapping library"
  homepage "https://abiword.github.io/enchant/"
  url "https://github.com/AbiWord/enchant/releases/download/v2.2.1/enchant-2.2.1.tar.gz"
  sha256 "97f2e617b34c66a645b9cfebe33700456c31ca2f4677eb827b364c0d9a7f4e5e"

  bottle do
    rebuild 1
    sha256 "24e76accb2fb5f0a0f3967b5753181f897bd12c48f48f7eadd1cc4f521ff2b67" => :high_sierra
    sha256 "639aea9da20e38e7cf917e293689488b5b80842beeaf7e1a3ddf89a4c5e1b481" => :sierra
    sha256 "4646ecd867253d07e02ee6dc0d44726966c726756d0fe2bc77ba832005afa74b" => :el_capitan
  end

  depends_on "pkg-config" => :build
  depends_on "python" => :optional
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
