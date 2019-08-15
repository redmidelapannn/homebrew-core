class Goose < Formula
  desc "Go Language's command-line interface for database migrations"
  homepage "https://github.com/pressly/goose"
  url "https://github.com/pressly/goose/archive/v2.6.0.tar.gz"
  sha256 "389953f40e567fd92090fd29d60e1baec576e6432e689f11ef54e6493502383a"

  bottle do
    cellar :any_skip_relocation
    sha256 "d14e7c4dc7b99af61601ff09a6c728e472a826243279ef288ceaf83840fadbc0" => :mojave
    sha256 "a6ddc698f7aafdd1eb1aba6b9046c7c4874e0dee4c32d67e07fee3940f08aec1" => :high_sierra
    sha256 "4e49a923cb17e9baa1b0d43899e65b7ac89542d556e5e8f95b77590b74afaac9" => :sierra
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
