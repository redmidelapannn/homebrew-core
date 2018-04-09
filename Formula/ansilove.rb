class Ansilove < Formula
  desc "ANSi / ASCII art to PNG converter in C"
  homepage "https://www.ansilove.org/"
  url "https://github.com/ansilove/ansilove/archive/3.0.8.tar.gz"
  sha256 "655472d31a9ec5a5ba29f5c15485d8647526ff8b0c9968d71f4267a9aa9bb544"

  bottle do
    cellar :any
    sha256 "0ebe22a6150177cef2fa89ab9da8719bcc584aa82b2dd8717d57e9f85e96be9f" => :high_sierra
    sha256 "0fe022847878c9d37acd6dfbe6c3e5de530da675028c48fb861cb53aefad2d12" => :sierra
    sha256 "74a38423d24b76a40af6220f8acdb0a079e5ab9a09df80d20d7d5d3f0a4887f6" => :el_capitan
  end

  depends_on "cmake" => :build
  depends_on "gd"

  def install
    system "cmake", "."
    system "make"
    prefix.install "examples/43-nslv1.ans"
    bin.install "ansilove"
  end

  test do
    system bin/"ansilove", "-o", testpath/"43-nslv1.ans.png", prefix/"43-nslv1.ans"
    assert_predicate testpath/"43-nslv1.ans.png", :exist?
  end
end
