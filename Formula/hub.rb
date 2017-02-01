class Hub < Formula
  desc "Add GitHub support to git on the command-line"
  homepage "https://hub.github.com/"
  url "https://github.com/github/hub/archive/v2.2.9.tar.gz"
  sha256 "b3cf227e38a34a56e37b7705a60bec258cea52174d8e030b559f74af647a70d6"

  head "https://github.com/github/hub.git"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "c0f13aa5461dac2a099164ee4639b01511a1b3d4b6ab9e558cebf3f3e6c0c7f4" => :sierra
    sha256 "06553d4748ef9d490fcf156dfa18270264294705f87ba88424c8d50a4735e01e" => :el_capitan
    sha256 "b51c07daa0b79f4c80017adab16f82b6684c6469c12dee36d8d70e3a447a7939" => :yosemite
  end

  devel do
    url "https://github.com/github/hub/archive/v2.3.0-pre8.tar.gz"
    version "2.3.0-pre8"
    sha256 "1cea4a5958f7ca72c232ede173f5e4893e007aaddf6842d48665dff6fb1d7e19"
  end

  option "without-completions", "Disable bash/zsh completions"
  option "without-docs", "Don't install man pages"

  depends_on "go" => :build

  def install
    if build.stable?
      system "script/build", "-o", "hub"
      bin.install "hub"
      man1.install Dir["man/*"] if build.with? "docs"
    elsif build.with? "docs"
      begin
        deleted = ENV.delete "SDKROOT"
        ENV["GEM_HOME"] = buildpath/"gem_home"
        system "gem", "install", "bundle"
        ENV.prepend_path "PATH", buildpath/"gem_home/bin"
        system "make", "man-pages"
      ensure
        ENV["SDKROOT"] = deleted
      end
      system "make", "install", "prefix=#{prefix}"
    else
      system "script/build", "-o", "hub"
      bin.install "hub"
    end

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
