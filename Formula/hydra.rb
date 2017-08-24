class Hydra < Formula
  desc "Network logon cracker which supports many services"
  homepage "https://www.thc.org/thc-hydra/"
  url "https://github.com/vanhauser-thc/thc-hydra/archive/8.6.tar.gz"
  sha256 "05a87eb018507b24afca970081f067e64441460319fb75ca1e64c4a1f322b80b"
  head "https://github.com/vanhauser-thc/thc-hydra.git"

  bottle do
    cellar :any
    rebuild 1
    sha256 "2ff1bf196f5f50a7f8cc740b63c2bb9c8d82317e33dccf6e333161490171bfdc" => :sierra
    sha256 "3e0d8fca41f9ce585a86493779b6045d72ed82c9332dc4aeac8de9035495c5e5" => :el_capitan
    sha256 "fc9ad4feb711ad42e92d69a09142cc5fb6e4e561424b596447558e666a7894bf" => :yosemite
  end

  depends_on "pkg-config" => :build
  depends_on :mysql
  depends_on "openssl"
  depends_on "subversion" => :optional
  depends_on "libidn" => :optional
  depends_on "libssh" => :optional
  depends_on "pcre" => :optional
  depends_on "gtk+" => :optional

  def install
    inreplace "configure" do |s|
      # Link against our OpenSSL
      # https://github.com/vanhauser-thc/thc-hydra/issues/80
      s.gsub! "/opt/local/lib", Formula["openssl"].opt_lib
      s.gsub! "/opt/local/*ssl", Formula["openssl"].opt_lib
      s.gsub! "/opt/*ssl/include", Formula["openssl"].opt_include
      # Avoid opportunistic linking of subversion
      s.gsub! "libsvn", "oh_no_you_dont" if build.without? "subversion"
      # Avoid opportunistic linking of libssh
      s.gsub! "libssh", "certainly_not" if build.without? "libssh"
    end

    # Having our gcc in the PATH first can cause issues. Monitor this.
    # https://github.com/vanhauser-thc/thc-hydra/issues/22
    system "./configure", "--prefix=#{prefix}"
    bin.mkpath
    system "make", "all", "install"
    share.install prefix/"man" # Put man pages in correct place
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/hydra", 255)
  end
end
