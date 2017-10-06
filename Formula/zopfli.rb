class Zopfli < Formula
  desc "New zlib (gzip, deflate) compatible compressor"
  homepage "https://github.com/google/zopfli"
  url "https://github.com/google/zopfli/archive/zopfli-1.0.1.tar.gz"
  sha256 "29743d727a4e0ecd1b93e0bf89476ceeb662e809ab2e6ab007a0b0344800e9b4"
  head "https://github.com/google/zopfli.git"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "462560656ee895a9591cc2c15f934b7543e6f7968441946e9f7e5873a8b6252f" => :high_sierra
    sha256 "aecaccf1c8b67b6c6c57b9c5d2665cc0af1c5f94dc363ebe77e658f2dbc57bff" => :sierra
    sha256 "e41bfcdae0807dd480647ca47ccd58d05277fc1aa745668987defe97bb6d6a31" => :el_capitan
  end

  def install
    system "make", "zopfli", "zopflipng"
    bin.install "zopfli", "zopflipng"
  end

  test do
    system "#{bin}/zopfli"
    system "#{bin}/zopflipng", test_fixtures("test.png"), "#{testpath}/out.png"
    assert_predicate testpath/"out.png", :exist?
  end
end
