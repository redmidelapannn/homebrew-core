class Yaws < Formula
  desc "Webserver for dynamic content (written in Erlang)"
  homepage "http://yaws.hyber.org"
  url "http://yaws.hyber.org/download/yaws-2.0.3.tar.gz"
  sha256 "450a4b2b2750a6feb34238c0b38bc9801de80b228188a22d85dccbb4b4e049f6"

  bottle do
    rebuild 2
    sha256 "632239b94a9ccafee2b3e2bcc040e1d5bce2748d53fcd0b6ed4eabf264862c2e" => :sierra
    sha256 "a3d236350de61ceeabeeb4a7bb350be8aebd5cd8f175eed5d615923aaf16c81d" => :el_capitan
    sha256 "4cdbbdd3dbdf4812338da6c6129784f45a05dfddba5a5b4e99d3099c541310c2" => :yosemite
  end

  head do
    url "https://github.com/klacke/yaws.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  option "without-yapp", "Omit yaws applications"

  depends_on "erlang"

  # the default config expects these folders to exist
  skip_clean "var/log/yaws"
  skip_clean "lib/yaws/examples/ebin"
  skip_clean "lib/yaws/examples/include"

  def install
    system "autoreconf", "-fvi" if build.head?
    system "./configure", "--prefix=#{prefix}",
                          # Ensure pam headers are found on Xcode-only installs
                          "--with-extrainclude=#{MacOS.sdk_path}/usr/include/security"
    system "make", "install"

    if build.with? "yapp"
      cd "applications/yapp" do
        system "make"
        system "make", "install"
      end
    end

    # the default config expects these folders to exist
    (lib/"yaws/examples/ebin").mkpath
    (lib/"yaws/examples/include").mkpath
  end

  def post_install
    (var/"log/yaws").mkpath
    (var/"yaws/www").mkpath
  end

  test do
    system bin/"yaws", "--version"
  end
end
