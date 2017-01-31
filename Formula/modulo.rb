class Modulo < Formula
  desc "source-only dependency manager"
  homepage "https://github.com/modulo-dm/modulo"
  url "https://github.com/modulo-dm/modulo/archive/v0.5.0.tar.gz"
  sha256 "d9d6362b962a5e747c785b56dc8084453870d260a83a3af8886dce678623c331"

  bottle do
    cellar :any_skip_relocation
    sha256 "8d9b4c368b1998a36f17e0a24cdf03fcc237c16f95d174bbb0a2a07a3220831a" => :sierra
    sha256 "f686f1d6791d7481af0b18ca0f0c18ac57f51b6b31a36d2423f6bf282da0b77a" => :el_capitan
  end

  depends_on :xcode => "8.0"

  def install
    xcodebuild "build", "-project", "modulo.xcodeproj", "-scheme", "modulo", "-configuration", "Release", "SYMROOT=build"
    bin.install "/tmp/modulo"
    man1.install "Documentation/modulo.1"
    man1.install "Documentation/modulo-layout.1"
    man1.install "Documentation/modulo-init.1"
    man1.install "Documentation/modulo-add.1"
    man1.install "Documentation/modulo-update.1"
  end

  test do
    system "#{bin}/modulo", "--help"
  end
end
