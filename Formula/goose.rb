class Goose < Formula
  desc "Go Language's command-line interface for database migrations"
  homepage "https://github.com/pressly/goose"
  url "https://github.com/pressly/goose/archive/v2.2.0.tar.gz"
  sha256 "0d977417e60ba24fac7ba68f282e99d27600f583c3d7acd537b33f7afc7efdf1"

  bottle do
    cellar :any_skip_relocation
    sha256 "fe1ed49d0e9ec995c90588245da5ff5b56b9eeae8b9068190bdf0540b18a9a67" => :high_sierra
    sha256 "5aae0ff926cb28748db39738b8939fdea0b7692d5067b8de0503fee2d639e0ec" => :sierra
    sha256 "7e48e67aba1c69e12f9e621f5de63b2d45485cfb51a5c7bb983e80793749c018" => :el_capitan
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
    output = shell_output("#{bin}/goose sqlite3 foo.db status create")
    assert_match "Migration", output
    assert_predicate testpath/"foo.db", :exist?, "Failed to create foo.db!"
  end
end
