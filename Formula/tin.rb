class Tin < Formula
  desc "Threaded, NNTP-, and spool-based UseNet newsreader"
  homepage "http://www.tin.org"
  url "http://ftp.cuhk.edu.hk/pub/packages/news/tin/v2.4/tin-2.4.0.tar.gz"
  sha256 "26ee20980c88308f225c0bae55b6db12365ced3398dbea0621992dff0e74cbb6"

  bottle do
    rebuild 1
    sha256 "fa45fe59f873dd76621c87951d44aac5b148ac444a49c93a2c6debca9a5e4614" => :sierra
    sha256 "3aa85515908d39886544207d24e6af761c2b1ab6e581391e035402568d48edbd" => :el_capitan
    sha256 "4b7db41ebe30479fbc4d8d3b1f9bacdfd43be5436a2d334784d3c0c916320b60" => :yosemite
  end

  conflicts_with "mutt", :because => "both install mmdf.5 and mbox.5 man pages"

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--mandir=#{man}"
    system "make", "build"
    system "make", "install"
  end

  test do
    system "#{bin}/tin", "-H"
  end
end
