class Hub < Formula
  desc "Add GitHub support to git on the command-line"
  homepage "https://hub.github.com/"
  url "https://github.com/github/hub/archive/v2.2.9.tar.gz"
  sha256 "b3cf227e38a34a56e37b7705a60bec258cea52174d8e030b559f74af647a70d6"

  head "https://github.com/github/hub.git"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "639bf090ba4b6692238f3d41f378c7a3002584dfa9eec8bc775583705e7dd996" => :sierra
    sha256 "e41f70904acdb37224711f3a81bdbc865730b89f3f1d9d2959520aa361e0dc74" => :el_capitan
    sha256 "be2fba64f806db753c5941dea7be3edc2f6af8293a6b2a0bb36422ed0e4efd7a" => :yosemite
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
