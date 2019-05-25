class Sfk < Formula
  desc "Command-line tools collection"
  homepage "http://stahlworks.com/dev/swiss-file-knife.html"
  url "https://downloads.sourceforge.net/project/swissfileknife/1-swissfileknife/1.9.4.3/sfk-1.9.4.tar.gz"
  version "1.9.4.3"
  sha256 "103b0877ad84787a73d551c241258b1119aef229cbb56c130795a3760d516f00"

  bottle do
    cellar :any_skip_relocation
    sha256 "be2c69562b8e795e03e3d17f84844bacbb9d5ed34913466ebab55597b42f7570" => :sierra
  end

  def install
    ENV.libstdcxx

    system "./configure", "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end

  test do
    system "#{bin}/sfk", "ip"
  end
end
