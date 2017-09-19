class Lumo < Formula
  desc "Fast, cross-platform, standalone ClojureScript environment"
  homepage "https://github.com/anmonteiro/lumo"
  url "https://github.com/anmonteiro/lumo/archive/1.7.0.tar.gz"
  sha256 "c5b37815d41581974dd026f2f02389102c4af4934c87e15d4c3c1d85f3211e1e"
  head "https://github.com/anmonteiro/lumo.git"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "71db68183bb8d3bc236427f04e39085f3af8428aec24a1576ef3b7e8f43e4149" => :sierra
    sha256 "22490158b8e7ff9136881a0c98f4fa9d86949c35ebe378717bafd945bdc49cab" => :el_capitan
  end

  devel do
    url "https://github.com/anmonteiro/lumo/archive/1.8.0-beta.tar.gz"
    sha256 "be267bd26f98a0963260af6848598786dcdf1576353f4dc9f40e13166ced2491"
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
