class Libxmi < Formula
  desc "C/C++ function library for rasterizing 2D vector graphics"
  homepage "https://www.gnu.org/software/libxmi/"
  url "https://ftpmirror.gnu.org/libxmi/libxmi-1.2.tar.gz"
  mirror "https://ftp.gnu.org/gnu/libxmi/libxmi-1.2.tar.gz"
  sha256 "9d56af6d6c41468ca658eb6c4ba33ff7967a388b606dc503cd68d024e08ca40d"

  bottle do
    cellar :any_skip_relocation
    rebuild 3
    sha256 "16fbae05d6de797366b6ad0ead305aab0dc9444ce388862507cbfeb10b80fb5b" => :sierra
    sha256 "85dbae0fdd29b14acb77e71e00b2246eaab3053fdef21fa186bcf51705114feb" => :el_capitan
    sha256 "0eff8bf6e17483d568fd98d08a8249f24477dda8ffc2bf8e5126ea2fd85f1054" => :yosemite
  end

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}", "--infodir=#{info}"
    system "make", "install"
  end
end
