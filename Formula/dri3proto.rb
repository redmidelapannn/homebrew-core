class Dri3proto < Formula
  desc "X11 DRI3 protocol"
  homepage "https://wiki.freedesktop.org/xorg"
  url "https://www.x.org/releases/individual/proto/dri3proto-1.0.tar.bz2"
  sha256 "01be49d70200518b9a6b297131f6cc71f4ea2de17436896af153226a774fc074"

  bottle do
    cellar :any_skip_relocation
    sha256 "d9723180ec6f0d88669518ff6e74b660900b68926166582eb5055a90f2e8e300" => :sierra
    sha256 "d9723180ec6f0d88669518ff6e74b660900b68926166582eb5055a90f2e8e300" => :el_capitan
    sha256 "d9723180ec6f0d88669518ff6e74b660900b68926166582eb5055a90f2e8e300" => :yosemite
  end

  depends_on :x11
  depends_on "pkg-config" => :optional

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end
end
