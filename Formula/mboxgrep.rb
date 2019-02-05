class Mboxgrep < Formula
  desc "Scan a mailbox for messages matching a regular expression"
  homepage "https://datatipp.se/mboxgrep/"
  url "https://downloads.sourceforge.net/project/mboxgrep/mboxgrep/0.7.9/mboxgrep-0.7.9.tar.gz"
  sha256 "78d375a05c3520fad4bca88509d4da0dbe9fba31f36790bd20880e212acd99d7"

  bottle do
    cellar :any
    rebuild 1
    sha256 "54968a34daff4c8e0ab23051a51f464d6d9836cb55ab6020778ae7e8fe398780" => :mojave
    sha256 "4790da274e8f711f2a1416772e0b095dbd6e7d18ca44293cf2c9e4b7515fe57c" => :high_sierra
    sha256 "6e39c8a3d6830da568cd98b67ffd10b64c19291f4198fddab88deaccc729397d" => :sierra
  end

  depends_on "pcre"

  def install
    system "./configure", "--prefix=#{prefix}",
                          "--mandir=#{man}",
                          "--infodir=#{info}"
    system "make"
    system "make", "install"
  end

  test do
    system "#{bin}/mboxgrep", "--version"
  end
end
