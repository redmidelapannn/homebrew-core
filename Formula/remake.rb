class Remake < Formula
  desc "GNU Make with improved error handling, tracing, and a debugger"
  homepage "http://bashdb.sourceforge.net/remake/"
  url "https://downloads.sourceforge.net/project/bashdb/remake/4.1%2Bdbg-1.1/remake-4.1%2Bdbg1.1.tar.bz2"
  version "4.1-1.1"
  sha256 "42eb79a8418e327255341a55ccbdf358eed42c4e15ffb39052c1627de83521fe"

  bottle do
    sha256 "6be98927b7043f275c945e57feec44a7ae7d6b7420e2925b2243a9f92673ee68" => :el_capitan
    sha256 "521c4370d42f1ceca81eb9b665a8886162f3c1ee7497ec0a66a9edc15c183502" => :yosemite
    sha256 "260d1ac2aac0f356a2548152d70a0cc4c68817fdc5f59fb505454aca7076a236" => :mavericks
    sha256 "685c98bcbdc8a9c4586802c9d73b895c0ff0a91df2ae3ee78dab57d7cfdba68e" => :mountain_lion
  end

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"Makefile").write <<-EOS.undent
      all:
      \techo "Nothing here, move along"
    EOS
    system bin/"remake", "-x"
  end
end
