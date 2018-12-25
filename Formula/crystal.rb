class Crystal < Formula
  desc "Fast and statically typed, compiled language with Ruby-like syntax"
  homepage "https://crystal-lang.org/"

  stable do
    url "https://github.com/crystal-lang/crystal/archive/0.27.0.tar.gz"
    sha256 "43c8ac1b5c59ccea3cd58c9bd2a7af07a56f96cf1eff1e54d93f648b5340e83a"

    resource "shards" do
      url "https://github.com/crystal-lang/shards/archive/v0.8.1.tar.gz"
      sha256 "75c74ab6acf2d5c59f61a7efd3bbc3c4b1d65217f910340cb818ebf5233207a5"
    end
  end

  bottle do
    cellar :any
    rebuild 1
    sha256 "0a583bcb23cda49566bab5fe0d7e6637e9354885b51a76c1be3395dd44f82efd" => :mojave
    sha256 "0cc220acbbb073fbabdf9e6d385d121040dff07377e6a19218c0d666281db5d2" => :high_sierra
    sha256 "a1719223676d318409786f7cf6993833fbf85ae300b7ee180cb688ae6c7be26c" => :sierra
  end

  head do
    url "https://github.com/crystal-lang/crystal.git"

    resource "shards" do
      url "https://github.com/crystal-lang/shards.git"
    end
  end

  depends_on "libatomic_ops" => :build # for building bdw-gc
  depends_on "pkg-config"
  depends_on "bdw-gc"
  depends_on "gmp" # std uses it but it's not linked
  depends_on "libevent"
  depends_on "libyaml"
  depends_on "llvm@6"
  depends_on "pcre"

  resource "boot" do
    url "https://github.com/crystal-lang/crystal/releases/download/0.26.1/crystal-0.26.1-1-darwin-x86_64.tar.gz"
    version "0.26.1-1"
    sha256 "3ad9616204d36ee4171e15892ee32216eab06f87f1f6cf5e32b45196dd4231d7"
  end

  def install
    (buildpath/"boot").install resource("boot")

    if build.head?
      ENV["CRYSTAL_CONFIG_BUILD_COMMIT"] = Utils.popen_read("git rev-parse --short HEAD").strip
    end

    ENV["CRYSTAL_CONFIG_PATH"] = prefix/"src:lib"
    ENV.append_path "PATH", "boot/bin"

    system "make", "deps"
    (buildpath/".build").mkpath

    system "bin/crystal", "build",
                          "-D", "without_openssl",
                          "-D", "without_zlib",
                          "-o", ".build/crystal",
                          "src/compiler/crystal.cr",
                          "--release", "--no-debug"

    resource("shards").stage do
      system buildpath/"bin/crystal", "build", "-o", buildpath/".build/shards", "src/shards.cr"
    end

    bin.install ".build/shards"
    bin.install ".build/crystal"
    prefix.install "src"
    bash_completion.install "etc/completion.bash" => "crystal"
    zsh_completion.install "etc/completion.zsh" => "_crystal"
  end

  test do
    assert_match "1", shell_output("#{bin}/crystal eval puts 1")
  end
end
