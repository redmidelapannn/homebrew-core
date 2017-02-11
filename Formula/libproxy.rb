class Libproxy < Formula
  desc "Library that provides automatic proxy configuration management"
  homepage "https://libproxy.github.io/libproxy/"
  url "https://github.com/libproxy/libproxy/archive/0.4.14.tar.gz"
  sha256 "6220a6cab837a8996116a0568324cadfd09a07ec16b930d2a330e16d5c2e1eb6"
  head "https://github.com/libproxy/libproxy.git"

  bottle do
    rebuild 1
    sha256 "86c0460c46734d563e13511a11549bf01d54be706d329a931915d9b3565e0dd0" => :sierra
    sha256 "4d2c3a6526faab647f39d66f8b160593a13e0e36e79fd2f1965eba90e064570d" => :el_capitan
    sha256 "f05860ae8196aa09fe90a0642ef64de79c47beee8f7645c2a6f56c1a638cd6a7" => :yosemite
  end

  depends_on "cmake" => :build
  # Non-fatally fails to build against system Perl, so stick to Homebrew's here.
  depends_on "perl" => :optional
  depends_on :python if MacOS.version <= :snow_leopard

  def install
    args = std_cmake_args + %W[
      ..
      -DPYTHON2_SITEPKG_DIR=#{lib}/python2.7/site-packages
      -DWITH_PYTHON3=OFF
    ]

    if build.with? "perl"
      args << "-DPX_PERL_ARCH=#{lib}/perl5/site_perl"
      args << "-DPERL_LINK_LIBPERL=YES"
    else
      args << "-DWITH_PERL=OFF"
    end

    mkdir "build" do
      system "cmake", *args
      system "make", "install"
    end
  end

  test do
    assert_equal "direct://", pipe_output("#{bin}/proxy 127.0.0.1").chomp
  end
end
