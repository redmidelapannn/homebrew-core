class Dssim < Formula
  desc "RGBA Structural Similarity Rust implementation"
  homepage "https://github.com/kornelski/dssim"
  url "https://github.com/kornelski/dssim/archive/2.9.7.tar.gz"
  sha256 "4ee60e125efae43f49bf9c4ca849f9cef2b1f86ee1d538da84907faae853eeeb"

  bottle do
    rebuild 1
    sha256 "3587efa781bc8dbfb2b12a35d7e23ac3fe889aac7de71bfda732e34e637507d2" => :high_sierra
    sha256 "fbc5ba04b95590bf8b13754afc5f8119e643fc6995632b99b726987532d562f0" => :sierra
    sha256 "231d88d0834c59af861c2dbbc386277556d9bdfb8e5726ab45d217ade54d37e5" => :el_capitan
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", "--root", prefix
  end

  test do
    system "#{bin}/dssim", test_fixtures("test.png"), test_fixtures("test.png")
  end
end
