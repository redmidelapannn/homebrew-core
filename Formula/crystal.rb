class Crystal < Formula
  desc "Fast and statically typed, compiled language with Ruby-like syntax"
  homepage "https://crystal-lang.org/"

  stable do
    url "https://github.com/crystal-lang/crystal/archive/0.26.1.tar.gz"
    sha256 "b7c755a7d0f49f572ae5c08b8b0139fcb1c6862c9479dfae74f00e2c8424fcb0"

    resource "shards" do
      url "https://github.com/crystal-lang/shards/archive/v0.8.1.tar.gz"
      sha256 "75c74ab6acf2d5c59f61a7efd3bbc3c4b1d65217f910340cb818ebf5233207a5"
    end
  end

  bottle do
    rebuild 1
    sha256 "27b8c7fc5da76d95bbd9c56a08bb6de791ebd6b7926816c59f3456da50a6463e" => :mojave
    sha256 "669d1a1e77c1fd568f50caec9231de71e74507feebee88aea6635ce685f028db" => :high_sierra
    sha256 "91511d014a0b11d316366d3bce650ed7b580e6028ef365e8ce0a162844fdd172" => :sierra
    sha256 "ff6916990b5af5c3fe3e53fd3978767d1b6075a32ced118b9abbb18ad0915834" => :el_capitan
  end

  head do
    url "https://github.com/crystal-lang/crystal.git"

    resource "shards" do
      url "https://github.com/crystal-lang/shards.git"
    end
  end

  depends_on "pkg-config" => :build
  depends_on "libatomic_ops" => :build # for building bdw-gc
  depends_on "bdw-gc"
  depends_on "gmp" # std uses it but it's not linked
  depends_on "libevent"
  depends_on "libyaml"
  depends_on "llvm"
  depends_on "pcre"

  resource "boot" do
    url "https://github.com/crystal-lang/crystal/releases/download/0.26.0/crystal-0.26.0-1-darwin-x86_64.tar.gz"
    version "0.26.0-1"
    sha256 "13ccd6425593f33f7423423553bc5c2fdcf5d76b6b97b82bf4204bc55831ec43"
  end

  def install
    (buildpath/"boot").install resource("boot")

    if build.head?
      ENV["CRYSTAL_CONFIG_VERSION"] = Utils.popen_read("git rev-parse --short HEAD").strip
    else
      ENV["CRYSTAL_CONFIG_VERSION"] = version
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
