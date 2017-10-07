class Sfk < Formula
  desc "Command-line tools collection"
  homepage "http://stahlworks.com/dev/swiss-file-knife.html"
  url "https://downloads.sourceforge.net/project/swissfileknife/1-swissfileknife/1.8.8/sfk-1.8.8.tar.gz"
  sha256 "b139998e3aca294fe74ad2a6f0527e81cbd11eddfb5e8a81f6067a79d26c97ed"

  bottle do
    cellar :any_skip_relocation
    sha256 "a4e6469f864fec16ae3896148f6e7788b2f8204e8e67482e854c17bbf7c7107d" => :el_capitan
  end

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end

  test do
    system "#{bin}/sfk", "ip"
  end
end
