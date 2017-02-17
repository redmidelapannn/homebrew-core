class Hub < Formula
  desc "Add GitHub support to git on the command-line"
  homepage "https://hub.github.com/"
  url "https://github.com/github/hub/archive/v2.2.9.tar.gz"
  sha256 "b3cf227e38a34a56e37b7705a60bec258cea52174d8e030b559f74af647a70d6"

  head "https://github.com/github/hub.git"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "48acbe125d3ee7feac7fe067cb41dfb8e49147d2a1a1f3eb947b94dad10ea3da" => :sierra
    sha256 "2204ea8a22658d765da505765bbd3294a557f66994d71316335eb7afeca594da" => :el_capitan
    sha256 "7b7bfd8de8e5c096565858913b5838f06f40ede02896d2f314460fa19e966a32" => :yosemite
  end

  devel do
    url "https://github.com/github/hub/archive/v2.3.0-pre9.tar.gz"
    version "2.3.0-pre9"
    sha256 "3246a5e3a071a7ccb06c30230a720b6457837bd6b97b32ab248dfb2b2222dbfb"
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
        system "gem", "install", "bundler"
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
