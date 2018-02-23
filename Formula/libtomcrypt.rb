class Libtomcrypt < Formula
  desc "Comprehensive, modular and portable cryptographic toolkit"
  homepage "https://www.libtom.net/"
  url "https://github.com/libtom/libtomcrypt/archive/v1.18.1.tar.gz"
  sha256 "e1319d77bf8ac296b69cf68f66e4dadfb68a8519bd684cc83d29b8d6754d10ef"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "058d09cd0cabe5cd5067b24bb57f6934997d2c2352cec1eed56bd78cb7e6c615" => :high_sierra
    sha256 "332642729c99fd4ea11269b94ea35959626a35b9a7e726a7e8d5d3384ebcb997" => :sierra
    sha256 "967ba9d679e33ffb8e7c6bc7038f929af3643fe4cf06577e5460be62d8d874e5" => :el_capitan
  end

  option "with-gmp", "enable gmp as MPI provider"
  option "with-libtommath", "enable libtommath as MPI provider"

  depends_on "gmp" => :optional
  depends_on "libtommath" => :optional

  def install
    if build.with? "gmp"
      ENV.append "CFLAGS", "-DUSE_GMP -DGMP_DESC"
      ENV.append "EXTRALIBS", "-lgmp"
    end
    if build.with? "libtommath"
      ENV.append "CFLAGS", "-DUSE_LTM -DLTM_DESC"
      ENV.append "EXTRALIBS", "-ltommath"
    end
    system "make", "test"
    system "make", "install", "PREFIX=#{prefix}"
    pkgshare.install "test"
    (pkgshare/"tests").install "tests/test.key"
  end

  test do
    cp_r Dir[pkgshare/"*"], testpath
    system "./test"
  end
end
