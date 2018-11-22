class Goose < Formula
  desc "Go Language's command-line interface for database migrations"
  homepage "https://github.com/pressly/goose"
  url "https://github.com/pressly/goose/archive/v2.4.3.tar.gz"
  sha256 "d394351842b0854150fd720ee49adaec88a92420f816fe15fcd216ed9d055a5a"

  bottle do
    cellar :any_skip_relocation
    sha256 "dd9f6d551d758cc405aade24db4007d7a7845107d8309c7cf82308f36afa2d4e" => :mojave
    sha256 "7e553f6286b0255687daa05dc3663fae9f79964f498d66e51cda59e5eb75d796" => :high_sierra
    sha256 "4b15be9800d114bdb3eb4b2a43b9e65f5f281cbfa38fe69705392fbf16cd6b37" => :sierra
  end

  depends_on "dep" => :build
  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    (buildpath/"src/github.com/pressly/goose").install buildpath.children
    cd "src/github.com/pressly/goose" do
      system "dep", "ensure"
      system "go", "build", "-o", bin/"goose", ".../cmd/goose"
      prefix.install_metafiles
    end
  end

  test do
    output = shell_output("#{bin}/goose sqlite3 foo.db status create 2>&1")
    assert_match "Migration", output
    assert_predicate testpath/"foo.db", :exist?, "Failed to create foo.db!"
  end
end
