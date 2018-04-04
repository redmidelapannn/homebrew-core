class Oksh < Formula
  desc "The portable version of the OpenBSD Korn shell, a Public Domain shell"
  homepage "https://devio.us/~bcallah/oksh/"
  url "https://devio.us/~bcallah/oksh/oksh-20180111.tar.gz"
  sha256 "c15652b503123dd542144c36f12a076fdb89b1fc4c6a8807ce1ec83fa1e0d797"

  bottle do
    cellar :any_skip_relocation
    sha256 "4c65fd49e8d980a238866d5aa5447f9c4b72365125e8a2a3350b7a67d525a39a" => :high_sierra
    sha256 "7b8a2407ac082f887fd600063f7820149c468397b55c878fa7cce9a97e24b6b8" => :sierra
    sha256 "d33379bbfb7080fc43d7a578c3f5e51118fd3316b140a6aafdee8af99dab40a0" => :el_capitan
  end

  def install
    system "./configure", "--prefix=#{prefix}",
                          "--mandir=#{man}"
    system "make"
    bin.install "oksh"
    man1.install "oksh.1"
  end

  test do
    system "make", "test"
  end
end
