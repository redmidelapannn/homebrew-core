class Web100clt < Formula
  desc "Command-line version of NDT diagnostic client"
  homepage "https://software.internet2.edu/ndt/"
  url "https://software.internet2.edu/sources/ndt/ndt-3.7.0.2.tar.gz"
  sha256 "bd298eb333d4c13f191ce3e9386162dd0de07cddde8fe39e9a74fde4e072cdd9"
  revision 1

  bottle do
    cellar :any
    rebuild 1
    sha256 "6b34924305a17e1a61521ff56ab9efa84c86ab0228fcc8626bee9acc92ecebd8" => :mojave
    sha256 "827cdb74b5ea3ad01979e4b01dfdc79d9024b4c78143c2f8c7dee0d8046ffcfd" => :high_sierra
    sha256 "cb1bd3b07c9b00b500996f92a4e8cdbd7a2032df0f1b56e96b1697e0cbbe5e72" => :sierra
  end

  depends_on "i2util"
  depends_on "jansson"
  depends_on "openssl"

  # fixes issue with new default secure strlcpy/strlcat functions in 10.9
  # https://github.com/ndt-project/ndt/issues/106
  patch do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/37aa64888341/web100clt/ndt-3.6.5.2-osx-10.9.patch"
    sha256 "86d2399e3d139c02108ce2afb45193d8c1f5782996714743ec673c7921095e8e"
  end

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--mandir=#{man}",
                          "--with-openssl=#{Formula["openssl"].opt_prefix}"

    # we only want to build the web100clt client so we need
    # to change to the src directory before installing.
    system "make", "-C", "src", "install"
    man1.install "doc/web100clt.man" => "web100clt.1"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/web100clt -v")
  end
end
