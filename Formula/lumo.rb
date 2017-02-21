class Lumo < Formula
  desc "Fast, cross-platform, standalone ClojureScript REPL"
  homepage "https://github.com/anmonteiro/lumo"
  url "https://github.com/anmonteiro/lumo/archive/1.2.0.tar.gz"
  sha256 "811a3efe0e374a253e7a9a2681543d92038454f794ed0415b370fef82ff65e6b"
  head "https://github.com/anmonteiro/lumo.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "b0933790ab37d1b0e014fc6cb3277b76c963ad8d7b642a7651342d08d828ebe6" => :sierra
    sha256 "f1286e52fd9b434931ae82f28630ad2bb1f5d0ab5aae96c5af2b40560ee71cf9" => :yosemite
  end

  depends_on "boot-clj" => :build
  depends_on "node" => :build
  depends_on "yarn" => :build

  def install
    ENV["BOOT_HOME"] = "#{buildpath}/.boot"
    ENV["BOOT_LOCAL_REPO"] = "#{buildpath}/.m2/repository"
    system "boot", "release-ci"
    bin.install "build/lumo"
  end

  test do
    assert_equal "0", shell_output("#{bin}/lumo -e '(- 1 1)'").chomp
  end
end
