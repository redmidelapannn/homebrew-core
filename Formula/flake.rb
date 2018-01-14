class Flake < Formula
  desc "FLAC audio encoder"
  homepage "https://flake-enc.sourceforge.io"
  url "https://downloads.sourceforge.net/project/flake-enc/flake/0.11/flake-0.11.tar.bz2"
  sha256 "8dd249888005c2949cb4564f02b6badb34b2a0f408a7ec7ab01e11ceca1b7f19"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "7889ed3f0a8b6ecf0f6864560d626c39ce40070f723bb09f9218b568098493cc" => :high_sierra
    sha256 "85ce1d9ebad5c71f1b4c42af6ede752a41820c14348f7c3a1c0f17ea0d979f4f" => :sierra
    sha256 "c7e14082bdead0cfc46b6413483eb3017f9dd7cddb3e6021f1fc3effa7cc5506" => :el_capitan
  end

  def install
    ENV.deparallelize
    system "./configure", "--disable-debug", "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end

  test do
    system bin/"flake", test_fixtures("test.wav"), "-o", testpath/"test"
  end
end
