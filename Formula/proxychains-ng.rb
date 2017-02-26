class ProxychainsNg < Formula
  desc "Hook preloader"
  homepage "https://sourceforge.net/projects/proxychains-ng/"
  url "https://github.com/rofl0r/proxychains-ng/releases/download/v4.12/proxychains-ng-4.12.tar.xz"
  sha256 "482a549935060417b629f32ddadd14f9c04df8249d9588f7f78a3303e3d03a4e"
  revision 1

  head "https://github.com/rofl0r/proxychains-ng.git"

  bottle do
    rebuild 1
    sha256 "5bfcb672c8ccf8509aa996cdbb616a728d0f3d42518db4c084e128cb198d285d" => :sierra
    sha256 "1c84320b37830d0002d7b9412b731cb6bd4a07e3addae2f28fb42d1a2193a9a2" => :el_capitan
    sha256 "3f389147f4ff742ef1c653443e47254e3730be0b281da259f92ed5120c798420" => :yosemite
  end

  def install
    system "./configure", "--prefix=#{prefix}", "--sysconfdir=#{etc}"
    system "make"
    system "make", "install"
    system "make", "install-config"
  end

  test do
    assert_match "config file found", shell_output("#{bin}/proxychains4 test 2>&1", 1)
  end
end
