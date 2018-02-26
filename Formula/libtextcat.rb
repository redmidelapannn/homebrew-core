class Libtextcat < Formula
  desc "N-gram-based text categorization library"
  homepage "https://software.wise-guys.nl/libtextcat/"
  url "https://software.wise-guys.nl/download/libtextcat-2.2.tar.gz"
  mirror "https://src.fedoraproject.org/repo/pkgs/libtextcat/libtextcat-2.2.tar.gz/128cfc86ed5953e57fe0f5ae98b62c2e/libtextcat-2.2.tar.gz"
  sha256 "5677badffc48a8d332e345ea4fe225e3577f53fc95deeec8306000b256829655"

  bottle do
    cellar :any
    rebuild 2
    sha256 "ade517342a050c00fc69a96ab9bfa2a1221ff8bf41240617cc1da569dd3260c4" => :high_sierra
    sha256 "68b97689d5fa2717f711f80d52dc98b656394e2eba8ae7930db7596d5d3d210f" => :sierra
    sha256 "9f5bb5df407f0075fd0321d010e09c2ae07333682c76832e9a114d90933976b8" => :el_capitan
  end

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
    (include/"libtextcat/").install Dir["src/*.h"]
    share.install "langclass/LM", "langclass/ShortTexts", "langclass/conf.txt"
  end

  test do
    system "#{bin}/createfp < #{prefix}/README"
  end
end
