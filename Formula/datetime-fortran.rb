class DatetimeFortran < Formula
  desc "Fortran time and date manipulation library"
  homepage "https://github.com/wavebitscientific/datetime-fortran"
  url "https://github.com/wavebitscientific/datetime-fortran/releases/download/v1.6.0/datetime-fortran-1.6.0.tar.gz"
  sha256 "e46c583bca42e520a05180984315495495da4949267fc155e359524c2bf31e9a"
  revision 3

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "b74f8c86fb6455598927e0f0acc3595d8a92bfc01f747dec0978e1be1ceda541" => :mojave
    sha256 "0cc26a37c09577bd2d5b9b61c74b560c7907851831c9256c2267882317eaf3e1" => :high_sierra
    sha256 "a62a6f47cf74194231b843e3eb28bc04ad4478142d56ccab7b75e3fb05416791" => :sierra
  end

  head do
    url "https://github.com/wavebitscientific/datetime-fortran.git"

    depends_on "autoconf"   => :build
    depends_on "automake"   => :build
    depends_on "pkg-config" => :build
  end

  depends_on "gcc" # for gfortran

  def install
    system "autoreconf", "-fvi" if build.head?
    system "./configure", "--prefix=#{prefix}",
                          "--disable-silent-rules"
    system "make", "install"
    (pkgshare/"test").install "src/tests/datetime_tests.f90"
  end

  test do
    system "gfortran", "-o", "test", "-I#{include}", "-L#{lib}", "-ldatetime",
                       pkgshare/"test/datetime_tests.f90"
    system "./test"
  end
end
