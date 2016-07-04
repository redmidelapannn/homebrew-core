class Lftp < Formula
  desc "Sophisticated file transfer program"
  homepage "https://lftp.yar.ru/"
  url "https://lftp.yar.ru/ftp/lftp-4.7.2.tar.xz"
  sha256 "475d7699b1390f951efee867ba1ad600f78329e13fd2a04d92f82bfffb70d872"

  bottle do
    sha256 "a7863f036c3fd48fc1e28ff29fa89ba0ffafe7e7819096ef873e213e8425a1f2" => :el_capitan
    sha256 "d5cd8fb0e6bfe3fd8dd45199b00b3d5bc9ffb99aa294cc635f56e4599a2c4cb0" => :yosemite
    sha256 "75dc54ff770145fb9c563178e46ce70e5ed0625bdba9f204f831245c47def7a3" => :mavericks
  end

  depends_on "automake" => :build
  depends_on "autoconf" => :build
  depends_on "pkg-config" => :build
  depends_on "readline"
  depends_on "openssl" if MacOS.version < :yosemite

  patch do
    url "https://gist.githubusercontent.com/nijikon/b1b4eb47c39cd171b9fa4c892d6ca2ff/raw/9e13a6a810bc36cd79ab389e458c0f332841d612/lftp-4.7.2.patch"
    sha256 "6ebd26c695782b29c2e24c534b358cef032461bba90835087afec29a704fa063"
  end

  def install
    mv "src/lftp_rl.c", "src/lftp_rl.cc"

    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--with-openssl=#{Formula["openssl"].opt_prefix}",
                          "--with-readline=#{Formula["readline"].opt_prefix}"
    system "make", "install"
  end

  test do
    system "#{bin}/lftp", "-c", "open ftp://mirrors.kernel.org; ls"
  end
end
