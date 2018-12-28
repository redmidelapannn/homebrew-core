class Exenv < Formula
  desc "Elixir version manager"
  homepage "https://github.com/exenv/exenv"
  url "https://github.com/exenv/exenv/archive/v1.1.1.tar.gz"
  sha256 "d8318ed11ddf6f8a215f982677f4166035efe02bc67993b216d01dec11add2ef"
  head "https://github.com/exenv/exenv.git"

  bottle do
    cellar :any
    sha256 "eca8849c0dbe0829cb8c0a07044a618e6d148028127249a71c1ad79f9881b8e4" => :mojave
    sha256 "7f05cf732a8c3ee52e3f2d1f4408f6bde00f62f9a91eabb7d1f1a11d2a9b1ecf" => :high_sierra
    sha256 "1adc3dc71d48db98d9c2df4d07073a00bc8c2f63f54a1f6c16788d3b1244345c" => :sierra
  end

  depends_on "elixir-build"

  def install
    inreplace "libexec/exenv" do |s|
      s.gsub! '"${BASH_SOURCE%/*}"/../libexec', libexec
      if HOMEBREW_PREFIX.to_s != "/usr/local"
        s.gsub! ":/usr/local/etc/exenv.d", ":#{HOMEBREW_PREFIX}/etc/exenv.d\\0"
      end
    end

    # Compile optional bash extension.
    system "src/configure"
    system "make", "-C", "src"

    if build.head?
      # Record exact git revision for `rbenv --version` output
      git_revision = `git rev-parse --short HEAD`.chomp
      inreplace "libexec/exenv---version", /^(version=)"([^"]+)"/,
                                           %Q(\\1"\\2-g#{git_revision}")
    end

    prefix.install ["bin", "completions", "libexec", "exenv.d"]
  end

  test do
    shell_output("eval \"$(#{bin}/exenv init -)\"")
  end
end
