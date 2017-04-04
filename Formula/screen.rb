class Screen < Formula
  desc "Terminal multiplexer with VT100/ANSI terminal emulation"
  homepage "https://www.gnu.org/software/screen"

  stable do
    url "https://ftpmirror.gnu.org/screen/screen-4.5.1.tar.gz"
    mirror "https://ftp.gnu.org/gnu/screen/screen-4.5.1.tar.gz"
    sha256 "97db2114dd963b016cd4ded34831955dcbe3251e5eee45ac2606e67e9f097b2d"

    # This patch is to disable the error message
    # "/var/run/utmp: No such file or directory" on launch
    patch :p2 do
      url "https://gist.githubusercontent.com/yujinakayama/4608863/raw/75669072f227b82777df25f99ffd9657bd113847/gistfile1.diff"
      sha256 "9c53320cbe3a24c8fb5d77cf701c47918b3fabe8d6f339a00cfdb59e11af0ad5"
    end
  end

  bottle do
    rebuild 1
    sha256 "0d033df0b008b5e4de96dadccc9f6ce6f2811cd3a387ce102f2b510d3a4b751f" => :sierra
    sha256 "7bceebbd5fbc2cf1eb5413d18945543c7aa149a333c5064a7f144e0bfbaa3ffa" => :el_capitan
    sha256 "6e79769bcd2ae23dde0e6e6678cd4ed1b4537c0271f1f79f6124594b520325a3" => :yosemite
  end

  head do
    url "https://git.savannah.gnu.org/git/screen.git"

    # This patch avoid a bug that prevents detached sessions to reattach
    # See https://lists.gnu.org/archive/html/screen-users/2016-10/msg00007.html
    patch do
      url "https://gist.githubusercontent.com/sobrinho/5a7672e088868c2d036957dbe7825dd0/raw/c6fe5dc20cb7dbd0e23f9053aa3867fcbc01d983/diff.patch"
      sha256 "47892633ccb137316a0532b034d0be81edc26fc72a6babca9761a1649bc67fd1"
    end
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build

  def install
    if build.head?
      cd "src"
    end

    # With parallel build, it fails
    # because of trying to compile files which depend osdef.h
    # before osdef.sh script generates it.
    ENV.deparallelize

    system "./autogen.sh"
    system "./configure", "--prefix=#{prefix}",
                          "--mandir=#{man}",
                          "--infodir=#{info}",
                          "--enable-colors256",
                          "--enable-pam"

    system "make"
    system "make", "install"
  end

  test do
    shell_output("#{bin}/screen -h", 1)
  end
end
