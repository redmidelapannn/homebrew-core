class Sfk < Formula
  desc "Command-line tools collection"
  homepage "http://stahlworks.com/dev/swiss-file-knife.html"
  url "https://downloads.sourceforge.net/project/swissfileknife/1-swissfileknife/1.9.3.2/sfk-1.9.3.tar.gz"
  version "1.9.3.2"
  sha256 "cabfcbef6f145d4a5d182c9e968158ff37e407174a0cd13cb77dc0564e1dba78"

  bottle do
    cellar :any_skip_relocation
    sha256 "004cc739484e6b0d1ed83b178a9a3f72976c5b5b57a721e66148e821423abb14" => :sierra
  end

  def install
    ENV.libstdcxx

    system "./configure", "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end

  test do
    system "#{bin}/sfk", "ip"
  end
end
