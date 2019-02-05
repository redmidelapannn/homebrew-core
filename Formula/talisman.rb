class Talisman < Formula
  desc "Detects secrets checked into git repository before commit or push"
  homepage "https://thoughtworks.github.io/talisman/"
  url "https://github.com/thoughtworks/talisman/archive/v0.4.3.tar.gz"
  sha256 "3aa40773885cbdab4ef5aa5cdc2465879cfe2d61e91619be4a2fb034fb001ae1"

  bottle do
    cellar :any_skip_relocation
    sha256 "86e296c148de509a55e4e27ad7c2a4cf81e2440f872ba66810fbe0566f661bc8" => :mojave
    sha256 "c3d428bce8db213666f837ea50934ba121316eb1828408ae408270e293c05e89" => :high_sierra
    sha256 "27ec7d1a8a03f60d55aa884ad4345ec86dfdc94ffc9c7e4edfa68cf75578b2fd" => :sierra
  end

  depends_on "go" => :build
  depends_on "gox" => :build

  def install
    ENV["GOPATH"] = buildpath
    ENV["GO111MODULE"] = "on"
    talisman_path = buildpath/"src/github.com/thoughtworks/talisman"
    talisman_path.install buildpath.children

    cd talisman_path do
      arch = "amd64"
      system "gox", "-osarch=darwin/#{arch}", "-ldflags=\"-X main.Version=v#{version}\"", "-output", bin/"talisman"
      bin.install "global_install_scripts/setup_talisman.bash"
      bin.install "global_install_scripts/remove_hooks.bash"
    end
  end

  def caveats
    <<~EOS
      \x1b[33mTalisman has been setup in your machine.
      To configure your git repositories to use Talisman, please follow instructions at
      https://github.com/thoughtworks/talisman
    EOS
  end

  test do
    assert_equal "talisman Development Build\n", shell_output("#{bin}/talisman --v")
  end
end
