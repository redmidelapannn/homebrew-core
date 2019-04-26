class Dirt < Formula
  desc "Experimental sample playback"
  homepage "https://github.com/tidalcycles/Dirt"
  url "https://github.com/tidalcycles/Dirt/archive/1.1.tar.gz"
  sha256 "bb1ae52311813d0ea3089bf3837592b885562518b4b44967ce88a24bc10802b6"
  revision 2
  head "https://github.com/tidalcycles/Dirt.git"

  bottle do
    cellar :any
    sha256 "a4238a1460f8f0a3c3d4801282b7de6ec1718871a790d17296f9b6913b09e330" => :mojave
    sha256 "6c59ab7d7104f99076fadec22f4e479263355d84e355989f036708a297fdf2c3" => :high_sierra
    sha256 "4748640a598392cc4910dc62374c0337c4bb70940e21f6aff682695ee7c67f8e" => :sierra
  end

  depends_on "jack"
  depends_on "liblo"

  def install
    system "make", "PREFIX=#{prefix}", "install"
  end

  test do
    assert_match "Usage", shell_output("#{bin}/dirt --help; :")
  end
end
