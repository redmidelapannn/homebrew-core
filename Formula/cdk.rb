class Cdk < Formula
  desc "Curses development kit provides predefined curses widget for apps"
  homepage "https://invisible-island.net/cdk/"
  url "https://invisible-mirror.net/archives/cdk/cdk-5.0-20161210.tgz"
  version "5.0.20161210"
  sha256 "9e7558cb8850ca5c7ab4cc38e0612b0e8c4aad680d2a2511f31d62f239e35fad"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "d6cfe267d7d953b322bea64dd10c945756ee97e7b5acbc334a8ad576ddde4864" => :high_sierra
    sha256 "4db538d81d5d5c70bd019427179f0068fb0880d74b4285ed16696abdf4dd39b9" => :sierra
    sha256 "a1c37ad4edff9fb9c76ecd5e2287caaf5b81862c9c94e81d9f3c4b5579b6060f" => :el_capitan
  end

  def install
    system "./configure", "--prefix=#{prefix}", "--with-ncurses"
    system "make", "install"
  end

  test do
    assert_match lib.to_s, shell_output("#{bin}/cdk5-config --libdir")
  end
end
