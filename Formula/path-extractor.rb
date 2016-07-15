class PathExtractor < Formula
  desc "unix filter which outputs the filepaths found in stdin"
  homepage "https://github.com/edi9999/path-extractor"
  url "https://github.com/edi9999/path-extractor/archive/v0.2.0.tar.gz"
  sha256 "7d6c7463e833305e6d27c63727fec1029651bfe8bca5e8d23ac7db920c2066e7"

  head "https://github.com/edi9999/path-extractor.git"

  bottle do
    cellar :any_skip_relocation
    revision 1
    sha256 "da9e7e2f5697d61bc3e324bc63b5e459787f7c421040c37ed238abcecd340933" => :el_capitan
    sha256 "befd038e0485a54b736aef15bed5968b7185f4abfd88106ef44d9cdbaeaf11e4" => :yosemite
    sha256 "841abe326d036100d1c930d523d0fcc495c3537e8cbc33979441a8ff3a5c740f" => :mavericks
  end

  depends_on "go" => :build

  def install
    ENV["GOBIN"] = bin
    ENV["GOPATH"] = buildpath
    ENV["GOHOME"] = buildpath

    (buildpath/"src/github.com/edi9999").mkpath
    ln_sf buildpath, buildpath/"src/github.com/edi9999/path-extractor"

    system "go", "build", "-o", bin/"path-extractor", "path-extractor/pe.go"
  end

  test do
    assert_equal "foo/bar/baz\n",
      pipe_output("#{bin}/path-extractor", "a\nfoo/bar/baz\nd\n")
  end
end
