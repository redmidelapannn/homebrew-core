class Qd < Formula
  desc "C++/Fortran-90 double-double and quad-double package"
  homepage "https://crd.lbl.gov/~dhbailey/mpdist/"
  url "https://crd.lbl.gov/~dhbailey/mpdist/qd-2.3.15.tar.gz"
  sha256 "17d7ed554613e4c17ac18670ef49d114ba706a63d735d72032b63a8833771ff7"

  bottle do
    cellar :any
    revision 1
    sha256 "4fe7df93be88b58216a42226173e95efad5b94a7f39fb40c9001eb9444625bb0" => :el_capitan
    sha256 "deec764f01972a3b36792101452d03a21d970057edc9d89e12079ff0f1021bd3" => :yosemite
    sha256 "059a485334481ce56b9563a5f2ee68dfeee9d88a5103191c2af0e4b066c84ac0" => :mavericks
  end

  depends_on :fortran => :recommended

  def install
    args = ["--disable-dependency-tracking", "--enable-shared", "--prefix=#{prefix}"]
    args << "--enable-fortran=no" if build.without? :fortran
    system "./configure", *args
    system "make"
    system "make", "check"
    system "make", "install"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/qd-config --configure-args")
  end
end
