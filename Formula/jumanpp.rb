class Jumanpp < Formula
  desc "Japanese Morphological Analyzer based on RNNLM"
  homepage "http://nlp.ist.i.kyoto-u.ac.jp/EN/index.php?JUMAN%2B%2B"
  url "https://lotus.kuee.kyoto-u.ac.jp/nl-resource/jumanpp/jumanpp-1.02.tar.xz"
  sha256 "01fa519cb1b66c9cccc9778900a4048b69b718e190a17e054453ad14c842e690"

  bottle do
    rebuild 1
    sha256 "bdbfa6ed7fe56ba98f2b338da821d98b3d13df25c7c64ddd813b3017da279385" => :high_sierra
    sha256 "34ce45e26698b9a77e1d0628cde4d9632b19b2906b7514ee456922ba19ae2af5" => :sierra
    sha256 "f9b134d6c7f12db812436a850d84ceaa22ca38d22aa7cc74679a2639f65b166f" => :el_capitan
  end

  depends_on "boost-build" => :build
  depends_on "boost"
  depends_on "gperftools"

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    ENV["LANG"] = "C.UTF-8" # prevent "invalid byte sequence in UTF-8" on sierra build
    system bin/"jumanpp", "--version"

    output = <<~EOS
      こんにち こんにち こんにち 名詞 6 時相名詞 10 * 0 * 0 "代表表記:今日/こんにち カテゴリ:時間"
      は は は 助詞 9 副助詞 2 * 0 * 0 NIL
    EOS

    assert_match output, pipe_output(bin/"jumanpp", "echo こんにちは")
  end
end
