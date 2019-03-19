class Cage < Formula
  desc "Develop complex, multi‑container Docker applications locally"
  homepage "https://cage.faraday.io/"
  url "https://github.com/faradayio/cage/releases/download/v0.2.7/cage-v0.2.7-osx.zip"
  sha256 "d438383f997a3c5e31ee8c739f35fc2fdd371a186ef295e945b56475842eebd6"
  head "https://github.com/faradayio/cage.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "d0d5ababc3e8e5c59631b08ecc788bfe3adb1725eaf885e1bd47dbb2acba37ff" => :mojave
    sha256 "d0d5ababc3e8e5c59631b08ecc788bfe3adb1725eaf885e1bd47dbb2acba37ff" => :high_sierra
    sha256 "08852ea530b5e2416a3b64879a5abd59fd84248bb458b3f48eb10458f766bd8c" => :sierra
  end

  depends_on "docker-compose"

  def install
    bin.install "cage"
  end

  test do
    system "#{bin}/cage", "-h"
  end
end
