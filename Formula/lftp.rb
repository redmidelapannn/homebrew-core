class Lftp < Formula
  desc "Sophisticated file transfer program"
  homepage "https://lftp.yar.ru/"
  url "https://lftp.yar.ru/ftp/lftp-4.7.2.tar.xz"
  sha256 "475d7699b1390f951efee867ba1ad600f78329e13fd2a04d92f82bfffb70d872"

  bottle do
    sha256 "644e176bc377b256e69c261a780d1548e85d5dc408529dcae88b4e427195223d" => :el_capitan
    sha256 "66c7fcdb701579432076f87a67928f8e21b14f70f2d4428e7bad3ad8e1eaabaf" => :mavericks
  end

  depends_on "automake" => :build
  depends_on "autoconf" => :build
  depends_on "pkg-config" => :build
  depends_on "readline"
  depends_on "openssl"

  # https://github.com/lavv17/lftp/issues/223
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
