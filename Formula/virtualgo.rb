class Virtualgo < Formula
  desc "Easy and powerful workspace based development for Go"
  homepage "https://github.com/GetStream/vg"
  url "https://github.com/GetStream/vg/archive/v0.8.0.tar.gz"
  sha256 "e7267b1306c36b3a4a4d10cb9e7ece66a9436a430bbf15028b82313496c92ebe"

  bottle do
    cellar :any_skip_relocation
    sha256 "fe4ca7081e81d6982c3015819013c9602d0f1ea1425cbd9801150b47b0ef86c4" => :high_sierra
    sha256 "7799421eb7b1d513193008a8282632f3ae93aa56d6d371e2cc19c181db3cd563" => :sierra
    sha256 "d4a8b5aa5b1ed8d636e79d5acf2b676633114a727b82e52f0e5b10d8251d165e" => :el_capitan
  end

  depends_on "go" => :build
  depends_on "dep" => :build
  depends_on "bindfs"

  def install
    ENV["GOPATH"] = buildpath
    vgpath = buildpath/"src/github.com/GetStream/vg"
    vgpath.install buildpath.children
    cd vgpath do
      system "dep", "ensure"
      system "go", "build", "-o", bin/"vg",
        "-ldflags", "-w -s -X github.com/GetStream/vg/cmd.Version=#{version}"
      prefix.install_metafiles
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/vg version")
  end
end
