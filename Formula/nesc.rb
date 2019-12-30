class Nesc < Formula
  desc "Programming language for deeply networked systems"
  homepage "https://github.com/tinyos/nesc"
  url "https://github.com/tinyos/nesc/archive/v1.4.0.tar.gz"
  sha256 "ea9a505d55e122bf413dff404bebfa869a8f0dd76a01a8efc7b4919c375ca000"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "dba019dcc548898c0d47936e3dcae0c44b00b4f2d9cb708652762e765251005b" => :mojave
    sha256 "8ef0c92b93aac610f38d9faf52d0da63fb8d7635f5f0b01461c1dd4db43859b6" => :high_sierra
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on :java => :build

  def install
    # nesc is unable to build in parallel because multiple emacs instances
    # lead to locking on the same file
    ENV.deparallelize

    system "./Bootstrap"
    system "./configure", "--disable-debug", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end
end
