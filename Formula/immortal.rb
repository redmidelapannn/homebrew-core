class Immortal < Formula
  desc "OS agnostic (*nix) cross-platform supervisor"
  homepage "https://immortal.run/"
  url "https://github.com/immortal/immortal/archive/0.19.0.tar.gz"
  sha256 "a08f5890b4a62e8f8a9440e1b9242bfe01d226461290fe4a483e982558f7fe8b"
  head "https://github.com/immortal/immortal.git"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "6ec3f9949e8d8e831ae386809e990fc40cf4c1ae099a22b602f3e707bb40325e" => :high_sierra
    sha256 "e9a5e00e05b816dd846596db2855fd6cf7b4d6e69b2649c47a91ebcf28389fda" => :sierra
    sha256 "c3ad96ef21fb08745cfa3995c766f1b15cbb6d89bac66f3a361f29c22f6bdd3c" => :el_capitan
  end

  depends_on "dep" => :build
  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    (buildpath/"src/github.com/immortal/immortal").install buildpath.children
    cd "src/github.com/immortal/immortal" do
      system "dep", "ensure", "-vendor-only"
      ldflags = "-s -w -X main.version=#{version}"
      system "go", "build", "-ldflags", ldflags, "-o", "#{bin}/immortal", "cmd/immortal/main.go"
      system "go", "build", "-ldflags", ldflags, "-o", "#{bin}/immortalctl", "cmd/immortalctl/main.go"
      system "go", "build", "-ldflags", ldflags, "-o", "#{bin}/immortaldir", "cmd/immortaldir/main.go"
      man8.install Dir["man/*.8"]
      prefix.install_metafiles
    end
  end

  test do
    system bin/"immortal", "-v"
    system bin/"immortalctl", "-v"
    system bin/"immortaldir", "-v"
  end
end
