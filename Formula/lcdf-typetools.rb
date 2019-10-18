class LcdfTypetools < Formula
  desc "Manipulate OpenType and multiple-master fonts"
  homepage "https://www.lcdf.org/type/"
  url "https://www.lcdf.org/type/lcdf-typetools-2.108.tar.gz"
  sha256 "fb09bf45d98fa9ab104687e58d6e8a6727c53937e451603662338a490cbbcb26"

  bottle do
    rebuild 1
    sha256 "a1e61f060d882f4392e49db1cc2ad3be93383f73da9fcc0f8eb50d8806677503" => :catalina
    sha256 "d0381c74919a14d0e3b3187eced249f0099f47a146f9aef075e16d1d4f75168c" => :mojave
    sha256 "ba9866f192b0c72c1a98f070c037fb6490f3f5b0ac2ba119665b267b09572424" => :high_sierra
  end

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--without-kpathsea"
    system "make", "install"
  end

  test do
    font_name = (MacOS.version >= :catalina) ? "Arial\\ Unicode.ttf" : "Arial.ttf"
    assert_include shell_output("#{bin}/otfinfo -p /Library/Fonts/#{font_name}"), "Arial"
  end
end
