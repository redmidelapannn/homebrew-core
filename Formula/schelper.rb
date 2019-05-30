class Schelper < Formula
  desc "Analyze log files from Sauce Connect"
  homepage "https://github.com/mdsauce/schelper"
  url "https://github.com/mdsauce/schelper/archive/v1.0.tar.gz"
  sha256 "ec647cec27758d80ad4dbe31f16303a695eee4e1b9126733c77ec23faa0cda73"
  bottle do
    cellar :any_skip_relocation
    sha256 "c9dc978bf57447be349263f1e2759431d1776f411a7570af8ff3d5183cf737e1" => :mojave
    sha256 "2ddeb17fee87aad8518878ad3d8d4219d8d0fdfdb25166381abd6e1dee46d265" => :high_sierra
    sha256 "85b7d129de66015252fd5c156424bfcc184a35301f399d47f6b4656a84f40511" => :sierra
  end

  depends_on "go" => :build

  def install
    system "go", "build", "-o", bin/"schelper", "."
  end

  test do
    system "#{bin}/schelper", --help, ">", "output.txt"
    assert_predicate ./"output.txt", :exist?
  end
end
