class Hub < Formula
  desc "Add GitHub support to git on the command-line"
  homepage "https://hub.github.com/"
  url "https://github.com/github/hub/archive/v2.2.9.tar.gz"
  sha256 "b3cf227e38a34a56e37b7705a60bec258cea52174d8e030b559f74af647a70d6"

  head "https://github.com/github/hub.git"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "d7e648af51e02476e4635858c8b4bb0039f13e8f49d3c4dd622e826d3470387a" => :sierra
    sha256 "4a99d61863d68228db2e24291ca82440d5f97b58982d54df62b006da383b9e4d" => :el_capitan
    sha256 "13c88914cfa7a4c842d9cbccc0ff72cfb64f98dfdd939213ea1067b64c5c2383" => :yosemite
  end

  devel do
    url "https://github.com/github/hub/archive/v2.3.0-pre8.tar.gz"
    sha256 "1cea4a5958f7ca72c232ede173f5e4893e007aaddf6842d48665dff6fb1d7e19"
  end

  option "without-completions", "Disable bash/zsh completions"

  depends_on "go" => :build

  def install
    system "script/build", "-o", "hub"
    bin.install "hub"
    man1.install Dir["man/*"]

    if build.with? "completions"
      bash_completion.install "etc/hub.bash_completion.sh"
      zsh_completion.install "etc/hub.zsh_completion" => "_hub"
    end
  end

  test do
    system "git", "init"
    %w[haunted house].each { |f| touch testpath/f }
    system "git", "add", "haunted", "house"
    system "git", "commit", "-a", "-m", "Initial Commit"
    assert_equal "haunted\nhouse", shell_output("#{bin}/hub ls-files").strip
  end
end
