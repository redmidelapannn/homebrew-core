class Rbenv < Formula
  desc "Ruby version manager"
  homepage "https://github.com/rbenv/rbenv#readme"
  url "https://github.com/rbenv/rbenv/archive/v1.1.0.tar.gz"
  sha256 "070835ccb4a295a49712ded936be306433442129d5a8411dddf2f52e6732ce59"
  head "https://github.com/rbenv/rbenv.git"

  bottle do
    cellar :any
    rebuild 1
    sha256 "dccb454b32505c3b6cd14a58845975c180943221c3aaf057487f4728ce3563fa" => :sierra
    sha256 "30855fdbd4f24eb5bda631f57b7ead2770f2a10870b5aba5dc7473b4e406d585" => :el_capitan
    sha256 "82927fb04be18fffbe11120a15dfebab0e1467bbf71ec92d420955e354e66f38" => :yosemite
  end

  depends_on "ruby-build" => :recommended

  def install
    inreplace "libexec/rbenv" do |s|
      s.gsub! '"${BASH_SOURCE%/*}"/../libexec', libexec
      if HOMEBREW_PREFIX.to_s != "/usr/local"
        s.gsub! ":/usr/local/etc/rbenv.d", ":#{HOMEBREW_PREFIX}/etc/rbenv.d\\0"
      end
    end

    # Compile optional bash extension.
    system "src/configure"
    system "make", "-C", "src"

    if build.head?
      # Record exact git revision for `rbenv --version` output
      git_revision = `git rev-parse --short HEAD`.chomp
      inreplace "libexec/rbenv---version", /^(version=)"([^"]+)"/,
                                           %Q(\\1"\\2-g#{git_revision}")
    end

    prefix.install ["bin", "completions", "libexec", "rbenv.d"]
  end

  test do
    shell_output("eval \"$(#{bin}/rbenv init -)\" && rbenv versions")
  end
end
