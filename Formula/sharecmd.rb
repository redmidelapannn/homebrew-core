class Sharecmd < Formula
  desc "Share your files using Cloudproviders with just one command"
  homepage "https://github.com/mschneider82/sharecmd"
  url "https://github.com/mschneider82/sharecmd/releases/download/v0.0.26/sharecmd_0.0.26_Darwin_x86_64.tar.gz"
  version "0.0.26"
  sha256 "adcf3f4f4c0edb2811bc9985936d5343a04e19fcca5a1e622e772f91a3560f3e"

  bottle do
    cellar :any_skip_relocation
    sha256 "4d8b1293bcc351a88c87494a07ee779456cab85dafbedfbb1167fcc0281a3595" => :mojave
    sha256 "e56ce597a24555f07e851ea9ee05bef78c1bf77ea7d7faac2f85af78bcada8be" => :high_sierra
    sha256 "e56ce597a24555f07e851ea9ee05bef78c1bf77ea7d7faac2f85af78bcada8be" => :sierra
  end

  def install
    bin.install "share"
  end

  test do
    system "#{bin}/share --help"
  end
end
