class CrystalLang < Formula
  desc "Fast and statically typed, compiled language with Ruby-like syntax"
  homepage "https://crystal-lang.org/"
  url "https://github.com/crystal-lang/crystal/archive/0.18.7.tar.gz"
  sha256 "72b33fd4bd903a9f0957c74c2f95429e8c0f94c04df86396711b5560f540805d"
  head "https://github.com/crystal-lang/crystal.git"

  bottle do
    revision 1
    sha256 "fff03c946e68979975f4d82311b10b3289601d90558f024d561858928c086b02" => :el_capitan
    sha256 "b84ea869c534d2f77d8aa71a2227baa73fd263f1d4e47730e6182537ace041ef" => :yosemite
    sha256 "ca75685b190372c87a9438ac8d6a26d002af91de3697add5897986748e667296" => :mavericks
  end

  option "without-release", "Do not build the compiler in release mode"
  option "without-shards", "Do not include `shards` dependency manager"

  depends_on "libevent"
  depends_on "bdw-gc"
  depends_on "llvm" => :build
  depends_on "libyaml" if build.with?("shards")

  resource "boot" do
    url "https://github.com/crystal-lang/crystal/releases/download/0.18.6/crystal-0.18.6-1-darwin-x86_64.tar.gz"
    version "0.18.6"
    sha256 "ce4e282edbf35542cee2cc95a1feb070612716200f142f712707c17cf4175c48"
  end

  resource "shards" do
    url "https://github.com/ysbaddaden/shards/archive/v0.6.3.tar.gz"
    sha256 "5245aebb21af0a5682123732e4f4d476e7aa6910252fb3ffe4be60ee8df03ac2"
  end

  def install
    (buildpath/"boot").install resource("boot")

    if build.head?
      ENV["CRYSTAL_CONFIG_VERSION"] = `git rev-parse --short HEAD`.strip
    else
      ENV["CRYSTAL_CONFIG_VERSION"] = version
    end

    ENV["CRYSTAL_CONFIG_PATH"] = prefix/"src:libs"
    ENV.append_path "PATH", "boot/bin"

    if build.with? "release"
      system "make", "crystal", "release=true"
    else
      system "make", "deps"
      (buildpath/".build").mkpath
      system "bin/crystal", "build", "-o", "-D", "without_openssl", "-D", "without_zlib", ".build/crystal", "src/compiler/crystal.cr"
    end

    if build.with? "shards"
      resource("shards").stage do
        system buildpath/"bin/crystal", "build", "-o", buildpath/".build/shards", "src/shards.cr"
      end
      bin.install ".build/shards"
    end

    bin.install ".build/crystal"
    prefix.install "src"
    bash_completion.install "etc/completion.bash" => "crystal"
    zsh_completion.install "etc/completion.zsh" => "crystal"
  end

  test do
    system "#{bin}/crystal", "eval", "puts 1"
  end
end
