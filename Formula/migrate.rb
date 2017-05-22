class Migrate < Formula
  desc "Database migrations. CLI and Golang library."
  homepage "https://github.com/mattes/migrate"
  url "https://github.com/mattes/migrate/releases/download/v3.0.1/migrate.darwin-amd64.tar.gz"
  version "3.0.1"
  sha256 "17e19678e930d4a48114937fb07300c107088d86a80c798630fabc08d32ee4ee"

  bottle do
    cellar :any_skip_relocation
    sha256 "21c50f285eaab8f4def36348515689d9d8a681e559cf28b4d8f238bebd41abaa" => :sierra
    sha256 "efdb8d4ac880b18e10bc9ded2c0901f4953d015a84c508e2d7855ac94013c41d" => :el_capitan
    sha256 "efdb8d4ac880b18e10bc9ded2c0901f4953d015a84c508e2d7855ac94013c41d" => :yosemite
  end

  def install
    mv "migrate.darwin-amd64", "migrate"
    bin.install "migrate"
  end

  test do
    system "#{bin}/migrate", "-version"
  end
end
