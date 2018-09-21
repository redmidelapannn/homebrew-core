class Gammu < Formula
  desc "Command-line utility to control a phone"
  homepage "https://wammu.eu/gammu/"
  url "https://dl.cihar.com/gammu/releases/gammu-1.39.0.tar.xz"
  sha256 "66d1d991d7a993fdf254d4c425f0fdd38c9cca15b1735936695a486067a6a9f8"
  head "https://github.com/gammu/gammu.git"

  bottle do
    rebuild 1
    sha256 "85dc2ad6de1ed414052ff367a05570a0c1da99fa2ac437fadc0378563cc062c3" => :mojave
    sha256 "3beaa9dc2d75b7aa27842ed248bd78a08fe618da20488aba2afbca0e65aad237" => :high_sierra
    sha256 "c46a9e2390d548b43f6fe382ee6e1b9f61c9baf27e877ae984d6672387fe9992" => :sierra
    sha256 "d37cdd6fa8b137546d8040d5c1d1247baea70dd280a97397581ef5880a467378" => :el_capitan
  end

  depends_on "cmake" => :build
  depends_on "glib"
  depends_on "openssl"

  def install
    mkdir "build" do
      system "cmake", "..", "-DBASH_COMPLETION_COMPLETIONSDIR:PATH=#{bash_completion}", *std_cmake_args
      system "make", "install"
    end
  end

  test do
    system bin/"gammu", "--help"
  end
end
