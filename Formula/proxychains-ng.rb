class ProxychainsNg < Formula
  desc "Hook preloader"
  homepage "https://sourceforge.net/projects/proxychains-ng/"
  url "https://downloads.sourceforge.net/project/proxychains-ng/proxychains-ng-4.11.tar.bz2"
  sha256 "dcc4149808cd1fb5d9663cc09791f478805816b1f017381f424414c47f6376b6"

  head "https://github.com/rofl0r/proxychains-ng.git"

  bottle do
    revision 1
    sha256 "4b43b9ef554924757151702c085aa825631a792b2ca3a0c44cb855452e2e4e25" => :el_capitan
    sha256 "e6603eb3963cf95a15b0f7cbd83886c4b222cca38a7152d0ab78749c7a5f0cca" => :yosemite
    sha256 "be4fa1609f1a241693dd3405c9d92039d69afa6fa77f6448a52b8d4c058dde7d" => :mavericks
  end

  option :universal

  def install
    args = ["--prefix=#{prefix}", "--sysconfdir=#{prefix}/etc"]
    if build.universal?
      ENV.universal_binary
      args << "--fat-binary"
      args << "-arch i386"
    end
    system "./configure", *args
    system "make"
    system "make", "install"
    system "make", "install-config"
  end

  test do
    assert_match "config file found", shell_output("#{bin}/proxychains4 test 2>&1", 1)
  end
end
