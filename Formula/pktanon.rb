class Pktanon < Formula
  desc "Packet trace anonymization"
  homepage "https://www.tm.uka.de/software/pktanon/index.html"
  url "https://www.tm.uka.de/software/pktanon/download/pktanon-1.4.0-dev.tar.gz"
  sha256 "db3f437bcb8ddb40323ddef7a9de25a465c5f6b4cce078202060f661d4b97ba3"
  revision 1

  bottle do
    cellar :any
    rebuild 1
    sha256 "b8b2df71d7f6778714dec287dc2513fdd75bb6b1f58671b8dee5481dd6e70d26" => :high_sierra
    sha256 "a6e6b8400b4a8a777570f852bfa8c6ee0acde0d1509a32a4e09e676a072ae7b3" => :sierra
    sha256 "c9207f2dfad4782f8524b64802ce5e474316386b47d9bbb39a9b935bdcc852b4" => :el_capitan
  end

  depends_on "xerces-c"
  depends_on "boost"

  def install
    # fix compile failure caused by undefined function 'sleep'.
    inreplace "src/Timer.cpp", %Q(#include "Timer.h"\r\n),
      %Q(#include "Timer.h"\r\n#include "unistd.h"\r\n)

    # include the boost system library to resolve compilation errors
    ENV["LIBS"] = "-lboost_system-mt"

    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "#{bin}/pktanon", "--version"
  end
end
