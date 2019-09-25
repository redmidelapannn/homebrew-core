class Mmark < Formula
  desc "Powerful markdown processor in Go geared towards the IETF"
  homepage "https://mmark.miek.nl/"
  url "https://github.com/mmarkdown/mmark/archive/v2.1.1.tar.gz"
  sha256 "c69bbeb263ca38c528016094fc299585fe8804db0c80f123c994cdec0c191716"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "8a63ed3e87a135b4c60522042c9697b99a10a5fb56086353b4b50212834db09d" => :mojave
    sha256 "4ed8cba5759941b73796f2bfca09d8c2d6a19b08662ea44acef7abe1c5ab4098" => :high_sierra
    sha256 "9d2be01bacd68870ee4e7b8957c14b3896da7cbb9f4e7dbf85e0ad96a0340568" => :sierra
  end

  depends_on "go" => :build

  resource "test" do
    url "https://raw.githubusercontent.com/mmarkdown/mmark/v2.0.7/rfc/2100.md"
    sha256 "2d220e566f8b6d18cf584290296c45892fe1a010c38d96fb52a342e3d0deda30"
  end

  def install
    ENV["GOPATH"] = buildpath

    (buildpath/"src/github.com/mmarkdown/mmark").install buildpath.children
    cd "src/github.com/mmarkdown/mmark" do
      system "go", "build", "-o", bin/"mmark"
      man1.install "mmark.1"
      prefix.install_metafiles
    end
  end

  test do
    resource("test").stage do
      system "#{bin}/mmark", "-2", "-ast", "2100.md"
    end
  end
end
