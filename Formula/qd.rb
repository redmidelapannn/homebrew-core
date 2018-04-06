class Qd < Formula
  desc "C++/Fortran-90 double-double and quad-double package"
  homepage "https://crd.lbl.gov/~dhbailey/mpdist/"
  url "https://crd.lbl.gov/~dhbailey/mpdist/qd-2.3.18.tar.gz"
  sha256 "81096b5b33519cbeed5fc8ef58e1d47ee8f546382514849967627b972483716e"
  revision 1

  bottle do
    cellar :any
    rebuild 1
    sha256 "532c29aac2baef61db3095cedf6341d81725666a4e929a8c4e8015506572697d" => :high_sierra
    sha256 "14566b55a8e5c3f84d6037343ead658203611c670690c321c89a5518920cf1c6" => :sierra
    sha256 "80921a17368f4c9732b794b2c54cd5041fbcb511a71d53593af4dd0d1427c417" => :el_capitan
  end

  depends_on "gcc" # for gfortran

  def install
    system "./configure", "--disable-dependency-tracking", "--enable-shared",
                          "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/qd-config --configure-args")
  end
end
