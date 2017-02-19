class Argtable < Formula
  desc "ANSI C library for parsing GNU-style command-line options"
  homepage "https://argtable.sourceforge.io"
  url "https://downloads.sourceforge.net/project/argtable/argtable/argtable-2.13/argtable2-13.tar.gz"
  version "2.13"
  sha256 "8f77e8a7ced5301af6e22f47302fdbc3b1ff41f2b83c43c77ae5ca041771ddbf"

  bottle do
    cellar :any
    rebuild 1
    sha256 "687d98b6fb7ec666f73e025e80a3d575b454e1ff6d7774ea74522a4c7a583118" => :sierra
    sha256 "3ec4920e82ffba8c6b1d0f2e41abf637acc2d770406ba33808842d5864746d85" => :el_capitan
    sha256 "3e77ba851e398aafee700a91c2144d180aa86cbe35b9cc66d19e3629ad674933" => :yosemite
  end

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end
end
