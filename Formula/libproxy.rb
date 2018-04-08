class Libproxy < Formula
  desc "Library that provides automatic proxy configuration management"
  homepage "https://libproxy.github.io/libproxy/"
  url "https://github.com/libproxy/libproxy/archive/0.4.15.tar.gz"
  sha256 "18f58b0a0043b6881774187427ead158d310127fc46a1c668ad6d207fb28b4e0"
  head "https://github.com/libproxy/libproxy.git"

  bottle do
    rebuild 1
    sha256 "05fdade76317df1524fc452ff87152e9e3d6b4bb83a8dba37b5896e18b972f08" => :high_sierra
    sha256 "ee0559e06040a91b6ed541063b4897e3e661de507f183697f9df267b4f43e9c4" => :sierra
    sha256 "3b1bc2298604a8b1c6a74135d334c117522f6f89dff526dd558370997fe064b4" => :el_capitan
  end

  depends_on "cmake" => :build
  # Non-fatally fails to build against system Perl, so stick to Homebrew's here.
  depends_on "perl" => :optional
  depends_on "python@2"

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
