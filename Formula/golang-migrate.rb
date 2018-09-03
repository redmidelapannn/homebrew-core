class GolangMigrate < Formula
  desc "Database migrations CLI tool"
  homepage "https://github.com/golang-migrate/migrate"
  url "https://github.com/golang-migrate/migrate/archive/v3.4.0.tar.gz"
  sha256 "7a0789bf611d1efda95528cc581495fd9590cfa25d1dfc0be9e33eaf4c62e33e"

  bottle do
    cellar :any_skip_relocation
    sha256 "7b7dc3533e2e4aeb560e6e5b1e9d0cf0cdf92519e8f580396c50be8f6d59bfc3" => :mojave
    sha256 "47be44c965776472e8a57c26c64ae51e8c5da8bece91fca998798159aad1ee0a" => :high_sierra
    sha256 "2ddc1f942845d5f65fa06077b540d9ea42eff90046b9a92224125fa8230c8d6d" => :sierra
    sha256 "b30ffdf3efdebe3f1acd651a13efc03e09bb3a057d518d59bc2e1f85539c2a39" => :el_capitan
  end

  depends_on "dep" => :build
  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    (buildpath/"src/github.com/golang-migrate/migrate").install buildpath.children

    # Build and install CLI as "migrate"
    cd "src/github.com/golang-migrate/migrate" do
      system "dep", "ensure", "-vendor-only"
      system "make", "build-cli", "VERSION=v#{version}"
      bin.install "cli/build/migrate.darwin-amd64" => "migrate"
      prefix.install_metafiles
    end
  end

  test do
    touch "0001_migtest.up.sql"
    assert_match "1/u migtest", shell_output("#{bin}/migrate -database stub: -path . up 2>&1")
  end
end
