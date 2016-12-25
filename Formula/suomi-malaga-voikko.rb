class SuomiMalagaVoikko < Formula
  desc "Linguistic software and data for Finnish"
  homepage "http://voikko.puimula.org/"
  url "http://www.puimula.org/voikko-sources/suomi-malaga/suomi-malaga-1.19.tar.gz"
  sha256 "5c4c15dd87a82e9b8ab74f9c570c6db011e3fd824db4de47ffeb71c4261451cc"

  head "https://github.com/voikko/corevoikko.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "8df8a840b30c28ae1628142944da2297ba5d6ab98bf26deeb2d556e7953041a7" => :sierra
    sha256 "6856ce6fab78f195362ebd7ebd51eb630528407856b031550df616b09d641f81" => :el_capitan
    sha256 "58e0c9c5f3577c7dc3b529a5547bd5c396164de856c9f14f91dd899d9e28e6d3" => :yosemite
    sha256 "f6517988b130926540d936cbf3b415b1ff2f5803d72d88c0672225e4aa410c46" => :mavericks
    sha256 "d4a98cf1328fc05aad4aa111b718df03c0b66a1f28da980f87a9a3c5231fa037" => :mountain_lion
  end

  depends_on "malaga"

  def install
    Dir.chdir "suomimalaga" if build.head?
    system "make", "voikko"
    system "make", "voikko-install", "DESTDIR=#{lib}/voikko"
  end
end
