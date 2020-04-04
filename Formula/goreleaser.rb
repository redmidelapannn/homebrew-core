class Goreleaser < Formula
  desc "Deliver Go binaries as fast and easily as possible"
  homepage "https://goreleaser.com/"
  url "https://github.com/goreleaser/goreleaser.git",
      :tag      => "v0.131.1",
      :revision => "dec22cf0c8a6464390ea26b42086d242e396ecda"

  bottle do
    cellar :any_skip_relocation
    sha256 "4aef3689130a78aa6fcb547c74c365b9b2eb828af4f39eefe9a53c87fbb7ecd2" => :catalina
    sha256 "3e5458660852084945810c2f06739784b259f261e8229ed6863a641e89448bd0" => :mojave
    sha256 "29a0781bb78a8693f4538bda36a1900d63b78474e0339072f3ba35b781efd715" => :high_sierra
  end

  depends_on "go" => :build

  def install
    system "go", "build", "-ldflags",
             "-s -w -X main.version=#{version} -X main.commit=#{stable.specs[:revision]} -X main.builtBy=homebrew",
             "-o", bin/"goreleaser"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/goreleaser -v 2>&1")
    assert_match "config created", shell_output("#{bin}/goreleaser init --config=.goreleaser.yml 2>&1")
    assert_predicate testpath/".goreleaser.yml", :exist?
  end
end
