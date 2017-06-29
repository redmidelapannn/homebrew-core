class Hub < Formula
  desc "Add GitHub support to git on the command-line"
  homepage "https://hub.github.com/"
  url "https://github.com/github/hub/archive/v2.2.9.tar.gz"
  sha256 "b3cf227e38a34a56e37b7705a60bec258cea52174d8e030b559f74af647a70d6"

  head "https://github.com/github/hub.git"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "df422e9efb393105dc2aa3c2809f150840c1233785d84b5b1d32541f76112fc0" => :sierra
    sha256 "29b0f8af5e14c3078b711186392c6bfc0bd4046fe80dea60dfef87ca62541dc1" => :el_capitan
    sha256 "56ce9bdabd29a1896102182fb8677c74e1c9645bee603be434633d7226446575" => :yosemite
  end

  devel do
    url "https://github.com/github/hub/archive/v2.3.0-pre10.tar.gz"
    version "2.3.0-pre10"
    sha256 "9b4764dc2647bc0c14de2bd386e6f428f002d93baf01059d994e1cfa928483fc"
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
      # TODO: Remove the conditional when hub 2.3.0 is released.
      fish_completion.install "etc/hub.fish_completion" => "hub.fish" unless build.stable?
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
