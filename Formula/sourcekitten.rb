class Sourcekitten < Formula
  desc "Framework and command-line tool for interacting with SourceKit"
  homepage "https://github.com/jpsim/SourceKitten"
  url "https://github.com/jpsim/SourceKitten.git",
      :tag => "0.21.2",
      :revision => "4be914be6fa49cd30b1e7ef5d32d06c037d8f469"
  head "https://github.com/jpsim/SourceKitten.git"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "e0e4b2c8fbda738ace9f42b23332ddb1eae512a7b25b88f869da419b6e72ed6a" => :mojave
    sha256 "3d88e8917c1b47f4c402276325f67e3c92c82b1f6bd58cf695b4ac2dfbaf87b8" => :high_sierra
    sha256 "4f912e3a748ac622ce87372d1848da4a064d5bd699ba11a2e349c95af9e86a26" => :sierra
  end

  depends_on :xcode => ["9.0", :build]
  depends_on :xcode => "6.0"

  def install
    system "make", "prefix_install", "PREFIX=#{prefix}", "TEMPORARY_FOLDER=#{buildpath}/SourceKitten.dst"
  end

  test do
    # Rewrite test after sandbox issues investigated.
    # https://github.com/Homebrew/homebrew/pull/50211
    system "#{bin}/sourcekitten", "version"
  end
end
