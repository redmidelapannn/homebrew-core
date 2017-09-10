class Osxutils < Formula
  desc "Suite of Mac OS command-line utilities"
  homepage "https://github.com/specious/osxutils"
  url "https://github.com/specious/osxutils/archive/v1.8.2.tar.gz"
  sha256 "83714582cce83faceee6d539cf962e587557236d0f9b5963bd70e3bc7fbceceb"
  head "https://github.com/specious/osxutils.git"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "e57ed9a2a39a788b6e2c3a0a35d8ca67fbd38d4b2155f6f55c729815f5358e94" => :sierra
    sha256 "e17c7478f51ffe7eb9e3c37e772f89e219087677495b30035f8d6cef5ef54293" => :el_capitan
  end

  conflicts_with "trash", :because => "both install a `trash` binary"
  conflicts_with "trash-cli", :because => "both install a `trash` binary"
  conflicts_with "leptonica",
    :because => "both leptonica and osxutils ship a `fileinfo` executable."
  conflicts_with "wiki", :because => "both install `wiki` binaries"

  def install
    system "make"
    system "make", "PREFIX=#{prefix}", "install"
  end

  test do
    system "#{bin}/trash"
  end
end
