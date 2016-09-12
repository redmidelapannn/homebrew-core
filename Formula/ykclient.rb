class Ykclient < Formula
  desc "Library to validate YubiKey OTPs against YubiCloud"
  homepage "https://developers.yubico.com/yubico-c-client/"
  url "https://developers.yubico.com/yubico-c-client/Releases/ykclient-2.15.tar.gz"
  sha256 "f461cdefe7955d58bbd09d0eb7a15b36cb3576b88adbd68008f40ea978ea5016"

  bottle do
    cellar :any
    rebuild 2
    sha256 "fde1eb1e863a216892176e690c58eea57f617bb0ec631aa3b8705618d96d3b5d" => :el_capitan
    sha256 "916e83f245596b0096f412f9f51ea65c2aedfc2f844be6b2552bf1eed4dc0599" => :yosemite
    sha256 "2dbae8e0e3e19e37b7d2ce10e6a5747efadb418d5e4c8559b3f3a4eb8cfcc416" => :mavericks
  end

  head do
    url "https://github.com/Yubico/yubico-c-client.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  option :universal

  depends_on "pkg-config" => :build
  depends_on "help2man" => :build

  def install
    ENV.universal_binary if build.universal?

    system "autoreconf", "-iv" if build.head?
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
    system "make", "check"
  end

  test do
    assert_equal version.to_s, shell_output("#{bin}/ykclient --version").chomp
  end
end
