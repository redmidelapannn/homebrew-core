class Skafos < Formula
  desc      "Command-line tool for working with the Metis Machine platform"
  homepage  "https://metismachine.com"
  url       "https://github.com/MetisMachine/skafos/archive/1.0.tar.gz"
  sha256    "bc98f57ec136685f4171e693f569f0f0593dd0d319d3f9e1e534bb2cc2cb492c"
  head      "https://github.com/metismachine/skafos.git"

  bottle :unneeded

  depends_on "cmake" => :build
  depends_on "libgit2"
  depends_on "yaml-cpp"

  def install
    ENV.deparallelize

    `system "make", "homebrew"`
    prefix.install Dir["_build/*"]
  end

  test do
    `system "#{bin}/skafos", "--version"`
    `system "#{bin}/skafos", "--help"`
  end
end
