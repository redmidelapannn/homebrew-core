class Tldr < Formula
  desc "Simplified and community-driven man pages"
  homepage "https://tldr.sh/"
  url "https://github.com/tldr-pages/tldr-cpp-client/archive/v1.3.0.tar.gz"
  sha256 "6210ece3f5d8f8e55b404e2f6c84be50bfdde9f0d194a271bce751a3ed6141be"
  revision 1
  head "https://github.com/tldr-pages/tldr-cpp-client.git"

  bottle do
    cellar :any
    rebuild 1
    sha256 "09c6d663937add70ac2f1acd72fad018f06b3564d5a422dd5521518befaad0b6" => :high_sierra
    sha256 "2ffa61d3e5e6fc948b042920dda5a16eb0dbabb48f056ae86f47e7015f4cfecb" => :sierra
    sha256 "77ac499cdb0cf3badb0320aa4438dcf26f3605b19b2666990fccbe88ec419e08" => :el_capitan
  end

  depends_on "pkg-config" => :build
  depends_on "libzip"

  def install
    system "make", "PREFIX=#{prefix}", "install"
  end

  test do
    assert_match "brew", shell_output("#{bin}/tldr brew")
  end
end
