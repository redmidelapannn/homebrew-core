class GitProfile < Formula
  desc "Simple user profile manager for git"
  homepage "https://github.com/bobbo/git-profile"
  url "https://github.com/bobbo/git-profile/archive/v0.1.0.tar.gz"
  sha256 "999404c4872d5af9b3fbb651337617fdc5ab075015267a64ae044cb14ff12ea1"
  head "https://github.com/bobbo/git-profile.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "f28cc47bfd8469fb22532f8cc246b8f9a20dd404be29654f94787c6bc2ea7095" => :catalina
    sha256 "811690d3247da780b0123a08a9e332964fdd64588cb5c1a6edf1648ce678bd38" => :mojave
    sha256 "e2182db2efc12a564eaa116f21714db857eda8e02bbed297c40d7d90a43c55f2" => :high_sierra
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", "--locked", "--root", prefix, "--path", "."
  end

  test do
    major, minor = version.to_s.split(".")
    assert_match "git-profile #{major}.#{minor}",
                 shell_output("#{bin}/git-profile --version")
  end
end
