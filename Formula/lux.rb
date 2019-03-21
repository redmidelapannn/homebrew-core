class Lux < Formula
  desc "Lux (LUcid eXpect scripting) simplifies test automation and provides an Expect-style execution of commands"
  homepage "https://github.com/hawk/lux"
  url "https://github.com/hawk/lux/archive/lux-1.19.3.tar.gz"
  sha256 "e2dd36275c76a087a4b4577bd056a6928a5e5ba5b00d8c366e2a4f94b16f921e"

  bottle do
    cellar :any_skip_relocation
    sha256 "c3d5307dca009a9bb397ee96c9a6ca6e12479f99396766af8d178f86966b3e20" => :mojave
    sha256 "94cca20e67cb8c1652a6807c195a5ed1ca2c734995cd99386f74b6b311b2de8b" => :high_sierra
    sha256 "cf83a49267b266224972628402d5115d87bc2700349b982eb99194ea641cbfe9" => :sierra
  end

  head do
    url "https://github.com/hawk/lux.git"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build

  option "without-runpty", "Omit pseudo TTY wrapper"

  depends_on "erlang"
  depends_on "wxmac" => :optional

  def install
    ENV.deparallelize  # if your formula fails when building in parallel

    system "autoconf"
    system "./configure", "--prefix=#{prefix}/lux"
    system "make"

    #system "make", "install"
    system "mkdir -p #{prefix}/lux"
    system "tar cf - * | (cd #{prefix}/lux && tar xf -)"
    system "mkdir -p #{prefix}/bin"
    system "ln -s #{prefix}/lux/bin/lux #{prefix}/bin/lux"
  end

  test do
    system "#{bin}/lux", "--version"
  end
end
