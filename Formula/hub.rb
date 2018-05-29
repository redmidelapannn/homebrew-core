class Hub < Formula
  desc "Add GitHub support to git on the command-line"
  homepage "https://hub.github.com/"
  url "https://github.com/github/hub/archive/v2.3.0.tar.gz"
  sha256 "69e48105f7287537e7afaf969825666c1f09267eae3507515151900487342fae"

  head "https://github.com/github/hub.git"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "9e15420bfe07183fc1a756632e41e5bfda62b4290512811f8ed43e464361b334" => :high_sierra
    sha256 "cc187608e03fbdfcd791a486fd667ccbf207c5f1d3f97d4cfaf5adaf28a1a012" => :sierra
    sha256 "6e6f2ffd9df78ce9ad09d5876042b7f007454ac4f70d9685b48e52848c16c77f" => :el_capitan
  end

  option "without-completions", "Disable bash/zsh completions"
  option "without-docs", "Don't install man pages"

  depends_on "go" => :build

  # The build needs Ruby 1.9 or higher.
  depends_on "ruby" => :build if MacOS.version <= :mountain_lion

  def install
    if build.with? "docs"
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
      fish_completion.install "etc/hub.fish_completion" => "hub.fish"
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
