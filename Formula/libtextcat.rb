class Libtextcat < Formula
  desc "N-gram-based text categorization library"
  homepage "http://software.wise-guys.nl/libtextcat/"
  url "http://pkgs.fedoraproject.org/repo/pkgs/libtextcat/libtextcat-2.2.tar.gz/128cfc86ed5953e57fe0f5ae98b62c2e/libtextcat-2.2.tar.gz"
  sha256 "5677badffc48a8d332e345ea4fe225e3577f53fc95deeec8306000b256829655"

  bottle do
    cellar :any
    rebuild 2
    sha256 "9c37ff4533784a7d15329f060f81f77c09f51f14555ea60ba46af6aa20260ba6" => :sierra
    sha256 "6eec0da7467132d189faa70578e340c187adfaa5847ec61c319be351b6a19d04" => :el_capitan
    sha256 "1efb5e055e8a602b456afa5d9d431614a555415ee2d53d28b94e00634d792664" => :yosemite
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
