class Alac < Formula
  desc "Basic decoder for Apple Lossless Audio Codec files (ALAC)"
  homepage "https://web.archive.org/web/20150319040222/craz.net/programs/itunes/alac.html"
  url "https://web.archive.org/web/20150510210401/craz.net/programs/itunes/files/alac_decoder-0.2.0.tgz"
  sha256 "7f8f978a5619e6dfa03dc140994fd7255008d788af848ba6acf9cfbaa3e4122f"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "125f2bac5614b844a4f743463e276cf4f9df6f7c4045f518a6dd0eeaae79231a" => :sierra
    sha256 "150e2833f2aca78bce651666aa766a5f62f62cb0680090c3359a445c5a204afb" => :el_capitan
    sha256 "45a9103d9115383bd044806beb41c5cfad1697fb64c554fabb52c95fa6b44d2a" => :yosemite
  end

  def install
    system "make", "CFLAGS=#{ENV.cflags}", "CC=#{ENV.cc}"
    bin.install "alac"
  end

  test do
    sample = test_fixtures("test.m4a")
    assert_equal "file type: mp4a\n", shell_output("#{bin}/alac -t #{sample}", 100)
  end
end
