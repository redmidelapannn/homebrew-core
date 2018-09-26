class Pktanon < Formula
  desc "Packet trace anonymization"
  homepage "https://www.tm.uka.de/software/pktanon/index.html"
  url "https://www.tm.uka.de/software/pktanon/download/pktanon-1.4.0-dev.tar.gz"
  sha256 "db3f437bcb8ddb40323ddef7a9de25a465c5f6b4cce078202060f661d4b97ba3"
  revision 2

  bottle do
    cellar :any
    sha256 "dd4eeadb795a5bb311caae0797ad54db035ac8866cbc5cfc8fbfbad1f7a0a548" => :mojave
    sha256 "398a0df8b93a1237f879bdf0c58122266fdf4363723baba8f17edbd09c4c67a7" => :high_sierra
    sha256 "f15ae98bec9e45adfa501a3a84fda681406f64e77296702cf58103d974c23121" => :sierra
  end

  depends_on "boost"
  depends_on "xerces-c"

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
