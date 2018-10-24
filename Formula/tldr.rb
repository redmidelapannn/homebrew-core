class Tldr < Formula
  desc "Simplified and community-driven man pages"
  homepage "https://tldr.sh/"
  url "https://github.com/tldr-pages/tldr-cpp-client/archive/v1.3.0.tar.gz"
  sha256 "6210ece3f5d8f8e55b404e2f6c84be50bfdde9f0d194a271bce751a3ed6141be"
  revision 2
  head "https://github.com/tldr-pages/tldr-cpp-client.git"

  bottle do
    cellar :any
    rebuild 1
    sha256 "22ff1a93c615951e804eb8c1d29b0b123d0eb6eb6c741fe842c4f7d1700bd30a" => :mojave
    sha256 "0fe7b6884d98808c3ab8efa25775cb7c29d2eeab12ba310c9e70620384510aab" => :high_sierra
    sha256 "69f4eceb401c5a1a07fc0c901296e797b9108045f2351141c948936b1a54f52f" => :sierra
  end

  depends_on "pkg-config" => :build
  depends_on "libzip"

  conflicts_with "tealdeer", :because => "both install `tldr` binaries"

  def install
    system "make", "PREFIX=#{prefix}", "install"
  end

  test do
    assert_match "brew", shell_output("#{bin}/tldr brew")
  end
end
