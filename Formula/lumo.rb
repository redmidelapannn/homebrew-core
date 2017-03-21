class Lumo < Formula
  desc "Fast, cross-platform, standalone ClojureScript REPL"
  homepage "https://github.com/anmonteiro/lumo"
  url "https://github.com/anmonteiro/lumo/archive/1.2.0.tar.gz"
  sha256 "811a3efe0e374a253e7a9a2681543d92038454f794ed0415b370fef82ff65e6b"
  head "https://github.com/anmonteiro/lumo.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "45f8e0954291aa50c033bc6efb3279c7f3cc19b2a94298a895d964323e5b43eb" => :sierra
    sha256 "e98c2d55deae20f89f40e0232e25a025660f81dc6aa0384aa810af31e0a18336" => :yosemite
  end

  depends_on "boot-clj" => :build
  depends_on "node" => :build
  depends_on "yarn" => :build

  def install
    ENV["BOOT_HOME"] = "#{buildpath}/.boot"
    ENV["BOOT_LOCAL_REPO"] = "#{buildpath}/.m2/repository"
    system "boot", "release"
    bin.install "build/lumo"
  end

  test do
    assert_equal "0", shell_output("#{bin}/lumo -e '(- 1 1)'").chomp
  end
end
