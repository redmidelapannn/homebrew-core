class Pick < Formula
  desc "Utility to choose one option from a set of choices"
  homepage "https://github.com/thoughtbot/pick"
  url "https://github.com/thoughtbot/pick/releases/download/v1.5.0/pick-1.5.0.tar.gz"
  sha256 "1dac1c9cf0b14b0bbb4d9eefb6af72cdf5314af7b2ff9e4c7c8858014ad63549"

  bottle do
    cellar :any_skip_relocation
    sha256 "1fbd954578885e562db5824c2d28202160bb6c6fea294d4a2ab32aef616d8aa5" => :sierra
    sha256 "f6b5f21b104638640df4673e452f082df74718abdd3d5e3b5b76cc13a11b3f6e" => :el_capitan
    sha256 "3ad32588a9ea8aec5eb1a125778bd1e26c7b230ee2e05cc4e054b31ea7ac14ab" => :yosemite
  end

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make check || cat test-suite.log"
    system "make", "install"
  end

  test do
    system "#{bin}/pick", "-v"
  end
end
