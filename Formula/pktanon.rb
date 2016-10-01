class Pktanon < Formula
  desc "Packet trace anonymization"
  homepage "https://www.tm.uka.de/software/pktanon/index.html"
  url "https://www.tm.uka.de/software/pktanon/download/pktanon-1.4.0-dev.tar.gz"
  sha256 "db3f437bcb8ddb40323ddef7a9de25a465c5f6b4cce078202060f661d4b97ba3"
  revision 1

  bottle do
    cellar :any
    sha256 "60a42c05b6a1a6becd36589642819b06c0d757f14effb2490239dfcfe53ceb76" => :sierra
    sha256 "fb031e4991656cd6d2df40df7f7a03a6a87c8c758df335120e65cbc225459079" => :el_capitan
    sha256 "a47ed6e9914ebad74dcd549c24f11b8095466a33115ebd819c3ca4d7024f0347" => :yosemite
  end

  depends_on "xerces-c"
  depends_on "boost@1.61"

  def install
    # fix compile failure caused by undefined function 'sleep'.
    inreplace "src/Timer.cpp", %(#include "Timer.h"\r\n),
      %(#include "Timer.h"\r\n#include "unistd.h"\r\n)

    # include the boost system library to resolve compilation errors
    ENV["LIBS"] = "-lboost_system-mt"

    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make", "install"
  end
end
