class AmberCmd < Formula
  desc "Amber CLI client for generating, scaffolding Amber web apps."
  homepage "https://www.ambercr.io"
  url "https://github.com/Amber-Crystal/amber_cmd/archive/v0.1.13.tar.gz"
  sha256 "2b56718bf1623dc03d25183544d9ecf2f980ac60407e6c7320d83bcb4102b99c"

  bottle do
    sha256 "75ba54c62cb5974300a740e3999ac11d91d7bb315caa40ba75e1e1ea9cf41e71" => :sierra
    sha256 "35f659969538b53fcd6f3f2d7c28b1b2dcbe1a2c7416f6e9217ffde5f43c2d75" => :el_capitan
    sha256 "311390829a1e70da04537215cfc5dfe54d947865ee881a3d065bba4919743266" => :yosemite
  end

  depends_on "crystal-lang"
  depends_on "openssl"

  def install
    cd buildpath do
      system "shards", "install"
      system "crystal", "build", "-o", "amber", "src/amber_cmd.cr"
      bin.install "amber"
    end
  end

  test do
    system "#{bin}/amber", "--version"
  end
end
