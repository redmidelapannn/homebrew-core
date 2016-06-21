class Libofx < Formula
  desc "Library to support OFX command responses"
  homepage "http://libofx.sourceforge.net"
  url "https://downloads.sourceforge.net/project/libofx/libofx/0.9.9/libofx-0.9.9.tar.gz"
  sha256 "94ef88c5cdc3e307e473fa2a55d4a05da802ee2feb65c85c63b9019c83747b23"

  bottle do
    revision 2
    sha256 "3ba692f5791af9bb94bbd3b92f2720d56fe16c51180b5434ace901bb02830fd0" => :el_capitan
    sha256 "ba7a6327fee833da81eb2d92562f5db7ff5a4a66b5207dc1d84c58fa15dbf27c" => :yosemite
    sha256 "da09129b74cd3a918531f468614ec380be7b7e0495b2ac995e9c994ffe763c6f" => :mavericks
  end

  depends_on "open-sp"

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    assert_equal "ofxdump #{version}", shell_output("ofxdump -V").chomp
  end
end
