require "base64"

class Deark < Formula
  desc "File conversion utility for older formats"
  homepage "https://entropymine.com/deark/"
  url "https://entropymine.com/deark/releases/deark-1.4.7.tar.gz"
  sha256 "f26441f7f361e9f4bf584866d46995e35441ea88f269cb6c024881a5d17c11ff"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "7c2042646669ee023d16d5413caad6eb658378d5cc00a3f9d5721d1986b3f573" => :mojave
    sha256 "fbf8dec6a76c76ac2bcd4cc811182abdd1ef91701c601c057f914f30a74aea9b" => :high_sierra
    sha256 "47d157a52f4aa01b09c850e2d7e8f562e558181da4f8c75dcc8292d0a844f144" => :sierra
  end

  def install
    system "make"
    bin.install "deark"
  end

  test do
    (testpath/"test.gz").write ::Base64.decode64 <<~EOS
      H4sICKU51VoAA3Rlc3QudHh0APNIzcnJ11HwyM9NTSpKLVfkAgBuKJNJEQAAAA==
    EOS
    system "#{bin}/deark", "test.gz"
    file = (testpath/"output.000.test.txt").readlines.first
    assert_match "Hello, Homebrew!", file
  end
end
