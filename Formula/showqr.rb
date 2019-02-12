class Showqr < Formula
  desc "Show QR code from any selected text on your Mac"
  homepage "https://ricsxn.github.io/ShowQR/"
  url "https://github.com/ricsxn/ShowQR/archive/1.3.1.tar.gz"
  sha256 "6eb4d14dca99b562d994ad8371ab7577443679e4ef8f54e8accaa946db5fd75f"
  bottle do
    cellar :any_skip_relocation
    sha256 "6f076e2d7db41f9d8e3a8d7c3a0b42adfded98b65cfd990100abb3f9402e3814" => :mojave
    sha256 "a27b191036541d02518f434dcad2c4e013277d0a35cd7f18f91f405c5dbc7405" => :high_sierra
    sha256 "38fe4949810640549d5eb8c8e59b16a95576742f5932b94da94207ac73cedbf2" => :sierra
  end

  depends_on "pipenv"
  depends_on "python@2"

  def install
    system "make", "install"
  end

  test do
    system "make", "test"
  end
end
