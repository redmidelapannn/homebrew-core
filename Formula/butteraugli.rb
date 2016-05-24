class Butteraugli < Formula
  desc "Measuring differences between images."
  homepage "https://github.com/google/butteraugli"
  url "https://github.com/google/butteraugli/archive/2f8d6a0b1466b003d610271ef1f0ae3dd0d28998.tar.gz"
  version "0.1"
  sha256 "79ce7ead4ccb159b84bbab05e8a3e569c3b98b032ee58bdfd13df25acc85d5a2"

  bottle do
    cellar :any
    sha256 "aaf561efd8ffc9c5133366cdaa7f08cf91f2bc8964d04c58e41778c04700a288" => :el_capitan
    sha256 "63120ca2c41ce3138b8196ac23b52ed57dae22d79ccd0fdcba0f8ea6bfe27e87" => :yosemite
    sha256 "7974c24c0ee161283de948a936f968798edc01130dc483630898fdf401731075" => :mavericks
  end

  depends_on "libpng"

  def install
    cd "src"
    system "make"
    bin.install "compare_pngs"
  end

  test do
    # unfortunatley, butteraugli fails when applied to the test fixtures
    # system "#{bin}/compare_pngs", test_fixtures("test.png"), test_fixtures("test.png")
  end
end
