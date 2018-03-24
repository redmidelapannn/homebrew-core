class IsoCodes < Formula
  desc "Provides lists of various ISO standards"
  homepage "https://pkg-isocodes.alioth.debian.org/"
  url "https://pkg-isocodes.alioth.debian.org/downloads/iso-codes-3.77.tar.xz"
  sha256 "21cd73a4c6f95d9474ebfcffd4e065223857720f24858e564f4409b19f7f0d90"
  revision 2
  head "https://anonscm.debian.org/git/pkg-isocodes/iso-codes.git"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "3b7b001cfede84099eda87638c1662f669ac89601b01e4baff5f4868531e4c42" => :high_sierra
    sha256 "3b7b001cfede84099eda87638c1662f669ac89601b01e4baff5f4868531e4c42" => :sierra
    sha256 "3b7b001cfede84099eda87638c1662f669ac89601b01e4baff5f4868531e4c42" => :el_capitan
  end

  depends_on "gettext" => :build
  depends_on "python"
  depends_on "pkg-config"

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make"
    system "make", "check"
    system "make", "install"
  end

  test do
    pkg_config = Formula["pkg-config"].opt_bin/"pkg-config"
    output = shell_output("#{pkg_config} --variable=domains iso-codes")
    assert_match "iso_639-2 iso_639-3 iso_639-5 iso_3166-1", output
  end
end
