class Vert < Formula
  desc "Command-line version testing"
  homepage "https://github.com/Masterminds/vert"
  url "https://github.com/Masterminds/vert/archive/v0.1.0.tar.gz"
  sha256 "96e22de4c03c0a5ae1afb26c717f211c85dd74c8b7a9605ff525c87e66d19007"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "9c97d5b7b5107a39c3aca384b72e4079b46ca6e10d330c9ace19ab986d114717" => :high_sierra
    sha256 "33dd66474b57d6e624bff97fa32a0a9c09e48b6a4235279e56839ff4224f01e6" => :sierra
    sha256 "1d5ff5c977a63aa0a43bf4911beea469b36830f723e14bf37312dabbbe2f4da1" => :el_capitan
  end

  depends_on "dep" => :build
  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    (buildpath/"src/github.com/Masterminds/vert").install buildpath.children
    cd "src/github.com/Masterminds/vert" do
      system "dep", "ensure", "-vendor-only"
      system "make", "build"
      bin.install "vert"
      prefix.install_metafiles
    end
  end

  test do
    output = shell_output("#{bin}/vert 1.2.3 1.2.3 1.2.4 1.2.5", 2)
    assert_match "1.2.3", output
  end
end
