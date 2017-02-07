class Snobol4 < Formula
  desc "String oriented and symbolic programming language"
  homepage "http://www.snobol4.org/"
  url "ftp://ftp.ultimate.com/snobol/snobol4-1.5.tar.gz"
  sha256 "9f7ec649f2d700a30091af3bbd68db90b916d728200f915b1ba522bcfd0d7abd"

  bottle do
    rebuild 1
    sha256 "99d33f8d3f9ac6c0a42cddb1ee64b2a4455f22fab150bb8c1a904e083ff655b9" => :sierra
    sha256 "2ccb96db8804369871ac6f81fd625ebb127923196b89e23456d620e043cdff27" => :el_capitan
    sha256 "6f8dc40b759b1c6c15b85794430b747c380fa636752965807b091f862f9d618d" => :yosemite
  end

  def install
    system "./configure", "--prefix=#{prefix}", "--mandir=#{man}"
    system "make", "install"
  end
end
