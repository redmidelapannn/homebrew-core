class Rbenv < Formula
  desc "Ruby version manager"
  homepage "https://github.com/rbenv/rbenv#readme"
  url "https://github.com/rbenv/rbenv/archive/v1.1.2.tar.gz"
  sha256 "80ad89ffe04c0b481503bd375f05c212bbc7d44ef5f5e649e0acdf25eba86736"
  head "https://github.com/rbenv/rbenv.git"

  bottle do
    cellar :any
    rebuild 1
    sha256 "aded2bc621749c2ff1d5aaaf307c4e371e5340a54b08691dfaa63f4236d63e4d" => :mojave
    sha256 "17174907fdfb1b58e6c7eddd36a999dfa9cf6a6a664f371a065b623e01cc9911" => :high_sierra
    sha256 "48f1fc737b8ee8a3415d6df25117ab65524a8de652cb616bda0fd850d77f1e39" => :sierra
  end

  depends_on "ruby-build"

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

  def post_install
    # Update shims, when the older version is removed things get broken
    system "#{bin}/rbenv", "rehash"
  end

  test do
    shell_output("eval \"$(#{bin}/rbenv init -)\" && rbenv versions")
  end
end
