class LcdfTypetools < Formula
  desc "Manipulate OpenType and multiple-master fonts"
  homepage "https://www.lcdf.org/type/"
  url "https://www.lcdf.org/type/lcdf-typetools-2.104.tar.gz"
  sha256 "d7985458ead0850cb9549ff1d619ffc18da5d7be892be5e1fce6048d510f0fff"

  bottle do
    rebuild 1
    sha256 "54303680a4c373b138cbab2ea8bcc9532b7273612b5b80123b51bb5afbdb34e2" => :el_capitan
    sha256 "d44d736145de0d1730070a9401e4138f0be3ad50a4a70241fde9410f7683aa5e" => :mavericks
  end

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--without-kpathsea"
    system "make", "install"
  end
end
