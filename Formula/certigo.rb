class Certigo < Formula
  desc "Utility to examine and validate certificates in a variety of formats"
  homepage "https://github.com/square/certigo"
  url "https://github.com/square/certigo.git"
  version "1.0.0"
  sha256 "935d4092e232099b1001680ac76dafb6e144898bb8dc7397529a6b78655db52d"

  bottle do
    cellar :any_skip_relocation
    sha256 "bb9c75698ae75bc08c7daa0db76b2a1136e33be94d34e17ac85253ea8082fa4c" => :el_capitan
    sha256 "f888cb5e554577d2a211e27ce98f98b1f29e7a36cd74dbe402bd254978ad2ff4" => :yosemite
    sha256 "0d8b49e01f6b5cda187ecb4b406c99978760de96308e89d64ccb0c6f2faf8a15" => :mavericks
  end

  depends_on "go" => :build

  def install
    system "./build"
    bin.install "bin/certigo"
  end

  test do
    system "certigo", "help"
  end
end
