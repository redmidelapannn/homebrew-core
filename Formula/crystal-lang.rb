class CrystalLang < Formula
  desc "Fast and statically typed, compiled language with Ruby-like syntax"
  homepage "https://crystal-lang.org/"
  revision 2

  stable do
    url "https://github.com/crystal-lang/crystal/archive/0.24.1.tar.gz"
    sha256 "4999a4d2a9ffc7bfbea8351b97057c3a135c2091cbd518e5c22ea7f5392b67d8"

    resource "shards" do
      url "https://github.com/crystal-lang/shards/archive/v0.7.2.tar.gz"
      sha256 "97a3681e74d2fdcba0575f6906f4ba0aefc709a2eb672c7289c63176ff4f3be2"
    end
  end

  bottle do
    rebuild 1
    sha256 "be939af9bf5b0f313f9aa16e6b1c6fac07dcb293e27631bc9103e344f3ec92a2" => :high_sierra
    sha256 "48d6128f4c742b650ca63738b9e71095caeb10e2f52038ac963bcd1592302c18" => :sierra
    sha256 "802d7ddace25104fb1c25b945d426d0b6f6207a9612a7b4b1fc0e7414f9ff1ed" => :el_capitan
  end

  head do
    url "https://github.com/crystal-lang/crystal.git"

    resource "shards" do
      url "https://github.com/crystal-lang/shards.git"
    end
  end

  option "without-release", "Do not build the compiler in release mode"
  option "without-shards", "Do not include `shards` dependency manager"

  depends_on "pkg-config" => :build
  depends_on "libatomic_ops" => :build # for building bdw-gc
  depends_on "libevent"
  depends_on "bdw-gc"
  depends_on "llvm"
  depends_on "pcre"
  depends_on "gmp" # std uses it but it's not linked
  depends_on "libyaml" if build.with? "shards"

  resource "boot" do
    url "https://github.com/crystal-lang/crystal/releases/download/v0.24.1/crystal-0.24.1-2-darwin-x86_64.tar.gz"
    version "0.24.1"
    sha256 "2be256462f4388cd3bb14b1378ef94d668ab9d870944454e828b4145155428a0"
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

    command = ["bin/crystal", "build", "-D", "without_openssl", "-D", "without_zlib", "-o", ".build/crystal", "src/compiler/crystal.cr"]
    command.concat ["--release", "--no-debug"] if build.with? "release"

    system *command

    if build.with? "shards"
      resource("shards").stage do
        system buildpath/"bin/crystal", "build", "-o", buildpath/".build/shards", "src/shards.cr"
      end
      bin.install ".build/shards"
    end

    bin.install ".build/crystal"
    prefix.install "src"
    bash_completion.install "etc/completion.bash" => "crystal"
    zsh_completion.install "etc/completion.zsh" => "_crystal"
  end

  test do
    assert_match "1", shell_output("#{bin}/crystal eval puts 1")
  end
end
