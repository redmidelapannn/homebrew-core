class Nfdump < Formula
  desc "Tools to collect and process netflow data on the command-line"
  homepage "http://nfdump.sourceforge.net"
  url "https://github.com/phaag/nfdump.git",
    :tag => "v1.6.15",
    :revision => "68d660e984e8b6ce099fc7309f61f3bfa460598f"

  bottle do
    cellar :any
    sha256 "59bcdf45d888e49e3227f22f42198a9026ac5345bc4f447f99957cc799c597fc" => :el_capitan
    sha256 "6a5cc18290f8187113c3a8591020a417dce345f7116feb4e78c03d5942359e81" => :mavericks
  end

  def install
    system "./configure", "--prefix=#{prefix}", "--enable-readpcap"
    system "make", "-j1", "install"
  end

  test do
    system "#{bin}/nfdump", "-Z 'host 8.8.8.8'"
  end
end
